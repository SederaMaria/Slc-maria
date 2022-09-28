class RunBlackboxService
  
  # @blackbox_job_opts (see BlackboxJob#perform)
    def initialize(lessee_id:, fetch_type: :finalize, request_type: :new, blackbox_job_opts: {}) #type :lessee, lessee_colessee
      @lessee    = Lessee.where(id: lessee_id).first
      @lease_application = @lessee.lease_application
      @fetch_type = fetch_type
      @request_type = request_type
      @blackbox_job_opts = blackbox_job_opts
    end
  

    def run_lessee_colessee
        create_recommened_blackbox_tier
        BlackboxJob.new.perform(lessee_id: @lease_application.lessee.id, fetch_type: @fetch_type, request_type: @request_type, **@blackbox_job_opts)
        BlackboxJob.new.perform(lessee_id: @lease_application.colessee.id, fetch_type: @fetch_type, request_type: @request_type, **@blackbox_job_opts) if @lease_application&.colessee&.present?
    end

    def run_lessee
        create_recommened_blackbox_tier unless @fetch_type == :finalize
        BlackboxJob.new.perform(lessee_id: @lessee.id, fetch_type: @fetch_type, request_type: @request_type, **@blackbox_job_opts)
    end


    private

    def create_recommened_blackbox_tier
        @lease_application.lease_application_recommended_blackbox_tiers.create!
    end

end
  