class ESign::SigningViaEmailService
  attr_reader :args

  SENT_STATUS = 'sent'.freeze
  VOIDED_STATUS = 'voided'.freeze
  VOIDING_REASON = 'Admin wants to void the envelope'.freeze
  COMPLETED_STATUS = 'completed'.freeze

  class EsignErrors < StandardError
    def initialize(error)
      @error = error
    end

    def to_s
      "Docusign signing via email service failed. Reason: #{@error}"
    end
  end

  class EsignVoidErrors < StandardError
    def initialize(error)
      @error = error
    end

    def to_s
      "Docusign envelope voiding failed. Reason: #{@error}"
    end
  end

  class EsignResendErrors < StandardError
    def initialize(error)
      @error = error
    end

    def to_s
      "Docusign envelope resend failed. Reason: #{@error}"
    end
  end

  class EsignGetStatusErrors < StandardError
    def initialize(error)
      @error = error
    end

    def to_s
      "Docusign envelope status getting failed. Reason: #{@error}"
    end
  end

  def initialize(args)
    @args = args
    @envelope_api = create_envelope_api(args)
  end

  def worker
    envelope_args = args[:envelope_args]
    envelope_definition = make_envelope args[:envelope_args]
    results = @envelope_api.create_envelope args[:account_id], envelope_definition
    envelope_id = results.envelope_id
    update_docusign_informations(envelope_id, envelope_args)
    { envelope_id: envelope_id }
  rescue => errors
    raise EsignGetStatusErrors, errors.to_s
  end

  def get_envelope(envelope_id)
    @envelope_api.get_envelope(args[:account_id], envelope_id)
  end

  def import_docusign_envelopes
    options = DocuSign_eSign::ListStatusChangesOptions.new
    options.from_date = (Date.today - 1).strftime('%Y/%m/%d')
    docusign_data = @envelope_api.list_status_changes args[:account_id], options
    docusign_data.envelopes.each do |envelope|
      envelope_exist = DocusignSummary.find_by(envelope_id: envelope.envelope_id)
      if(envelope_exist && envelope_exist&.envelope_status != envelope.status) 
        envelope_exist.envelope_status = envelope.status
        envelope_exist.updated_at = envelope.last_modified_date_time
        envelope_exist.save
      end
      update_envelope_or_receipients(envelope, envelope_exist)
    end
  end

  def update_envelope_or_receipients(envelope, envelope_exist)
    ActiveRecord::Base.transaction do
      docusign_summary_id = envelope_exist&.id
      if envelope_exist.nil?
        envelope_custom_fields = @envelope_api.list_custom_fields args[:account_id], envelope.envelope_id
        lease_application = LeaseApplication.find_by(application_identifier: envelope_custom_fields.text_custom_fields[2].value )
        docusign_summary = lease_application && lease_application&.docusign_summaries&.create(envelope_id: envelope.envelope_id, envelope_status: envelope.status, created_at: envelope.sent_date_time, updated_at: envelope.last_modified_date_time)
        docusign_summary_id = docusign_summary&.id
      end
      if !docusign_summary_id.nil?
        docusign_histories = []
        receipients = @envelope_api.list_recipients args[:account_id], envelope.envelope_id
        receipients.signers.each.with_index do |signer, index|
          docusign_histories << { docusign_summary_id: docusign_summary_id, user_name: signer.name,
          user_role: DocusignHistory.user_roles[signer_roles(signer.recipient_id)],
          user_email: signer.email,
          user_status: DocusignHistory.user_statuses[signer.status],
          created_at: signer.sent_date_time || envelope.sent_date_time, updated_at: signer.signed_date_time || envelope.last_modified_date_time }
        end
        DocusignHistory.upsert_all(docusign_histories, unique_by: [:docusign_summary_id, :user_role])
      end
    end
  end

  def get_envelope_status
    envelope_id = args[:envelope_args][:envelope_id]
    envelope = get_envelope(envelope_id)
    status = envelope.status
    signers_status = get_envelope_recipients_statuses(envelope_id)
    docusign_summary = DocusignSummary.find_by(envelope_id: envelope_id)
    if docusign_summary
      docusign_summary.update(envelope_status: status) unless docusign_summary.envelope_status == status
      docusign_histories = docusign_summary.docusign_histories
      docusign_histories.each do |history|
        history.user_status = signers_status[history.user_role]
        history.save
      end
    end
    { envelope_status: status, recipients_status: signers_status }
  rescue => errors
    raise EsignGetStatusErrors, errors.to_s
  end

  def void_envelope
    envelope_id = args[:envelope_args][:envelope_id]
    docusign_summary = DocusignSummary.find_by(envelope_id: envelope_id)
    raise EsignVoidErrors, 'envelope does not exist in the database' unless docusign_summary.present?
    raise EsignVoidErrors, 'envelope is already voided' if docusign_summary.envelope_status == VOIDED_STATUS

    envelope_details = get_envelope(envelope_id)
    if envelope_details.status == COMPLETED_STATUS
      docusign_summary.update(envelope_status: 2) unless docusign_summary.envelope_status == COMPLETED_STATUS
      raise EsignVoidErrors, 'envelope is already completed' if docusign_summary.envelope_status == COMPLETED_STATUS
    end

    env = DocuSign_eSign::EnvelopeDefinition.new
    env.status = VOIDED_STATUS
    env.voided_reason = VOIDING_REASON
    envelope_update = @envelope_api.update(args[:account_id], envelope_id, env)
    raise EsignVoidErrors, envelope_update.error_details.message if envelope_update.error_details.present?

    docusign_summary.update(envelope_status: 1)
    envelope_id
  rescue EsignVoidErrors => errors
    raise errors
  rescue => errors
    raise EsignVoidErrors, errors.to_s
  end

  def resend_envelope
    envelope_id = args[:envelope_args][:envelope_id]
    docusign_summary = DocusignSummary.find_by(envelope_id: envelope_id)
    raise EsignResendErrors, 'envelope does not exist in the database' unless docusign_summary.present?
    raise EsignResendErrors, 'envelope is already voided' if docusign_summary.envelope_status == VOIDED_STATUS

    envelope_details = get_envelope(envelope_id)
    if envelope_details.status == COMPLETED_STATUS
      docusign_summary.update(envelope_status: 2) unless docusign_summary.envelope_status == COMPLETED_STATUS
      raise EsignVoidErrors, 'envelope is already completed' if docusign_summary.envelope_status == COMPLETED_STATUS
    end

    envelope = get_envelope(envelope_id)
    raise EsignResendErrors, 'envelope status must be sent to resend the envelope' unless envelope.status == SENT_STATUS

    env = DocuSign_eSign::EnvelopeDefinition.new
    update_option = DocuSign_eSign::UpdateOptions.new
    update_option.resend_envelope = true
    envelope_update = @envelope_api.update(args[:account_id], envelope_id, env, update_option)
    raise EsignResendErrors, envelope_update.error_details.message if envelope_update.error_details.present?

    envelope_id
  rescue EsignResendErrors => errors
    raise errors
  rescue => errors
    raise EsignResendErrors, errors.to_s
  end

  def get_envelope_recipients_statuses(envelope_id)
    recipients_details = @envelope_api.list_recipients(args[:account_id], envelope_id)
    signer_objects = recipients_details.signers
    signers_status = {}
    signer_objects.each do |signer|
      recipient_id = signer.recipient_id
      status = signer_roles(recipient_id)
      signers_status[status] = signer.status
    end
    signers_status
  end

  def signer_roles(recipient_id)
    case recipient_id
    when '1'
      'lessee'
    when '2'
      'colessee'
    when '3'
      'dealer'
    when '4'
      'approver'
    end
  end

  private

  def update_docusign_informations(envelope_id, envelope_args)
    docusign_histories = []
    ActiveRecord::Base.transaction do
      lease_application = LeaseApplication.find(envelope_args[:lease_application_id])
      docusign_summary = lease_application.docusign_summaries.create(envelope_id: envelope_id, envelope_status: 0)
      docusign_histories << { docusign_summary_id: docusign_summary.id, user_name: envelope_args[:signer1_name],
                              user_role: 0, user_email: envelope_args[:signer1_email], user_status: 1,
                              created_at: DateTime.now, updated_at: DateTime.now }
      if envelope_args[:signer2_email].present? && envelope_args[:signer2_name].present?
        docusign_histories << { docusign_summary_id: docusign_summary.id, user_name: envelope_args[:signer2_name],
                                user_role: 1, user_email: envelope_args[:signer2_email], user_status: 0,
                                created_at: DateTime.now, updated_at: DateTime.now }
      end
      docusign_histories << { docusign_summary_id: docusign_summary.id, user_name: envelope_args[:signer3_name],
                              user_role: 2, user_email: envelope_args[:signer3_email], user_status: 0,
                              created_at: DateTime.now, updated_at: DateTime.now }
      docusign_histories << { docusign_summary_id: docusign_summary.id, user_name: envelope_args[:approver_name],
                              user_role: 3, user_email: envelope_args[:approver_email], user_status: 0,
                              created_at: DateTime.now, updated_at: DateTime.now }
      DocusignHistory.upsert_all(docusign_histories)
    end
  end

  def create_envelope_api(args)
    configuration = DocuSign_eSign::Configuration.new
    configuration.host = args[:base_path]
    api_client = DocuSign_eSign::ApiClient.new configuration
    api_client.default_headers['Authorization'] = "Bearer #{args[:access_token]}"
    DocuSign_eSign::EnvelopesApi.new api_client
  end

  def set_attributes_attachment_tab(attachment_tab)
    attachment_tab.optional = true
    attachment_tab.anchor_ignore_if_not_present = true
  end

  def assign_custom_fields(envelope_args, envelope_definition)
    lessee_name = envelope_args[:signer1_name]
    lessee_name_array = lessee_name.split(' ')
    lease_application = LeaseApplication.find(envelope_args[:lease_application_id])
    custom_fields = DocuSign_eSign::CustomFields.new

    text_custom_field1 = DocuSign_eSign::TextCustomField.new
    text_custom_field1.name = 'First_Name'
    text_custom_field1.field_id = 'text_custom_field_first_name'
    lessee_first_name = lessee_name_array[0..-2].join(' ')
    text_custom_field1.value = lessee_first_name
    text_custom_field1.show = true
    text_custom_field1.required = true

    text_custom_field2 = DocuSign_eSign::TextCustomField.new
    text_custom_field2.name = 'Last_Name'
    text_custom_field2.field_id = 'text_custom_field_last_name'
    lessee_last_name = lessee_name_array.last
    text_custom_field2.value = lessee_last_name
    text_custom_field2.show = true
    text_custom_field2.required = true

    text_custom_field3 = DocuSign_eSign::TextCustomField.new
    text_custom_field3.name = 'App_ID'
    text_custom_field3.field_id = 'text_custom_field_app_id'
    text_custom_field3.value = lease_application.application_identifier
    text_custom_field3.show = true
    text_custom_field3.required = true

    custom_fields.text_custom_fields = [text_custom_field1, text_custom_field2, text_custom_field3]
    envelope_definition.custom_fields = custom_fields
  end

  def base64_encoded_document(envelope_args)
    pdf_url = Rails.env.production? || Rails.env.staging? ? envelope_args[:doc_pdf] : "#{Rails.root}/public#{envelope_args[:doc_pdf]}"
    pdf_file = open(pdf_url)
    Base64.encode64(File.binread(pdf_file))
  end

  def sign_here_tabs
    sign_here1 = DocuSign_eSign::SignHere.new(anchorString: '*Signature1*', anchorYOffset: '0',
                                              anchorUnits: 'pixels', anchorXOffset: '0')

    sign_here3 = DocuSign_eSign::SignHere.new(anchorString: '*Signature3*', anchorYOffset: '0',
                                              anchorUnits: 'pixels', anchorXOffset: '0')

    sign_here2 = DocuSign_eSign::SignHere.new(anchorString: '*Signature2*', anchorYOffset: '0',
                                              anchorUnits: 'pixels', anchorXOffset: '0')
    [sign_here1, sign_here2, sign_here3]
  end

  def tread_tabs
    signer3_front_tread = DocuSign_eSign::Number.new(anchorString: '*Signer3 FrontTread*', anchorYOffset: '0',
                                                     anchorUnits: 'pixels', anchorXOffset: '30', locked: 'false',
                                                     width: '20')

    signer3_rear_tread = DocuSign_eSign::Number.new(anchorString: '*Signer3 RearTread*', anchorYOffset: '0',
                                                    anchorUnits: 'pixels', anchorXOffset: '30', locked: 'false',
                                                    width: '20')

    signer3_third_tread = DocuSign_eSign::Number.new(anchorString: '*Signer3 ThirdTread*', anchorYOffset: '0',
                                                     anchorUnits: 'pixels', anchorXOffset: '30', locked: 'false',
                                                     width: '20')

    signer3_front_tread.tab_id = 'signer3_front_tread'
    signer3_front_tread.tab_label = 'Front Tread label for signer3'
    signer3_rear_tread.tab_id = 'signer3_rear_tread'
    signer3_rear_tread.tab_label = 'Rear Tread label for signer3'
    signer3_third_tread.tab_id = 'signer3_third_tread'
    signer3_third_tread.tab_label = 'Third Tread label for signer3'
    signer3_third_tread.required = false

    [signer3_front_tread, signer3_rear_tread, signer3_third_tread]
  end

  def all_text_tabs
    text_tab1 = DocuSign_eSign::Text.new(anchorString: '*Bank Name*', anchorYOffset: '0', anchorUnits: 'pixels',
                                         anchorXOffset: '0', locked: 'false', width: '100')

    text_tab2 = DocuSign_eSign::Text.new(anchorString: '*Bank Branch Location*', anchorYOffset: '0',
                                         anchorUnits: 'pixels', anchorXOffset: '0', locked: 'false', width: '100')

    signer3_vehicle_condition = DocuSign_eSign::Text.new(anchorString: '*Signer3 VehicleCondition*', anchorYOffset: '0',
                                                         anchorUnits: 'pixels', anchorXOffset: '-10', locked: 'false',
                                                         width: '642', height: '60')

    signer1_vehicle_condition = DocuSign_eSign::Text.new(anchorString: '*Signer1 VehicleCondition*',
                                                         anchorYOffset: '-10', anchorUnits: 'pixels',
                                                         anchorXOffset: '-10', locked: 'false',
                                                         width: '642', height: '30')

    bank_routing_number_tab = DocuSign_eSign::Text.new(anchorString: '*Bank Routing Number*', anchorYOffset: '0',
                                     anchorUnits: 'pixels', anchorXOffset: '0', locked: 'false', width: '100')

    text_tab1.tab_id = 'text_tab1'
    text_tab1.tab_label = 'Bank name text for Signer 1'
    text_tab2.tab_id = 'text_tab2'
    text_tab2.tab_label = 'Bank branch location text for Signer 1'
    signer3_vehicle_condition.tab_id = 'signer3_vehicle_condition'
    signer3_vehicle_condition.tab_label = 'Vehicle Condition Text box for signer3'
    signer3_vehicle_condition.tooltip = 'Dealer Notes'
    signer3_vehicle_condition.required = false
    signer1_vehicle_condition.tab_id = 'signer1_vehicle_condition'
    signer1_vehicle_condition.tab_label = 'Vehicle Condition Text box for signer1'
    signer1_vehicle_condition.required = false
    signer1_vehicle_condition.tooltip = 'Applicant Notes'
    bank_routing_number_tab.tab_id = 'bank_routing_number'
    bank_routing_number_tab.tab_label = 'Bank routing number for Signer 1'
    bank_routing_number_tab.validation_pattern = "^([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])*$"
    bank_routing_number_tab.validation_message = 'Please enter a valid 9 digit routing number'
    bank_routing_number_tab.max_length = 9

    [text_tab1, text_tab2, signer3_vehicle_condition, signer1_vehicle_condition, bank_routing_number_tab]
  end

  def bank_account_number_tab
    tab = DocuSign_eSign::Number.new(anchorString: '*Bank Account Number*', anchorYOffset: '0',
                                     anchorUnits: 'pixels', anchorXOffset: '0', locked: 'false', width: '100')
    tab.tab_id = 'bank_account_number'
    tab.tab_label = 'Bank account number for Signer 1'
    tab
  end

  def radio_tabs
    radio_tab1 = DocuSign_eSign::Radio.new(anchorString: '*Signer1 radio1*', anchorYOffset: '-2',
                                           anchorUnits: 'pixels', anchorXOffset: '-12', locked: 'false', required: true)
    radio_tab2 = DocuSign_eSign::Radio.new(anchorString: '*Signer1 radio2*', anchorYOffset: '-2',
                                           anchorUnits: 'pixels', anchorXOffset: '-12', locked: 'false', required: true)
    radio_tab3 = DocuSign_eSign::Radio.new(anchorString: '*Signer1 radio3*', anchorYOffset: '-2',
                                           anchorUnits: 'pixels', anchorXOffset: '-11', locked: 'false', required: true)
    radio_tab4 = DocuSign_eSign::Radio.new(anchorString: '*Signer1 radio4*', anchorYOffset: '-2',
                                           anchorUnits: 'pixels', anchorXOffset: '-12', locked: 'false', required: true)
    radio_tab5 = DocuSign_eSign::Radio.new(anchorString: '*Signer1 radio5*', anchorYOffset: '-2',
                                           anchorUnits: 'pixels', anchorXOffset: '-12', locked: 'false', required: true)
    radio_tab6 = DocuSign_eSign::Radio.new(anchorString: '*Signer1 radio6*', anchorYOffset: '-2',
                                           anchorUnits: 'pixels', anchorXOffset: '-12', locked: 'false', required: true)
    radio_tab7 = DocuSign_eSign::Radio.new(anchorString: '*Signer1 radio7*', anchorYOffset: '-2',
                                           anchorUnits: 'pixels', anchorXOffset: '-12', locked: 'false', required: true)
    radio_tab1.value = 'Once per month'
    radio_tab1.selected = 'false'
    radio_tab2.value = 'Twice per month'
    radio_tab2.selected = 'false'
    radio_tab3.value = 'Checking'
    radio_tab3.selected = 'false'
    radio_tab4.value = 'Savings'
    radio_tab4.selected = 'false'
    radio_tab5.value = 'In the Lessees Name'
    radio_tab5.selected = 'false'
    radio_tab6.value = 'In the Co-Lessee’s Name'
    radio_tab6.selected = 'false'
    radio_tab7.value = 'In Both Names'
    radio_tab7.selected = 'false'
    [radio_tab1, radio_tab2, radio_tab3, radio_tab4, radio_tab5, radio_tab6, radio_tab7]
  end

  def dealer_full_name_tab
    DocuSign_eSign::FullName.new(anchorString: '*Dealer FullName*', anchorYOffset: '0', anchorUnits: 'pixels',
                                 anchorXOffset: '0', locked: 'false')
  end

  def drawing_tab
    motor_condition_drawing_tab = DocuSign_eSign::Draw.new(anchorString: '*Signer3 Draw*', anchorYOffset: '0',
                                                           anchorUnits: 'pixels', anchorXOffset: '0', locked: false,
                                                           required: false)
    motor_condition_drawing_tab.tab_id = 'signer3_drawing_tab1'
    motor_condition_drawing_tab.height = 270
    motor_condition_drawing_tab.width = 360
    motor_condition_drawing_tab.allow_signer_upload = true
    motor_condition_drawing_tab
  end

  def attachment_tabs
    lessee_attachment_tab = DocuSign_eSign::SignerAttachment.new
    lessee_attachment_tab.anchor_string = '*Lessee Attachment*'
    lessee_attachment_tab.tab_id = 'lessee_attachment'
    set_attributes_attachment_tab(lessee_attachment_tab)

    approver_attachment_tab = DocuSign_eSign::SignerAttachment.new
    approver_attachment_tab.anchor_string = '*Approver Attachment*'
    approver_attachment_tab.tab_id = 'approver_attachment'
    set_attributes_attachment_tab(approver_attachment_tab)
    [lessee_attachment_tab, approver_attachment_tab]
  end

  def date_tabs
    date_tab1 = DocuSign_eSign::DateSigned.new(anchorString: '*Signature1 Date*', anchorYOffset: '0',
                                               anchorUnits: 'pixels', anchorXOffset: '0', locked: 'false')
    date_tab2 = DocuSign_eSign::DateSigned.new(anchorString: '*Signature2 Date*', anchorYOffset: '0',
                                               anchorUnits: 'pixels', anchorXOffset: '0', locked: 'false')
    date_tab3 = DocuSign_eSign::DateSigned.new(anchorString: '*Signature3 Date*', anchorYOffset: '0',
                                               anchorUnits: 'pixels', anchorXOffset: '0', locked: 'false')

    date_tab1.tab_id = 'signature1_date'
    date_tab1.tab_label = 'Signature1 Date'
    date_tab2.tab_id = 'signature2_date'
    date_tab2.tab_label = 'Signature2 Date'
    date_tab3.tab_id = 'signature3_date'
    date_tab3.tab_label = 'Signature3 Date'
    [date_tab1, date_tab2, date_tab3]
  end

  def create_lessee(envelope_args, lease_application)
    signer1 = DocuSign_eSign::Signer.new
    signer1.email = envelope_args[:signer1_email]
    signer1.name = envelope_args[:signer1_name]
    signer1.email_notification = {
      "emailSubject": "Please review and sign documents from Speed Leasing for contract [#{lease_application.application_identifier}]",
      "emailBody": "Thank you for choosing Speed Leasing. Please review and sign your documents, and feel free to speak with your Dealer if you have any questions.

Once completed, please allow time for us to receive and review the documents. You will receive confirmation by email once the signing is complete and accepted, and we will call you at the number provided to verify your identity and go over a few quick details.

We look forward to speaking with you. Thanks again for choosing Speed Leasing."
    }
    signer1.recipient_id = '1'
    signer1.routing_order = '1'
    signer1
  end

  def create_dealer(envelope_args, lease_application)
    signer3 = DocuSign_eSign::Signer.new
    signer3.email = envelope_args[:signer3_email]
    signer3.name = envelope_args[:signer3_name]
    signer3.email_notification = {
      "emailSubject": "Please review and sign documents from Speed Leasing for contract [#{lease_application.application_identifier}]",
      "emailBody": "Thank you for choosing Speed Leasing.

Your customer(s) have signed and the documents are now ready for Dealer signatures. Once completed, our Funding Department will review the contracts and send notifications that signing is complete.  You will be notified by email if any additional items are required for Funding.

WE DO A WELCOME CALL AS PART OF OUR FUNDING PROCESS. IT TAKES THE CUSTOMER ABOUT 2 TO 3 MINUTES, AND WE RECOMMEND IT GETS COMPLETED AT THE TIME OF SIGNING TO AVOID ANY DELAYS.  PLEASE CONTACT US AT 1-844-221-0102 (OR BY EMAIL AT SUPPORT@SPEEDLEASING.COM) WHEN YOU ARE READY FOR US TO CALL THE CUSTOMER, OR IF YOU NEED ASSISTANCE WITH ANYTHING ELSE.

Thanks. Please let us know if you have any questions."
    }
    signer3.recipient_id = '3'
    signer3.routing_order = '3'
    signer3
  end

  def create_colessee(envelope_args, lease_application)
    signer2 = DocuSign_eSign::Signer.new
    signer2.email = envelope_args[:signer2_email]
    signer2.name = envelope_args[:signer2_name]
    signer2.email_notification = {
      "emailSubject": "Please review and sign documents from Speed Leasing for contract [#{lease_application.application_identifier}]",
      "emailBody": "Thank you for choosing Speed Leasing. Please review and sign your documents, and feel free to speak with your Dealer if you have any questions.

Once completed, please allow time for us to receive and review the documents. You will receive confirmation by email once the signing is complete and accepted, and we will call you at the number provided to verify your identity and go over a few quick details.

We look forward to speaking with you. Thanks again for choosing Speed Leasing."
    }
    signer2.recipient_id = '2'
    signer2.routing_order = '2'
    signer2
  end

  def create_approver(envelope_args, lease_application)
    signer4 = DocuSign_eSign::Signer.new
    signer4.email = envelope_args[:approver_email]
    signer4.name = envelope_args[:approver_name]
    signer4.email_notification = {
      "emailSubject": "Please review and sign documents from Speed Leasing for contract [#{lease_application.application_identifier}]",
      "emailBody": "This contract has been signed by both the customer(s) and the dealer. Please review for correctness and approve if acceptable. Once approved, please update the status in the LOS and issue Funding Delays for any additionally required items. Thank you."
    }
    signer4.recipient_id = '4'
    signer4.routing_order = '4'
    signer4
  end

  def create_radio_groups(radio_tabs)
    radio_tab1, radio_tab2, radio_tab3, radio_tab4, radio_tab5, radio_tab6, radio_tab7 = radio_tabs
    radioGroup1 = DocuSign_eSign::RadioGroup.new
    radioGroup1.group_name = 'Group1'
    radioGroup1.radios = [radio_tab1, radio_tab2]
    radioGroup2 = DocuSign_eSign::RadioGroup.new
    radioGroup2.group_name = 'Group2'
    radioGroup2.radios = [radio_tab3, radio_tab4]
    radioGroup3 = DocuSign_eSign::RadioGroup.new
    radioGroup3.group_name = 'Group3'
    radioGroup3.radios = [radio_tab5, radio_tab6, radio_tab7]
    [radioGroup1, radioGroup2, radioGroup3]
  end

  def make_envelope(envelope_args)
    envelope_definition = DocuSign_eSign::EnvelopeDefinition.new
    assign_custom_fields(envelope_args, envelope_definition)
    envelope_definition.email_subject = 'Please sign this document set'
    doc_b64 = base64_encoded_document(envelope_args)

    document = DocuSign_eSign::Document.new(documentBase64: doc_b64, name: 'Lease Package Document',
                                            fileExtension: 'pdf', documentId: '1')
    envelope_definition.documents = [document]
    lease_application = LeaseApplication.find(envelope_args[:lease_application_id])

    signer1 = create_lessee(envelope_args, lease_application)
    signer3 = create_dealer(envelope_args, lease_application)
    signers = [signer1]

    sign_here1, sign_here2, sign_here3 = sign_here_tabs
    signer3_front_tread, signer3_rear_tread, signer3_third_tread = tread_tabs
    text_tab1, text_tab2, signer3_vehicle_condition, signer1_vehicle_condition, bank_routing_number_tab = all_text_tabs
    radio_groups = create_radio_groups(radio_tabs)

    approve_tab = DocuSign_eSign::Approve.new(anchorString: '*Approve*')
    motor_condition_drawing_tab = drawing_tab
    lessee_attachment_tab, approver_attachment_tab = attachment_tabs
    date_tab1, date_tab2, date_tab3 = date_tabs

    signer2_tabs = DocuSign_eSign::Tabs.new
    signer2_tabs.sign_here_tabs = [sign_here2]
    signer2_tabs.date_signed_tabs = [date_tab2]

    if envelope_args[:signer2_email].present? && envelope_args[:signer2_name].present?
      signer2 = create_colessee(envelope_args, lease_application)
      signer2.tabs = signer2_tabs
      signers << signer2
    end
    signer4 = create_approver(envelope_args, lease_application)

    signer1_tabs = DocuSign_eSign::Tabs.new
    signer1_tabs.sign_here_tabs = [sign_here1]
    signer1_tabs.text_tabs = [text_tab1, text_tab2, signer1_vehicle_condition, bank_routing_number_tab]
    signer1_tabs.radio_group_tabs = radio_groups
    signer1_tabs.signer_attachment_tabs = [lessee_attachment_tab]
    signer1_tabs.date_signed_tabs = [date_tab1]
    signer1_tabs.draw_tabs = [motor_condition_drawing_tab]
    signer1_tabs.number_tabs = [bank_account_number_tab]

    signer3_tabs = DocuSign_eSign::Tabs.new
    signer3_tabs.sign_here_tabs = [sign_here3]
    signer3_tabs.full_name_tabs = [dealer_full_name_tab]
    signer3_tabs.draw_tabs = [motor_condition_drawing_tab]
    signer3_tabs.text_tabs = [signer3_vehicle_condition]
    signer3_tabs.number_tabs = [signer3_front_tread, signer3_rear_tread, signer3_third_tread]
    signer3_tabs.date_signed_tabs = [date_tab3]

    signer4_tabs = DocuSign_eSign::Tabs.new
    signer4_tabs.approve_tabs = [approve_tab]
    signer4_tabs.signer_attachment_tabs = [approver_attachment_tab]

    signer1.tabs = signer1_tabs
    signer3.tabs = signer3_tabs
    signer4.tabs = signer4_tabs

    signers += [signer3, signer4]

    recipients = DocuSign_eSign::Recipients.new(signers: signers)
    envelope_definition.recipients = recipients
    envelope_definition.status = SENT_STATUS
    envelope_definition
  end
end
