class DocusignSummary < ApplicationRecord
  include SimpleAudit::Model
  simple_audit child: true

  has_many :docusign_histories, dependent: :destroy
  belongs_to :lease_application
  enum envelope_status: { sent: 0, voided: 1, completed: 2, created: 3, delivered: 4, deleted: 5, signed: 6,
                          declined: 7, timed_out: 8, authoritative_copy: 9, transfer_completed: 10,
                          template: 11, correct: 12 }
  validates :envelope_id, :envelope_status, presence: true
  scope :search_all_fields, -> (text){
    # joins(:docusign_histories)
    where("cast(envelope_id as text) LIKE ?
    OR lease_application_id IN(select id from lease_applications where application_identifier like ?)
    OR cast(envelope_status as integer) = ?",
    "%#{text}%", "%#{text}%",self.envelope_statuses[text.downcase]).ordered_by_created_at
  }
  scope :ordered_by_created_at, -> { order(created_at: :desc) }
end
