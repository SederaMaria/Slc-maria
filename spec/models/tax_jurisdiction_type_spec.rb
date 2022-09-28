# == Schema Information
#
# Table name: tax_jurisdiction_types
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  sort_order :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe TaxJurisdictionType, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :name }

    it 'is invalid without a name' do
      expect(build(:tax_jurisdiction_type, name: nil)).to_not be_valid
    end
  end
end
