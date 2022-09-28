class LeaseApplication
  onLeaseApplication: ->
    $('form.lease_application').length

  setup: ->
    $(document).on 'ready page:load turbolinks:load', ->
      select2Focus = ->
        $(this).closest('.select2').prev('select').select2 'open'

      $('.select2-input').next('.select2').find('.select2-selection').one('focus', select2Focus).on 'blur', ->
        $(this).one 'focus', select2Focus

      $(document).on 'keydown', '.select2-search', (e) ->
        code = (e.keyCode || e.which)
        if (code == 9)
          $targetSelectID = $(e.currentTarget).next().find('ul').attr('id')
          $targetSelectID = $targetSelectID.replace('select2-', '').replace('-results', '')
          $('#' + $targetSelectID).closest('.state-select').next().find('input').trigger('focus')

$(document).ready ->
  leaseApplication = new LeaseApplication
  if leaseApplication.onLeaseApplication()
    leaseApplication.setup()
    set_vehicle_possession()

  input = $("<input>").attr("type", "hidden").attr("name", "save_submit").attr("id", "save_submit").val(true);
  $('form.lease_application').append(input);

  $('#save-lease-application-btn-form').on 'click', (e) =>
    e.preventDefault();
    $('#save_submit').val(false);
    $('form.lease_application').submit()

  $('#submit-lease-application-btn-from').on 'click', (e) =>
    e.preventDefault();
    $('#save_submit').val(true);
    $('form.lease_application').submit()

  $('form.lease_application').on 'submit', (e) =>
    add_colessee_form = $('form.lease_application').hasClass('add-colessee-form')
    lessee_home = document.getElementById("lease_application_lessee_attributes_home_address_attributes_street1")
    colessee_home = document.getElementById("lease_application_colessee_attributes_home_address_attributes_street1")
    new_used = document.getElementById("lease_application_lease_calculator_attributes_new_used");
    make = document.getElementById("lease_application_lease_calculator_attributes_asset_make");
    years = document.getElementById("lease_application_lease_calculator_attributes_asset_year");
    model = document.getElementById("lease_application_lease_calculator_attributes_asset_model");
    mileage_tier = document.getElementById("lease_application_lease_calculator_attributes_mileage_tier");
    relationship_to_lessee = document.getElementById("lease_application_colessee_attributes_lessee_and_colessee_relationship");
    lessee_first_name = document.getElementById("lease_application_lessee_attributes_first_name");
    lessee_last_name = document.getElementById("lease_application_lessee_attributes_last_name");
    colessee_first_name = document.getElementById("lease_application_colessee_attributes_first_name");
    colessee_last_name = document.getElementById("lease_application_colessee_attributes_last_name")
    colessee_middle_name = document.getElementById("lease_application_colessee_attributes_middle_name")
    save_submit = document.getElementById("save_submit");
    save_submit_value = (save_submit.value.toLowerCase() == 'true')

    vehicle_submitted = true
    # return false
    if (save_submit_value) 
      if (new_used.value == '' || new_used.value == null)
        $('.new-used-not-found').show()
        vehicle_submitted = false
      else
        $('.new-used-not-found').hide()

      if (make.value == '' || make.value == null)
        $('.make-not-found').show()
        vehicle_submitted = false
      else
        $('.make-not-found').hide()

      if (years.value == '' || isNaN(years.value))
        $('.year-not-found').show()
        vehicle_submitted = false
      else
        $('.year-not-found').hide()

      if (model.value == '' || model.value == null)
        $('.model-not-found').show()
        vehicle_submitted = false
      else
        $('.model-not-found').hide()

      if (mileage_tier.value == '' || mileage_tier.value == null)
        $('.mileage-not-found').show()
        vehicle_submitted = false
      else
        $('.mileage-not-found').hide()
      
    else
      $('.new-used-not-found').hide()
      $('.make-not-found').hide()
      $('.year-not-found').hide()
      $('.model-not-found').hide()
      $('.mileage-not-found').hide()


    if (colessee_first_name.value || colessee_last_name.value || colessee_middle_name.value)
      if (relationship_to_lessee.value == '' || relationship_to_lessee.value == null)
        $('.relation-not-found').show()
        vehicle_submitted = false
      else
        $('.relation-not-found').hide()
    else
      $('.relation-not-found').hide()     

    if (!save_submit_value)
      if (lessee_first_name.value == '' || lessee_first_name.value == null)
        $('.lessee-firstname-not-found').show()
        lessee_first_name.focus()
        lessee_first_name.style.border = "1px red solid"
        vehicle_submitted = false
      else
        lessee_first_name.style.border = "1px #c9d0d6 solid"
    else

      lessee_first_name.style.border = "1px #c9d0d6 solid"


    if (!save_submit_value)
      if (lessee_last_name.value == '' || lessee_last_name.value == null)
        $('.lessee-lastname-not-found').show()
        lessee_last_name.focus()
        lessee_last_name.style.border = "1px red solid"
        vehicle_submitted = false
      else
        lessee_last_name.style.border = "1px #c9d0d6 solid"
    else
      lessee_last_name.style.border = "1px #c9d0d6 solid"
    
    if !vehicle_submitted
      return false

    patt = /(P.?O.? ?BOX)/gi
    if (lessee_home != null) || (colessee_home != null)
      lessee_result = lessee_home.value.match(patt) if lessee_home != null
      colessee_result = colessee_home.value.match(patt)
      if lessee_result?
        alert("Physical Address is required. You may enter the PO Box in the Mailing Address section.")
        lessee_home.focus()
        return false
      if colessee_result?
        alert("Physical Address is required. You may enter the PO Box in the Mailing Address section.")
        colessee_home.focus()
        return false
    if add_colessee_form
      primary_lessee_elem = document.getElementById("lease_application_vehicle_possession_primary_lessee");
      colessee_elem = document.getElementById("lease_application_vehicle_possession_colessee");
      if ( !primary_lessee_elem.checked && !colessee_elem.checked)
        alert("Please update who will have possession of the bike.")
        primary_lessee_elem.focus()
        return false
    $(".override-address-input").each ->
      $(this).removeAttr("disabled")

  onSelectYear()
  $('#new_lease_document_request').on 'submit', (e) ->
    bank_name = document.getElementById("lease_document_request_lease_application_payment_bank_name").value
    payment_aba_routing_number = document.getElementById("lease_document_request_lease_application_payment_aba_routing_number").value
    payment_account_number = document.getElementById("lease_document_request_lease_application_payment_account_number").value
    payment_account_type = document.getElementById("lease_document_request_lease_application_payment_account_type").value
    payment_account_holder_lessee = document.getElementById("lease_document_request_lease_application_payment_account_holder_lessee").checked
    payment_account_holder_co_lessee = document.getElementById("lease_document_request_lease_application_payment_account_holder_co-lessee").checked
    payment_account_holder_both = document.getElementById("lease_document_request_lease_application_payment_account_holder_both").checked
    incomplete_bank = !bank_name or !payment_aba_routing_number or !payment_account_number or !payment_account_type
    incomplete_holder = !payment_account_holder_lessee and !payment_account_holder_co_lessee and !payment_account_holder_both
    is_acknowledgement_checked = document.getElementById("lease_document_request_acknowledgement").checked
    acknowledgement_showed = document.getElementsByClassName("new_lease_document_request_acknowledgement")
    if (incomplete_bank or incomplete_holder) and !is_acknowledgement_checked
      $('.new_lease_document_request_acknowledgement').show()
      toggleBankingRequire(is_acknowledgement_checked, incomplete_holder)
      return false
    else
      $('.new_lease_document_request_acknowledgement').hide()
    if (acknowledgement_showed.length > 0) and (incomplete_bank or incomplete_holder) and !is_acknowledgement_checked
      return false

