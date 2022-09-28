require 'rails_helper'

RSpec.describe BlackboxJob, type: :job do
  describe '#perform' do
    # NOTE: Should be removed if recommended_credit_tier is removed from database table
    it 'finalize doesnt populate RecommendedCreditTier.recommended_credit_tier' do
      lessee = create(:lessee)
      application = create(:lease_application, lessee: lessee)
      # WARNING: Mocking a generic class is not reliable because it might be called twice. But since in this context, its only called once, this kinda works for now
      # TODO: Create a dedicated client class for Blackbox API request
      allow_any_instance_of(RestClient::Request).to receive(:execute).and_return('{"decision":"ACCEPT", "creditScore":null}')

      subject.perform(lessee_id: lessee.id, fetch_type: :finalize)

      expect(application.reload.lease_application_blackbox_requests.last.recommended_credit_tier.recommended_credit_tier).to eq nil
    end

    context 'LeaseApplicationBlackboxEmploymentSearch' do
      let(:dummy_blackbox_response) { File.read(Rails.root.join('spec/data/blackbox/COSTCO_Sarah_Milford.json')) }

      it 'saves record properly' do
        lessee = create(:lessee)
        application = create(:lease_application, lessee: lessee)

        # WARNING: Mocking a generic class is not reliable because it might be called twice. But since in this context, its only called once, this kinda works for now
        # TODO: Create a dedicated client class for Blackbox API request
        allow_any_instance_of(RestClient::Request).to receive(:execute).and_return(dummy_blackbox_response)

        subject.perform(lessee_id: lessee.id, fetch_type: :finalize)

        blackbox = application.reload.lease_application_blackbox_requests.last
        current_employer = blackbox.lease_application_blackbox_employment_searches.find_by(employment_status: "ACTIVE")
        past_employer = blackbox.lease_application_blackbox_employment_searches.find_by(employment_status: "NOT CURRENTLY ON ASSIGNMENT")

        # Total record count of 2 from dummy JSON
        expect(blackbox.lease_application_blackbox_employment_searches.count).to eq 2

        # Test monetize
        expect(current_employer.rate_of_pay_cents).to eq(1607)
        expect(current_employer.annualized_income_cents).to eq(3898297)
        expect(past_employer.rate_of_pay_cents).to eq(0)
        expect(past_employer.annualized_income_cents).to eq(nil)

        # Test content
        expect(current_employer.employer_name).to eq("COSTCO")
        expect(current_employer.employee_first_name).to eq("Sarah")
        expect(current_employer.employee_middle_name).to eq(nil)
        expect(current_employer.employee_last_name).to eq("Milford")
        expect(current_employer.employee_encrypted_ssn).to eq("676894321")
        expect(current_employer.employment_start_date).to eq(Date.parse("2014-04-13"))
        expect(current_employer.total_months_with_employer).to eq(70)
        expect(current_employer.termination_date).to eq(nil)
        expect(current_employer.position_title).to eq("Associate III")
        expect(current_employer.pay_frequency).to eq("HOURLY")
        expect(current_employer.pay_period_frequency).to eq("BIWEEKLY")
        expect(current_employer.average_hours_worked_per_pay_period).to eq(100)
        expect(current_employer.compensation_history).to be_present
      end
    end

    context "generate_payload" do
      context "finalize" do
        it "should send lessee's job title" do
          lessee = create(:lessee, :submittable)
          application = create(:lease_application, lessee: lessee)

          subject.perform(lessee_id: lessee.id, fetch_type: :finalize, request_type: :new)
          payload = subject.send(:generate_payload, lessee)

          expect(payload['title']).to eq('RUBY ON RAILS DEVELOPER')
        end
      end

      context "fill" do
        it "should send lessee's job title" do
          lessee = create(:lessee, :submittable)
          application = create(:lease_application, lessee: lessee)

          subject.perform(lessee_id: lessee.id, fetch_type: :fill, request_type: :new)
          payload = subject.send(:generate_payload, lessee)

          expect(payload['title']).to eq('RUBY ON RAILS DEVELOPER')
        end
      end
    end
  end
end
