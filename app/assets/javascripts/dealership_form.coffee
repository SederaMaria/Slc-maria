class DealershipForm
  init: ->
    @initCredcoSettings()

  initCredcoSettings: ->
    @requireCheckedBeforeSubmit()
    @onlyAllowOneCheckbox()
    @check_experial_equifax()

  onlyAllowOneCheckbox: ->
    $('[data-function="require-one"]').on 'change', (e) =>
      $('[data-function="require-one"]').not(e.target).prop('checked', false)

  check_experial_equifax: ->
    $('#dealership_use_experian').prop('checked', true)
    $('#dealership_use_equifax').prop('checked', true)

  requireCheckedBeforeSubmit: ->
    $('form#new_dealership').on 'submit', (e) =>
      checkedCount = $('[data-function="require-one-ex-eq"]:checked').length
      if checkedCount < 1
        alert('Please select Experian or Equifax')
        return false

$(document).ready ->
  handler = new DealershipForm
  handler.init()

# Dealership Address
$(document).on "blur", "#dealership_address_attributes_zipcode", (e) ->
  zip_ele = document.getElementById("dealership_address_attributes_zipcode")
  county_ele = document.getElementById("dealership_address_attributes_county")
  state_ele = document.getElementById("dealership_address_attributes_state")
  city_ele = document.getElementById("dealership_address_attributes_city")
  populateCountyState(zip_ele, state_ele, county_ele, city_ele, 1)

# Populate City Dropdown based on County value
$(document).on "change", "#dealership_address_attributes_county", (e) ->
  zip_ele = document.getElementById("dealership_address_attributes_zipcode")
  county_ele = document.getElementById("dealership_address_attributes_county")
  state_ele = document.getElementById("dealership_address_attributes_state")
  city_ele = document.getElementById("dealership_address_attributes_city")
  value = $(this).val()
  
  if !value? || value == ''
    deletAllOptions(city_ele)
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 1)
  else
    populateCity(zip_ele, state_ele, county_ele, city_ele)

# Clear County value when City is cleared
$(document).on "change", "#dealership_address_attributes_city", (e) ->
  zip_ele = document.getElementById("dealership_address_attributes_zipcode")
  county_ele = document.getElementById("dealership_address_attributes_county")
  state_ele = document.getElementById("dealership_address_attributes_state")
  city_ele = document.getElementById("dealership_address_attributes_city")

  value = $(this).val()
  if !value? || value == ''
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 1)
    $(this).val('')
    
getTaxDetails = (zipcode) ->
  response= $.ajax
    type: 'GET'
    async: false
    data: zipcode: zipcode
    dataType: 'script'
    url: '/api/v1/address/find_city'

  return JSON.parse(response.responseText)

deletAllOptions = (element) ->
  select = element
  length = select.options.length
  i = 0
  while i <= length
    element.remove("option")
    i++

fillAddressElements = (values, elements) ->
  state  = values.state;
  county =   values.county;
  
  state_ele  = elements.state_ele;
  county_ele = elements.county_ele;

  county_ele.value  = county
  state_ele.value   = state

  # State Option
  state_length = state_ele.options;
  if state_length != undefined
    deletAllOptions(state_ele)

  i = 0
  while i < state.length
    state_opt = document.createElement('option')
    state_opt.innerHTML = state
    state_opt.value = state
    state_ele.appendChild state_opt
    i++

  # County Option
  county_length = county_ele.options;
  if county_length != undefined
    deletAllOptions(county_ele)

  i = 0
  while i < county.length
    opt = document.createElement('option')
    opt.innerHTML = county[i]
    opt.value = county[i]
    county_ele.appendChild opt
    i++

fillCityElements = (values, elements) ->
  cities  = values.cities;
  city_ele  = elements.city_ele;

  # City Option
  length = city_ele.options;
  if length != undefined
    deletAllOptions(city_ele)

  i = 0
  while i < cities.length
    opt = document.createElement('option')
    opt.innerHTML = cities[i]
    opt.value = cities[i]
    city_ele.appendChild opt
    i++
    
clearCountyInput = (element) ->
  element.value = ""

getCityDetails = (zipcode, state, county) ->
  response= $.ajax
    type: 'GET'
    async: false
    data: {
      zipcode: zipcode,
      state: state,
      county: county
    }
    dataType: 'script'
    url: '/api/v1/address/find_city'

  return JSON.parse(response.responseText)

populateCity = (zip_ele, state_ele, county_ele, city_ele) ->
  zipcode = zip_ele.value
  state = state_ele.value
  county = county_ele.value

  parsed_response = getCityDetails(zipcode, state, county)
  cities = parsed_response.city

  deletAllOptions(city_ele)

  elements = { city_ele: city_ele }
  values = { cities: cities }

  fillCityElements(values, elements)

populateCountyState = (zip_ele, state_ele, county_ele, city_ele, getTax) ->
  zipcode = zip_ele.value
  get_tax = getTax.value
  parsed_response = getTaxDetails(zipcode)

  state = parsed_response.state
  is_state_active_on_calculator = parsed_response.is_state_active_on_calculator
  cities = parsed_response.city
  county = parsed_response.county

  deletAllOptions(city_ele)

  if state.length > 0
    if is_state_active_on_calculator == true
      elements = { county_ele: county_ele, state_ele: state_ele }
      values = { county: county, state: state }

      fillAddressElements(values, elements)
      clearCountyInput(county_ele)
    else
      alert("No state found.")
      deletAllOptions(state_ele)
      deletAllOptions(city_ele)
      deletAllOptions(county_ele)
  else
    alert("Please apply a valid Zip Code.")
    deletAllOptions(state_ele)
    deletAllOptions(city_ele)
    deletAllOptions(county_ele)
