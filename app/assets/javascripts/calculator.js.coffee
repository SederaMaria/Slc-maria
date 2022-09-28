class LeaseCalculator
  constructor: ->
    @inputs = $("[data-calculator-input]")
    @form_changed = false

  onLeaseCalculatorPage = ->
    $('form.lease_calculator').length

  disable_submitting_by_pressing_enter = ->
    $('form.lease_calculator').keydown (event) ->
      if(event.keyCode == 13)
        event.preventDefault()
        return false
  is_ga_custom = ->
    return document.getElementById("lease_calculator_us_state").getAttribute('data-calculation-is-custom')

  is_tax_jurisdiction_label_with_dealership = ->
    return document.getElementById("lease_calculator_us_state").getAttribute('data-calculation-tax_jurisdiction_label-with-dealership')

  california_county_town = ->
    return document.getElementById("lease_calculator_tax_jurisdiction").getAttribute('data-calculation-california-county-town')

  arizona_new_mexico_zip_code = ->
    return document.getElementById("lease_calculator_tax_jurisdiction").getAttribute('data-calculation-arizona-new_mexico-zip-code')

  selectedState = ->
    state = $("[data-calculator-us-state-input]")[0]
    unless state == undefined
      return state.value

  selectedOption = ->
    return $("[data-calculator-us-state-input]").find(':selected')

  changeHeaderLabel = (tax_label_settings) ->
    if tax_label_settings != undefined
      h4 = document.getElementById("calculator_r1_h4")
      if tax_label_settings.includes('Dealership') || is_tax_jurisdiction_label_with_dealership() == 'true'
        h4.innerHTML = "Dealer"

  overrideMode = ->
    if gon.override_mode
      true
    else
      false

  toggleTaxJurisdictions = ->
    $("[data-calculator-us-state-input]").change ->
      request_data = {}
      request_data["us_state"] = selectedState()
      $.get(
        '/tax_jurisdictions.json',
        request_data,
        (data) ->
          field_name = "#lease_calculator_tax_jurisdiction"
          field = $(field_name)
          selected_val = field.val()
          field.empty()
          field.append(data)
          field.val(selected_val)
          $("#{field_name} option:first").attr('selected', 'selected') unless field.val()?
          $("#lease_calculator_tax_jurisdiction").trigger("change")
      )

  syncStateAndTaxLabel = ->
    label = $('#lease_calculator_tax_jurisdiction_input label')
    taxLabelSetting = selectedOption().data('tax-label')
    changeHeaderLabel(taxLabelSetting)
    if taxLabelSetting == ''
      label.text('Tax Jurisdiction')
    else if is_tax_jurisdiction_label_with_dealership() == 'true'
      label.text(taxLabelSetting.replace('Customer', 'Dealership'))
    else
      label.text(taxLabelSetting)

  toggleTaxJurisdictionField = ->
    element = $('#lease_calculator_tax_jurisdiction_input')
    syncStateAndTaxLabel()
    if (selectedState() == 'georgia') && (is_ga_custom() == 'true')
      element.hide()
    $("[data-calculator-us-state-input]").change ->
      syncStateAndTaxLabel()
      if (selectedState() == 'georgia') && (is_ga_custom() == 'true')
        element.hide()
      else
        element.show()
    if (selectedState() == 'california')
      $('#lease_calculator_tax_jurisdiction_input select').val(california_county_town()).change()
    if (selectedState() == ('arizona' || 'new mexico')) && is_tax_jurisdiction_label_with_dealership() == 'true'
      $('#lease_calculator_tax_jurisdiction_input select').val(arizona_new_mexico_zip_code()).change()


  toggleGeorgiaTavtField = ->
    element = $('#ga-tavt-value')
    guide_element = $('#georgia-tax-guide')
    inputField = element.find('input')
    if (selectedState() == 'georgia') && (is_ga_custom() == 'true')
      guide_element.show()
      element.show()
    $("[data-calculator-us-state-input]").change ->
      if (selectedState() == 'georgia') && (is_ga_custom() == 'true')
        guide_element.show()
        element.show()
      else
        inputField.val('0.00')
        element.hide()
        guide_element.hide()

  togglePreTaxPaymentsSumField = ->
    element = $('#pre_tax_payments_sum')
    if sumOfPaymentsStateSelected()
      element.show()
    $("[data-calculator-us-state-input]").change ->
      if sumOfPaymentsStateSelected()
        element.show()
      else
        element.hide()

  sumOfPaymentsStateSelected = ->
    _.find(gon.sum_of_payments_states, (state) ->
      true if state.name.toUpperCase() == selectedState().toUpperCase()
    )

  refreshCalculations = (data) ->
    return true if overrideMode()
    $.each data["calculations"], (key, value) ->
      if isCustomDataUI(key)
        renderCustomDataUI(key, value)
      else
        $("input[name*='" + key + "']").val(value)

  isCustomDataUI = (key) ->
    # This should be in sync with `renderCustomDataUI.renderers`
    # TODO: Make `customList` an instance variable
    customList = ['cash_down_minimum']
    if key in customList
      return true
    else
      return false

  renderCustomDataUI = (key, value) ->
    # TODO: Make `renderers` an instance variable
    renderers =
      cash_down_minimum:
        render: (key, value) ->
          $("input[name*='" + key + "']").val(value)
          $('label[for="lease_calculator_cash_down_payment"]').text "Down Payment (Minimum Required: $#{value})"

    renderers[key].render(key, value)

  refreshSelectOptions = (data) ->
    return true if overrideMode()
    creditTier = $('#lease_calculator_credit_tier_id option:selected').text().split(' ')[1]
    if creditTier > 5
      $.each data["select_options"], (key, _values) ->
        field_name = "#lease_calculator_#{key}"
        field = $(field_name)
        selected_val = field.val()
        field.empty()
        field.append(_values)
        field.val(selected_val)
        unless field.val()?
          $("#{field_name} option:first").attr('selected', 'selected')
          $("#{field_name} option:first").trigger('change')
          $("#{field_name}").trigger("refreshSelectOptionsEvent")
  refreshChangeSelectOptions = (data) ->
    return true if overrideMode()
    $.each data["select_options"], (key, _values) ->
      creditTier = $('#lease_calculator_credit_tier_id option:selected').text().split(' ')[1]
      field_name = "#lease_calculator_#{key}"
      field = $(field_name)
      selected_val = field.val()
      field.empty()
      field.append(_values)
      field.val(selected_val)
      unless field.val()?
        $("#{field_name} option:first").attr('selected', 'selected')
        $("#{field_name}").trigger("refreshChangeSelectOptionsEvent")
      if creditTier <= 5
        exist = {}
        $('select > option').each ->
          if exist[$(this).val()]
            $(this).remove()
          else
            exist[$(this).val()] = true
          return
    refreshCalculations(data)


  renderErrors = (data) ->
    $('form ul.errors').remove()
    errors = {
      backend_total_error: false,
      cash_down_payment_error: false,
      total_monthly_payment_error: false,
    }

    if !!data["error"]
      $('form').prepend("<ul class='errors'>" + data["error"] + "</ul>")

      $(data["error"]).map () ->
        switch $(this).data('id')
          when 'backend_total_error' then errors.backend_total_error = true
          when 'cash_down_payment_error' then errors.cash_down_payment_error = true
          when 'total_monthly_payment_error' then errors.total_monthly_payment_error = true

    renderBackendTotalExceedIndicator errors.backend_total_error
    renderCashDownPaymentErrorIndicator errors.cash_down_payment_error
    renderTotalMonthlyPaymentError errors.total_monthly_payment_error

  renderBackendTotalExceedIndicator = (isError) ->
    if isError
      $('#lease_calculator_backend_max_advance_input label').css('color', 'red')
      $('#lease_calculator_guaranteed_auto_protection_cost_input label').css('color', 'red')
      $('#lease_calculator_prepaid_maintenance_cost_input label').css('color', 'red')
      $('#lease_calculator_extended_service_contract_cost_input label').css('color', 'red')
      $('#lease_calculator_tire_and_wheel_contract_cost_input label').css('color', 'red')
      $('#lease_calculator_gps_cost_input label').css('color', 'red')
      $('#lease_calculator_guaranteed_auto_protection_cost_input input').css('color', 'red')
      $('#lease_calculator_prepaid_maintenance_cost_input input').css('color', 'red')
      $('#lease_calculator_extended_service_contract_cost_input input').css('color', 'red')
      $('#lease_calculator_tire_and_wheel_contract_cost_input input').css('color', 'red')
      $('#lease_calculator_gps_cost_input input').css('color', 'red')
      $('#lease_calculator_backend_max_advance_input input').css('color', 'red')
      $('h4.backend_components').css('color', 'red')
      $('input.backend_components').css('color', 'red')
    else
      $('#lease_calculator_backend_max_advance_input label').css('color', '#5E6469')
      $('#lease_calculator_guaranteed_auto_protection_cost_input label').css('color', '#5E6469')
      $('#lease_calculator_prepaid_maintenance_cost_input label').css('color', '#5E6469')
      $('#lease_calculator_extended_service_contract_cost_input label').css('color', '#5E6469')
      $('#lease_calculator_tire_and_wheel_contract_cost_input label').css('color', '#5E6469')
      $('#lease_calculator_gps_cost_input label').css('color', '#5E6469')
      $('#lease_calculator_guaranteed_auto_protection_cost_input input').css('color', 'inherit')
      $('#lease_calculator_prepaid_maintenance_cost_input input').css('color', 'inherit')
      $('#lease_calculator_extended_service_contract_cost_input input').css('color', 'inherit')
      $('#lease_calculator_tire_and_wheel_contract_cost_input input').css('color', 'inherit')
      $('#lease_calculator_gps_cost_input input').css('color', 'inherit')
      $('#lease_calculator_backend_max_advance_input input').css('color', 'inherit')
      $('h4.backend_components').css('color', '#5E6469')
      $('input.backend_components').css('color', 'inherit')

  renderCashDownPaymentErrorIndicator = (isError) ->
    # Change "Cash Required" red if "Cash Down Payment" doesn't meet or exceed it
    if isError
      $('#lease_calculator_cash_down_payment_input > label').css('color', 'red')
      $('#lease_calculator_cash_down_payment_input > input').css('color', 'red')
    else
      $('#lease_calculator_cash_down_payment_input > label').css('color', '#5E6469')
      $('#lease_calculator_cash_down_payment_input > input').css('color', 'inherit')

  renderTotalMonthlyPaymentError = (isError) ->
    if isError
      $('#lease_calculator_total_monthly_payment_input > label').css('color', 'red')
      $('#lease_calculator_total_monthly_payment_input > input').css('color', 'red')
    else
      $('#lease_calculator_total_monthly_payment_input > label').css('color', '#5E6469')
      $('#lease_calculator_total_monthly_payment_input > input').css('color', 'inherit')

  syncCreditTierToRateMarkup = ->
    creditTier = $('#lease_calculator_credit_tier_id option:selected').text().split(' ')[1]
    if creditTier > 5
      dealerParticipationMarkupSelect = $('#lease_calculator_dealer_participation_markup')
      dealerParticipationMarkupSelect.find('option[value="0.0"]').prop('selected', true)

  enforceMaximumTermLength = ->
    maximum_term_length = $('#lease_calculator_asset_model option:selected').data('maximum-term-length')
    if !!maximum_term_length
      $.each $('#lease_calculator_term_input input'), (i, field) ->
        if parseInt(field.value) > maximum_term_length
          $(field).attr('disabled', true)
        else
          $(field).attr('disabled', false)
      if $("input[name='lease_calculator[term]']:checked").val() > maximum_term_length
        $('input[name="lease_calculator[term]"][value=' + maximum_term_length + ']').prop('checked', true)

  requiredSelectOptionsSet = ->
    requiredOptionCount = $('[data-calculation-prerequisite]:visible').length
    dropdownSelectWithVal = _.select($('select[data-calculation-prerequisite]:visible'), (el) ->
      !!$(el).val()
    )
    dropdownSelectCount = dropdownSelectWithVal.length
    radioButtonSelectedCount = $('[data-calculation-prerequisite] input:checked').length
    totalSelected = dropdownSelectCount + radioButtonSelectedCount
    return requiredOptionCount == totalSelected ? true: false

  setDefaultState = ->
    if $("input[name='lease_calculator[term]']:checked").val() == undefined
      overall_maximum_term_length = $('#lease_calculator_asset_model option:selected').data('overall-maximum-term-length')
      $('input[name="lease_calculator[term]"][value=' + overall_maximum_term_length + ']').prop('checked', true)
    if selectedState() != undefined && selectedState().length < 1
      state_select = $("[data-calculator-us-state-input]")
      state_select.find("option[value=#{gon.dealership_default_state}]").prop('selected', true)
      state_select.trigger('change')
  updateCalculations = (id) ->
    post_data = {}
    $.each $('.update_calculator').serializeArray(), (i, field) ->
      post_data[field.name] = field.value
    post_data['lease_calculator[id]'] = document.getElementById("calculator_data_id").getAttribute('data-calculator-id')
    $.post(
      '/lease_calculators.json',
      post_data,
      (data) ->
        refreshCalculations(data) if requiredSelectOptionsSet()
        renderErrors(data) if requiredSelectOptionsSet()
        refreshChangeSelectOptions(data)
        toggleHideIfZeroRows(data)
        if ['lease_calculator_asset_model', 'lease_calculator_asset_year'].includes(id)
          populateCreditTierForMakeEventHandler()
        $(document.activeElement).select()
    )

  updateSelectOptions = ->
    post_data = {}
    $.each $('.update_calculator').serializeArray(), (i, field) ->
      post_data[field.name] = field.value
    post_data['lease_calculator[id]'] = document.getElementById("calculator_data_id").getAttribute('data-calculator-id')
    $.post(
      '/lease_calculators.json',
      post_data,
      (data) ->
        renderErrors(data)
        refreshSelectOptions(data)
        toggleHideIfZeroRows(data)
        $(document.activeElement).select()
    )

  setupChangeTrigger = ->
    $('form input').on 'input', ->
      formChangeTrigger()
    $('form select').on 'change', ->
      formChangeTrigger()

  formChangeTrigger = ->
    $('form.lease_calculator').submit ->
      $(window).unbind 'beforeunload'
    unless @form_changed
      $(window).on 'beforeunload', ->
        'Are you sure? You didn\'t finish the form!'
      @form_changed = true

  toggleDealerInfo = ->
    $('#hide_dealer_info_button').click (event) ->
      event.preventDefault();
      $('.dealer-info').toggle();

  populateCreditTierForMakeEventHandler = (event) ->
    request_data = {}
    request_data['make'] = make = $('#lease_calculator_asset_make').val()
    request_data['year'] = year = $('#lease_calculator_asset_year').val()
    request_data['model'] = model = $('#lease_calculator_asset_model').val()

    if make and year and model and (year != 'Select Year')
      $.ajax({
        url: '/lease_calculators/credit_tier_select',
        data: request_data
      }).done (response) ->
        $('#lease_calculator_credit_tier_id').html response
        populateSavedCreditTier()
    else
      $('#lease_calculator_credit_tier_id').html ""

  # This function tries to retrieve saved credit tier level from database and use
  # it to automatically reselect same tier level when credit tier options are updated
  populateSavedCreditTier = ->
    saved_credit_tier = $('#lease_calculator_credit_tier_id').data('saved-credit-tier-level')
    return unless saved_credit_tier != undefined
    should_be_selected = 0
    current_options = $('#lease_calculator_credit_tier_id option').toArray().map (option) ->
      value = option.value
      tier = option.innerText.split(' ')[1]
      if parseInt(tier) == saved_credit_tier
        $('#lease_calculator_credit_tier_id').val(value).trigger('change')

  populateCreditTierForMake = ->
  $(document).on "change", "#lease_calculator_asset_make, #lease_calculator_asset_year, #lease_calculator_asset_model", (e) ->
    populateCreditTierForMakeEventHandler()

  toggleHideIfZeroRows = (data) ->
    data ?= { calculations: {} }
    toggleable = ["servicing_fee", "refundable_security_deposit"]

    $.each toggleable, (index, key) ->
      value = data["calculations"][key]
      if parseFloat(value) == 0 or value == undefined
        $(".thizr-" + key.replace(/_/g, "-")).addClass("hidden")
      else
        $(".thizr-" + key.replace(/_/g, "-")).removeClass("hidden")

  init: ->
    return false unless onLeaseCalculatorPage()
    #updateCalculations() # Initial update calculations
    updateSelectOptions()
    # setup event listeners
    togglePreTaxPaymentsSumField()
    toggleGeorgiaTavtField()
    toggleTaxJurisdictions()
    setDefaultState()
    toggleTaxJurisdictionField()
    toggleDealerInfo()
    setupChangeTrigger()
    disable_submitting_by_pressing_enter()
    syncCreditTierToRateMarkup()
    populateCreditTierForMake()
    @inputs.change ->
      enforceMaximumTermLength()
      updateCalculations($(this).attr('id'))

$(document).ready ->
  calculator = new LeaseCalculator
  calculator.init()