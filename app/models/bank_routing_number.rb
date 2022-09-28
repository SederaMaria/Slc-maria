# == Schema Information
#
# Table name: bank_routing_numbers
#
#  id                      :integer          not null, primary key
#  routing_number          :string
#  office_code             :string
#  servicing_frb_number    :string
#  record_type_code        :string
#  change_date             :date
#  new_routing_number      :string
#  customer_name           :string
#  address                 :string
#  city                    :string
#  state_code              :string
#  zipcode                 :string
#  zipcode_extension       :string
#  telephone_area_code     :string
#  telephone_prefix_number :string
#  telephone_suffix_number :string
#  institution_status_code :string
#  data_view_code          :string
#  filler                  :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_bank_routing_numbers_on_routing_number  (routing_number) UNIQUE
#

class BankRoutingNumber < ApplicationRecord

  OFFICE_CODE = [['Main Office', 'O'], ['Branch Office', 'B']]
  RECORD_TYPE_CODE = [['Institution is a Federal Reserve Bank', '0'], ['Send items to customer routing number', '1'], ['Send items to customer using new routing number field', '2']]
  INSTITUTION_STATUS_CODE = [['Receives Gov/Comm', '1']]
  DATA_VIEW_CODE = [['Current view', '1']]

  validates :routing_number, uniqueness: true, presence: true

end
