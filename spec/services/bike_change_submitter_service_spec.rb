require 'rails_helper'

RSpec.describe BikeChangeSubmitterService do

  context 'Bike Changed' do
    let!(:lessee) { create(:lessee, :with_valid_phone_numbers, :with_addresses) }
    let!(:colessee) { create(:lessee, :with_valid_phone_numbers, :with_addresses) }
    let!(:application) { create(:lease_application, lessee: lessee, colessee: colessee) }
    let!(:lease_calculator) { create(:lease_calculator,lease_application: application) }

    subject { described_class.new(lease_calculator: lease_calculator) }

    before do
      application.update(credit_status: "approved",document_status: "no_documents",expired: false)
      lease_calculator.update(nada_retail_value: "10000.00")
    end
    
    context 'when does not change nada retail value' do
      it 'should not change the status' do
        expect { subject.bike_change({"nada_retail_value"=>"10000.00"}) }.not_to change { application.credit_status }.from("approved")
      end
    end

    context 'when decrease nada retail value' do
      it 'should not change the status' do
        expect { subject.bike_change({"nada_retail_value"=>"8000.00"}) }.not_to change { application.credit_status }.from("approved")
      end
    end

    context 'when increase nada retail value' do
      it 'should change the status' do
          expect { subject.bike_change({"nada_retail_value"=>"15000.00"}) }.to change { application.credit_status }.from("approved").to("awaiting_credit_decision")
      end
    end

    context 'when the nada retail value increases, it sends an email' do 
      it 'should notify admin' do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(DealerMailer).to receive(:bike_change_submitted).with(application.id,application.lease_calculator.display_name.upcase,"10000.00").and_return(message_delivery)
        allow(message_delivery).to receive(:deliver_later)
        subject.bike_change({"nada_retail_value"=>"15000.00"})
      end
    end

    context 'when does not change nada do not sends email to admin' do 
      it 'should not notify admin' do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(DealerMailer).not_to receive(:bike_change_submitted).with(application.id,application.lease_calculator.display_name.upcase,"10000.00")
        allow(message_delivery).to receive(:deliver_later)
        subject.bike_change({"nada_retail_value"=>"10000.00"})
      end
    end
  end
end