# Lessee Home Address
$(document).on "keyup keypress", "#lease_application_lessee_attributes_home_address_attributes_zipcode", (e) ->
  zip_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_county")
  state_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_state")
  city_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_city_id")
  value = $(this).val()
  invalid_zip_alert = value.length == 5
  if(e.keyCode == 13)
    e.preventDefault();
    return false;
  if $.isNumeric($(this).val())
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 1, invalid_zip_alert)

# Clear County value when City is cleared
$(document).on "change", "#lease_application_lessee_attributes_home_address_attributes_city_id", (e) ->
  zip_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_county")
  state_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_state")
  city_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_city_id")

  value = $(this).val()
  if !value? || value == ''
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 1)
    $(this).val('')

# Populate City Dropdown based on County value
$(document).on "change", "#lease_application_lessee_attributes_home_address_attributes_county", (e) ->
  zip_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_county")
  state_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_state")
  city_ele = document.getElementById("lease_application_lessee_attributes_home_address_attributes_city_id")
  value = $(this).val()
  
  if !value? || value == ''
    deletAllOptions(city_ele)
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 1)
  else
    populateCity(zip_ele, state_ele, county_ele, city_ele)

# Lessee Mailing Address
$(document).on "keyup keypress", "#lease_application_lessee_attributes_mailing_address_attributes_zipcode", (e) ->
  zip_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_county")
  state_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_state")
  city_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_city_id")
  value = $(this).val()
  invalid_zip_alert = value.length == 5
  if(e.keyCode == 13)
    e.preventDefault();
    return false;
  if $.isNumeric($(this).val())
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 1, invalid_zip_alert)

