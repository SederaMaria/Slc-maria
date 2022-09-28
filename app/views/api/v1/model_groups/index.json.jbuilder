if @model_groups.present?
  json.message 'Model Groups List Data'
  json.model_groups @model_groups do |model_group|
    json.id model_group.id
    json.name model_group.name
    json.sort_index model_group.sort_index
  end
else
  json.message 'Invalid Data'
  json.model_groups([])
end
