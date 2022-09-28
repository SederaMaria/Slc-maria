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
#
# Indexes
#
#  index_states_on_abbreviation  (abbreviation) UNIQUE
#

FactoryBot.define do
  factory :state do
    name { 'arizona' }
    abbreviation { 'AZ' }
    tax_jurisdiction_label { 'Customer\'s County/Town' }
  end
end
