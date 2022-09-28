require 'rails_helper'

RSpec.describe RetryExistingOrQueue do
  describe '#perform_async' do
    context 'Job already in queue' do
      before do
        stub_sidekiq_retry_queue
      end

      it 'retries the existing job available in the queue' do
        expect_any_instance_of(Sidekiq::SortedEntry).to receive(:retry)
        RetryExistingOrQueue.perform_async(job: 'CreditReportJob', args: 1)
      end

      it 'does not retry a job with different arguments' do
        expect_any_instance_of(Sidekiq::SortedEntry).not_to receive(:retry)
        expect(CreditReportJob).to receive(:perform_async).with(3)
        RetryExistingOrQueue.perform_async(job: 'CreditReportJob', args: 3)
      end
    end

    context 'Job not yet in queue' do
      it 'queues new job' do
        expect(CreditReportJob).to receive(:perform_async).with(1)
        RetryExistingOrQueue.perform_async(job: 'CreditReportJob', args: 1)
      end
    end
  end

  def stub_sidekiq_retry_queue
    allow(Sidekiq::RetrySet).to receive(:new).and_return([
      Sidekiq::SortedEntry.new('CreditReportJob', 'default_score', { 'queue' => 'default', 'args' => [1], 'class' => 'CreditReportJob' })
    ])
  end
end
