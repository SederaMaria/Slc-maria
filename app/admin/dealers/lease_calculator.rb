ActiveAdmin.register LeaseCalculator, namespace: :dealers do
  menu false
  actions :all, except: [:index, :destroy, :create]
  before_action :prevent_updating_locked_calculator, only: [:update]
  before_action :load_application_settings
  
  config.action_items.delete_if { |item| item.display_on?(:show) }

  breadcrumb { |b| [] }

  permit_params :asset_make, :asset_model, :asset_year, :condition, :mileage_tier,
                :credit_tier_id, :term, :tax_jurisdiction, :us_state, :nada_retail_value,
                :customer_purchase_option, :dealer_sales_price, :dealer_freight_and_setup,
                :total_dealer_price, :upfront_tax, :title_license_and_lien_fee, :dealer_documentation_fee,
                :guaranteed_auto_protection_cost, :prepaid_maintenance_cost, :extended_service_contract_cost,
                :tire_and_wheel_contract_cost, :fi_maximum_total, :total_sales_price, :gross_trade_in_allowance,
                :trade_in_payoff, :net_trade_in_allowance, :rebates_and_noncash_credits,
                :cash_down_payment, :cash_down_minimum, :acquisition_fee, :adjusted_capitalized_cost,
                :base_monthly_payment, :monthly_sales_tax, :total_monthly_payment, :refundable_security_deposit,
                :total_cash_at_signing, :minimum_reserve, :dealer_participation_markup,
                :dealer_reserve, :monthly_depreciation_charge, :monthly_lease_charge,
                :trade_and_down_payment_total, :cod_on_lease, :remit_to_dealer, :servicing_fee,
                :backend_max_advance, :frontend_max_advance, :ga_tavt_value, :acc_less_fi_less_af,
                :gps_cost, :gross_capitalized_cost

  decorate_with LeaseCalculatorDecorator

  form do |f| #must use a block to get locals support
    f.render partial: "lease_calculators/form", locals: { namespace: :dealers }
  end

  scope_to do
    current_dealer.dealership
  end

  action_item(:lease_application, only: %i(show edit)) do
    link_to 'Open Lease Application', resource.lease_application.credit_status.eql?('unsubmitted') ? edit_dealers_lease_application_path(resource.lease_application.id) : dealers_lease_application_path(resource.lease_application.id)
  end

  action_item(:hide_dealer_info, only: %i(show edit)) do
    link_to 'Hide/Show Dealer Info', '#', id: 'hide_dealer_info_button' #has click handler in calculator.js.coffee
  end

  action_item(:amortization_schedule, only: [:edit, :show]) do
    function_attr = params['action'] == 'show' ? '' : 'amortization-remote'
    link_to("Amortization Schedule", amortization_schedule_dealers_lease_calculator_path(resource), target: '_blank', data: { function: function_attr }) if AmortizationSchedule.new(
      lease_calculator:   resource,
      credit_tier_record: resource.credit_tier_v2,
    ).can_generate?
  end

  action_item(:order_gps, only: %i(show edit)) do
    link_to 'Order GPS', 'https://secure.passtimeusa.com/onlineordering/codesite/SpeedLeasing.aspx?otag=SLF', target: '_blank', class: 'button special' , id: 'order_gps' #has click handler in calculator.js.coffee
  end

  action_item(:print_amortization_schedule, only: [:amortization_schedule]) do
    link_to 'Print Payment Schedule', 'your_link_here', :onclick => 'window.print();return false;'
  end

  member_action :amortization_schedule, method: :get, title: 'Payment Schedule' do
    lease_calculator = resource.object
    @data            = AmortizationSchedule.new(
      lease_calculator:   lease_calculator,
      credit_tier_record: lease_calculator.credit_tier_v2,
    )
    @data.create_amortization_schedule
    render 'lease_calculators/amortization_schedule', layout: 'active_admin'
  end

  member_action :preview do
    @lease_calculator = resource
    redirect_to edit_dealers_lease_calculator_path unless resource.lease_application.bike_change_requested?
    @page_title   = 'Edit Lease Calculator'
    @preview_mode = true
  end

  collection_action :cash_out_of_pocket_helper do 
    render 'lease_calculators/cash_out_of_pocket_helper' , layout: false
  end

  controller do
    before_action :disallow_after_submission, only: [:edit, :update]

    def permitted_params
      params.permit!
    end

    def new
      @lease_application = LeaseApplication.create(dealership_id: current_dealer.dealership_id, dealer: current_dealer)
      redirect_to [:edit, :dealers, @lease_application.load_or_create_lease_calculator]
    end

    def show
      @lease_calculator = LeaseCalculator.find(params[:id])
      @preview_mode     = true
      @page_title       = @lease_calculator.display_name
      render layout: "active_admin"
    end

    def edit
      gon.sum_of_payments_states   = UsState.sum_of_payments_states
      gon.dealership_default_state = States.name_from(abbreviation: current_dealer.dealership.state)

      @page_title = resource.decorate.page_title
      if resource.lease_application.expired?
        redirect_to dealers_root_path, alert: 'This deal has been expired' and return
      elsif resource.lease_application.bike_change_requested?
        redirect_to preview_dealers_lease_calculator_path and return
      end


      ga = UsState.where(name: "georgia")[0]
      @label_text   = ga.tax_jurisdiction_type.name
      @hyperlink    = nil
      @is_ga_custom = false
      if ga.tax_jurisdiction_type.name == 'Custom'
        @is_ga_custom = true
        @label_text   = "GA TAVT Value"
        @hyperlink    = "https://onlinemvd.dor.ga.gov/tap/Option1.aspx#message"
        unless ga.hyperlink.nil?
          @hyperlink  = ga.hyperlink
          @label_text = ga.label_text
        end
      end
    end

    def update
      update! do |success, failure|
        success.html { redirect_to edit_dealers_lease_calculator_path(resource) }
      end
    end

    private

      def load_application_settings
        @setting = CommonApplicationSetting.first
      end

      def prevent_updating_locked_calculator
        if resource.locked?
          if request.xhr?
            render json: { error: 'calculator_locked' }, status: :unprocessable_entity and return
          else
            redirect_to(resource_path, alert: 'Unable to update. Lease Calculator is locked.') and return
          end
        end
      end

    def disallow_after_submission
      if resource.lease_application.submitted?
        redirect_to dealers_lease_applications_path, alert: 'This action cannot be completed after deal has been submitted.' and return
      end
    end
  end
end

