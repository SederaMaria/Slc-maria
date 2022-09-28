class UpcaseAllStateStringFields < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      UPDATE addresses 
        SET state=upper(state),
            street1=upper(street1),
            street2=upper(street2),
            city=upper(city),
            county=upper(county)
    SQL

  end
end
