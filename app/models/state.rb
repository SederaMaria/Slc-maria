# == Schema Information
#
# Table name: states
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string           not null
#  abbreviation           :string           not null
#  sum_of_payments_state  :boolean          default(FALSE)
#  active_on_calculator   :boolean          default(FALSE)
#  tax_jurisdiction_label :string
#  label_text             :string
#  hyperlink              :string
#  state_enum             :integer
#
# Indexes
#
#  index_states_on_abbreviation  (abbreviation) UNIQUE
#

class State < ApplicationRecord
  TAX_JURISDICTION_LABELS =  %w(Customer's\ County/Town
                                Customer's\ Zip\ Code
                                Customer's\ Parish
                                Dealership's\ County/Town
                                Dealership's\ Zip\ Code
                                Custom )
  
  scope :sum_of_payments_states, -> { where(sum_of_payments_state: true) }
  scope :active_on_calculator, -> { where(active_on_calculator: true) }

  validates_uniqueness_of :abbreviation
  validates_uniqueness_of :state_enum
  validates :tax_jurisdiction_label, :name, :abbreviation, presence: true
  
  has_one :lpc_form_code_lookup
  
end
