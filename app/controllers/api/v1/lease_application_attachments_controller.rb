class Api::V1::LeaseApplicationAttachmentsController < Api::V1::ApiController
  
    before_action :set_attachment, except: [:index, :create]
    include UnderscoreizeParams
    before_action :override_current_dealer, only: [:index, :create], if: :dealer?
    before_action :override_current_admin, only: [:index, :create], if: :admin?


    # GET        /api/v1/lease_application_attachments
    def index
      params.require(:lease_application_id)
      # Reload Dealer
      dealer = Dealer.find(@current_dealer.id)

      resource = dealer.dealership.lease_applications.find(params[:lease_application_id])

      # TODO: Serialize?
      render json: {
        # TODO: Find a better way to get app identifier?
        # Hack to provide app identifier
        application_identifier: resource.application_identifier,
        attachments: resource.lease_application_attachments.limit(100).map do |attachment|
          {
            id: attachment.id,
            filename: attachment.upload.file&.filename,
            notes: attachment.notes,
            download_link: attachment.upload.url,
          }
        end
      }
    end

    # POST       /api/v1/lease_application_attachments
    def create
      params.require(:lease_application_id)
      params.require(:upload)

      if @current_dealer
        # Reload Dealer
        dealer = Dealer.find(@current_dealer.id)

        resource = dealer.dealership.lease_applications.find(params[:lease_application_id])
        attachment = get_attachment(@current_dealer, resource, create_attachments_dealer_params)

        if attachment.save
          DealerMailer.file_attachment_notification(attachment_id: attachment.id).deliver_later(wait: 1.minute)
          Notification.create_for_admins(
            notification_mode: 'InApp',
            notification_content: 'lease_attachment_added',
            notifiable: resource
          )

          render json: { message: "Attachment added" }
        else
          render json: { message: "Could not add attachment. #{attachment.errors.full_messages.to_sentence}" }, status: 500
        end
      end

      if @current_admin

        resource = LeaseApplication.find(params[:lease_application_id])
        attachment = get_attachment(@current_admin, resource, create_attachments_admin_params)

        if attachment.save
          render json: { message: "Attachment added"}
        else
          render json: { message: "Could not add attachment. #{attachment.errors.full_messages.to_sentence}" }, status: 500
        end
      end
    end

    def toggle_visibility
        if @attachment.toggle!(:visible_to_dealers)
            render json: {message: "Visibility sucessfully Updated"}
        else
            render json: {message: @attachment.errors.full_messages}, status: 500
        end
    end
    
    def mail_attachment_to_dealership
        begin
          MailToDealershipJob.perform_later(@attachment.id)
          render json: {message: "The attachment will now be sent to the dealership"}
        rescue => exception
          render json: {message: "Error processing Email"}, status: 500 
        end
    end

    def update 
      if @attachment.update!(attachments_params)

        ActiveRecord::Base.transaction do

          if (@attachment.file_attachment_type_ids != file_attachment_type_ids_params[:file_attachment_type_ids]) && !file_attachment_type_ids_params[:file_attachment_type_ids].nil?
            @attachment.lease_application_attachment_meta_data.all.delete_all
            file_attachment_type_ids_params[:file_attachment_type_ids].each do |id|
              @attachment.lease_application_attachment_meta_data.create(
                  lease_application: @attachment.lease_application, 
                  file_attachment_type_id: id
              )
            end
          end
          
          unless file_attachment_type_ids_params[:file_attachment_type_ids].include?(FileAttachmentType.income_verification.id)
            @attachment.income_verification_attachments.all.delete_all
          end
          
          if (@attachment.income_verification_attachment_ids != income_verification_attachment_ids_params[:income_verification_attachment_ids]) && !income_verification_attachment_ids_params[:income_verification_attachment_ids].nil?
            @attachment.income_verification_attachments.all.delete_all
            income_verification_attachment_ids_params[:income_verification_attachment_ids].each do |id|
              @attachment.income_verification_attachments.create(
                  income_verification_id: id
              )
            end
          end

        end

        render json: {message: "Attachment updated sucessfully"}
      else
        Rails.logger.info(@attachment.errors.full_messages)
        render json: {message: @attachment.errors.full_messages}, status: 500
      end
    end

    def destroy
      @attachment.destroy
    end
    
    private 

    def dealer?
      current_user.class.eql?(Dealer)
    end

    def admin?
      current_user.class.eql?(AdminUser)
    end
  
    def set_attachment
      @attachment = LeaseApplicationAttachment.find(params[:id])
    end

    def create_attachments_dealer_params
      params.permit(:upload, :description, :notes)
    end

    def create_attachments_admin_params
      params.permit(:upload, :description, :notes, :lease_application_id, :visible_to_dealers)
    end

    def attachments_params
      params.require(:lease_application_attachment).permit(:description)
    end

    def file_attachment_type_ids_params
      params.permit(file_attachment_type_ids: [])
    end

    def income_verification_attachment_ids_params
      params.permit(income_verification_attachment_ids: [])
    end

    def override_current_dealer
      # `current_user`: Inherited from Api::V1::ApiController
      if current_user.class.eql?(Dealer)
        @current_dealer = current_user
      else
        return render json: { message: "Actions only allowed to Dealer" }, status: :unauthorized
      end
    end

    def override_current_admin
      # `current_user`: Inherited from Api::V1::ApiController
      if current_user.class.eql?(AdminUser)
        @current_admin = current_user
      else
        return render json: { message: "Actions only allowed to Admin" }, status: :unauthorized
      end
    end

    def get_attachment(user, resource, params)
      attachment = resource.lease_application_attachments.new(params)
      attachment.uploader = user
      attachment
    end
end