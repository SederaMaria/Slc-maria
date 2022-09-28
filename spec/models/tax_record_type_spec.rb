# == Schema Information
#
# Table name: tax_record_types
#
#  id                 :bigint(8)        not null, primary key
#  vertex_record_type :integer
#  record_type_desc   :string(100)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe TaxRecordType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
