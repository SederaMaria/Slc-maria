# == Schema Information
#
# Table name: us_states
#
#  id                           :bigint(8)        not null, primary key
#  name                         :string
#  abbreviation                 :string
#  sum_of_payments_state        :boolean
#  active_on_calculator         :boolean
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  security_deposit             :integer          default(0), not null
#  enable_security_deposit      :boolean          default(FALSE)
#  label_text                   :string
#  hyperlink                    :string
#  state_enum                   :integer
#  geo_code_state               :string(2)
#  tax_jurisdiction_type_id     :bigint(8)
#  secretary_of_state_website   :string
#  enable_electronic_signatures :boolean          default(FALSE), not null
#
# Indexes
#
#  index_us_states_on_abbreviation              (abbreviation) UNIQUE
#  index_us_states_on_state_enum                (state_enum) UNIQUE
#  index_us_states_on_tax_jurisdiction_type_id  (tax_jurisdiction_type_id)
#

class UsState < ApplicationRecord
  # OPTIONAL: Might be reused with ActiveModel::EachValidator
  URL_REGEXP = /\A^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$\z/ix
	TAX_JURISDICTION_LABELS =  %w(Customer's\ County/Town
                                Customer's\ Zip\ Code
                                Customer's\ Parish
                                Dealership's\ County/Town
                                Dealership's\ Zip\ Code
                                Custom )

  LEASE_APPLICATION_STATES = {
      'AL' => 'Alabama',
      'AZ' => 'Arizona',
      'CA' => 'California',
      'DE' => 'Delaware',
      'FL' => 'Florida',
      'GA' => 'Georgia',
      'IL' => 'Illinois',
      'IN' => 'Indiana',
      'LA' => 'Louisiana',
      'MD' => 'Maryland',
      'MI' => 'Michigan',
      'MS' => 'Mississippi',
      'MO' => 'Missouri',
      'NV' => 'Nevada',
      'NJ' => 'New Jersey',
      'NM' => 'New Mexico',
      'NC' => 'North Carolina',
      'OH' => 'Ohio',
      'OK' => 'Oklahoma',
      'PA' => 'Pennsylvania',
      'SC' => 'South Carolina',
      'TN' => 'Tennessee',
      'TX' => 'Texas',
      'VA' => 'Virginia'
  }.freeze
  
  scope :sum_of_payments_states, -> { where(sum_of_payments_state: true) }
  scope :active_on_calculator, -> { where(active_on_calculator: true) }

  validates_uniqueness_of :abbreviation
  validates_uniqueness_of :state_enum
  validates :name, :abbreviation, presence: true
  validates :secretary_of_state_website, format: { with: URL_REGEXP, message: 'Invalid URL' }, allow_blank: true

  belongs_to :tax_jurisdiction_type, required: true

  has_one :lpc_form_code_lookup

  has_many :holding_counties, dependent: :destroy, class_name: "County", foreign_key: :us_state_id

  def check_location
    tax_jurisdiction_type.name.include?("Customer")
  end
end
