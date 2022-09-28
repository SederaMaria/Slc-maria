namespace :update_lessees_created_at do
  desc 'Update Lessee `created_at`'
  task update: :environment do
    Lessee.where.not(deleted_from_lease_application_id: nil).find_each do |applicant|
      applicant.update(deleted_at: applicant.created_at)
    end
  end
end
