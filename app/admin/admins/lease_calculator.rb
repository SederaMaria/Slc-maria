# Route is broken. It returns a 404
ActiveAdmin.register LeaseCalculator, namespace: :admins do
  menu false
  actions :all, except: [:index, :destroy]
  before_action :prevent_updating_locked_calculator, only: [:update]
  before_action :load_application_settings

  decorate_with LeaseCalculatorDecorator

  action_item(:amortization_schedule, only: [:edit, :show]) do
    function_attr = params['action'] == 'show' ? '' : 'amortization-remote'
    link_to("Amortization Schedule", amortization_schedule_admins_lease_calculator_path(resource), target: '_blank', data: { function: function_attr }) if AmortizationSchedule.new(
      lease_calculator:   resource,
      credit_tier_record: resource.credit_tier_v2,
    ).can_generate?
  end

  action_item(:print_amortization_schedule, only: [:amortization_schedule]) do
    link_to 'Print Payment Schedule', 'your_link_here', :onclick => 'window.print();return false;'
  end

  action_item(:order_gps, only: %i(show edit)) do
    link_to 'Order GPS', 'https://secure.passtimeusa.com/onlineordering/codesite/SpeedLeasing.aspx?otag=SLF', target: '_blank', class: 'button special' , id: 'order_gps' #has click handler in calculator.js.coffee
  end

  member_action :amortization_schedule, method: :get, title: 'Payment Schedule' do
    lease_calculator = resource.object
    @data = AmortizationSchedule.new(
      lease_calculator: lease_calculator,
      credit_tier_record: lease_calculator.credit_tier_v2,
    )
    @data.create_amortization_schedule
    render 'lease_calculators/amortization_schedule', layout: 'active_admin'
  end

  member_action :override, method: :get do
    set_up_edit_calculator
    override_mode
    california_county_town
    render :edit, layout: false
  end

  collection_action :cash_out_of_pocket_helper do
      render 'lease_calculators/cash_out_of_pocket_helper' , layout: false
  end

  controller do
    def permitted_params
      params.permit!
    end

    def index
      redirect_to admins_root_path
    end

    def edit
      set_up_edit_calculator
      california_county_town
    end

    def set_up_edit_calculator
      gon.sum_of_payments_states = UsState.sum_of_payments_states
      @page_title                = resource.decorate.page_title

      ga = UsState.where(name: "georgia")[0]
      @label_text   = ga.tax_jurisdiction_type.name
      @hyperlink    = nil
      @is_ga_custom = false
      @is_tax_jurisdiction_label_with_dealership = tax_jurisdiction_label_with_dealership?
      @arizona_new_mexico_zip_code = arizona_new_mexico_zip_code
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

    def override_mode
      gon.override_mode = true
      @override_mode    = true
    end

    def tax_jurisdiction_label_with_dealership?
      dealership_state = resource.lease_application.dealership.state
      include_dealership_label = ['AZ', 'CA', 'NM'].include? dealership_state
      include_dealership_label
    end

    def arizona_new_mexico_zip_code
      dealership_state = resource.lease_application.dealership.state
      customer_state = States.abbreviation_for(name: resource.lease_application.lease_calculator.us_state)
      is_same_state = dealership_state == customer_state
      zip_code = is_same_state ? resource.lease_application.dealership.address.zipcode : resource.lease_application.lessee.home_address.zipcode
      zip_code
    end

    def california_county_town
      county = resource&.lessee&.home_address&.county
      town = resource&.lessee&.home_address&.new_city&.name
      if county && town
        @california_county_town = "#{county.titleize} - #{town.titleize}"
      else
        @california_county_town = ""
      end
    end

    private

    def load_application_settings
      @setting = CommonApplicationSetting.first
    end

    def prevent_updating_locked_calculator
      if resource.locked? && !override_mode?
        if request.xhr?
            render json: { error: 'calculator_locked' }, status: :unprocessable_entity and return
          else
            redirect_to(resource_path, alert: 'Unable to update. Lease Calculator is locked.') and return
        end
      end
    end

    def override_mode?
      params['override_mode'] == 'true'
    end
  end

  form do |f| #must use a block to get locals support
    f.render partial: "lease_calculators/form", locals: { namespace: :admins }
  end
end