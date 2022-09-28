# == Schema Information
#
# Table name: email_templates
#
#  id              :bigint(8)        not null, primary key
#  template        :string
#  enable_template :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :email_template do
    string { "" }
    boolean { "" }
  end
end
