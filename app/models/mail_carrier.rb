# == Schema Information
#
# Table name: mail_carriers
#
#  id          :bigint(8)        not null, primary key
#  description :string
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sort_index  :integer
#

class MailCarrier < ApplicationRecord

  class << self
    def update_sort_index(mail_carrier_params, sort_index)
      mail_carrier = MailCarrier.find_by(id: mail_carrier_params['id'])
      mail_carrier.update(sort_index: sort_index) if mail_carrier.present?
    end
  end
end
