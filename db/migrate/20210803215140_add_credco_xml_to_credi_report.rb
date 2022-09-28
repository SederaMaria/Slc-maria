class AddCredcoXmlToCrediReport < ActiveRecord::Migration[6.0]
  def change
    add_column :credit_reports, :credco_xml, :string
  end
end
