class PoliceBikesRules < ActiveRecord::Migration[5.1]
  def change
  	create_table :police_bike_rules do |t|
  		t.integer :proxy_model_make
  		t.string :proxy_model_name
  		t.integer :new_model_make
  		t.string :new_model_name
  		t.decimal :proxy_rough_value_percent, precision: 10, scale: 2
  		t.decimal :proxy_retail_value_percent, precision: 10, scale: 2
  		t.timestamps
  	end
  end
end