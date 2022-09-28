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

class Audit < ApplicationRecord
  belongs_to :audited, polymorphic: true, optional: true
  belongs_to :user, polymorphic: true, optional: true
  scope :with_parents, -> (id) { where('parent_id = ?', id) }
  scope :with_dealers, -> { where(user_type: 'Dealer') }
  scope :with_admin_users, -> { where(user_type: 'AdminUser') }
  scope :with_no_users, -> { where(user_type: nil) }
  scope :with_no_tokens, 
    -> () { where(arel_table[:audited_changes].does_not_match("%Last Request At%")).where(arel_table[:audited_changes].does_not_match("%Auth Token Created At%")) }
end
