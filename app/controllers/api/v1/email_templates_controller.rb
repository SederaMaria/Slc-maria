class Api::V1::EmailTemplatesController < Api::V1::ApiController
  skip_before_action :verify_authenticity_token
  before_action :set_email_temaplte

  def get_details
    if @email_template
      render json: serializer.new(@email_template).as_json
    else
      render json: {message: "Email template not found."}, status: :not_found
    end
  end

  def update
    if @email_template.update(email_template_params)
      render json: {message: "Email Template updated sucessfully"}
    else
      render json: {message: @email_template.errors.full_messages}, status: 500
    end
  end


  private

  def model
      ::EmailTemplate
  end 

  def set_email_temaplte
      @email_template = model.find_by(name: email_template_params[:name])
  end

  def serializer
      ::EmailTemplateSerializer
  end

  def email_template_params
    params.permit(:id, :template, :enable_template, :name)
  end
end