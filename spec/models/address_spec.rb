# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  street1    :string
#  street2    :string
#  city       :string
#  state      :string
#  zipcode    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  county     :string
#

require 'rails_helper'

RSpec.describe Address, type: :model do
  let!(:full_address) { build(:address) }
  let!(:empty_address) { build(:address, :empty)}
  let!(:employment_address) { build(:address, :employment_only) }

  describe '#upcase' do
    let(:street1) { 'red and gold street' }
    let(:state) { 'ga' }
    let(:county) { 'fulton' }
    let(:city) { 'atlanta' }
    let(:street2) { 'suite 500' }
    let(:address) { create(:address, street1: street1, state: state, county: county, street2: street2, city: city) }

    it { expect(address.reload.state).to   match(/[[:upper:]]/) }
    it { expect(address.reload.street1).to match(/[[:upper:]]/) }
    it { expect(address.reload.street2).to match(/[[:upper:]]/) }
    it { expect(address.reload.new_city_value).to    match(/[[:upper:]]/) }
    it { expect(address.reload.new_county_value).to  match(/[[:upper:]]/) }
  end

end
