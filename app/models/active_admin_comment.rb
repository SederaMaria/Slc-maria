# == Schema Information
#
# Table name: active_admin_comments
#
#  id            :integer          not null, primary key
#  namespace     :string
#  body          :text
#  resource_id   :string           not null
#  resource_type :string           not null
#  author_type   :string
#  author_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_active_admin_comments_on_author_type_and_author_id      (author_type,author_id)
#  index_active_admin_comments_on_namespace                      (namespace)
#  index_active_admin_comments_on_resource_type_and_resource_id  (resource_type,resource_id)
#

class ActiveAdminComment < ApplicationRecord
  include SimpleAudit::Model
  simple_audit child: true
  include SimpleAudit::Custom::ActiveAdminComment

  belongs_to :resource, polymorphic: true
  belongs_to :author,   polymorphic: true

  validates :body, presence: true
end
