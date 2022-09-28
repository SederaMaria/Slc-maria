
class Api::V1::EmploymentStatusController < Api::V1::ApiController

  def index
    render json: { employment_status: EmploymentStatus.all.map{ |e| [e.definition.humanize, e.employment_status_index] } }
  end

end
