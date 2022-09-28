class CreateEmailTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :email_templates do |t|
      t.string :template
      t.boolean :enable_template, default: true

      t.timestamps
    end
  end
end
