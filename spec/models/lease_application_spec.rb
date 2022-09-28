# == Schema Information
#
# Table name: lease_applications
#
#  id                                         :integer          not null, primary key
#  lessee_id                                  :integer
#  colessee_id                                :integer
#  dealer_id                                  :integer
#  lease_calculator_id                        :integer
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  document_status                            :string           default("no_documents"), not null
#  credit_status                              :string           default("unsubmitted"), not null
#  submitted_at                               :date
#  expired                                    :boolean          default(FALSE)
#  application_identifier                     :string
#  documents_issued_date                      :date
#  dealership_id                              :integer
#  lease_package_received_date                :datetime
#  credit_decision_date                       :datetime
#  funding_delay_on                           :date
#  funding_approved_on                        :date
#  funded_on                                  :date
#  first_payment_date                         :date
#  payment_aba_routing_number                 :string
#  payment_account_number                     :string
#  payment_bank_name                          :string
#  payment_account_type                       :integer          default(NULL)
#  payment_frequency                          :integer
#  payment_first_day                          :integer
#  payment_second_day                         :integer
#  second_payment_date                        :date
#  promotion_name                             :string
#  promotion_value                            :float
#  is_dealership_subject_to_clawback          :boolean          default(FALSE)
#  this_deal_dealership_clawback_amount       :decimal(30, 2)
#  after_this_deal_dealership_clawback_amount :decimal(30, 2)
#  city_id                                    :bigint(8)
#  vehicle_possession                         :string
#  payment_account_holder                     :string
#  welcome_call_due_date                      :datetime
#  department_id                              :bigint(8)
#  is_verification_call_completed             :boolean          default(FALSE)
#  is_exported_to_access_db                   :boolean          default(FALSE)
#  requested_by                               :integer
#  approved_by                                :integer
#  prenote_status                             :string
#  mail_carrier_id                            :bigint(8)
#  workflow_status_id                         :bigint(8)
#
# Indexes
#
#  index_lease_applications_on_application_identifier  (application_identifier) UNIQUE WHERE (application_identifier IS NOT NULL)
#  index_lease_applications_on_city_id                 (city_id)
#  index_lease_applications_on_colessee_id             (colessee_id)
#  index_lease_applications_on_dealer_id               (dealer_id)
#  index_lease_applications_on_dealership_id           (dealership_id)
#  index_lease_applications_on_department_id           (department_id)
#  index_lease_applications_on_lease_calculator_id     (lease_calculator_id)
#  index_lease_applications_on_lessee_id               (lessee_id)
#  index_lease_applications_on_mail_carrier_id         (mail_carrier_id)
#  index_lease_applications_on_workflow_status_id      (workflow_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (colessee_id => lessees.id)
#  fk_rails_...  (dealer_id => dealers.id)
#  fk_rails_...  (dealership_id => dealerships.id)
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (lease_calculator_id => lease_calculators.id)
#  fk_rails_...  (lessee_id => lessees.id)
#  fk_rails_...  (mail_carrier_id => mail_carriers.id)
#  fk_rails_...  (workflow_status_id => workflow_statuses.id)
#

require 'rails_helper'

