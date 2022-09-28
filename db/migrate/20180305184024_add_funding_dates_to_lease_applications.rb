class AddFundingDatesToLeaseApplications < ActiveRecord::Migration[5.1]
  def change
    change_table :lease_applications do |t|
      #Add Funding Delay Date, Funding Approved Date, and Funded Date to individual applications
      t.date :funding_delay_on
      t.date :funding_approved_on
      t.date :funded_on
    end
  end
end
