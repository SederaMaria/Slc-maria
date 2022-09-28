require 'rails_helper'

RSpec.describe Dealers::DashboardFacade, type: :facade do
  describe 'lease_apps' do
    let(:dealer) { create :dealer }
    let(:apps) { create_list :lease_application, 3, dealer: dealer }
    let!(:other_apps) { create_list :lease_application, 3 }
    let(:decorated_apps) { LeaseApplicationDecorator.decorate_collection(apps) }

    subject { described_class.new(dealer: dealer).lease_apps }

    it { is_expected.to include *decorated_apps }
  end
end
