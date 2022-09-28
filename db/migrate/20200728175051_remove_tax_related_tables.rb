class RemoveTaxRelatedTables < ActiveRecord::Migration[5.1]
  def change
    drop_table(:vertex_statistics, force: true) if ActiveRecord::Base.connection.tables.include?('vertex_statistics')
    drop_table(:tax_details, force: true) if ActiveRecord::Base.connection.tables.include?('tax_details')
    drop_table(:vertex_statistic_lease_applications, force: true) if ActiveRecord::Base.connection.tables.include?('vertex_statistic_lease_applications')
    drop_table(:vertex_files, force: true) if ActiveRecord::Base.connection.tables.include?('vertex_files')
    drop_table(:vertex_extracts, force: true) if ActiveRecord::Base.connection.tables.include?('vertex_extracts')
  end
end
