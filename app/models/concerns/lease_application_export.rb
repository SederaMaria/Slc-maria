module LeaseApplicationExport
  def self.included(base)
    base.instance_eval do
      csv do
        column 'Days Since Application Submitted' do |application|
          (Time.now.to_date - application.created_at.to_date).to_i if application.created_at
        end
        column 'App Received Date' do |application|
          application.created_at.in_time_zone('Eastern Time (US & Canada)').strftime('%m/%d/%Y %r')
        end
        column :application_identifier
        column :dealer do |application|
          application.dealer&.full_name
        end
        column :dealer_contact do |application|
          application.dealer&.dealership&.name
        end
        column :lessee do |application|
          application.lessee&.full_name
        end
        column :applicant_credit_score do |application|
          application.lessee.highest_fico_score rescue ''
        end
        column 'Co-Applicant' do |application|
          application.colessee&.full_name
        end
        column 'Co-Applicant Credit Score' do |application|
          application.colessee.highest_fico_score rescue ''
        end
        column 'Number and Street' do |application|
          application.lessee&.home_address&.street1
        end

        column 'Apt. / Unit' do |application|
          application.lessee&.home_address&.street2
        end
        column 'City' do |application|
          application.lessee&.home_address&.new_city_value
        end
        column 'State' do |application|
          application.lessee&.home_address&.state
        end
        column 'Zip' do |application|
          application.lessee&.home_address&.zipcode
        end
        column 'County' do |application|
          application.lessee&.home_address&.county
        end
        column 'Primary Phone' do |application|
          application.lessee&.mobile_phone_number
        end
        column 'Secondary Phone' do |application|
          application.lessee&.home_phone_number
        end
        column 'Email' do |application|
          application.lessee&.email_address
        end
        column 'Bike' do |application|
          application.lease_calculator.display_name
        end
        column 'Decision Date' do |application|

        end
        column 'App Status' do |application|
          application.credit_status
        end
        column 'SLC Tier' do |application|

        end
        column 'Comments' do |application|

        end
        column 'Lease Package Sent Date' do |application|

        end
        column 'Funding Package Received Date' do |application|

        end
        column 'Funding Delay Issue Date' do |application|

        end
        column 'Funding Delays' do |application|

        end
        column 'Outstanding' do |application|

        end
        column 'Cleared' do |application|

        end
        column 'Funding Approval Date' do |application|

        end
        column 'Funding Date' do |application|

        end
        column 'Speed Remits To Dealer Amount' do |application|
          application.lease_calculator.remit_to_dealer
        end
      end
    end
  end
end
