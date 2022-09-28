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

class RelatedApplication < ApplicationRecord
  belongs_to :origin_application, foreign_key: 'origin_application_id', class_name: 'LeaseApplication'
  belongs_to :related_application, foreign_key: 'related_application_id', class_name: 'LeaseApplication'

  validates_uniqueness_of :origin_application, scope: :related_application
end
