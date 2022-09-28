# == Schema Information
#
# Table name: related_applications
#
#  id                     :bigint(8)        not null, primary key
#  origin_application_id  :integer          not null
#  related_application_id :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_related_applications_on_origin_application_id   (origin_application_id)
#  index_related_applications_on_related_application_id  (related_application_id)
#

FactoryBot.define do
  factory :related_application do
    origin_application_id { 1 }
    related_application_id { 1 }
  end
end
