class AddDefaultValuesToAllThePlaces < ActiveRecord::Migration[5.0]
  def up
    change_column_default :model_groups, :participation_minimum, 0
    change_column_default :model_groups, :new_residual_factor_24_months, 0
    change_column_default :model_groups, :new_residual_factor_36_months, 0
    change_column_default :model_groups, :new_residual_factor_48_months, 0
    change_column_default :model_groups, :used_residual_reduction_factor, 0
    change_column_default :tax_rules, :sales_tax_percentage, 0
    change_column_default :tax_rules, :up_front_tax_percentage, 0
    change_column_default :tax_rules, :cash_down_tax_percentage, 0
    change_column_default :credit_tiers, :money_factor, 0
    change_column_default :credit_tiers, :irr_value, 0
  end

  def down
    change_column_default :model_groups, :participation_minimum, nil
    change_column_default :model_groups, :new_residual_factor_24_months, nil
    change_column_default :model_groups, :new_residual_factor_36_months, nil
    change_column_default :model_groups, :new_residual_factor_48_months, nil
    change_column_default :model_groups, :used_residual_reduction_factor, nil
    change_column_default :tax_rules, :sales_tax_percentage, nil
    change_column_default :tax_rules, :up_front_tax_percentage, nil
    change_column_default :tax_rules, :cash_down_tax_percentage, nil
    change_column_default :credit_tiers, :money_factor, nil
    change_column_default :credit_tiers, :irr_value, nil
  end
end