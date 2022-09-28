# == Schema Information
#
# Table name: lease_package_templates
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  lease_package_template :string
#  document_type          :integer          not null
#  us_states              :string           default([]), not null, is an Array
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  position               :integer
#  enabled                :boolean          default(TRUE), not null
#
# Indexes
#
#  index_lease_package_templates_on_name  (name) UNIQUE
#

FactoryBot.define do
  factory :lease_package_template do
    name { FFaker::Name.name }
    lease_package_template { fixture_file_upload('spec/data/TPS Report.pdf', Mime[:pdf]) }
    us_states { ['georgia'] }
    document_type { :dealership }

    factory :dealership_lease_package_template do
      lease_package_template { fixture_file_upload('spec/data/dealership-template.pdf', Mime[:pdf]) }
      document_type { :dealership }
      us_states { ['texas', 'oklahoma'] }
    end

    factory :customer_lease_package_template do
      lease_package_template { fixture_file_upload('spec/data/customer-template.pdf', Mime[:pdf]) }
      document_type { :customer }
      us_states { ['texas', 'florida'] }
    end
  end
end
