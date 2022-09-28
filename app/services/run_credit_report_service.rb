class RunCreditReportService
  
  # @crj_opts (see CreditReportJob#perform)
    def initialize(lessee_id:, request_type: :new, credit_report_job_opts: {}) #type :lessee, lessee_colessee
      @lessee    = Lessee.where(id: lessee_id).first
      @lease_application = @lessee.lease_application
      @retried_credit_report_id = nil
      @request_type = request_type
      @crj_opts = credit_report_job_opts
    end
  

    def run_lessee_colessee
        create_recommened_credit_tier
        CreditReportJob.perform_async(@lease_application.lessee.id, @retried_credit_report_id, @request_type, @crj_opts[:request_control], @crj_opts[:request_event_source])
        CreditReportJob.perform_async(@lease_application.colessee.id, @retried_credit_report_id, @request_type, @crj_opts[:request_control], @crj_opts[:request_event_source]) if @lease_application.colessee.id.present?
    end
    

    def run_lessee
        create_recommened_credit_tier
        CreditReportJob.perform_async(@lessee.id, @retried_credit_report_id, @request_type, @crj_opts[:request_control], @crj_opts[:request_event_source])
    end


    private

    def create_recommened_credit_tier
        @lease_application.lease_application_recommended_credit_tiers.create!
    end

end
  