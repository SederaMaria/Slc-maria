# == Schema Information
#
# Table name: credit_report_bankruptcies
#
#  id                :bigint(8)        not null, primary key
#  date_filed        :string
#  year_filed        :integer
#  month_filed       :integer
#  bankruptcy_type   :string
#  bankruptcy_status :string
#  date_status       :string
#  credit_report_id  :bigint(8)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_credit_report_bankruptcies_on_credit_report_id  (credit_report_id)
#
require 'rails_helper'

RSpec.describe CreditReportBankruptcy, type: :model do
  it { should belong_to(:credit_report) }

  it 'creates correctly' do
    record = create(:credit_report_bankruptcy)
    expect(record).to be_valid
    expect(record).to be_persisted
  end
end