# Clear County value when City is cleared
$(document).on "change", "#lease_application_lessee_attributes_mailing_address_attributes_city_id", (e) ->
  zip_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_county")
  state_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_state")
  city_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_city_id")

  value = $(this).val()
  if !value? || value == ''
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 1)
    $(this).val('')

# Populate City Dropdown based on County value
$(document).on "change", "#lease_application_lessee_attributes_mailing_address_attributes_county", (e) ->
  zip_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_county")
  state_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_state")
  city_ele = document.getElementById("lease_application_lessee_attributes_mailing_address_attributes_city_id")
  value = $(this).val()
  if !value? || value == ''
    deletAllOptions(city_ele)
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 1)
  else
    populateCity(zip_ele, state_ele, county_ele, city_ele)

$(document).on "change", "#lease_application_document_status", (e) ->
  issued_date_elem = document.getElementById("lease_application_documents_issued_date")
  if issued_date_elem != null
    value = $(this).val()
    now = new Date();
    day = ("0" + now.getDate()).slice(-2);
    month = ("0" + (now.getMonth() + 1)).slice(-2);
    today = (month)+"/"+(day)+"/"+now.getFullYear() ;
    if value == "documents_issued"
      issued_date_elem.value = today

# CO-LESSEE

# Co-Lessee Home Address
$(document).on "keyup keypress", "#lease_application_colessee_attributes_home_address_attributes_zipcode", (e) ->
  zip_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_county")
  state_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_state")
  city_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_city_id")
  value = $(this).val()
  invalid_zip_alert = value.length == 5
  if(e.keyCode == 13)
    e.preventDefault();
    return false;
  if $.isNumeric($(this).val())
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 0, invalid_zip_alert)

# Clear Co-Lessee County value when Co-Lessee City is cleared
$(document).on "change", "#lease_application_colessee_attributes_home_address_attributes_city_id", (e) ->
  zip_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_county")
  state_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_state")
  city_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_city_id")

  value = $(this).val()
  if !value? || value == ''
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 0)
    $(this).val('')

