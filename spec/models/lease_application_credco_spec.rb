# == Schema Information
#
# Table name: lease_application_credcos
#
#  id                   :bigint(8)        not null, primary key
#  lease_application_id :integer
#  credco_xml           :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe LeaseApplicationCredco, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
