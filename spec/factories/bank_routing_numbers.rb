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

FactoryBot.define do
  factory :bank_routing_number do
    
    routing_number             {generate(:routing_number)}
    office_code                { "O" }
    servicing_frb_number       { "11008515" }
    record_type_code           { "1" }
    change_date                { Date.current }
    new_routing_number         { "500015" }
    customer_name              { FFaker::Name.name }
    address                    { FFaker::Address.secondary_address }
    city                       { FFaker::Address.city }
    state_code                 { FFaker::AddressUS.state_abbr }
    zipcode                    { FFaker::AddressUS.zip_code }
    zipcode_extension          { "7025" }
    telephone_area_code        { FFaker::PhoneNumber.area_code }
    telephone_prefix_number    { "123" }
    telephone_suffix_number    { "8376" }
    institution_status_code    { "1" }
    data_view_code             { "1" }
    filler                     { " " }
    
  end

  sequence :routing_number do |n|
     "#{ n + 11000000}"
  end
end
