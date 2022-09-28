require 'fileutils'

class CreditDecisionAttachment
  APPROVED_DOC_PATH                        = "#{Rails.root}/app/assets/data/notification_attachments/Approved.pdf"
  APPROVED_WITH_CONTINGENCIES_DOC_PATH     = "#{Rails.root}/app/assets/data/notification_attachments/ApprovedWithContingencies.pdf"
  REQUIRES_ADDITIONAL_INFORMATION_DOC_PATH = "#{Rails.root}/app/assets/data/notification_attachments/RequiresAdditionalInformation.pdf"
  DECLINED_DOC_PATH                        = "#{Rails.root}/app/assets/data/notification_attachments/Declined.pdf"

  def initialize(lease_application:, dealer:)
    @lease_application = lease_application
    @dealer            = dealer
  end

  def prefilled
    return false if unsupported_credit_status
    return prefilled_doc_path
  end

  private
  attr_reader :lease_application, :dealer

  def prefilled_doc_path
    FileUtils::mkdir_p(File.join(Rails.root, 'tmp', 'credit_decision_attachments'))

    source_doc_path = self.class.const_get("#{lease_application.credit_status.upcase}_DOC_PATH")
    dest_doc_path   = File.join(Rails.root, 'tmp', 'credit_decision_attachments', "#{lease_application.credit_status}-#{Time.now.to_i}.pdf")
    pdftk.fill_form source_doc_path, dest_doc_path, fields, flatten: true
    return dest_doc_path
  end

  def pdftk
    @pdftk ||= PdfForms.new(pdftk_path)
  end

  def unsupported_credit_status
    !['approved', 'approved_with_contingencies', 'requires_additional_information', 'declined'].include? lease_application.credit_status
  end

  def pdftk_path
    PdftkConfig.executable_path
  end

  def lease_calculator
    lease_application.lease_calculator
  end

  def fields
    case lease_application.credit_status
      when 'approved', 'approved_with_contingencies', 'requires_additional_information'
        approved_template_fields
      when 'declined'
        declined_fields
    end
  end

  def approved_template_fields
    {
      "FormDate"           => lease_application.updated_at.in_time_zone('Eastern Time (US & Canada)').strftime('%e %b %Y %H:%M:%S%p'),
      "TitleIdentifier"    => lease_application.application_identifier,
      "TitleApplicants"    => title_applicants,
      "Attention"          => dealer.full_name&.upcase,
      "ApplicationNumber"  => lease_application.application_identifier,
      "DealerName"         => lease_application.dealership_name,
      "PrimaryApplicant"   => lease_application.lessee.name.upcase,
      "CoApplicant"        => lease_application.colessee&.name&.upcase,
      "VehicleDescription" => "#{lease_calculator.asset_year} #{lease_calculator.asset_make} #{lease_calculator.asset_model} #{lease_calculator.asset_year}",
      "MileageRange"       => lease_calculator.mileage_tier,
      "MaxFrontAdvance"    => lease_calculator.frontend_max_advance,
      "MaxProdAdvance"     => lease_calculator.backend_max_advance,
      "SlcCreditTier"      => lease_calculator.credit_tier_v2&.description,
      "MaxTerm"            => lease_calculator.term
    }.merge(stipulations)
  end

  def declined_fields
    {
      "Date"             => Date.today.to_s,
      "PrimaryApplicant" => lease_application.lessee.name.upcase,
      "CoApplicant"      => lease_application.colessee&.name&.upcase,
      "Address1"         => address_line_1,
      "Address2"         => address_line_2,
      "Address3"         => '',
      "FirstName"        => lease_application.lessee.first_name.upcase,
      "DealerName"       => lease_application.dealership.name.upcase,
    }.merge(stipulations)
  end

  def address_line_1
    lease_application.lessee.home_address.try(:street1_street2)
  end

  def address_line_2
    lease_application.lessee.home_address.try(:city_state_zip)
  end

  def stipulations
    hash = {}
    lease_application.lease_application_stipulations.required.each_with_index do |stip, i|
      description                 = stip.decorate.with_notes
      hash["Stipulation#{i + 1}"] = description
    end
    hash
  end

  def title_applicants
    names = ''
    names += "#{lease_application.lessee&.name&.upcase}"
    names += " and #{lease_application.colessee&.name&.upcase}" unless lease_application.colessee.blank?
    names
  end
end
