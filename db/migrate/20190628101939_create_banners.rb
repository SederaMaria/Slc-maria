class CreateBanners < ActiveRecord::Migration[5.1]
  def change
    create_table :banners do |t|
      t.string :headline
      t.string :message
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
