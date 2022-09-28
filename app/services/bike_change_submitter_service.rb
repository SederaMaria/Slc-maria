class BikeChangeSubmitterService
  attr_reader :lease_calculator

  def initialize(lease_calculator:)
    @lease_calculator = lease_calculator
  end

	def bike_change(params)
		LeaseCalculator.transaction do
			if lease_calculator.nada_retail_value.to_f < params["nada_retail_value"].to_f
				original_bike             = lease_calculator.display_name&.upcase
				original_bike_nada_retail = lease_calculator.nada_retail_value&.to_s
				lease_calculator.assign_attributes(params)
				if lease_calculator.valid?
					lease_calculator.lease_application.update(credit_status: "awaiting_credit_decision")
					notify_admins(original_bike, original_bike_nada_retail)
				end
			end
		end
	end

	private
		def notify_admins(original_bike, original_bike_nada_retail)
			DealerMailer.bike_change_submitted(lease_calculator.lease_application.id, original_bike, original_bike_nada_retail).deliver_later(wait: 1.minute)
			Notification.create_for_admins(
				notification_mode:    'InApp',
				notification_content: 'bike_change',
				notifiable:           lease_calculator.lease_application
			)
		end
end
