require 'csv'
namespace :import_data do
  desc "Import attached fixed width file (FedACHDir.txt) into a bank_routing_numbers table"
  task bank_routing: :environment do
    DataImportService.new(method_type: "fixedwidth", file_name: File.join(Rails.root, 'lib', 'data', 'FedACHdir.txt')).import_data_bank_routing
  end

  
  desc "Import Harley Davidson Model Years from lib/data/tbl_TMotorcycleModelDetails.txt"
  task model_years: :environment do
    DataImportService.new(method_type: "psv", file_name: File.join(Rails.root, 'lib', 'data', 'tbl_TMotorcycleModelDetails.txt')).import_data_for_all_make
  end

  desc "Import Make Data from NADA API"
  task models_data: :environment do
    DataImportService.new(method_type: '', file_name: '').import_data_from_nada
    DataImportService.new(method_type: '', file_name: '').send_nada_updates
  end

  desc 'Clear Model Years Table'
  task clear_model_years: :environment do
    ModelYear.delete_all
  end

  desc 'Send NADA API updates to Admin'
  task send_nada_updates: :environment do
    new_models = ModelYear.where(:created_at => Time.zone.now.beginning_of_day.utc..Time.zone.now.end_of_day.utc)
    updated_models = ModelYear.where(end_date: Date.today)
    AdminMailer.models_list(new_models, updated_models).deliver_now
  end

  desc 'Update lease calculator with new nada values'
  task update_lease_calculator_nada_values: :environment do
    lease_applications = LeaseApplication.where(:submitted_at => (Date.today - 31.days)..Date.today)
                                         .where(:document_status => 'no_documents')
    lease_applications.each do |la|
      lc = la.lease_calculator
      if lc.present?
        model_year = ModelYear.active.where(year: lc.asset_year).where('LOWER(name) = ?', lc.asset_model.downcase).last
        if model_year.present?
          nada_rough_vc = lc.nada_rough_value_cents.presence || 0
          nada_retail_vc = lc.nada_retail_value_cents.presence || 0
          my_nrc = model_year.nada_rough_cents.presence || 0
          my_narc = model_year.nada_avg_retail_cents.presence || 0

          if ((nada_rough_vc != my_nrc) || (nada_retail_vc != my_narc))
            nada_rough_value_cents = [nada_rough_vc, my_nrc].max
            nada_retail_value_cents = [nada_retail_vc, my_narc].max
            lc.update!(nada_rough_value_cents: nada_rough_value_cents, nada_retail_value_cents: nada_retail_value_cents)
            Rails.logger.info("LeaseApplication updated for #{la.application_identifier}, Calculator ID : #{lc.id}")
          end
        else
          Rails.logger.info("Bike Model not found for #{la.application_identifier}, Calculator ID : #{lc.id}, Model Name : #{lc.asset_model} & year : #{lc.asset_year}")
        end
      end
    end
  end
end
