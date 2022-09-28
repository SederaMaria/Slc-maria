if @makes.present?
  json.message 'Makes List Data'
  json.makes @makes do |make|
    json.id make.id
    json.name make.name
  end
else
  json.message 'Invalid Data'
  json.makes([])
end