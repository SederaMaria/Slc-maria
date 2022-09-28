class Api::V1::WelcomeCallTypesController < Api::V1::ApiController
  
  def index
    authorize(current_user, 'WelcomeCall', 'get')
    @welcome_call_types = WelcomeCallType.order('sort_index  asc')
  end

  def update_sort_order
    authorize(current_user, 'AdminUser', 'update')
    if params[:welcome_call_types].present?
      params[:welcome_call_types].each.with_index(1) do |welcome_call_type, index|
        WelcomeCallType.update_sort_index(welcome_call_type, index)
      end
      render json: { message: 'Sort order updated successfully.' }
    else
      render json: { errors: [ { detail: 'Error updating sort order.' }]}, status: 401
    end
    rescue StandardError
    render json: { errors: [ { detail: 'Error updating sort order.' }]}, status: 401
  end
 
  def update_active_type
    authorize(current_user, 'AdminUser', 'update')
    if params[:id].present?
      @welcome_call_type = WelcomeCallType.find(params[:id])
      if @welcome_call_type.update(active: params[:active])
        render :json => {
          :status => true, 
          :messages => "Update Successfull",
          :data => {
            :id => @welcome_call_type.id,
            :active => @welcome_call_type.active
          } 
        }
      end
    end
  end

  def update_description
    authorize(current_user, 'AdminUser', 'update')
    if params[:id].present?
      @welcome_call_type = WelcomeCallType.find(params[:id])
      if @welcome_call_type.update(description: params[:description])
        render :json => {
          :status => true, 
          :messages => "Update Successfull",
          :data => {
            :id => @welcome_call_type.id,
            :description => @welcome_call_type.description
          } 
        }
      end
    end
  end

  def create
    authorize(current_user, 'AdminUser', 'create')
    if params[:welcome_call_type].present?
      if WelcomeCallType.create(description: params[:welcome_call_type][:description])
        render json: { message: 'Welcome Call Type successfully created.' }
      else
        render json: { errors: [ { detail: 'Error creating Welcome Call Type.' }]}, status: 401
      end
    end
  end

end