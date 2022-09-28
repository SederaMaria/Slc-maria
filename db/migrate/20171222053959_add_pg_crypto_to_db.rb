class AddPgCryptoToDb < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      CREATE extension IF NOT EXISTS pgcrypto;
    SQL
  end
end
