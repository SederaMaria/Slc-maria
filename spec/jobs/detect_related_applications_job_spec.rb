require 'rails_helper'

RSpec.describe DetectRelatedApplicationsJob, type: :job do
  describe '#perform' do
    it 'stores related applications if found', retry: 3, retry_wait: 10 do
      app = create(:lease_application)
      related_applications = create_list(:lease_application, 4, lessee: create(:lessee, ssn: app.lessee.ssn))
      unrelated_applications = create_list(:lease_application, 2, lessee: create(:lessee, ssn: 'irrelevant'))

      described_class.new.perform(app.id)

      expect(app.reload.related_applications.size).to eq 4
      expect(app.reload.related_applications.pluck(:related_application_id)).to eq related_applications.pluck(:id)
    end

    it 'filters out empty string and nil SSNs from detection' do
      app = create(:lease_application, lessee: create(:lessee, ssn: ''))
      unrelated_applications = create_list(:lease_application, 2, lessee: create(:lessee, ssn: ''))

      described_class.new.perform(app.id)

      expect(app.reload.related_applications.size).to eq 0
    end
  end
end
