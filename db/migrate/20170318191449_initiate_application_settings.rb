class InitiateApplicationSettings < ActiveRecord::Migration[5.1]
  def up
    ApplicationSetting.reset_column_information
    ApplicationSetting.new.save(validate: false) #creates initial settings model
  end

  def down
    ApplicationSetting.new.destroy
  end
end
