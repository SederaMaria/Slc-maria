class Api::V1::Docusign::DocusignEsignController < Api::V1::ApiController
  before_action :add_e_sign_type
  before_action :check_if_docusign_sent, only: [:create]
  before_action :check_if_any_signers_completed, only: [:resend]
  DOCUSIGN = 'docusign'.freeze
  COMPLETED_STATUS = 'completed'.freeze

  def create
    transformed_params = esign_params.transform_keys { |key| key.to_s.underscore }
    data = ESign::ESignFacade.new(transformed_params).create
    render json: { success: true, message: data }, status: 201
  rescue => errors
    render json: { success: false, errors: [ { detail: errors.to_s } ] }, status: 500
  end

  def check_if_docusign_sent
    check_if_docusign_sent = DocusignSummary.where(lease_application_id: params[:leaseApplicationId], envelope_status: 'sent')
    if !check_if_docusign_sent.length.zero?
      render json: { success: false, message: 'Duplicate Envelope Create Request. Please void your current docusign and try again' }, status: 409
    end
  end

  def check_if_any_signers_completed
    statuses = ESign::ESignFacade.new(esign_envelope_params).get_status
    recipients_status = statuses[:recipients_status].values
    if !recipients_status.include? COMPLETED_STATUS
      render json: { success: false, message: 'Not any Signers has completed signing the envelope. Please do not resend now' }, status: 409
    end
  end

  def get_envelope_status
    statuses = ESign::ESignFacade.new(esign_envelope_params).get_status
    render json: { success: true,
                   envelope_status: statuses[:envelope_status],
                   recipients_status: statuses[:recipients_status] }, status: 200
  rescue => errors
    render json: { success: false, errors: errors.to_s }, status: 500
  end

  def add_e_sign_type
    params.merge!(e_sign_type: DOCUSIGN)
  end

  def void
    envelope_id = ESign::ESignFacade.new(esign_envelope_params).void
    render json: { success: true, message: { envelope_id: envelope_id } }, status: 201
  rescue => errors
    render json: { success: false, errors: [ { detail: errors.to_s } ] }, status: 500
  end

  def resend
    envelope_id = ESign::ESignFacade.new(esign_envelope_params).resend
    render json: { success: true, message: { envelope_id: envelope_id } }, status: 201
  rescue => errors
    render json: { success: false, errors: [ { detail: errors.to_s } ] }, status: 500
  end

  def get_all_envelopes
    @all_envelopes = []
    if params['search'].present?
      @all_envelopes = DocusignSummary.search_all_fields params['search'].to_s
    else
      @all_envelopes = DocusignSummary.all.includes([:docusign_histories]).ordered_by_created_at
    end

    docusign_summary_report = {}
    docusign_summary_report['total_completed'] =  @all_envelopes.where(envelope_status: 'completed')&.count
    docusign_summary_report['default_current'] =  1
    docusign_summary_report['total_sent'] =  @all_envelopes.where(envelope_status: 'sent')&.count
    docusign_summary_report['total_voided'] =  @all_envelopes.where(envelope_status: 'voided')&.count
    docusign_summary_report['total_lease_apps'] =  @all_envelopes.select(:lease_application_id).distinct(:lease_application_id)&.count
    docusign_reports = []
     @all_envelopes.map do |envelope|
      envelope_info = {}
      envelope_info[:id] = envelope.id
      envelope_info[:envelope_id] = envelope.envelope_id
      envelope_info[:envelope_status] = envelope.envelope_status.capitalize
      envelope_info[:lease_application_id] = envelope.lease_application_id
      envelope_info[:application_identifier] = envelope&.lease_application&.application_identifier
      envelope_info[:created_at] = envelope.created_at
      envelope_info[:updated_at] = envelope.updated_at
      docusign_histories_array = []
      envelope.docusign_histories.each do|item|
        historyObj = {}
        historyObj[:id] = item.id
        historyObj[:docusign_summary_id] = item.docusign_summary_id
        historyObj[:user_name] = item.user_name
        historyObj[:user_email] = item.user_email
        historyObj[:created_at] = item.created_at
        historyObj[:updated_at] = item.updated_at
        historyObj[:user_role] = item.user_role.capitalize
        historyObj[:user_status] = item.user_status.capitalize
        docusign_histories_array.push(historyObj)
      end
      envelope_info[:docusign_history] = docusign_histories_array
      docusign_reports.push(envelope_info)
    end

    render json: { success: true, docusign_reports: docusign_reports, docusign_summary_reports: docusign_summary_report}, status: 200
    rescue => errors
      render json: { success: false, errors: errors.to_s }, status: 500
  end

  private

  # Here signer1 is lessee, signer2 is colessee and signer3 is the dealer
  def esign_params
    params.permit(:signer1_name, :signer1_email, :signer2_name, :signer2_email,
                  :signer3_name, :signer3_email, :approver_email, :approver_name,
                  :doc_pdf, :leaseApplicationId, :e_sign_type)
  end

  def esign_envelope_params
    params.permit(:envelope_id, :e_sign_type)
  end
end
