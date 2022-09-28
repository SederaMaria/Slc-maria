class FundingApprovalChecklist < PdfDocument
  cattr_accessor :fields
  attr_reader :application

  text('Doc Date') { doc_date }
  text('Dealer') { dealership.name.upcase }

  text('Received Date') { received_date }

  text('Lessee') { lessee_field }
  text('Lease') { application.application_identifier }
  text('DATE ISSUED') { '' }
  text('INITIALS') { '' }
  text('undefined') { '' }
  text('undefined_2') { '' }
  text('undefined_3') { '' }
  text('undefined_4') { '' }
  text('undefined_5') { '' }
  text('undefined_6') { '' }
  text('undefined_7') { '' }
  text('undefined_8') { '' }
  text('undefined_9') { '' }
  text('undefined_10') { '' }
  text('undefined_11') { '' }
  text('Date') { '' }
  text('Initials') { '' }
  text('Text1') { '' }
  text('Text2') { '' }
  text('Text3') { '' }
  text('Text4') { '' }
  text('Text5') { '' }
  text('Text6') { '' }
  text('Text7') { '' }
  text('Text8') { '' }
  text('Text9') { '' }
  text('Text10') { '' }
  text('Text11') { '' }

  def initialize(application:)
    @application = application
  end

  def self.generate(*args)
    new(*args).generate
  end

  def generate
    File.open(fill(template_path, output_path))
  end

private
  def template_path
    # "#{Rails.root}/public/uploads/application_setting/funding_approval_checklist/1/FundingApprovalChecklist.pdf"
    CommonApplicationSetting.instance.local_funding_approval_checklist_path
  end

  def lessee
    application.lessee
  end

  def colessee
    application.colessee
  end

  def dealership
    application.dealership
  end

  def output_path
    dir = "#{Rails.root}/tmp/funding_approval_checklist/"
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    @output_path ||= "tmp/funding_approval_checklist/funding_approval_checklist_#{Time.now.to_i}.pdf"
  end

  def doc_date
    application&.documents_issued_date&.strftime('%b %d %Y')
  end

  def received_date
    application&.lease_package_received_date&.to_date&.strftime('%b %d %Y')
  end

  def lessee_field
    str  = "#{lessee.name.upcase}"
    str += " and #{colessee&.name&.upcase}" if colessee
    str
  end
end
