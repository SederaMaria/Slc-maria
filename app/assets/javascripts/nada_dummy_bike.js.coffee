$(document).on "change", "#nada_dummy_bike_make_id", (e) ->
  make_ele = document.getElementById("nada_dummy_bike_make_id")
  group_name_ele = document.getElementById("nada_dummy_bike_model_group_name")
  populateGroupName(make_ele, group_name_ele)

populateGroupName = (make_ele, group_name_ele) ->
  make_id = make_ele.value

  parsed_response = getGroupName(make_id)
  model_groups = parsed_response.model_groups

  deletAllGroupNameOptions(group_name_ele)

  option = createGroupNameOption("")
  group_name_ele.appendChild option

  i = 0
  while i < model_groups.length
    option = createGroupNameOption(model_groups[i])
    group_name_ele.appendChild option
    i++

createGroupNameOption = (option_item) ->
  if option_item != ""
    option_name = option_item.name
  else
    option_name = ""
 
  option = document.createElement('option')
  option.innerHTML = option_name
  option.value = option_name
  return  option

getGroupName = (make_id) ->
  response = $.ajax
    type: 'GET'
    async: false
    data: make_id: make_id
    dataType: 'script'
    url: '/api/v1/model-groups'

  return JSON.parse(response.responseText)

deletAllGroupNameOptions = (element) ->
  select = element
  length = select.options.length
  i = 0
  while i <= length
    element.remove("option")
    i++