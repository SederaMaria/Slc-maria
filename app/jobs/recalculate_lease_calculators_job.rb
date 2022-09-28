class RecalculateLeaseCalculatorsJob < ApplicationJob
  queue_as :default

  def perform(lease_calculator_id:)
    #Recalculate! only if the Calculator can access a model year?
    if lease_calculator = LeaseCalculator.where(id: lease_calculator_id).first 
      if model_year_record = lease_calculator.model_year_record.present? #it looked up
        app_id = lease_calculator.lease_application.application_identifier

        LeaseRecalculator.new(lease_calculator: lease_calculator).recalculate_and_save

        puts "[RECALCULATING #{app_id}] THESE ATTRIBUTES CHANGED: #{lease_calculator.changed}"
        puts "[RECALCULATING #{app_id}] HERE ARE THE CHANGES: #{lease_calculator.changes}"

        lease_calculator.save
      end
    end
  end
end
