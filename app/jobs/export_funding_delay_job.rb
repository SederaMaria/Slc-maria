class ExportFundingDelayJob
    include Sidekiq::Worker
  
    sidekiq_options unique:      :until_executed,
                    unique_args: :unique_args
  
    attr_reader :recipient, :filter
  
    def self.unique_args(args)
      args[0]['email']
    end
  
    def perform(opts = {})
      @recipient = opts.with_indifferent_access['email']
      @filter    = opts.with_indifferent_access['filter'] || { document_status_eq: 'funding_delay' }
      generate_csv
      email_to_recipient
      return filepath
    end
  
    def email_to_recipient
      DealerMailer.funding_delay_export(recipient: recipient, filepath: @filepath).deliver_now
    end
  
    def generate_csv
      CSV.open(filepath, 'wb', headers: true) do |csv|
        csv << headers
        model.limit(nil).ransack(filter).result.find_each do |application|
          csv << values(application)
        end
      end
    end
  
    private
  
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
        "Application Identifier"        => app&.application_identifier,
        "Dealership"                    => app&.dealership&.name,
        "Lessee"                        => "#{app&.lessee&.first_name} #{app&.lessee&.last_name}",
        "Colessee"                      => "#{app&.colessee&.first_name} #{app&.lessee&.last_name}",
        "Asset"                         => "#{app&.asset_year} #{app&.asset_model}",
        "Credit Tier"                   => "#{app&.lease_calculator&.credit_tier_v2&.description}",
        "Credit Status"                 => "#{app&.credit_status&.humanize}",
        "Document Status"               => "#{app&.document_status&.humanize}",
        "Uploaded At"                   => "#{app&.updated_at}",
        "Dealer Name"                   => "#{app&.dealer&.first_name} #{app&.dealer&.last_name}",
        "Dealer Phone Number"           => app&.dealer&.dealership&.primary_contact_phone,
        "Primary Applicant Number"      => "#{app&.lessee&.home_phone_number || app&.lessee&.mobile_phone_number}",
      }
    end
  
    def filepath
      @filepath = "#{Rails.root.to_s}/tmp/funding_delay_export_#{Time.now.to_i}.csv"
    end
  end