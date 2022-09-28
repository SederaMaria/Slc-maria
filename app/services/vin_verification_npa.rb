class VinVerificationNpa
  include ActiveModel::Validations
  
  attr_accessor :vin, :make, :model, :year, :response

  validates :vin, :model, :year, :make, presence: true
  # validates :vin,
  #   format: {
  #     with: ->(vin_verification_npa) { vin_format_regexp_for_make(vin_verification_npa.make) },
  #     allow_blank: true },
  #   if: ->(vin_verification_npa) { vin_verification_npa.make.present? }
  validates :vin, length: { is: 17, allow_blank: true } #Vins must be 17 characters long always

  def initialize(vin:, make:, model:, year:)
    @vin = vin.upcase
    @make = make
    @model = model
    @year = year.to_s #ensure year is a string
    get_value
  end

  def vin_matches_make_model_and_year?
    valid? && matches_make? && matches_model? && matches_year?
  end

  def matches_year?
    year == response_year.to_s
  end

  def matches_make?
    response_make&.upcase == make&.upcase
  end

  def matches_model?
    model&.upcase == "#{bike_model}"&.upcase
  end

  def response_year
    @response_year ||= @response.dig("GetValueGuide","Info", "VehicleYear")
  end

  def response_make
    @response_make ||= @response.dig("GetValueGuide","Info", "VehicleBrand")
  end

  def bike_model
    @bike_model ||= @response.dig("GetValueGuide","Info", "VehicleModel")
  end


  private
  def get_value
    begin
      @response ||= JSON.parse(RestClient::Request.execute(method: :post, url: "#{ENV['MORPHEUS_URL']}/api/v1/verify" , payload:  {vin: @vin})) 
    rescue => e
      @response ||= JSON.parse(e.response)
    end
  end


  # def self.vin_format_regexp_for_make(make_string)
  #   Regexp.new("^#{Make[make_string].try(:vin_starts_with)}", ignore_case: true)
  # end

end
