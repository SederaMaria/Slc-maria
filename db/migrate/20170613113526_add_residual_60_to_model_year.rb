class AddResidual60ToModelYear < ActiveRecord::Migration[5.0]
  def change
     add_monetize :model_years, :residual_60
  end
end
