namespace :decline_reasons do
  desc "Destroy duplicate records"
  task destroy_duplicate_records: :environment do
    lease_application_ids = DeclineReason.select("lease_application_id").where.not(lease_application_id: nil).distinct.pluck(:lease_application_id)

    LeaseApplication.where(id: lease_application_ids).each do |lease_application|
      to_be_preserved = {}
      decline_reasons_ids = lease_application.decline_reasons.map do |decline_reason|
        to_be_preserved[decline_reason.description] = decline_reason.id
        decline_reason.id
      end
      to_be_destroyed_ids = decline_reasons_ids - to_be_preserved.values

      lease_application.decline_reasons.where(id: to_be_destroyed_ids).destroy_all
    end
  end
end
