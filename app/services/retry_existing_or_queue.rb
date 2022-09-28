class RetryExistingOrQueue
  attr_accessor :job, :args

  def initialize(job:, args: [])
    @job  = job
    @args = Array(args)
  end

  def self.perform_async(job:, args: [])
    new(job: job, args: args).perform_async
  end

  def perform_async
    has_enqueued_jobs? ? retry_jobs : enqueue_new_job
  end

  private

  def has_enqueued_jobs?
    matching_enqueued_jobs.any?
  end

  def matching_enqueued_jobs
    retry_queue = Sidekiq::RetrySet.new
    retry_queue.select do |enqueued_job|
      enqueued_job.item['class'] == job && enqueued_job.item['args'] == args
    end
  end

  def retry_jobs
    matching_enqueued_jobs.map(&:retry)
  end

  def enqueue_new_job
    job.constantize.perform_async(*args)
  end
end