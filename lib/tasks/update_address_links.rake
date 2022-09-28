namespace :update_address_links_167335937 do
  desc 'Update addresses linked to OPA LOCKA and delete OPA LOCKA'
  task update: :environment do
    LeaseApplication.where(city_id: [5896,5897]).update_all(city_id: 5898)
    City.where(id: [5896,5897]).delete_all
  end
end
