class AddingDummyBikesData < ActiveRecord::Migration[5.1]
  def change
# HARLEY-DAVIDSON 2009 FXCWIU ROCKER SOFTAIL LIMITED EDITION 6204002555
# HARLEY-DAVIDSON 2010 FXSTCU SOFTAIL CUSTOM CLASSIC 6204002554
  	 NadaDummyBike.create(:make=>"HARLEY-DAVIDSON",
        :year=>"2009",
        :model_group_name=>"FXCWIU",
        :bike_model_name=>"ROCKER SOFTAIL LIMITED EDITION",
        :nada_rough_cents=>"6204002555")

  	 NadaDummyBike.create(:make=>"HARLEY-DAVIDSON",
        :year=>"2010",
        :model_group_name=>"FXSTCU",
        :bike_model_name=>"SOFTAIL CUSTOM CLASSIC",
        :nada_rough_cents=>"6204002554")
  end
end
