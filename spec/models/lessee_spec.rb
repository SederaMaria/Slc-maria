# == Schema Information
#
# Table name: lessees
#
#  id                                :integer          not null, primary key
#  first_name                        :string
#  middle_name                       :string
#  last_name                         :string
#  suffix                            :string
#  encrypted_ssn                     :string
#  date_of_birth                     :date
#  mobile_phone_number               :string
#  home_phone_number                 :string
#  drivers_license_id_number         :string
#  drivers_license_state             :string
#  email_address                     :string
#  employment_details                :string
#  home_address_id                   :integer
#  mailing_address_id                :integer
#  employment_address_id             :integer
#  encrypted_ssn_iv                  :string
#  at_address_years                  :integer
#  at_address_months                 :integer
#  monthly_mortgage                  :decimal(, )
#  home_ownership                    :integer
#  drivers_licence_expires_at        :date
#  employer_name                     :string
#  time_at_employer_years            :integer
#  time_at_employer_months           :integer
#  job_title                         :string
#  employment_status                 :integer
#  employer_phone_number             :string
#  gross_monthly_income              :decimal(, )
#  other_monthly_income              :decimal(, )
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  highest_fico_score                :integer
#  deleted_from_lease_application_id :bigint(8)
#  mobile_phone_number_line          :string
#  mobile_phone_number_carrier       :string
#  home_phone_number_line            :string
#  home_phone_number_carrier         :string
#  employer_phone_number_line        :string
#  employer_phone_number_carrier     :string
#  ssn                               :text
#  proven_monthly_income             :decimal(, )
#
# Indexes
#
#  index_lessees_on_deleted_from_lease_application_id  (deleted_from_lease_application_id)
#  index_lessees_on_employment_address_id              (employment_address_id)
#  index_lessees_on_home_address_id                    (home_address_id)
#  index_lessees_on_mailing_address_id                 (mailing_address_id)
#
# Foreign Keys
#
#  fk_rails_...  (deleted_from_lease_application_id => lease_applications.id)
#

require 'rails_helper'

RSpec.describe Lessee, type: :model do
  
  describe "encrypting the ssn" do
    context "with a blank ssn" do
      let!(:lessee) { create(:lessee, ssn: '') }
      it "doesn't encrypt" do
        expect(lessee.ssn).to be_blank
        expect(lessee.encrypted_ssn).to be_blank
      end
    end

    context "with a valid ssn" do
      let!(:lessee) { create(:lessee, ssn: '123-45-6789') }
      it "does encrypt" do
        query  = "SELECT ssn FROM lessees WHERE lessees.id = #{lessee.id}"
        result = ActiveRecord::Base.connection.execute(query)
        expect(result[0]['ssn']).not_to eq lessee.ssn
        expect(result[0]['ssn'].length).to be > 25
      end
    end
  end

  describe "associations" do
    let!(:lessee) { create(:lessee) }
    describe "lease_application" do
      context "as a Lessee" do
        let!(:lease_application) { create(:lease_application, lessee: lessee) }
        it { expect(lessee.reload.lease_application).to eq(lease_application) }
      end
      context "as a Co-Lessee" do
        let!(:lease_application) { create(:lease_application, colessee: lessee) }
        it { expect(lessee.reload.lease_application).to eq(lease_application) }
      end
    end
  end
  describe "accepting nested attributes" do
    let!(:address_attrs) { attributes_for(:address) }
    it "accepts nested attributes for home address" do
      lessee = Lessee.create(
        first_name: 'Daniel',
        last_name: 'Rice',
        home_address_attributes: address_attrs,
      )
      expect(lessee.home_address).to be_kind_of(Address)
    end

    it "accepts nested attributes for mailing address" do
      lessee = Lessee.create(
        first_name: 'Daniel',
        last_name: 'Rice',
        mailing_address_attributes: address_attrs,
      )
      expect(lessee.mailing_address).to be_kind_of(Address)
    end

    it "accepts nested attributes for employment address" do
      lessee = Lessee.create(
        first_name: 'Daniel',
        last_name: 'Rice',
        employment_address_attributes: address_attrs,
      )
      expect(lessee.employment_address).to be_kind_of(Address)
    end
  end
  
  context "when saving dates" do
    describe "with an unambiguous date" do
      before do
        subject.update(date_of_birth: '04/19/1950')
      end
      it "should be able to handle american formatted dates" do
        expect(subject.date_of_birth).to eq(Date.new(1950, 4, 19))
      end
    end
    describe "with a (globally) ambiguous date" do
      before do
        #In most countries, this means December 5th, not May 12th.
        subject.update(date_of_birth: '05/12/1950') 
      end
      it "should be able to handle american formatted dates" do
        expect(subject.date_of_birth).to eq(Date.new(1950, 5, 12))
      end
    end
    
    describe "with an 18 year old" do
      let!(:lessee) { create(:lessee) }
      before do
        lessee.update(date_of_birth: 18.years.ago) 
      end
      it "applicant must be 18 years old" do
        expect(lessee).to be_valid
      end
    end

    describe "with a newborn infant who can't possibly drive a motorcycle" do
      let!(:lessee) { create(:lessee) }
      before do
        lessee.update(date_of_birth: Date.current) 
      end

      it "applicant must be 18 years old if first name present" do
        expect(lessee).to_not be_valid
      end

      it "applicant must be 18 years old if first name not present" do
        lessee.update(first_name: nil) 
        expect(lessee).to be_valid
      end
    end

    describe "#blank_record?" do
      context "with a fully submittable lessee" do
        subject { build(:lessee, :submittable) }
        it { is_expected.to_not be_blank_record }
        it { is_expected.to be_not_blank_record }
      end
      context "with one missing attribute" do
        subject { build(:lessee, :submittable, first_name: '') }
        it { is_expected.to_not be_blank_record }
        it { is_expected.to be_not_blank_record }
      end
      context "with a blank ssn, which is still encrypted in the database btw" do
        subject { Lessee.create(ssn: '') }
        it { is_expected.to be_blank_record }
        #the double negative is a bit confusing...
        it { is_expected.to_not be_not_blank_record }
      end

      context "with a totally new/blank record" do
        subject { Lessee.new }
        it { is_expected.to be_blank_record }
        #the double negative is a bit confusing...
        it { is_expected.to_not be_not_blank_record }
      end
    end

    describe '#upcase' do
      let(:first_name) { 'allen' }
      let(:employer_name) { 'some company' }
      let(:lessee) { create(:lessee, first_name: first_name, employer_name: employer_name)}
      it 'should upcase string attributes' do
        expect(lessee.first_name).to eql(first_name.upcase)
        expect(lessee.employer_name).to eql(employer_name.upcase)
      end
    end
  end
end
