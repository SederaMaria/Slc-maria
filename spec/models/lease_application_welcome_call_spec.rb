# == Schema Information
#
# Table name: lease_application_welcome_calls
#
#  id                                  :bigint(8)        not null, primary key
#  lease_application_id                :integer
#  welcome_call_result_id              :integer
#  welcome_call_type_id                :integer
#  welcome_call_status_id              :integer
#  welcome_call_representative_type_id :integer
#  admin_id                            :integer
#  due_date                            :datetime
#  notes                               :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#

require 'rails_helper'

RSpec.describe LeaseApplicationWelcomeCall, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
