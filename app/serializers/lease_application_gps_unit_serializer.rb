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

class LeaseApplicationGpsUnitSerializer < ApplicationSerializer
  attributes :id, :lease_application_id, :gps_serial_number, :active, :created_by_admin_id, :updated_by_admin_id, :created_at, :updated_at
end