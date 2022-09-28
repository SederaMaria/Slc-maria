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

require 'rails_helper'

RSpec.describe EmailTemplate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
