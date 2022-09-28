class AddMaximumTermLengthToModelYear < ActiveRecord::Migration[6.0]
  def change
    add_column :model_years, :maximum_term_length, :integer
  end
end
