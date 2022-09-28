require 'states'

class Credco::Client

  CREDCO_SERVICE_URL = URI.parse(ENV['CREDCO_SERVICE_URL'])
  CREDCO_CERT_PATH = File.join(Rails.root, "config", 'credco.crt')
  CREDCO_CERT = File.read(CREDCO_CERT_PATH).freeze
  CREDCO_KEY_PATH = File.join(Rails.root, 'config', 'credco.key')
  CREDCO_KEY = File.read(CREDCO_KEY_PATH).freeze

  DUMMY_PATH = Rails.root.join('lib', 'data', 'credco_success.xml').to_s.freeze
  DUMMY_RESPONSE = File.read(DUMMY_PATH).freeze

  attr_accessor :lessee_record, :http_client

  # Todo - Decouple from Lessee Record. Just pass in a hash of data.
  def initialize(lessee_record:)
    @lessee_record = lessee_record
    @http_client = build_http_client
  end

  def credit_report
    if ENV['CREDCO_DISABLED'] == 'yes'
      Rails.logger.info("[#{Time.current}] Stashing fake Credco response on lessee_record #{lessee_record.id}")
      return DUMMY_RESPONSE
    else
      Rails.logger.info("[#{Time.current}] CREDCO_CREDIT_RUN: Requesting credit for lessee_record: #{lessee_record.id}.  Called by: #{caller[0]}")
      valid_xml = false
      begin
        valid_credit_report_xml = credit_report_xml
        valid_xml = true
      rescue StandardError => error
        Rails.logger.info "#{error}"
        Rails.logger.info "#{error.backtrace}"
      end
      if valid_xml
        response = do_request(payload: valid_credit_report_xml)
        raise_on_error(response.body)
        return response.body
      end
    end
  end

private

  def credit_report_xml
    address          = lessee_record.home_address.street1
    suffix           = lessee_record&.suffix || ""
    state_code       = lessee_record.home_address.new_state_value
    dealership       = lessee_record.dealership
    transunion_flag  = dealership.use_transunion? ? "Y" : "N"
    equifax_flag     = dealership.use_equifax? ? "Y" : "N"
    experian_flag    = dealership.use_experian? ? "Y" : "N"
    xml   = '<REQUEST_GROUP MISMOVersionID="2.3.1"><REQUESTING_PARTY>'
    xml  += '<PREFERRED_RESPONSE _Format = "XML" _VersionIdentifier="2.3.1"/>'
    xml  += '<PREFERRED_RESPONSE _Format="PDF"/></REQUESTING_PARTY><RECEIVING_PARTY _Name="F3EA Servicing LLC dba Speed Leasing"/> '
    xml  += '<SUBMITTING_PARTY _Name="Lease Origination System" /><SUBMITTING_PARTY _Identifier="SLLOS"/>'
    xml  += '<REQUEST LoginAccountIdentifier="' + ENV['CREDCO_LOGIN_ID'] + '" LoginAccountPassword="' + ENV['CREDCO_PASSWORD'] + '"><REQUEST_DATA>'
    xml  += '<CREDIT_REQUEST MISMOVersionID="2.3.1" RequestingPartyRequestedByName="Brian Cramer"><CREDIT_REQUEST_DATA CreditReportType="Merge" CreditReportRequestActionType="Submit" BorrowerID = "Borrower" CreditReportIdentifier = "" CreditRequestType="Individual" >'
    xml  += "<CREDIT_REPOSITORY_INCLUDED _EquifaxIndicator=\"#{equifax_flag}\" _ExperianIndicator=\"#{experian_flag}\" _TransUnionIndicator=\"#{transunion_flag}\" />"
    xml  += '</CREDIT_REQUEST_DATA><LOAN_APPLICATION>'
    xml  += '<BORROWER BorrowerID="Borrower" _FirstName="' + lessee_record.first_name + '" _MiddleName = ""  _LastName="' + lessee_record.last_name
    xml  += '"  _NameSuffix="' + suffix + '" _PrintPositionType="Borrower" _SSN="' + lessee_record.ssn + '" >'
    xml  += '<_RESIDENCE _StreetAddress="' + address + '" _City="' + lessee_record.home_address.new_city_value + '" _State="' + state_code
    xml  += '" _PostalCode="' + lessee_record.home_address.zipcode + '" BorrowerResidencyType="Current">'
    xml  += '</_RESIDENCE></BORROWER>'
    xml  += '</LOAN_APPLICATION></CREDIT_REQUEST></REQUEST_DATA></REQUEST></REQUEST_GROUP>'
    xml
  end

  def build_http_client
    http_client = Net::HTTP.new(CREDCO_SERVICE_URL.host, CREDCO_SERVICE_URL.port)
    http_client.use_ssl = true
    http_client.ssl_version = :TLSv1_2
    http_client.cert = OpenSSL::X509::Certificate.new(CREDCO_CERT)
    http_client.verify_mode = OpenSSL::SSL::VERIFY_NONE #TODO: set to VERIFY_PEER to verify the other side's cert
    http_client.key = OpenSSL::PKey::RSA.new(CREDCO_KEY)
    http_client.ca_file = File.join(Rails.root, 'config', 'CaPublicKey.crt')
    http_client.ciphers=["3DES-EDE-CBC-SHA","TLSv1.2", 112, 168]
    return http_client
  end

  def raise_on_error(response)
    response = Nokogiri::XML.parse(response)
    if has_error?(response)
      message = "Error code: #{response.at('//CREDIT_ERROR_MESSAGE/@_Code').value}#{response.at('//CREDIT_ERROR_MESSAGE').text}"
      raise(StandardError, message)
    end
  end

  def has_error?(response)
    response.at('//CREDIT_RESPONSE/@CreditReportType')&.value == 'Error'
  end

  def do_request(payload:, http_method: 'GET')
    http_client.send_request(http_method, CREDCO_SERVICE_URL.path, payload)
  end

  def credit_report_identifier
    lessee_record.last_successful_credit_report.identifier
  end
end
