class UpcaseAllStateFields < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.connection.execute 'UPDATE addresses SET state=upper(state);'
  end

  def down
    #no-op
  end
end
