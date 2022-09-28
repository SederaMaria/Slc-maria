class AddSlcmodelgroupToModelyear < ActiveRecord::Migration[5.1]
  def change
  	add_column :model_years, :slc_model_group_mapping_flag, :boolean, default: true
  end
end