# Populate Co-Lessee City Dropdown based on Co-Lessee County value
$(document).on "change", "#lease_application_colessee_attributes_home_address_attributes_county", (e) ->
  zip_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_county")
  state_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_state")
  city_ele = document.getElementById("lease_application_colessee_attributes_home_address_attributes_city_id")
  value = $(this).val() 
  if !value? || value == ''
    deletAllOptions(city_ele)
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 1)
  else
    populateCity(zip_ele, state_ele, county_ele, city_ele)

# Co-Lessee Mailing Address
$(document).on "keyup keypress", "#lease_application_colessee_attributes_mailing_address_attributes_zipcode", (e) ->
  zip_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_county")
  state_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_state")
  city_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_city_id")
  e.preventDefault();
  value = $(this).val()
  invalid_zip_alert = value.length == 5
  if(e.keyCode == 13)
    e.preventDefault();
    return false;
  if $.isNumeric($(this).val())
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 0, invalid_zip_alert)

# Clear Co-Lessee County value when Co-Lessee City is cleared
$(document).on "change", "#lease_application_colessee_attributes_mailing_address_attributes_city_id", (e) ->
  zip_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_county")
  state_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_state")
  city_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_city_id")

  value = $(this).val()
  if !value? || value == ''
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 0)
    $(this).val('')

# Populate Co-Lessee City Dropdown based on Co-Lessee County value
$(document).on "change", "#lease_application_colessee_attributes_mailing_address_attributes_county", (e) ->
  zip_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_zipcode")
  county_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_county")
  state_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_state")
  city_ele = document.getElementById("lease_application_colessee_attributes_mailing_address_attributes_city_id")
  value = $(this).val()
  
  if !value? || value == ''
    deletAllOptions(city_ele)
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 1)
  else
    populateCity(zip_ele, state_ele, county_ele, city_ele)

# Populate Lessee Address
# Home Address
$(document).on 'blur keypress', '#lessee_home_address_attributes_zipcode', (e) ->
  zip_ele = document.getElementById('lessee_home_address_attributes_zipcode')
  county_ele = document.getElementById('lessee_home_address_attributes_county')
  state_ele = document.getElementById('lessee_home_address_attributes_state')
  city_ele = document.getElementById('lessee_home_address_attributes_city_id')
  if(e.keyCode == 13)
    e.preventDefault();
    return false;
  if $.isNumeric($(this).val())
    return populateCountyState(zip_ele, state_ele, county_ele, city_ele, 0)
  return

#Populate City Dropdown based on County value
$(document).on 'change', '#lessee_home_address_attributes_county', (e) ->
  zip_ele = document.getElementById('lessee_home_address_attributes_zipcode')
  county_ele = document.getElementById('lessee_home_address_attributes_county')
  state_ele = document.getElementById('lessee_home_address_attributes_state')
  city_ele = document.getElementById('lessee_home_address_attributes_city_id')
  value = $(this).val()
  
  if !value? || value == ''
    deletAllOptions(city_ele)
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 0)
  else
    populateCity(zip_ele, state_ele, county_ele, city_ele)

#Clear County value when City is cleared
$(document).on 'change', '#lessee_home_address_attributes_city_id', (e) ->
  zip_ele = document.getElementById('lessee_home_address_attributes_zipcode')
  county_ele = document.getElementById('lessee_home_address_attributes_county')
  state_ele = document.getElementById('lessee_home_address_attributes_state')
  city_ele = document.getElementById('lessee_home_address_attributes_city_id')

  value = $(this).val()
  if !value? || value == ''
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 0)
    $(this).val('')

# Employment Address
$(document).on 'blur keypress', '#lessee_employment_address_attributes_zipcode', (e) ->
  zip_ele = document.getElementById('lessee_employment_address_attributes_zipcode')
  county_ele = document.getElementById('lessee_employment_address_attributes_county')
  state_ele = document.getElementById('lessee_employment_address_attributes_state')
  city_ele = document.getElementById('lessee_employment_address_attributes_city')
  if(e.keyCode == 13)
    e.preventDefault();
    return false;
  if $.isNumeric($(this).val())
    return populateCountyState(zip_ele, state_ele, county_ele, city_ele, 0)
  return

