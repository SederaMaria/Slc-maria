# == Schema Information
#
# Table name: credit_report_repossessions
#
#  id               :bigint(8)        not null, primary key
#  date_filed       :string
#  year_filed       :integer
#  month_filed      :integer
#  creditor         :string
#  notes            :string
#  credit_report_id :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_credit_report_repossessions_on_credit_report_id  (credit_report_id)
#
class CreditReportRepossession < ApplicationRecord
  belongs_to :credit_report
end
