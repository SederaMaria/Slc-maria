$(document).on "change", "#police_bike_rule_make_id", (e) ->
  make_ele = document.getElementById("police_bike_rule_make_id")
  model_name_ele = document.getElementById("police_bike_rule_model_year_name")
  populateProxyModelName(make_ele, model_name_ele)

populateProxyModelName = (make_ele, model_name_ele) ->
  make_id = make_ele.value

  parsed_response = getModelName(make_id)
  model_years = parsed_response.model_years

  deletAllModelNameOptions(model_name_ele)

  option = createModelNameOption("")
  model_name_ele.appendChild option

  i = 0
  while i < model_years.length
    option = createModelNameOption(model_years[i])
    model_name_ele.appendChild option
    i++

createModelNameOption = (option_item) ->
  option = document.createElement('option')
  option.innerHTML = option_item
  option.value = option_item
  return  option

getModelName = (make_id) ->
  response = $.ajax
    type: 'GET'
    async: false
    data: make_id: make_id
    dataType: 'script'
    url: '/api/v1/model_years'

  return JSON.parse(response.responseText)

deletAllModelNameOptions = (element) ->
  select = element
  length = select.options.length
  i = 0
  while i <= length
    element.remove("option")
    i++