if @scheduling_days.present?  
    json.scheduling_days @scheduling_days do |result|
     json.scheduling_day result.scheduling_day
  end
else
  json.message 'Invalid Data'
  json.model_groups([])
end
