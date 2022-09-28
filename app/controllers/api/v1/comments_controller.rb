class Api::V1::CommentsController < Api::V1::ApiController
  before_action :set_comment, only: :destroy
  skip_before_action :verify_authenticity_token

  NAMESPACE = 'admins'

  # For `:resource_name` on the URL pattern, this constant is used to map out equivalent model
  # Example: /api/v1/comments/x/lease-applications/1
  RESOURCE_LOOKUP = {
    'lease-applications': 'LeaseApplication',
    # 'key': 'ModelName',
  }

  NAMESPACE_LOOKUP = {
    'AdminUser' => 'admins',
    'Dealer' => 'dealers'
  }

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      render json: {
        message: 'Comment has been created successfully',
        comment: send_comment
       }, status: :created
    else
      render json: { errors: @comment.errors.messages }, status: :bad_request
    end
  end

  def destroy
    @comment.destroy
    render json: { message: 'Comment has been deleted successfully.' }, status: :ok
  end

  # POST       /api/v1/comments/x/:resource_name/:resource_id
  #
  # params [String] :commit Comment body
  def resource_create_comment
    resource = find_resource(params[:resource_name], params[:resource_id])
    record = comment.new(body: params[:commit], resource: resource, author: current_user, namespace: find_namespace)

    if record.save
      render json: record, each_serializer: ActiveAdminCommentSerializer
    else
      render json: { errors: record.errors.messages }, status: :bad_request
    end
  end

  private

  def permitted_params
    params.permit(:id, :body, :resource_id, :resource_type)
  end

  def set_comment
    @comment = comment.find_by(id: permitted_params[:id])
    render json: {message: "Comment not found."}, status: :not_found unless @comment.present?
  end

  def comment
    ::ActiveAdminComment
  end

  def comment_params
    permitted_params.merge(namespace: NAMESPACE)
  end

  def send_comment
    serializer.new(@comment).as_json
  end

  def serializer
    WelcomeCalls::CommentSerializer
  end

  # @param [String] resource_name Key to use for `RESOURCE_LOOKUP`
  # @param [Integer] resource_id Resource ID
  def find_resource(resource_name, resource_id)
    if class_name = RESOURCE_LOOKUP[resource_name.to_sym]
      class_name.constantize.find(resource_id)
    else
      raise ActiveRecord::RecordNotFound.new("Data not found!")
    end
  end

  def find_namespace
    NAMESPACE_LOOKUP[current_user.class.to_s]
  end
end
