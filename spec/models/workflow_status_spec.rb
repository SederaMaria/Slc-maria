# == Schema Information
#
# Table name: workflow_statuses
#
#  id          :bigint(8)        not null, primary key
#  description :string
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe WorkflowStatus, type: :model do
  workflow = WorkflowStatus.new(
    description: "Test",
  )
  it 'return description' do
      expect(workflow.description).to eq "Test"
  end

  #it 'should Lease Application belongs to' do
  #  t = WorkflowStatus.reflect_on_association(:lease_application)
  #  expect(t.macro).to eq(:belongs_to)
  #end

end
