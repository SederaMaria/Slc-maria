if @funding_delay_reasons.present?
  json.message 'Funding Delay Resong List Data'
  json.funding_delay_reasons @funding_delay_reasons do |reason|
    json.id reason.id
    json.reason reason.reason
    json.active reason.active
  end
else
  json.message 'Invalid Data'
  json.funding_delay_reasons([])
end