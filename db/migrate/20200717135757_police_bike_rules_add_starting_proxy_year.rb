class PoliceBikeRulesAddStartingProxyYear < ActiveRecord::Migration[5.1]
  def change
    add_column :police_bike_rules, :starting_proxy_year, :integer, default: 2017, null: false
  end
end
