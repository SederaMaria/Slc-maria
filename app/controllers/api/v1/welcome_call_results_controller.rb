class Api::V1::WelcomeCallResultsController < Api::V1::ApiController

  def index
    authorize(current_user, 'WelcomeCall', 'get')
    @welcome_call_results = WelcomeCallResult.order('sort_index  asc')
  end

  def update_sort_order
    authorize(current_user, 'AdminUser', 'update')
    if params[:welcome_call_results].present?
      params[:welcome_call_results].each.with_index(1) do |welcome_call_result, index|
        WelcomeCallResult.update_sort_index(welcome_call_result, index)
      end
      render json: { message: 'Sort order updated successfully.' }
    else
      render json: { errors: [ { detail: 'Error updating sort order.' }]}, status: 401
    end
    rescue StandardError
    render json: { errors: [ { detail: 'Error updating sort order.' }]}, status: 401
  end


  def update_active_result
    authorize(current_user, 'AdminUser', 'update')
    if params[:id].present?
      @welcome_call_result = WelcomeCallResult.find(params[:id])
      if @welcome_call_result.update(active: params[:active])
        render :json => {
          :status => true, 
          :messages => "Update Successfull",
          :data => {
            :id => @welcome_call_result.id,
            :active => @welcome_call_result.active
          } 
        }
      end
    end
  end

  def update_description
    authorize(current_user, 'AdminUser', 'update')
    if params[:id].present?
      @welcome_call_result = WelcomeCallResult.find(params[:id])
      if @welcome_call_result.update(description: params[:description])
        render :json => {
          :status => true, 
          :messages => "Update Successfull",
          :data => {
            :id => @welcome_call_result.id,
            :description => @welcome_call_result.description
          } 
        }
      end
    end
  end

  def create
    authorize(current_user, 'AdminUser', 'create')
    if params[:welcome_call_result].present?
      if WelcomeCallResult.create(description: params[:welcome_call_result][:description])
        render json: { message: 'Welcome Call Result successfully created.' }
      else
        render json: { errors: [ { detail: 'Error creating Welcome Call Result.' }]}, status: 401
      end
    end
  end

end