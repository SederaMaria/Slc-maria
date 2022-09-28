class LesseesHaveAddresses < ActiveRecord::Migration[5.0]
  def change
    change_table :lessees do |t|
      t.references :home_address
      t.references :mailing_address
      t.references :employment_address
    end
  end
end
