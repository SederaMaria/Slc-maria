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

require 'rails_helper'

RSpec.describe RelatedApplication, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
