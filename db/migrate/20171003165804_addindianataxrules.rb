class Addindianataxrules < ActiveRecord::Migration[5.0]
  def up
    in_state_rule = TaxRule.where(name: 'Indiana').first_or_create({
      sales_tax_percentage: 7.0,
      up_front_tax_percentage: 7.0,
      cash_down_tax_percentage: 0.0,
      rule_type: :state
    })

    TaxJurisdiction.where(name: 'Indiana').first_or_create({
      us_state: :indiana,
      state_tax_rule: in_state_rule,

    })
  end
end
