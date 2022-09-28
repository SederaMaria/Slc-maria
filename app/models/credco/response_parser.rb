class Credco::ResponseParser

  MERGE_REPORT_LOCATION = "//RESPONSE_GROUP//RESPONSE//RESPONSE_DATA//CREDIT_RESPONSE//EMBEDDED_FILE//DOCUMENT".freeze

  attr_reader :xml_response

  def initialize(credco_response:)
    @xml_response = Nokogiri::XML.parse(credco_response)
  end
 
  def has_embedded_file?
    embedded_file.present?
  end

  def decode_and_return_embedded_file
    Base64.decode64(embedded_file.first.text) if has_embedded_file?
  end

  def highest_fico_score
    credit_scores.empty? ? 0 : credit_scores.max
  end

  #A Single XPATH search can replace this whole thing
  def embedded_file
    @xml_response.xpath(MERGE_REPORT_LOCATION)
  end

  def generate_credit_report_pdf
    tempfile = Tempfile.new(["credit_report_#{Time.now.to_i}", '.pdf'])
    tempfile.binmode
    tempfile.write(decode_and_return_embedded_file)
    tempfile
  end

  def credit_scores
    #https://www.w3schools.com/xml/xpath_syntax.asp
    #Finds any Credit Score XML nodes and pulls out their Value Attributes in one shot
    #Ignore CREDIT_SCORE's with IDIndex attributes.
    xpath = <<-XML
      //RESPONSE//RESPONSE_DATA//CREDIT_SCORE[not(@_ModelNameTypeOtherDescription='IDIndex')]//@_Value
    XML
    
    xml_response.xpath(xpath).map {|xml_attr| xml_attr.value.to_i}
  end

  def credit_score_equifax
    xpath = <<-XML
      //RESPONSE//RESPONSE_DATA//CREDIT_SCORE[(@CreditRepositorySourceType='Equifax')]//@_Value
    XML

    xml_response.xpath(xpath).first&.value.to_i
  end

  def credit_score_experian
    xpath = <<-XML
      //RESPONSE//RESPONSE_DATA//CREDIT_SCORE[(@CreditRepositorySourceType='Experian')]//@_Value
    XML

    xml_response.xpath(xpath).first&.value.to_i
  end

  def credit_score_transunion
    xpath = <<-XML
      //RESPONSE//RESPONSE_DATA//CREDIT_SCORE[(@CreditRepositorySourceType='TransUnion')]//@_Value
    XML

    xml_response.xpath(xpath).first&.value.to_i
  end

  def credit_report_identifier
    xml_response.at('//RESPONSE/RESPONSE_DATA/CREDIT_RESPONSE')['CreditReportIdentifier']
  end

  def credit_liability_repossessions
    xml_response.xpath("//RESPONSE_GROUP/RESPONSE/RESPONSE_DATA/CREDIT_RESPONSE/CREDIT_LIABILITY/_HIGHEST_ADVERSE_RATING[@_Type='Repossession']/parent::CREDIT_LIABILITY")
  end

  def credit_public_record_bankruptcies
    xml_response.xpath("//RESPONSE_GROUP/RESPONSE/RESPONSE_DATA/CREDIT_RESPONSE/CREDIT_PUBLIC_RECORD[starts-with(@_Type, 'Bankruptcy')]")
  end
end
