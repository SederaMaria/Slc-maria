# == Schema Information
#
# Table name: lease_application_gps_units
#
#  id                       :integer  not null, primary key
#  lease_application_id     :bigint   not null
#  gps_serial_number        :string   not null
#  active                   :boolean  not null                default(TRUE)
#  created_by_admin_id      :bigint   
#  updated_by_admin_id      :bigint   
#  created_at               :datetime not null
#  updated_at               :datetime not null
#
# Indexes
#
#  index_gps_units_created_by_on_admin_user_id                (created_by_admin_id)
#  index_gps_units_on_lease_application_id                    (lease_application_id)
#  index_gps_units_updated_by_on_admin_user_id                (updated_by_admin_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_admin_id => admin_users.id)
#  fk_rails_...  (updated_by_admin_id => admin_users.id)
#  fk_rails_...  (lease_application_id => lease_applications.id)
#      

FactoryBot.define do
  factory :lease_application_gps_unit do
    lease_application_id { 39932 }
    gps_serial_number { "a1234b56" }
    active { true }
    created_by_admin_id { 132 }
    updated_by_admin_id { 3 }
  end
end
