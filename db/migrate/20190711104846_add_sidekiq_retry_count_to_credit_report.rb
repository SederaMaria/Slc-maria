class AddSidekiqRetryCountToCreditReport < ActiveRecord::Migration[5.1]
  def change
    add_column :credit_reports, :sidekiq_retry_count, :integer, default: 0
  end
end
