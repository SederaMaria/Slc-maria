module Pages
  module LeasingCalculators
    class EditPage < SitePrism::Page
      set_url '/dealers/lease_calculators{/id}/edit'

      element :body, 'body'
      element :state, "select[name='lease_calculator[us_state]']"
      element :tax_jurisdiction, "select[name='lease_calculator[tax_jurisdiction]']"
      element :credit_tier, "select[name='lease_calculator[credit_tier]']"

      element :make, "select[name='lease_calculator[asset_make]']"
      element :year, "select[name='lease_calculator[asset_year]']"
      element :model, "select[name='lease_calculator[asset_model]']"
      element :mileage_range, "select[name='lease_calculator[mileage_tier]']"

      element :pre_tax_payment, "input[name='lease_calculator[base_monthly_payment]']"
      element :plus_sales_taxes, "input[name='lease_calculator[monthly_sales_tax]']"
      elements :total_payment, "input[name='lease_calculator[total_monthly_payment]']"

      element :nada_retail_value, "input[name='lease_calculator[nada_retail_value]']"
      element :customer_purchase_option, "input[name='lease_calculator[customer_purchase_option]']"

      element :frontend_max_advance, "input[name='lease_calculator[frontend_max_advance]']"
      element :backend_max_advance, "input[name='lease_calculator[backend_max_advance]']"

      elements :bike_sale_price, "input[name='lease_calculator[dealer_sales_price]']"
      elements :freight_fee, "input[name='lease_calculator[dealer_freight_and_setup]']"
      elements :documentation_fee, "input[name='lease_calculator[dealer_documentation_fee]']"
      elements :title, "input[name='lease_calculator[title_license_and_lien_fee]']"
      elements :upfront_tax, "#lease_calculator_upfront_tax"

      elements :gap_insurance, "input[name='lease_calculator[guaranteed_auto_protection_cost]']"
      elements :prepaid_maintenance, "input[name='lease_calculator[prepaid_maintenance_cost]']"
      elements :extended_service_contract, "input[name='lease_calculator[extended_service_contract_cost]']"
      elements :tire_warranty, "input[name='lease_calculator[tire_and_wheel_contract_cost]']"
      elements :gps_cost, "input[name='lease_calculator[gps_cost]']"

      element :acquisition_fee, "input[name='lease_calculator[acquisition_fee]']"
      element :servicing_fee, "input[name='lease_calculator[servicing_fee]']"
      element :security_deposit, "input[name='lease_calculator[refundable_security_deposit]']"
      element :first_payment, "input[name='lease_calculator[total_monthly_payment]']"

      element :gross_trade_in_allowance, "input[name='lease_calculator[gross_trade_in_allowance]']"
      element :trade_in_payoff, "input[name='lease_calculator[trade_in_payoff]']"
      element :net_trade_in_allowance, "input[name='lease_calculator[net_trade_in_allowance]']"

      elements :cash_down_payment, "input[name='lease_calculator[cash_down_payment]']"

      element :term, "input[name='lease_calculator[term]']"
      element :rate_markup, "select[name='lease_calculator[dealer_participation_markup]']"
      elements :dealer_reserve, "input[name='lease_calculator[dealer_reserve]']"

      elements :total_sales_price, "input[name='lease_calculator[total_sales_price]']"
      element :remit_to_dealer, "input[name='lease_calculator[remit_to_dealer]']"
      elements :net_trade_in_allowance, "input[name='lease_calculator[net_trade_in_allowance]']"
      element :total_cash_at_signing, "input.row-one-cash-at-signing"

      element :save_button, "input[name='commit']"

      element :errors, 'ul.errors'

      def submit_form
        execute_script 'window.scrollBy(0,5000)'
        save_button.click
      end

      def set_hidden_field(field_css, val)
        execute_script("$('#{field_css} input').val('#{val}')")
      end
    end
  end
end
