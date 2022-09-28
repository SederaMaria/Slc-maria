class IncomeVerification < ApplicationRecord
  include SimpleAudit::Model
  simple_audit child: true
  include SimpleAudit::Custom::IncomeVerification

  belongs_to :lessee
  belongs_to :income_verification_type
  belongs_to :income_frequency
  belongs_to :lease_application_attachment
  belongs_to :created_by_admin, class_name: 'AdminUser', foreign_key: 'created_by_admin_id'
  belongs_to :updated_by_admin, class_name: 'AdminUser', foreign_key: 'updated_by_admin_id'
  has_many :income_verification_attachments
  enum income_type: { gross: 0, net: 1 }

  after_update :run_payment_limit_job
  after_create :run_payment_limit_job_30
  after_destroy :run_payment_limit_job


  #monetize all _cents fields with a couple of lines
  if table_exists? #fix issue with rake db:schema:load
    self.column_names.each { |col| monetize(col) if col.ends_with?('_cents') }
  end


  private

  def run_payment_limit_job
    PaymentLimitJob.perform_async(self&.lessee&.lease_application&.id)
  end

  def run_payment_limit_job_30
    PaymentLimitJob.perform_in(30.seconds, self&.lessee&.lease_application&.id)
  end
end
