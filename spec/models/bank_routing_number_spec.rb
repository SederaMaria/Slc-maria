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

require 'rails_helper'

RSpec.describe BankRoutingNumber, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
