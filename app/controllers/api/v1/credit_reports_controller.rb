class Api::V1::CreditReportsController < Api::V1::ApiController
  # GET        /api/v1/credit-reports/:credit_report_id/details
  def details
    record = CreditReport.find(params[:credit_report_id])
    render json: record, serializer: CreditReportDetailSerializer
  end
end
