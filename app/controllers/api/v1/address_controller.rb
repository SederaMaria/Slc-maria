class Api::V1::AddressController < Api::V1::ApiController
  before_action :get_tax_details, only: [:find_city, :city_details]

  def index
    begin
      params[:state].present? ? find_state : find_county
      render json: { tax_detail: @tax_details, counties: @counties_names, cities: @cities }
    rescue => exception
      render json: {message: "Bad Request"}, status: 400
    end

  end

  def find_city
    if @state.present? && @city.present? && @county.present?
      lease_application_states = UsState::LEASE_APPLICATION_STATES.keys
      states_from_zip = @state.collect(&:abbreviation)
      is_state_valid = (states_from_zip - lease_application_states).empty?
      all_county_names = YAML.load_file("config/county_names.yml")
      county_names = is_state_valid ? @county.collect(&:name) : all_county_names
      render json: { state: lease_application_states,
                     state_from_zip: states_from_zip,
                     city: @city.pluck(:name, :id), 
                     county: county_names,
                     is_state_active_on_calculator: @state.first.try(:active_on_calculator) }
    elsif @city.present?
      render json: {  city: @city.pluck(:name, :id) }
    else
      county_names = YAML.load_file("config/county_names.yml")
      render json: { city: [],
                     state: UsState::LEASE_APPLICATION_STATES.keys,
                     state_from_zip: [],
                     county: county_names,
                     is_state_active_on_calculator: true }
    end
  end

  def city_details
    if @state.present? && @city.present? && @county.present?
      render :json => { 
        :state => @state.collect { |s| {
          id: s.id, 
          abbreviation: s.abbreviation
        } },
        :county => @county.collect { |c| { 
          id: c.id, 
          name: c.name
        } },
        :city => @city.collect { |c| { 
          id: c.id, 
          name: c.name, 
          countyId: c.county_id
        } },
        is_state_active_on_calculator: @state.first.try(:active_on_calculator) 
      }, key_transform: :camel_lower
    elsif @city.present?
      render json: {  city: @city.pluck(:name, :id) }
    else 
      render json: { city: [], state: "", }
    end
  end

  private

    def contact_params
      params.require(:address).permit
    end

    def find_state
      @state = params[:state][:name].split("-")[1].try(:strip)
      us_state = UsState.find_by(name: @state)
      @counties = us_state.holding_counties
      @counties_names = @counties.collect(&:name)
      @tax_details = us_state.tax_detail
    end

    def find_county
      @county = params[:county][:name]
      us_county = County.find_by(name: @county.try(:upcase))
      @cities = us_county.cities.collect(&:name)
      @tax_details = us_county.tax_detail
    end

    def get_tax_details
      county_name = params[:county]
      state_name = params[:state]
      @zipcode = params[:zipcode]
      if @zipcode.length == 5 && county_name.present? && state_name.present?
        state = UsState.find_by(abbreviation: state_name)
        county = County.find_by(name: county_name, us_state_id: state.id) if state.present?
        @city = City.where("us_state_id = ? and county_id = ? and (?) between city_zip_begin and city_zip_end",
                           state.id, county.id, @zipcode) if state.present? && county.present?
        @city = get_cities(county_name) unless @city.present?
      elsif @zipcode.length == 5
        @city = City.where("(?) between city_zip_begin and city_zip_end", @zipcode) 
        @county = County.where('id in (?)', @city.collect(&:county_id))
        @state = UsState.where('id in (?)', @city.collect(&:us_state_id))
      end
    end

  def get_cities(county_name)
    county_objs = County.where(name: county_name)
    county_objs.map(&:cities).flatten.compact.uniq
  end
end
