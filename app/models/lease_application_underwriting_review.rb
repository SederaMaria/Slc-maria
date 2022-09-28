class LeaseApplicationUnderwritingReview < ApplicationRecord
  include SimpleAudit::Model
  simple_audit child: true
  include SimpleAudit::Custom::LeaseApplicationUnderwritingReview

  belongs_to :lease_application, required: true
  belongs_to :admin_user, required: true
  belongs_to :workflow_status, required: true

  validates :comments, presence: true
end
