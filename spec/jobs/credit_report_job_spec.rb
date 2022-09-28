require 'rails_helper'

RSpec.describe CreditReportJob, type: :job do

  describe 'queuing' do
    it 'only allows queing of one contest at a time' do
      expect {
        3.times { CreditReportJob.perform_async(1) }
      }.to change(CreditReportJob.jobs, :size).by(1)
    end
  end

  describe '#perform' do
    #it 'saves credit report in db' do
    #  lessee = create(:lessee)
    #  create(:lease_application, lessee: lessee)
    #  allow_any_instance_of(Credco::Client).to receive(:credit_report).and_return(Credco::Client::DUMMY_RESPONSE)
    #  subject.perform(lessee.id)
    #  expect(lessee.last_successful_credit_report).not_to eq nil
    #end

    it 'keeps old credit reports' do
      lessee = create(:lessee)
      lessee.credit_reports << create(:credit_report, status: 'success')
      create(:lease_application, lessee: lessee)
      allow_any_instance_of(Credco::Client).to receive(:credit_report).and_return(Credco::Client::DUMMY_RESPONSE)
      subject.perform(lessee.id)
      expect(lessee.credit_reports.size).to eq 2
    end

    it 'saves highest credit score for lessee' do
      lessee = create(:lessee)
      colessee = create(:lessee)
      create(:lease_application, lessee: lessee, colessee: colessee)
      allow_any_instance_of(Credco::Client).to receive(:credit_report).and_return(Credco::Client::DUMMY_RESPONSE)

      subject.perform(colessee.id)

      expect(colessee.reload.highest_fico_score).to eq 756
    end

    it 'doesnt switch lessee and colessee' do
      lessee = create(:lessee)
      colessee = create(:lessee)
      application = create(:lease_application, lessee: lessee, colessee: colessee)
      allow_any_instance_of(Credco::Client).to receive(:credit_report).and_return(Credco::Client::DUMMY_RESPONSE)

      subject.perform(colessee.id)

      expect(application.reload.lessee_id).to eq lessee.id
      expect(application.reload.colessee_id).to eq colessee.id
      #expect(colessee.last_successful_credit_report).not_to be_nil
    end

    # TODO Find a way to make this pass in CI via wait_until, or rake task, or circleci config or something smarter
    # Finicky tests which fails often in CI
    xit 'handles expections by saving errors on the record' do
      VCR.use_cassette('credco/wrong_password') do
        ENV['CREDCO_PASSWORD'] = 'wrongpassword'
        lessee = create(:lessee, :credco_test)
        create(:lease_application, lessee: lessee)
        expect{
          subject.perform(lessee.id)
        }.to raise_error(/Invalid Login ID/)
        expect(lessee.credit_reports.last.record_errors.first).to eq "Error code: E038\nInvalid Login ID or Password\nLogin Account Identifier = #{ENV['CREDCO_LOGIN_ID']}\n"
      end
    end

    it 'saves rounded off credit_score_average' do
      lessee = create(:lessee)
      create(:lease_application, lessee: lessee)

      scores = [753, 752, 753] # Average = 752.6666666666666

      allow_any_instance_of(Credco::Client).to receive(:credit_report).and_return(Credco::Client::DUMMY_RESPONSE)
      allow_any_instance_of(Credco::ResponseParser).to receive(:credit_score_equifax).and_return(scores[0])
      allow_any_instance_of(Credco::ResponseParser).to receive(:credit_score_experian).and_return(scores[1])
      allow_any_instance_of(Credco::ResponseParser).to receive(:credit_score_transunion).and_return(scores[2])

      subject.perform(lessee.id)

      expect(lessee.credit_reports.last.credit_score_average).to eq 753
    end

    # NOTE: Should be removed if recommended_credit_tier is removed from database table
    it 'doesnt populate RecommendedCreditTier.recommended_credit_tier' do
      lessee = create(:lessee)
      create(:lease_application, lessee: lessee)

      allow_any_instance_of(Credco::Client).to receive(:credit_report).and_return(Credco::Client::DUMMY_RESPONSE)
      # WARNING: Mocking a generic class is not reliable because it might be called twice. But since in this context, its only called once, this kinda works for now
      # TODO: Create a dedicated client class for Blackbox API request
      allow_any_instance_of(RestClient::Request).to receive(:execute).and_return('{"decision":"ACCEPT", "creditScore":null}')

      subject.perform(lessee.id)

      expect(lessee.reload.recommended_credit_tiers.last.recommended_credit_tier).to eq nil
    end

    context 'bankruptcies and repossessions' do
      let!(:dummy_credco_response) { File.read(Rails.root.join('spec/data/credco_responses/bankruptcies_and_repossessions.xml')) }

      it 'saves credit report bankruptcies properly' do
        lessee = create(:lessee)
        create(:lease_application, lessee: lessee)

        allow_any_instance_of(Credco::Client).to receive(:credit_report).and_return(dummy_credco_response)

        subject.perform(lessee.id)

        credit_report = lessee.reload.credit_reports.last

        # Expected values from bankruptcies_and_repossessions.xml
        # [
        #   {:date_filed=>"Oct-2020", :bankruptcy_type=>"BankruptcyChapter13", :bankruptcy_status=>"Filed", :date_status=>nil},
        #   {:date_filed=>"Sep-2017", :bankruptcy_type=>"BankruptcyChapter11", :bankruptcy_status=>"Dismissed", :date_status=>nil},
        #   {:date_filed=>"Oct-2020", :bankruptcy_type=>"BankruptcyChapter13", :bankruptcy_status=>"Filed", :date_status=>nil},
        #   {:date_filed=>"Sep-2017", :bankruptcy_type=>"BankruptcyChapter7", :bankruptcy_status=>"Discharged", :date_status=>"Dec-2017"},
        #   {:date_filed=>"Oct-2020", :bankruptcy_type=>"BankruptcyChapter13", :bankruptcy_status=>"Filed", :date_status=>nil}
        # ]
        expect(credit_report.credit_report_bankruptcies.count).to eq(5)
        expect(credit_report.credit_report_bankruptcies.where(year_filed: 2017, month_filed: 9, date_filed: "Sep-2017", bankruptcy_type: "BankruptcyChapter11", bankruptcy_status: "Dismissed", date_status: nil).count).to eq(1)
        expect(credit_report.credit_report_bankruptcies.where(year_filed: 2017, month_filed: 9, date_filed: "Sep-2017", bankruptcy_type: "BankruptcyChapter7", bankruptcy_status: "Discharged", date_status: "Dec-2017").count).to eq(1)
        expect(credit_report.credit_report_bankruptcies.where(year_filed: 2020, month_filed: 10, date_filed: "Oct-2020", bankruptcy_type: "BankruptcyChapter13", bankruptcy_status: "Filed", date_status: nil).count).to eq(3)
      end

      it 'saves credit report repossessions properly' do
        lessee = create(:lessee)
        create(:lease_application, lessee: lessee)

        allow_any_instance_of(Credco::Client).to receive(:credit_report).and_return(dummy_credco_response)

        subject.perform(lessee.id)

        credit_report = lessee.reload.credit_reports.last

        # Expected values from bankruptcies_and_repossessions.xml
        # [
        #   {:creditor=>"A F S C I", :date_filed=>"Aug-2017", :notes=>""},
        #   {:creditor=>"AFSCI", :date_filed=>"May-2017", :notes=>""}
        # ]
        expect(credit_report.credit_report_repossessions.count).to eq(2)
        expect(credit_report.credit_report_repossessions.where(year_filed: 2017, month_filed: 8, creditor: "A F S C I", date_filed: "Aug-2017", notes: nil).count).to eq(1)
        expect(credit_report.credit_report_repossessions.where(year_filed: 2017, month_filed: 5, creditor: "AFSCI", date_filed: "May-2017", notes: nil).count).to eq(1)
      end
    end

    context 'credco_xml column update' do
      it 'doesnt populate on LeaseApplicationCredco.credco_xml' do
        lessee = create(:lessee)
        lease_application = create(:lease_application, lessee: lessee)

        allow_any_instance_of(Credco::Client).to receive(:credit_report).and_return(Credco::Client::DUMMY_RESPONSE)

        subject.perform(lessee.id)

        expect(lease_application.reload.lease_application_credco.credco_xml).to eq(nil)
      end

      it 'saves Credco XML to CreditReport.credco_xml' do
        lessee = create(:lessee)
        create(:lease_application, lessee: lessee)

        allow_any_instance_of(Credco::Client).to receive(:credit_report).and_return(Credco::Client::DUMMY_RESPONSE)

        subject.perform(lessee.id)

        expect(lessee.reload.credit_reports.last.credco_xml).not_to be_empty
      end
    end

    context 'revolving_credit_available' do
      it 'stores value from _PrcntRevolvingCreditAvailable' do
        lessee = create(:lessee)
        lease_application = create(:lease_application, lessee: lessee)

        allow_any_instance_of(Credco::Client).to receive(:credit_report).and_return(Credco::Client::DUMMY_RESPONSE)

        subject.perform(lessee.id, nil)

        # <_DATA_SET _Name="_PrcntRevolvingCreditAvailable" _Value="90"/>
        expect(lease_application.reload.lease_application_credco.revolving_credit_available).to eq("90")
      end
    end
  end
end