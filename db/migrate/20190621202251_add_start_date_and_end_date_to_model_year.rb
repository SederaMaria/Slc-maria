class AddStartDateAndEndDateToModelYear < ActiveRecord::Migration[5.1]
  def change
    add_column :model_years, :start_date, :date, default: "2019-05-01 00:00:00"
    add_column :model_years, :end_date, :date, default: "2999-12-31 00:00:00"
  end
end
