class ExportLeaseApplicationsJob
  include Sidekiq::Worker

  def perform(opts = {})
    @recipient = opts.with_indifferent_access['email']
    @filter    = opts.with_indifferent_access['filter'] || {}
    log("Perform for Email = #{@recipient} && filter = #{@filter}")
    @filepath_arr = []
    generate_csv
    email_to_recipient
    return filepath
  end

  def email_to_recipient
    DealerMailer.lease_applications_export(recipient: recipient, filepaths: @filepath_arr).deliver_now
  end

  def generate_csv
    limit = 50000
    offset = 0
    csv_count = (model.limit(nil).count.to_f / limit.to_f).ceil
    log("GenerateCSV for csv_count = #{csv_count}")


    (1..csv_count).each do |generate_csv|
      CSV.open(filepath, 'wb', headers: true) do |csv|
        csv << headers
        result = model.offset(offset).limit(limit).ransack(filter).result
        log("GenerateCSV for result_count = #{result.count}")
        result.find_each do |application|
          csv << values(application)
        end
      end
      @filepath_arr.push(@filepath) 
      offset += 1000 
    end
    log("GenerateCSV for filepath_arr = #{@filepath_arr}")
  end

  attr_reader :recipient, :filter

  private

  def log(msg)
    Rails.logger.info(" [#{Time.now.utc.strftime('%B %-d %Y at %r %Z')}][#{recipient}] - #{self.class.to_s}: #{msg}")
  end

  def model
    LeaseApplication
  end

  def values(app)
    mappings(app).values
  end

  def headers
    mappings(LeaseApplication.first).keys
  end

  def mappings(app)
    {
        'Days Since Application Submitted' => (Time.now.to_date - app.created_at.to_date).to_i,
        'App Received Date'                => app.created_at.in_time_zone('Eastern Time (US & Canada)').strftime('%m/%d/%Y %r'),
        'Application Identifier'           => app.application_identifier,
        'Dealer'                           => app.dealer&.full_name&.upcase,
        'Dealer Contact'                   => app.dealer&.dealership&.name&.upcase,
        'Lessee'                           => app.lessee&.full_name,
        'Applicant Credit Score'           => app.lessee&.highest_fico_score,
        'Co-Applicant'                     => app.colessee&.full_name,
        'Co-Applicant Credit Score'        => app.colessee&.highest_fico_score,
        'Number and Street'                => app.lessee&.home_address&.street1, 
        'Apt. / Unit'                      => app.lessee&.home_address&.street2,
        'City'                             => app.lessee&.home_address&.new_city_value,
        'State'                            => app.lessee&.home_address&.new_state_value,
        'Zip'                              => app.lessee&.home_address&.zipcode,
        'County'                           => app.lessee&.home_address&.new_county_value,
        'Primary Phone'                    => app.lessee&.mobile_phone_number,
        'Secondary Phone'                  => app.lessee&.home_phone_number,
        'Email'                            => app.lessee&.email_address,
        'Bike'                             => app.lease_calculator&.display_name,
        'Decision Date'                    => app.credit_decision_date&.in_time_zone('Eastern Time (US & Canada)')&.strftime('%m/%d/%Y %r'),
        'App Status'                       => app.credit_status,
        'SLC Tier'                         => app.lease_calculator&.credit_tier_v2&.description,
        # 'Comments'                         => '',
        'Lease Package Sent Date'          => app.documents_issued_date,
        'Funding Package Received Date'    => app.lease_package_received_date&.in_time_zone('Eastern Time (US & Canada)')&.strftime('%m/%d/%Y %r'),
        'Funding Delay Issue Date'         => app.funding_delay_on,
        'Funding Delays'                   => app.funding_delays&.map { |delay| delay&.funding_delay_reason.reason }.join(', '),
        'Outstanding'                      => app.lease_application_stipulations&.where(status: 'Required').map { |s| s.stipulation.description }.join(', '),
        'Cleared'                          => app.lease_application_stipulations&.where(status: 'Cleared').map { |s| s.stipulation.description }.join(', '),
        'Funding Approval Date'            => app.funding_approved_on,
        'Funding Date'                     => app.funded_on,
        'Speed Remits To Dealer Amount'    => app.lease_calculator.remit_to_dealer,
        'Lessee Proven Monthly Income'     => app.lessee&.proven_monthly_income,
        'Co-Lessee Proven Monthly Income'  => app.colessee&.proven_monthly_income,
        'Document Status'                  => app.document_status,
        'First Payment Date'               => app.first_payment_date,
        'Welcome Call Status'              => app.lease_application_welcome_calls&.order(created_at: :desc)&.last&.welcome_call_status&.description,
        'Welcome Call Due Date'            => app.welcome_call_due_date,
        'Welcome Call History'             => app.lease_application_welcome_calls&.order(created_at: :desc)&.map{ |w| [w.created_at&.in_time_zone('Eastern Time (US & Canada)')&.strftime('%m/%d/%Y %r %Z'), w.welcome_call_status&.description, w&.representative_full_name, w.welcome_call_type&.description, w.welcome_call_result&.description].join(',').chomp(",,") }.join(' | ')
    }
  end

  def filepath
    @filepath = "#{Rails.root.to_s}/tmp/lease_applications_export_#{Time.now.to_i}.csv"
  end
end