class ExportPoaService

  LESSEE = "lessee"
  
  def initialize(lease_application_id:, type:, email:)
    @lease_application = LeaseApplication.find(lease_application_id)
    @type              = type
    @lessee            = set_lessee
    @recipient         = email
  end

  def call
    return {"#{type.to_sym}" => 'does not exist.'} unless lessee
    email_to_recipient(generate_pdf)
    {}
  end

  private

  attr_reader :lease_application, :recipient, :lessee, :type

  def set_lessee
    type == LESSEE ? lease_application.lessee : lease_application.colessee
  end

  def generate_pdf
    PowerOfAttorneyDocument.new(lease_application, lessee).generate
  end

  def email_to_recipient(filepath)
    DealerMailer.poa_pdf_export(recipient: recipient, filepath: filepath).deliver
  end
  
  
end