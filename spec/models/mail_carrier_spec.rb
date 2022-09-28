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

require 'rails_helper'

RSpec.describe MailCarrier, type: :model do

  carrier = MailCarrier.new(
    description: 'UPS',
    active: true
  )
  it 'return description' do
    expect(carrier.description).to eq 'UPS'
  end

  it 'return admin_user_id' do
    expect(carrier.active).to eq true
  end

  it 'should Lease Application belongs to' do
    t = LeaseApplication.reflect_on_association(:mail_carrier)
    expect(t.macro).to eq(:belongs_to)
  end

end
