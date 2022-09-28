require 'rails_helper'

RSpec.describe CreditDecisionAttachment do
  describe '#prefilled' do
    it 'generates prefilled pdf for approved application' do
      dealer = create(:dealer)
      application = create(:lease_application, credit_status: 'approved', application_identifier: '12893713A')
      application.lease_application_stipulations << create_list(:lease_application_stipulation, 2, status: 'Required')
      lease_calculator = application.lease_calculator
      @file = CreditDecisionAttachment.new(lease_application: application, dealer: dealer).prefilled
      text = get_full_text(@file)

      aggregate_failures('Field Values') do
        expect(text).to include application.application_identifier.to_s
        expect(text).to include application.dealership_name
        expect(text).to include application.lessee.name.upcase
        expect(text).to include application.colessee.name.upcase
        expect(text).to include "#{lease_calculator.asset_make} #{lease_calculator.asset_model} #{lease_calculator.asset_year}"
        expect(text).to include lease_calculator.mileage_tier.to_s
        expect(text).to include lease_calculator.frontend_max_advance.to_s
        expect(text).to include lease_calculator.backend_max_advance.to_s
        expect(text).to include lease_calculator.credit_tier.to_s
        expect(text).to include lease_calculator.term.to_s
        expect(text).to include application.stipulations.first.description
        expect(text).to include application.stipulations.second.description
      end
    end

    it 'generates prefilled pdf for approved with contingencies application' do
      dealer = create(:dealer)
      application = create(:lease_application, credit_status: 'approved_with_contingencies')
      application.lease_application_stipulations << create_list(:lease_application_stipulation, 2, status: 'Required')
      lease_calculator = application.lease_calculator
      @file = CreditDecisionAttachment.new(lease_application: application, dealer: dealer).prefilled
      text = get_full_text(@file)

      aggregate_failures('Field Values') do
        expect(text).to include application.application_identifier.to_s
        expect(text).to include application.dealership_name
        expect(text).to include application.lessee.name.upcase
        expect(text).to include application.colessee.name.upcase
        expect(text).to include "#{lease_calculator.asset_make} #{lease_calculator.asset_model} #{lease_calculator.asset_year}"
        expect(text).to include lease_calculator.mileage_tier.to_s
        expect(text).to include lease_calculator.frontend_max_advance.to_s
        expect(text).to include lease_calculator.backend_max_advance.to_s
        expect(text).to include lease_calculator.credit_tier.to_s
        expect(text).to include lease_calculator.term.to_s
        expect(text).to include application.stipulations.first.description
        expect(text).to include application.stipulations.second.description
      end
    end

    it 'generates prefilled pdf for requires additional information application' do
      dealer = create(:dealer)
      application = create(:lease_application, credit_status: 'requires_additional_information')
      application.lease_application_stipulations << create_list(:lease_application_stipulation, 2, status: 'Required')
      lease_calculator = application.lease_calculator
      @file = CreditDecisionAttachment.new(lease_application: application, dealer: dealer).prefilled
      text = get_full_text(@file)

      aggregate_failures('Field Values') do
        expect(text).to include application.application_identifier.to_s
        expect(text).to include application.dealership_name
        expect(text).to include application.lessee.name.upcase
        expect(text).to include application.colessee.name.upcase
        expect(text).to include "#{lease_calculator.asset_make} #{lease_calculator.asset_model} #{lease_calculator.asset_year}"
        expect(text).to include lease_calculator.mileage_tier.to_s
        expect(text).to include application.stipulations.first.description
        expect(text).to include application.stipulations.second.description
      end
    end

    it 'generates prefilled pdf for declined application' do
      dealer = create(:dealer)
      lease_application = create(:lease_application, credit_status: 'declined', lessee: create(:lessee, :with_addresses))
      @file = CreditDecisionAttachment.new(lease_application: lease_application, dealer: dealer).prefilled
      text = get_full_text(@file)

      aggregate_failures('Field Values') do
        expect(text).to include Date.today.to_s
        expect(text).to include lease_application.lessee.name.upcase
        expect(text).to include lease_application.lessee.home_address.street1_street2
        expect(text).to include lease_application.lessee.home_address.city_state_zip
      end
    end

    it 'does not include stipulations which arent required' do
      dealer = create(:dealer)
      application = create(:lease_application, credit_status: 'requires_additional_information')
      application.lease_application_stipulations << create_list(:lease_application_stipulation, 2, status: 'Not Required')
      @file = CreditDecisionAttachment.new(lease_application: application, dealer: dealer).prefilled
      text = get_full_text(@file)

      aggregate_failures('Field Values') do
        expect(text).not_to include application.stipulations.first.description
        expect(text).not_to include application.stipulations.second.description
      end
    end
  end

  def get_full_text(file)
    pdf_text = ""
    PDF::Reader.open(file) do |reader|
      reader.pages.each do |page|
        pdf_text << page.text
      end
    end
    pdf_text
  end

  def pdftk
    @pdftk ||= PdfForms.new(PdftkConfig.executable_path)
  end
end
