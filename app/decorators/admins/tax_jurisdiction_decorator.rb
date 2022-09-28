class Admins::TaxJurisdictionDecorator < Draper::Decorator
  decorates :tax_jurisdiction

  delegate_all

  def total_sales_tax_percentage
    helpers.number_to_percentage(object.total_sales_tax_percentage, precision: 4)
  end
end
