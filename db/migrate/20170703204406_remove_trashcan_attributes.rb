class RemoveTrashcanAttributes < ActiveRecord::Migration[5.0]
  def change
    remove_columns :lease_calculators,
      :gross_capitalized_cost_cents,
      :total_capitalized_cost_reduction_cents,
      :net_due_on_motorcycle_cents,
      :cod_on_lease_cents
  end
end
