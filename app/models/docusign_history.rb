class DocusignHistory < ApplicationRecord
  belongs_to :docusign_summary
  enum user_role: { lessee: 0, colessee: 1, dealer: 2, approver: 3 }
  enum user_status: { created: 0, sent: 1, delivered: 2, signed: 3,
                      declined: 4, completed: 5, faxpending: 6, autoresponded: 7 }

  validates :user_name, :user_role, :user_email, presence: true
  validates :docusign_summary_id, uniqueness: { scope: [:docusign_summary_id, :user_role] }
end
