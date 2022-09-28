module Pages
  module LeasingCalculators
    class NewPage < SitePrism::Page
      set_url '/dealers/lease_calculators/new'

      element :body, 'body'
      element :state, "select[name='lease_calculator[us_state]']"
      element :tax_jurisdiction, "select[name='lease_calculator[tax_jurisdiction]']", visible: false
      element :ga_tavt_value, "input[name='lease_calculator[ga_tavt_value]']"
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

      element :term_60, "#lease_calculator_term_60"
      element :term_48, "#lease_calculator_term_48"
      element :term_36, "#lease_calculator_term_36"
      element :term_24, "#lease_calculator_term_24"

      element :rate_markup, "select[name='lease_calculator[dealer_participation_markup]']"
      elements :dealer_reserve, "input[name='lease_calculator[dealer_reserve]']"

      elements :total_sales_price, "input[name='lease_calculator[total_sales_price]']"
      element :remit_to_dealer, "input[name='lease_calculator[remit_to_dealer]']"
      elements :net_trade_in_allowance, "input[name='lease_calculator[net_trade_in_allowance]']"
      element :total_cash_at_signing, "input.row-one-cash-at-signing"

      element :errors, 'ul.errors'

      def initialize(values)
        @values = values
      end

      attr_reader :values

      def force_refresh_calculations
        el = bike_sale_price.first
        el.set el.value.match(/\d+/).to_s
        body.click
      end

      def select_state
        state.select values[:state]
      end

      def select_texas
        state.select 'Texas'
      end

      def select_credit_tier
        credit_tier.select values[:credit_tier]
      end

      def select_year
        year.select values[:year]
      end

      def select_leasing_term(term)
        send("term_#{term}").click
      end

      def select_model
        model.select values[:model]
      end

      def select_mileage_range
        mileage_range.select values[:mileage_range]
      end

      def fill_dealer_sales_price
        bike_sale_price.first.set values[:bike_sale_price]
        body.click
      end

      def fill_prep_price
        freight_fee.first.set values[:freight_fee]
        body.click
      end

      def fill_ga_tavt_value
        ga_tavt_value.set values[:ga_tavt_value]
        body.click
      end

      def fill_documentation_fee
        documentation_fee.first.set values[:documentation_fee]
        body.click
      end

      def fill_title_reg
        title.first.set values[:title_license_and_lien_fee]
        body.click
      end

      def fill_gap_insurance
        gap_insurance.first.set values[:gap_insurance]
        body.click
      end

      def fill_prepaid_maintenance
        prepaid_maintenance.first.set values[:prepaid_maintenance_cost]
        body.click
      end

      def fill_extended_service_cost
        extended_service_contract .first.set values[:extended_service_contract_cost]
        body.click
      end

      def fill_tire_warranty_cost
        tire_warranty.first.set values[:tire_and_wheel_contract_cost]
        body.click
      end

      def fill_gps_cost
        gps_cost.first.set values[:gps_cost]
        body.click
      end

      def fill_gt_allowance
        gross_trade_in_allowance.set values[:gross_trade_in_allowance]
        body.click
      end

      def fill_trade_in_payoff
        trade_in_payoff.set values[:trade_in_payoff]
        body.click
      end

      def fill_cash_down
        cash_down_payment.first.set values[:cash_down_payment]
        body.click
      end

      def fill_bike_details
        select_state
        select_credit_tier
        select_year
        select_model
        select_mileage_range
        fill_dealer_sales_price
      end

      def fill_frontend_fees
        fill_prep_price
        fill_documentation_fee
        fill_title_reg
      end

      def fill_backend_fees
        fill_gap_insurance
        fill_prepaid_maintenance
        fill_extended_service_cost
        fill_tire_warranty_cost
        fill_gps_cost
      end

      def fill_invalid_backend_advance
        fill_bike_details
        fill_gap_insurance
      end
    end
  end
end
