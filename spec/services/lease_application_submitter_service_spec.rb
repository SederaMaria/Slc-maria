require 'rails_helper'
RSpec.describe LeaseApplicationSubmitterService do
  
  let!(:cant_be_blank_translation) { I18n.backend.send(:translations)[:en][:errors][:messages][:blank] }
  
  #Check that the wrapped lease appliction can be submitted using ActiveModel::Validations
  describe "#valid?" do
    context "should require several attributes" do
      subject { build(:lease_application, :submittable, dealership: create(:dealership)) }
      it { is_expected.to be_valid }
    end
    
    context "when missing everything, including an empty Colessee Record" do
      let(:model) { described_class.new(lease_application: LeaseApplication.new(lessee: Lessee.new, colessee: Lessee.new)) }
      it { expect(model).to have(1).error_on(:lessee_first_name) }
      it { expect(model.errors_on(:lessee_first_name)).to include(cant_be_blank_translation) }
      it { expect(model).to have(1).error_on(:lessee_last_name) }
      it { expect(model.errors_on(:lessee_last_name)).to include(cant_be_blank_translation) }
      it { expect(model).to_not have(1).error_on(:colessee_first_name) }
      it { expect(model).to_not have(1).error_on(:colessee_last_name) }

      ### AND MANY MORE ERRORS TOO!
      ### ...
    end

    context "without a Colessee, does not apply conditional colessee validations" do
      let(:model) { described_class.new(lease_application: LeaseApplication.new(colessee: nil)) }
      it { expect(model).to_not have(1).error_on(:colessee_first_name) }
      it { expect(model).to_not have(1).error_on(:colessee_last_name) }
    end

    context "with a Colessee that is partially completed, apply conditional colessee validations" do
      let(:model) { described_class.new(lease_application: LeaseApplication.new(colessee: build(:lessee, first_name: '', last_name: '', ssn: '123-45-6789'))) }
      it { expect(model).to have(1).error_on(:colessee_first_name) }
      it { expect(model.errors_on(:colessee_first_name)).to include(cant_be_blank_translation) }
      it { expect(model).to have(1).error_on(:colessee_last_name) }
      it { expect(model.errors_on(:colessee_last_name)).to include(cant_be_blank_translation) }
    end

  end

  describe "#submit!" do

    subject { described_class.new(lease_application: application).submit! }

    context 'when lease application is fully filled out' do
      
      let!(:lessee)     { create(:lessee, :with_valid_phone_numbers, :submittable, :with_addresses) }
      let!(:colessee)   { create(:lessee, :with_valid_phone_numbers, :submittable, :with_addresses) }
      let!(:dealership) { create(:dealership) }
      let(:application) { create(:lease_application, :submittable, lessee: lessee, colessee: colessee, dealership: dealership ) }
      
      context 'when it has new status' do
        it 'submits application' do
          expect(described_class.new(lease_application: application).submit!).to be valid 
          expect { subject }.to change { application.credit_status }.from("unsubmitted").to("awaiting_credit_decision")
        end

        it 'sends email to dealer and speed leasing' do
          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(DealerMailer).to receive(:application_submitted).with(application_id: application.id).and_return(message_delivery)
          allow(message_delivery).to receive(:deliver_later)
          subject
        end

        it 'sends in-app notification to all admins' do
          expect(Notification).to receive(:create_for_admins).with({
            notification_mode: 'InApp',
            notification_content: 'application_submitted', 
            notifiable: application
          })
          subject
        end

        it 'enqueues job to store related applications' do
          expect { subject }.to change(DetectRelatedApplicationsJob.jobs, :size).by(1)
        end

        it "enqueues Address validations" do
          #  home_address_id            :integer
          #  mailing_address_id         :integer
          #  For Both Lessee And Colessee
          expect { subject }.to have_enqueued_job(ValidateAddressJob).exactly(4)
        end

        it "enqueues Phone Validations" do
          expect { subject }.to have_enqueued_job(ValidatePhoneJob).exactly(6)
        end

        it "enqueues Email Validations" do
          #one email address per applicant
          expect { subject }.to have_enqueued_job(ValidateEmailJob).exactly(2)
        end

        context "when pulling credit reports" do
          it "enqueues Credit Pull Jobs" do
            expect { subject }.to change(CreditReportJob.jobs, :size).by(2)
          end

          context "when credco is disabled" do
            before do
              ENV['CREDCO_DISABLED'] = 'yes'
            end
            it { expect { subject }.to_not have_enqueued_job(CreditReportJob) }
          end
        end

        context "when assigning an application identifier" do
          before do
            LeaseApplication.connection.execute <<-SQL
              ALTER SEQUENCE next_application_identifier_seq RESTART WITH 1;
            SQL
          end
          let(:yymmdd) { I18n.localize(Time.zone.now.in_time_zone('Eastern Time (US & Canada)'), format: '%y%m%d') }
          it "should be in YYMMDD format" do
            expect { subject }.to change { application.application_identifier }.from(nil).to("#{yymmdd}0001")
          end
        end

        context "when an application identifier has already been assigned" do
          let(:application) { create(:lease_application, application_identifier: '1701010001') }

          it "should not be assigned a new identifer" do
            expect { subject }.to_not change { application.application_identifier }
          end
        end

        context 'required Stipulations' do
          let!(:stipulation) { create(:stipulation, required: true) }
          it 'should required stipulations marked as required' do
            expect { subject }.to change(LeaseApplicationStipulation, :count).by(1)
          end
        end
      end

      context 'when it does not have new status' do
        before { application.rescind! }
        it 'does not submit application' do
          expect { subject }.not_to change { application.credit_status }
        end
      end
    end

    context 'when lease application does not have lessee' do
      let(:application) { build(:lease_application, lessee: nil) }
      it 'does not submit application' do
        expect { subject }.not_to change { application.credit_status }
      end
    end
  end
end