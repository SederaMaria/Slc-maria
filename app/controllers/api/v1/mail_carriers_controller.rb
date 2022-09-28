class Api::V1::MailCarriersController < Api::V1::ApiController

  def index
    @mail_carriers = MailCarrier.order('sort_index  asc')
  end

  def update_sort_order
    authorize(current_user, 'AdminUser', 'update')
    if params[:mail_carriers].present?
      params[:mail_carriers].each.with_index(1) do |mail_carrier, index|
        MailCarrier.update_sort_index(mail_carrier, index)
      end
      render json: { message: 'Sort order updated successfully.' }
    else
      render json: { errors: [ { detail: 'Error updating sort order.' }]}, status: 401
    end
  end


  def update_active_mail_carriers
    authorize(current_user, 'AdminUser', 'update')
    if params[:id].present?
      @mail_carrier = MailCarrier.find(params[:id])
      if @mail_carrier.update(active: params[:active])
        render :json => {
          :status => true, 
          :messages => "Update Successfull",
          :data => {
            :id => @mail_carrier.id,
            :active => @mail_carrier.active
          } 
        }
      end
    end
  end

  def update_description
    authorize(current_user, 'AdminUser', 'update')
    if params[:id].present?
      @mail_carrier = MailCarrier.find(params[:id])
      if @mail_carrier.update(description: params[:description])
        render :json => {
          :status => true, 
          :messages => "Update Successfull",
          :data => {
            :id => @mail_carrier.id,
            :description => @mail_carrier.description
          } 
        }
      end
    end
  end

  def create
    if params[:mail_carrier].present?
      if MailCarrier.create(description: params[:mail_carrier][:description], active: true)
        render json: { message: 'Mail Carrier successfully created.' }
      else
        render json: { errors: [ { detail: 'Error creating Mail Carrier.' }]}, status: 401
      end
    end
  end

end