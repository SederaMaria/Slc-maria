class RemovePolymoprhicFromAddresses < ActiveRecord::Migration[5.0]
  def up
    remove_columns :addresses, :addressable_type, :addressable_id
  end

  def down
    change_table :addresses do |t|
      t.refrences :addressable, polymorphic: true, index: true
    end
  end
end
