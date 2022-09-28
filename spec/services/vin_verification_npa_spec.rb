require 'rails_helper'
=begin
RSpec.describe VinVerificationNpa, type: :model do
  let!(:vin)   { '1HD4NCG67HC509333' }
  let!(:year)  { '2009' }
  let!(:model) { 'FLTRSE3' }
  let!(:make)  { 'HARLEY-DAVIDSON' }

  subject { described_class.new(vin: vin, make: make, model: model, year: year) }

  before do
    create(:make, :for_harley_davidson)
  end

  context "while handling bad arguments" do

    context "with lower case vins" do
      let!(:vin)   { '1hd4ncg67hc509333' }
      it { is_expected.to be_valid }
      it "should have automatically upcased the vin" do
        expect(subject.vin).to eq('1hd1pv4109y000001'.upcase)
      end
    end

    context "with a missing argument for vin" do
      let!(:vin)   { '' }
      it 'has 1 error_on' do
        expect(subject).to_not be_valid
        expect(subject.errors[:vin].count).to eq(1)
      end
    end

    context "with a missing argument for model" do
      let!(:model) { '' }
      it 'has 1 error_on' do
        expect(subject).to_not be_valid
        expect(subject.errors[:model].count).to eq(1)
      end
    end

    context "with a missing argument for year" do
      let!(:year) { '' }
      it 'has 1 error_on' do
        expect(subject).to_not be_valid
        expect(subject.errors[:year].count).to eq(1)
      end
    end

    context "with a vin of invalid length" do
      let!(:vin) { '1HD' }
      it 'has 1 error_on' do
        expect(subject).to_not be_valid
        expect(subject.errors[:vin].count).to eq(1)
      end
    end

    #Harleys Meant for Sale in the US Start have a VIN that starts with 1HD
    context "with a VIN for a Harley not meant for sale in the United States" do
      let!(:vin)   { '5HD1LD6A0BC000001' }
      let!(:year)  { '1993' }
      let!(:model) { 'XS1200' }
      it 'has 1 error_on' do
        expect(subject).to_not be_valid
        expect(subject.errors[:vin].count).to eq(1)
      end
    end

    context "with a VIN with the 1HD indicator in the middle of the string" do
      let!(:vin)   { '1PV41091HDY000001' }
      let!(:year)  { '1993' }
      let!(:model) { 'XS1200' }
      it 'has 1 error_on' do
        expect(subject).to_not be_valid
        expect(subject.errors[:vin].count).to eq(1)
      end
    end
  end
end
=end