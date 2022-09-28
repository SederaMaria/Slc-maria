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
class TaxJurisdictionType < ApplicationRecord
  validates :name, presence: true
end
