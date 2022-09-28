class CreditTiersController < InheritedResources::Base

  def model_group_options
    model_groups = Make.find(params[:make_id]).model_groups.pluck(:id, :name)
    render json: {model_group_options: model_groups}, status: :ok
  end

end

