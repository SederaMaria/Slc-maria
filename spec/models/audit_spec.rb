# == Schema Information
#
# Table name: audits
#
#  id              :integer          not null, primary key
#  audited_id      :integer
#  audited_type    :string
#  user_id         :integer
#  audited_changes :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_type       :string
#  parent_id       :integer
#  parent_type     :string
#
# Indexes
#
#  index_audits_on_audited_id_and_audited_type  (audited_id,audited_type)
#  index_audits_on_user_id                      (user_id)
#  index_audits_on_user_id_and_user_type        (user_id,user_type)
#

require 'rails_helper'

RSpec.describe Audit, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