#Populate City Dropdown based on County value
$(document).on 'change', '#lessee_employment_address_attributes_county', (e) ->
  zip_ele = document.getElementById('lessee_employment_address_attributes_zipcode')
  county_ele = document.getElementById('lessee_employment_address_attributes_county')
  state_ele = document.getElementById('lessee_employment_address_attributes_state')
  city_ele = document.getElementById('lessee_employment_address_attributes_city')
  value = $(this).val()
  
  if !value? || value == ''
    deletAllOptions(city_ele)
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 0)
  else
    populateCity(zip_ele, state_ele, county_ele, city_ele)

#Clear County value when City is cleared
$(document).on 'change', '#lessee_employment_address_attributes_city', (e) ->
  zip_ele = document.getElementById('lessee_employment_address_attributes_zipcode')
  county_ele = document.getElementById('lessee_employment_address_attributes_county')
  state_ele = document.getElementById('lessee_employment_address_attributes_state')
  city_ele = document.getElementById('lessee_employment_address_attributes_city')
  value = $(this).val()

  if !value? || value == ''
    populateCountyState(zip_ele, state_ele, county_ele, city_ele, 0)
    $(this).val('')




$(document).on 'change', '#lease_document_request_acknowledgement', (e) ->
  if this.checked
    remove_banking_requirements()

toggleBankingRequire = (is_acknowledgement_checked, ischecked) ->
  bank_name_elem = document.getElementById("lease_document_request_lease_application_payment_bank_name")
  payment_aba_routing_number_elem = document.getElementById("lease_document_request_lease_application_payment_aba_routing_number")
  payment_account_number_elem = document.getElementById("lease_document_request_lease_application_payment_account_number")
  payment_account_type_elem = document.getElementById("lease_document_request_lease_application_payment_account_type")
  toggleRequired(bank_name_elem, !bank_name_elem.value); 
  toggleRequired(payment_aba_routing_number_elem, !payment_aba_routing_number_elem.value);
  toggleRequired(payment_account_number_elem, !payment_account_number_elem.value);
  toggleRequired(payment_account_type_elem, !payment_account_type_elem.value);

  if is_acknowledgement_checked
    remove_banking_requirements()
  if ischecked
    $("#lease_document_request_lease_application_payment_account_holder_input").find('label').addClass("required")
  else
    $("#lease_document_request_lease_application_payment_account_holder_input").find('label').removeClass("required")

remove_banking_requirements = () ->
  $("#lease_document_request_lease_application_payment_bank_name").removeAttr('required')
  $("#lease_document_request_lease_application_payment_aba_routing_number").removeAttr('required')
  $("#lease_document_request_lease_application_payment_account_number").removeAttr('required')
  $("#lease_document_request_lease_application_payment_account_type").removeAttr('required')
  $("#lease_document_request_lease_application_payment_account_holder_input").removeAttr('required')

populateCity = (zip_ele, state_ele, county_ele, city_ele) ->
  zipcode = zip_ele.value
  state = state_ele.value
  county = county_ele.value

  parsed_response = getCityDetails(zipcode, state, county)
  cities = parsed_response.city
  same_as_lessee_ele = document.getElementById('same-as-lessee-checkbox') || null
  if same_as_lessee_ele != null
    same_as_lessee_ele_checked = same_as_lessee_ele.checked
  deletAllOptions(city_ele)

  elements = { city_ele: city_ele }
  values = { cities: cities }

  fillCityElements(values, elements)
  if(!same_as_lessee_ele_checked)
    if cities.length > 1
      clearCityInput(city_ele)

