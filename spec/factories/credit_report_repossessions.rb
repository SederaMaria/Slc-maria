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
FactoryBot.define do
  factory :credit_report_repossession do
    date_filed { "Aug-2017" }
    year_filed { 2017 }
    month_filed { 8 }
    creditor { "AFSCI" }
    notes { nil }

    credit_report
  end
end
