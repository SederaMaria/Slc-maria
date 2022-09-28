class CalculatorValidator
  constructor: ->
    @form = $('#edit_lease_calculator')

  preventSubmit: (e) =>
    e.preventDefault()
    e.stopPropagation()
    alert('Form cannot be submitted with obsolete Mileage Tier')

  validate: (e) =>
    selected_mileage_tier = $('#lease_calculator_mileage_tier option:selected')
    if selected_mileage_tier.attr('data-unsubmittable') == 'true'
      @preventSubmit(e)

$(document).ready ->
  return true unless $('#edit_lease_calculator')
  handler = new CalculatorValidator
  handler.form.on 'submit', (e) ->
    state = $('#lease_calculator_us_state').val();
    if state == 'georgia'
      ga_tavt_val = $('#lease_calculator_ga_tavt_value').val();
      if ga_tavt_val == undefined || ga_tavt_val == null || ga_tavt_val.length <= 0 || ga_tavt_val <= 0
        alert('Please enter a valid numeric GA TAVT value')
        return false
    handler.validate(e)
