# == Schema Information
#
# Table name: lease_package_templates
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  lease_package_template :string
#  document_type          :integer          not null
#  us_states              :string           default([]), not null, is an Array
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  position               :integer
#  enabled                :boolean          default(TRUE), not null
#
# Indexes
#
#  index_lease_package_templates_on_name  (name) UNIQUE
#

require 'rails_helper'

RSpec.describe LeasePackageTemplate, type: :model do
  describe "when saving" do
    subject { described_class.new(us_states: ['GA', 'FL', nil, "     "]) }
    before do
      subject.valid?
    end
    it "will reject any blank us_states" do
      expect(subject.us_states).to eq(['GA', 'FL'])
    end
  end

  describe 'name should be unique, on a per document_type basis' do
    let!(:lease_package_template) { create(:lease_package_template, name: 'Kentucky', document_type: :title ) }

    context "with the same name and document_type" do
      let(:duplicated_lease_package_template) { build(:lease_package_template, name: 'Kentucky', document_type: :title ) }
      it { expect(duplicated_lease_package_template).not_to be_valid }
    end

    context "with the same name, but a different document_type" do    
      let(:duplicated_lease_package_template) { build(:lease_package_template, name: 'Kentucky', document_type: :dealership ) }
      it { expect(duplicated_lease_package_template).to be_valid }
    end
  end
end
