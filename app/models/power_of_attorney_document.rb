class PowerOfAttorneyDocument < PdfDocument

  attr_reader :lease_application, :lessee, :lease_documents_request, :todays_date

  cattr_accessor :fields

  def initialize(lease_application, lessee)
    @lease_application = lease_application
    @lease_documents_request = lease_application.last_lease_document_request
    @lessee = lessee
    @todays_date = Date.today
  end

  #these mappings work with the general POA template and the Illinois Specific one.
  # Note, the illinois field names are just numbers......

  text("Year", 'B-Year', '6')   { lease_documents_request.asset_year }
  text("Make", '5')             { lease_documents_request.asset_make }
  text("Model", 'B-Model', '8') { lease_documents_request.asset_model }
  text("VIN", 'B-VIN', '9')     { lease_documents_request.asset_vin }
  date("CurrentDate")           { todays_date }
  text('DayofMonth')            { todays_date.day.ordinalize }
  text('CurrentMonth')          { todays_date.strftime('%B') }
  text('CurrentYear')           { todays_date.year }
  text("LeaseNumber")           { lease_application.application_identifier }
  text("LesseeFullName", 'Lessee1 Name', '3') { lessee.full_name_with_middle_initial }
  text('1')                     { 'SLC Trust'.freeze }
  text("LesseeState")           { lessee.home_address&.state }
  text('4')                     { lessee.home_address&.full_name }
  text('2')                     { '1855 Griffin Road Suite B390, Dania Beach, FL 33004'.freeze }
  date('12')                    { lease_documents_request.delivery_date }

  def local_template_path
    CommonApplicationSetting.instance.power_of_attorney_template_path
  end

  def illinois_template_path
    CommonApplicationSetting.instance.illinois_power_of_attorney_template_path
  end

  def output_path
    dir = "#{Rails.root}/tmp/poa/"
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    "tmp/poa/poa-#{lease_application.application_identifier}-#{lessee.full_name.parameterize}-#{Time.now.to_i}.pdf"
  end

  def generate #generates the Illinois Template if the Lessee lives there.
    if lessee.home_address.state.upcase == 'IL'.freeze
      File.open(fill(illinois_template_path, output_path))
    else
      File.open(fill(local_template_path, output_path))
    end
  end
end