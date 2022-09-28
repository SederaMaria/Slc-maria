class Addgeorgiarulesautomatically < ActiveRecord::Migration[5.0]
  def up
    ga_state_rule = TaxRule.where(name: 'Georgia').first_or_create({
      sales_tax_percentage: 0.00,
      up_front_tax_percentage: 7.0,
      cash_down_tax_percentage: 0.00,
      rule_type: :state
    })

    TaxJurisdiction.where(name: 'State of Georgia TAVT').first_or_create({
      us_state: :georgia,
      state_tax_rule: ga_state_rule,
    })
  end
end
