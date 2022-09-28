require 'rails_helper'

RSpec.describe LeaseApplicationDecorator, type: :decorator do
  let(:lease_calculator) { build :lease_calculator }
  let(:lessee) { build :lessee }
  let(:colessee) { build :lessee }
  let(:lease_app) { build :lease_application, lease_calculator: lease_calculator, lessee: lessee, colessee: colessee }

  describe "#application_identifier" do
    subject { lease_app.decorate.application_identifier }
    context "when application_identifier is present" do
      let(:lease_app) { build :lease_application, application_identifier: 'whatever' }
      it { is_expected.to eq 'whatever' }
    end

    context "when it is blank" do
      it { is_expected.to eq "N/A" }
    end
  end

  describe '#model_and_year' do
    subject { lease_app.decorate.model_and_year }

    it { is_expected.to eq "#{lease_calculator.asset_year} #{lease_calculator.asset_model}" }
  end

  describe '#days_submitted' do
    subject { lease_app.decorate.days_submitted }

    context 'when submitted at is recent' do
      let(:lease_app) { build :lease_application, submitted_at: Time.zone.now }
      it { is_expected.to eq(0) }
    end

    context 'when submitted at is a week ago' do
      let(:lease_app) { build :lease_application, submitted_at: 1.week.ago }
      it { is_expected.to eq(7) }
    end

    context 'when submitted_at is blank' do
      let(:lease_app) { build :lease_application, submitted_at: nil }
      it { is_expected.to be_blank }
    end

    context "with an expired lease" do
      let(:lease_app) { build :lease_application, expired: true }
      it { is_expected.to eq('Expired') }
    end
  end

  describe '#document_status' do
    subject { lease_app.decorate.document_status }

    it { is_expected.to eq 'No Documents' }
  end

  describe '#credit_status' do
    subject { lease_app.decorate.credit_status }

    it { is_expected.to eq 'Saved - NOT Submitted' }
  end

  describe '#all_checks_passed?' do
    context 'when no checks passed' do
      before do
        lease_app.lease_validations << create(:lease_validation)
        lease_app.lease_validations << create(:lease_validation)
      end

      subject { lease_app.decorate.all_checks_passed? }

      it { is_expected.to be false }
    end

    context 'when all checks passed' do
      before do
        lease_app.lease_validations << create(:lease_validation, status: 'status_valid')
        lease_app.lease_validations << create(:lease_validation, status: 'status_valid')
      end

      subject { lease_app.decorate.all_checks_passed? }

      it { is_expected.to be true }
    end

    context 'when some checks passed' do
      before do
        lease_app.lease_validations << create(:lease_validation, status: 'status_valid')
        lease_app.lease_validations << create(:lease_validation, status: 'status_invalid')
      end

      subject { lease_app.decorate.all_checks_passed? }

      it { is_expected.to be false }
    end
  end
  describe '#can_change_bikes?' do

    subject { lease_app.decorate.can_change_bikes? }

    context "in no documents status and approved" do
      let(:lease_app) { build :lease_application, :no_documents, :approved }
      it { is_expected.to be_truthy }
    end

    context "in no documents status and cont. approved." do
      let(:lease_app) { build :lease_application, :no_documents, :approved_with_contingencies }
      it { is_expected.to be_truthy }
    end

    context "anything other than no documents status" do
      let(:lease_app) { build :lease_application, :documents_requested, :approved }
      it { is_expected.to be_falsey }
    end

    context "with an expired lease application" do
      let(:lease_app) { build :lease_application, :expired }
      it { is_expected.to be_falsey }
    end
  end

  # describe '#approved_with_or_without_contingencies?' do

  #   object.approved? || object.approved_with_contingencies?
  # end

  # describe '#can_request_lease_documents?' do

  #   can_change_bikes? #same logic for the time being
  # end
end
