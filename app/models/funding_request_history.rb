# == Schema Information
#
# Table name: funding_request_histories
#
#  id                   :bigint(8)        not null, primary key
#  lease_application_id :bigint(8)
#  amount_cents         :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_funding_request_histories_on_lease_application_id  (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

class FundingRequestHistory < ApplicationRecord
  belongs_to :lease_application


  #monetize all _cents fields with a couple of lines
  if table_exists? #fix issue with rake db:schema:load
    self.column_names.each { |col| monetize(col) if col.ends_with?('_cents') }
  end

end
