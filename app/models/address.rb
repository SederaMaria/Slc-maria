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

class Address < ApplicationRecord
  include SimpleAudit::Model
  simple_audit child: true

  has_one :address_validation, foreign_key: 'validatable_id', dependent: :destroy
  belongs_to :new_city, class_name: 'City', foreign_key: 'city_id'

  #validates :state, length: {is: 2, allow_blank: true}
  validate :check_zipcode_length

  before_validation :upcase_attributes


  accepts_nested_attributes_for :new_city, reject_if: :all_blank

  def full_name
    "#{street1_street2} #{city_state_zip}".squish
  end

  def street1_street2
    "#{street1} #{street2}".squish
  end

  def city_state_zip
    "#{new_city_value}, #{new_state_value} #{zipcode}".squish
  end

  def to_smarty_streets_format
    [
      {:street=>self.street1, :city=>new_city_value, :state=>new_state_value, :zipcode=>self.zipcode}
    ]
  end

  def address
    street1
  end

  def new_city_value
    new_city.nil? ? city : new_city.name
  end

  def new_state_value
    new_city.nil? ? state : new_city&.us_state&.abbreviation
  end

  def new_county_value
    new_city.nil? ? county : new_city&.county&.name
  end

  def new_city_collection_value
    new_city.nil? ? [] : [[new_city.name, new_city.id]]
  end

  # TODO: Find a better solution for this
  # Specific use: to easily spawn a `search_address` input in
  # app/views/dealers/lease_applications/_lessee-form.html.slim
  def search_address
    [street1, street2, new_city_value, new_state_value, zipcode].select(&:present?).join(', ')
  end

  def search_address=(_attribute)
  end

private
  def check_zipcode_length
    return true if zipcode.blank?
    unless zipcode.size == 5 or zipcode.size == 10
      errors.add(:zipcode, 'length must be 5 or 10')
    end
  end

  def upcase_attributes
    self.street1 = self.street1&.upcase
    self.street2 = self.street2&.upcase
    self.city    = self.city&.upcase
    self.state   = self.state&.upcase
    self.county  = self.county&.upcase
  end
end
