class AutoMigrateLesseeSsns < ActiveRecord::Migration[5.1]
  def up
    if Rails.env.development?
      Rake::Task['db:clear_sensitive_fields'].invoke
    else
      Lessee.reset_column_information
      Rake::Task['lessee:migrate_to_cryptkeeper'].invoke
    end
  end
  def down
    Lessee.update_all(ssn: nil)
  end
end
