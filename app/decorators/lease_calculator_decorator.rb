class LeaseCalculatorDecorator < Draper::Decorator
  decorates :lease_calculator
  delegate_all

  def vehicle_display_name
    "#{asset_make} #{asset_model} #{asset_year}".squish!
  end

  def page_title
    page_title = "Edit Lease Calculator"
    lease_app = self.lease_application
    if lease_app&.lessee_first_name.present?
      page_title + " for #{lease_app.lessee_first_name} #{lease_app.lessee_last_name}"
    end
  end

  def cumulative_haircut
    LeaseRecalculator.new(lease_calculator: object).maximum_frontend_advance_haircut
  end
end
