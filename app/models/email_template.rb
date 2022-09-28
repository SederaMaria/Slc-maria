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

class EmailTemplate < ApplicationRecord
    validates :name, presence: true, uniqueness: true

    scope :lease_package_recieved,     -> { find_by(name: "Lease Package Received") }
    scope :blackbox_auto_reject,     -> { find_by(name: "Blackbox Auto Reject") }

end
