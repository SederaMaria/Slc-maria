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

class LeaseApplicationGpsUnit < ApplicationRecord
  belongs_to :lease_application
  belongs_to :created_by_admin, class_name: 'AdminUser', foreign_key: 'created_by_admin_id'
  belongs_to :updated_by_admin, class_name: 'AdminUser', foreign_key: 'updated_by_admin_id'
end