RSpec.describe LeaseApplication, type: :model do

  context "Has All Associations" do
    let!(:lease_application) { build(:lease_application) }
    it { expect(lease_application.colessee).to be_a(Lessee) }
    it { expect(lease_application.lessee).to be_a(Lessee) }
    it { expect(lease_application.dealer).to be_a(Dealer) }
    it { expect(lease_application.lease_calculator).to be_a(LeaseCalculator) }
  end

  describe "#load_or_create_lease_calculator" do
    it "creates a new lease calculator record when none is present" do
      lease_application = create(:lease_application, lease_calculator: nil)
      expect(lease_application.lease_calculator).to be_nil
      expect(lease_application.load_or_create_lease_calculator).to be_a(LeaseCalculator) #return a Lease Calculator
      expect(lease_application.lease_calculator).to be_a(LeaseCalculator) #association is set
      lease_calculator = lease_application.reload.lease_calculator
      expect(lease_application.load_or_create_lease_calculator).to eq(lease_calculator) #return a Lease Calculator
    end
  end

  describe '#by_lessee_ssn scope' do
    let(:ssn) { '123-456-789' }

    it 'matches on lesssee' do
      should_match = create(:lease_application, lessee: create(:lessee, ssn: ssn))
      shouldnt_match = create(:lease_application, lessee: create(:lessee, ssn: '101-101-333'))
      expect(LeaseApplication.by_lessee_ssn(ssn)).to include(should_match)
      expect(LeaseApplication.by_lessee_ssn(ssn)).not_to include(shouldnt_match)
    end

    it 'matches on colessee' do
      should_match = create(:lease_application, colessee: create(:lessee, ssn: ssn))
      shouldnt_match = create(:lease_application, colessee: create(:lessee, ssn: '101-101-333'))
      expect(LeaseApplication.by_lessee_ssn(ssn)).to include(should_match)
      expect(LeaseApplication.by_lessee_ssn(ssn)).not_to include(shouldnt_match)
    end
  end

  describe "expired applications scope" do
    subject { LeaseApplication.expireable_applications.all }

    context "over 30 days old" do
      context "awaiting_credit_decision and no documents" do
        let!(:lease_application) { create(:lease_application, :awaiting_credit_decision, :no_documents, submitted_at: 31.days.ago,) }
        it { is_expected.to include(lease_application) }
      end
    end

    context "earlier than 30 days" do
      let!(:lease_application) { create(:lease_application, submitted_at: 1.week.ago) }
      it { is_expected.to_not include(lease_application) }
    end

    context "unsubmitted" do
      let!(:lease_application) { create(:lease_application, :unsubmitted, submitted_at: 5.weeks.ago) }
      it 'should include unsubmitted applications' do
        results = LeaseApplication.expireable_applications
        expect(results).to include(lease_application)
      end
    end

    context "already expired" do
      let!(:lease_application) { create(:lease_application, expired: true) }
      it { is_expected.to_not include(lease_application) }
    end
  end

  describe '#has_application' do
    subject { LeaseApplication.has_application_eq }

    it 'includes applications when lessee has not-null first name and SSN' do
      application = create(:lease_application, lessee: create(:lessee))
      expect(subject).to include(application)
    end

    it 'excludes application when lessee has null first name' do
      application = create(:lease_application, lessee: create(:lessee, first_name: nil))
      expect(subject).not_to include(application)
    end

    it 'excludes application when lessee has blank first name' do
      application = create(:lease_application, lessee: create(:lessee, first_name: ''))
      expect(subject).not_to include(application)
    end

    it 'excludes application when lessee has null SSN' do
      application = create(:lease_application, lessee: create(:lessee, ssn: nil))
      expect(subject).not_to include(application)
    end
  end

  describe '#has_calculator' do
    subject { LeaseApplication.has_calculator_eq }

    it 'includes applications when calculator has a larger than 0 monthly payment' do
      application = create(:lease_application, lease_calculator: create(:lease_calculator, total_monthly_payment_cents: 50))
      expect(subject).to include(application)
    end

    it 'excludes application when calculator has a 0 monthly payment' do
      application = create(:lease_application, lease_calculator: create(:lease_calculator, total_monthly_payment_cents: 0))
      expect(subject).not_to include(application)
    end
  end

  describe '#find_by_url' do
    it 'finds lease app by lease app url' do
      app = create(:lease_application)
      url = "http://localhost:5000/admins/lease_applications/#{app.id}"

      expect(described_class.find_by_url(url)).to eq app
    end

    it 'finds lease app by lease calculator url' do
      app = create(:lease_application)
      url = "http://localhost:5000/admins/lease_calculators/#{app.lease_calculator.id}"

      expect(described_class.find_by_url(url)).to eq app
    end
  end

  describe '#dead_applications' do
    it 'only returns applications submitted > 30 days ago' do
      app  = create(:lease_application, updated_at: 35.days.ago, lessee: nil, lease_calculator: create(:lease_calculator))
      app2 = create(:lease_application, updated_at: 20.days.ago, lessee: nil, lease_calculator: create(:lease_calculator))
      expect(described_class.dead_applications).to include app
      expect(described_class.dead_applications).not_to include app2
    end

    it 'doesnt return applications without a lease calculator' do
      app  = create(:lease_application, updated_at: 35.days.ago, lessee: nil, lease_calculator: create(:lease_calculator))
      app2 = create(:lease_application, updated_at: 35.days.ago, lessee: nil, lease_calculator: nil)
      expect(described_class.dead_applications).to include app
      expect(described_class.dead_applications).not_to include app2
    end

    it 'returns applications with nil lessee' do
      app  = create(:lease_application, updated_at: 35.days.ago, lessee: nil, lease_calculator: create(:lease_calculator))
      app2 = create(:lease_application, updated_at: 35.days.ago, lessee: create(:lessee), lease_calculator: create(:lease_calculator))
      expect(described_class.dead_applications).to include app
      expect(described_class.dead_applications).not_to include app2
    end

    it 'returns applications with an invalid lessee' do
      app  = create(:lease_application, updated_at: 35.days.ago, lessee: create(:lessee, first_name: ''), lease_calculator: create(:lease_calculator))
      app2 = create(:lease_application, updated_at: 35.days.ago, lessee: create(:lessee), lease_calculator: create(:lease_calculator))
      expect(described_class.dead_applications).to include app
      expect(described_class.dead_applications).not_to include app2
    end
  end

  describe '#send_credit_decision_notification' do
    it 'creates credit decision notifications for dealership' do
      dealership                     = create(:dealership, :with_3_dealers)
      dealer                         = dealership.dealers.first
      app                            = create(:lease_application, dealership: dealership)
      statuses_required_notification = %w(approved approved_with_contingencies requires_additional_information declined rescinded withdrawn)

      statuses_required_notification.each do |status|
        expect {
          app.update_attribute(:credit_status, status)
        }.to change { dealer.notifications.reload.size }.by(1)
      end
    end

    it 'doesnt create credit decision notifications when changed to status not requiring notification' do
      dealership                          = create(:dealership, :with_3_dealers)
      dealer                              = dealership.dealers.first
      app                                 = create(:lease_application, dealership: dealership)
      statuses_not_requiring_notification = %w(draft bike_change_requested awaiting_credit_decision)

      statuses_not_requiring_notification.each do |status|
        expect {
          app.update_attribute(:credit_status, status)
        }.not_to change { dealer.notifications.reload.size }
      end
    end
  end

  describe '#log_funding_approved' do
    let(:lease_application) {create(:lease_application)}

    before do
      lease_application.update_attribute(:document_status, 'funding_approved')
    end

    it 'saves timestamp after document status is set' do
      expect(lease_application.reload.funding_approved_on).not_to be_nil
    end

    it 'Increment Sidekiq job count' do
      assert_equal 1, FundingRequestFormJob.jobs.size
    end
  end


  describe '#is_disable_credit_status_approved' do
    let(:ssn) { '123-456-789' }
    let(:lease_application) {create(:lease_application, workflow_status: create(:workflow_status, description: "Verification", active: true), colessee: nil, lessee: create(:lessee, ssn: ssn, proven_monthly_income: '100000'))}

    it 'Workflow status should be Verification' do
      expect(lease_application.workflow_status.description).to eq "Verification"
    end

    it 'is should be false' do
      expect(lease_application.is_disable_credit_status_approved).to eq false
    end
  end

end