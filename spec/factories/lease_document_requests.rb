# == Schema Information
#
# Table name: lease_document_requests
#
#  id                      :integer          not null, primary key
#  lease_application_id    :integer
#  asset_make              :string
#  asset_model             :string
#  asset_year              :integer
#  asset_vin               :string
#  asset_color             :string
#  exact_odometer_mileage  :string
#  trade_in_make           :string
#  trade_in_model          :string
#  trade_in_year           :string
#  delivery_date           :date
#  gap_contract_term       :integer          default(0)
#  service_contract_term   :integer          default(0)
#  ppm_contract_term       :integer          default(0)
#  tire_contract_term      :integer          default(0)
#  equipped_with           :string
#  notes                   :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  manual_vin_verification :boolean
#
# Indexes
#
#  index_lease_document_requests_on_lease_application_id  (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

FactoryBot.define do
  factory :lease_document_request do
    lease_application

    asset_make             { FFaker::Product.brand }
    asset_model            { FFaker::Product.model }
    asset_year             { 2017 }
    asset_vin              { '1HDabcdefghihjklm' }
    asset_color            { 'black' }
    exact_odometer_mileage { '12,345 km' }
    trade_in_make          { FFaker::Product.brand }
    trade_in_model         { FFaker::Product.model }
    trade_in_year          { 2017 }
    delivery_date          { Date.current }
    gap_contract_term      { 24 }
    service_contract_term  { 24 }
    ppm_contract_term      { 24 }
    tire_contract_term     { 24 }
    equipped_with          { 'sidebar' }
    notes                  { FFaker::BaconIpsum.paragraph }
  end
end