populateCountyState = (zip_ele, state_ele, county_ele, city_ele, getTax, invalid_zip_alert = false) ->
  zipcode = zip_ele.value
  get_tax = getTax.value
  parsed_response = getTaxDetails(zipcode)

  state = parsed_response.state
  state_from_zip = parsed_response.state_from_zip
  isFounded = _.intersection(state, state_from_zip).length > 0

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
      if(isFounded || $("#same-as-lessee").prop('checked'))
        state_ele.value = state_from_zip
      else
        clearStateInput(state_ele)
        if(invalid_zip_alert)
          alert("State not found in the list of valid states. Please select from dropdown.")
    else
      alert("Speed Leasing currently does not lease to residents of this state.")
      deletAllOptions(state_ele)
      deletAllOptions(city_ele)
      deletAllOptions(county_ele)
  else
    if zipcode
      alert("Please apply a valid Zip Code.")
    deletAllOptions(state_ele)
    deletAllOptions(city_ele)
    deletAllOptions(county_ele)

getTaxDetails = (zipcode) ->
  response= $.ajax
    type: 'GET'
    async: false
    data: zipcode: zipcode
    dataType: 'json'
    url: '/api/v1/address/find_city'

  return JSON.parse(response.responseText)

getCityDetails = (zipcode, state, county) ->
  response= $.ajax
    type: 'GET'
    async: false
    data: {
      zipcode: zipcode,
      state: state,
      county: county
    }
    dataType: 'json'
    url: '/api/v1/address/find_city'

  return JSON.parse(response.responseText)

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
    state_opt.innerHTML = state[i]
    state_opt.value = state[i]
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
    opt.innerHTML = cities[i][0]
    opt.value = cities[i][1]
    city_ele.appendChild opt
    i++

deletAllOptions = (element) ->
  select = element
  length = select.options.length
  i = 0
  while i <= length
    element.remove("option")
    i++

clearCountyInput = (element) ->
  element.value = ""

clearStateInput = (element) ->
  element.value = ""

clearCityInput = (element) ->
  element.value = ""

set_vehicle_possession = () ->
  if $('form.lease_application').attr("attr_is_form_new_record") == "true"
    primary_lessee_elem = document.getElementById("lease_application_vehicle_possession_primary_lessee");
    colessee_elem = document.getElementById("lease_application_vehicle_possession_colessee");
    is_new_page = (primary_lessee_elem.getAttribute("attr_is_new_record") == "true") && (colessee_elem.getAttribute("attr_is_new_record") == "true")
    is_colessee_form = $('form.lease_application').hasClass('add-colessee-form')
    if ( !primary_lessee_elem.checked && !colessee_elem.checked) && is_new_page
      primary_lessee_elem.checked = true
    setcheck = false
    $(document).on "change", "form.lease_application :input", (e) ->
      if is_new_page || is_colessee_form
        setcheck = false
        $("[name^='lease_application[colessee_attributes]']").each ->
          if !(($(this).val() == ''))
            setcheck = true
            return false
        if !((this == primary_lessee_elem) || (this == colessee_elem))
          if setcheck
            primary_lessee_elem.checked = false
            colessee_elem.checked = false
          else
            primary_lessee_elem.checked = true

onSelectYear = () -> 
  asset_make = document.getElementById('lease_application_lease_calculator_attributes_asset_make')
  asset_year = document.getElementById('lease_application_lease_calculator_attributes_asset_year')
  asset_model = $('#lease_application_lease_calculator_attributes_asset_model')

  $(document).on "change", "#lease_application_lease_calculator_attributes_asset_year", (e) ->
    model_repsonse = getModelOptions(asset_make.value, asset_year.value)
    asset_model.empty()
    asset_model.append(model_repsonse.select_options)
getModelOptions = (asset_make, asset_year) ->
  response = $.ajax
    type: 'GET'
    async: false
    data: {asset_make: asset_make, asset_year: asset_year}
    dataType: 'script'
    url: '/api/v1/model_years/select-options'
  return JSON.parse(response.responseText) 
  # if(response.status == 401)
  #   alert('Access denied. Invalid or Expired Token. Please try to login again')
  #   window.location.reload();
  # return JSON.parse(response.responseText)
