class AddMaximumTermLengthPerYearInModelGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :model_groups, :maximum_term_length_per_year, :jsonb
  end
end
