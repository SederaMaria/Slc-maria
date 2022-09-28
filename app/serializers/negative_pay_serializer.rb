# == Schema Information
#
# Table name: negative_pays
#
#  id                         :bigint(8)        not null, primary key
#  payment_bank_name          :string
#  payment_account_type       :string
#  payment_account_number     :string
#  payment_aba_routing_number :string
#  request                    :string
#  response                   :string
#  lease_application_id       :bigint(8)
#  lessee_id                  :bigint(8)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_negative_pays_on_lease_application_id  (lease_application_id)
#  index_negative_pays_on_lessee_id             (lessee_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#  fk_rails_...  (lessee_id => lessees.id)
#

class NegativePaySerializer < ApplicationSerializer
    attributes :id, :result, :response, :date

    def result
        self.object&.response["decision"]
    end

    def response
        self.object&.rejected_response
    end

    def date
        self.object&.created_at.strftime('%B %-d %Y at %r %Z')
    end

end
