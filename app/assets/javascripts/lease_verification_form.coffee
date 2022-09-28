$(document).ready ->

  event = document.getElementById("lease_application_document_status")
  disablePostFundingOptions = ->
    $("#lease_application_document_status option[value='funding_approved']").attr('disabled', 'disabled');
    $("#lease_application_document_status option[value='funded']").attr('disabled', 'disabled');
  
  if(event != null)
    document_status = event.options[event.selectedIndex].value;
    verification_status = $('#lease_application_is_verification_call_completed').is(':checked')
    if(document_status == 'documents_issued')
      $("#lease_application_document_status option[value='funding_delay']").attr('disabled', 'disabled');
      disablePostFundingOptions();
    if(!verification_status and document_status == 'lease_package_received')
      disablePostFundingOptions();
      
  if $('#lease_application_payment_frequency').length > 0
    updateSecondPaymentFields()

  if (window.location.search.indexOf('selected_doc=funding_approved') > -1) || (window.location.search.indexOf('selected_doc=funded') > -1) || (window.location.search.indexOf('selected_doc=lease_package_received') > -1)
    document_status = getUrlParameter("selected_doc")
    $('#lease_application_document_status').val(document_status).trigger('change');
  setFundingStatus = ->
    verificationStatus = $('#lease_application_is_verification_call_completed').is(':checked')
    documentStatus = $('#lease_application_document_status').val()
    workflowstatus = $('#lease_application_workflow_status_id option:selected').text()
    if documentStatus == 'documents_issued'
      disablePostFundingOptions();
      $('option[value="funding_delay"]').attr('disabled', 'disabled');
    else if !verificationStatus || workflowstatus == 'Underwriting Review'
      disablePostFundingOptions();
    else if !verificationStatus and documentStatus == 'lease_package_received'
      if workflowstatus == 'Underwriting Review'
        disablePostFundingOptions();
      $('option[value="funding_delay"]').removeAttr 'disabled'
    else
      $('option[value="funding_approved"]').removeAttr 'disabled'
      $('option[value="funded"]').removeAttr 'disabled'
      $('option[value="funding_delay"]').removeAttr 'disabled'

    if workflowstatus == 'Underwriting Review'
      $('#lease_application_credit_status option[value="approved"]').attr('disabled', 'disabled');
    else
      $('#lease_application_credit_status option[value="approved"]').removeAttr 'disabled'
    return
  setFundingStatus()
  disableDealershipSortfundThisLease()
  disableApprovedCreditDecision()
  $('#lease_application_is_dealership_subject_to_clawback').on 'change', disableDealershipSortfundThisLease
  $('#lease_application_is_verification_call_completed').on 'change', setFundingStatus
  $('#lease_application_document_status').on 'change', setFundingStatus

  $('form.lease-verification-form').on 'submit', (e) =>
    document_status = document.getElementById("lease_application_document_status")
    routing_number = document.getElementById("lease_application_payment_aba_routing_number")
    if ((document_status.value == "funded") || (document_status.value == "funding_approved"))
      funding_approved_on_date = (new Date( document.getElementById("lease_application_funding_approved_on").value ) )
      first_payment_elem = document.getElementById("lease_application_first_payment_date")
      second_payment_elem = document.getElementById("lease_application_second_payment_date")
      first_payment_date = (new Date( first_payment_elem.value ) )
      first_daterange = Math.round((first_payment_date - funding_approved_on_date)/(1000*60*60*24))

      if (first_daterange > 60) || (first_daterange < 0)
        alert('First Payment Date should be within 60 days of Funded date')
        first_payment_elem.focus()
        return false
      if second_payment_elem.value != null
        second_payment_date = (new Date( second_payment_elem.value ) )
        second_daterange = Math.round((second_payment_date - funding_approved_on_date)/(1000*60*60*24))
        if (second_daterange > 60) || (second_daterange < 0)
          alert('Second Payment Date should be within 60 days of Funded date')
          second_payment_elem.focus()
          return false
      if !validRoutingNumber(routing_number.value)
        alert('Invalid Routing Number')
        routing_number.focus()
        return false
        
  validRoutingNumber = (routing) ->
    if routing.length != 9
      return false;
    # // http://en.wikipedia.org/wiki/Routing_transit_number#MICR_Routing_number_format
    checksumTotal = (7 * (parseInt(routing.charAt(0),10) + parseInt(routing.charAt(3),10) + parseInt(routing.charAt(6),10))) +
                    (3 * (parseInt(routing.charAt(1),10) + parseInt(routing.charAt(4),10) + parseInt(routing.charAt(7),10))) +
                    (9 * (parseInt(routing.charAt(2),10) + parseInt(routing.charAt(5),10) + parseInt(routing.charAt(8),10)));
    checksumMod = checksumTotal % 10;
    if checksumMod != 0
      return false;
    else
      return true;

window.toggleRequiredIndicator = (ele, active) ->
  label = ele.labels[0]
  className = 'required'
  hasClass = label.classList.contains(className)

  switch active
    when true 
      if not hasClass 
        label.classList.add(className)
    when false
      if hasClass
        label.classList.remove(className)

window.toggleRequired = (ele, required) ->
  ele.required = required
  toggleRequiredIndicator(ele, required)

window.updateSecondPaymentFields = () ->
  ele = document.getElementById('lease_application_payment_frequency')
  paymentFrequency = ele.options[ele.selectedIndex].text

  secondPaymentFields = [
    document.getElementById('lease_application_second_payment_date')
    document.getElementById('lease_application_payment_second_day')
    ]

  switch paymentFrequency
    when 'Split'
      for e in secondPaymentFields
        toggleRequired(e, true)
    else
      for e in secondPaymentFields
        toggleRequired(e, false)
        
getUrlParameter = (sParam) ->
  sPageURL = window.location.search.substring(1)
  sURLVariables = sPageURL.split('&')
  sParameterName = undefined
  i = undefined
  i = 0
  while i < sURLVariables.length
    sParameterName = sURLVariables[i].split('=')
    if sParameterName[0] == sParam
      return if sParameterName[1] == undefined then true else decodeURIComponent(sParameterName[1])
    i++
  return

$(document).on 'change', '#lease_application_is_dealership_subject_to_clawback', (e) ->
disableDealershipSortfundThisLease = () -> 
  if !($('#lease_application_is_dealership_subject_to_clawback').is(':checked'))
    $("#lease_application_this_deal_dealership_clawback_amount").val(0);
    $("#lease_application_this_deal_dealership_clawback_amount").prop('readonly', true); 
  else
    $("#lease_application_this_deal_dealership_clawback_amount").prop('readonly', false); 


disableApprovedCreditDecision = () ->
  if $("#lease_application_credit_status").attr('data-is-disable-credit-status-approved') == "true"
    $("#lease_application_credit_status option[value='approved']").attr('disabled', 'disabled');