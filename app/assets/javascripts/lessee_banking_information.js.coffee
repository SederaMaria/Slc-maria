$(document).ready ->
  bank_name = document.getElementById("lease_application_payment_bank_name")
  aba_routing_number = document.getElementById("lease_application_payment_aba_routing_number")
  account_number = document.getElementById("lease_application_payment_account_number")
  account_type_id = document.getElementById("lease_application_payment_account_type")
  account_type = document.getElementsByClassName("select2-selection select2-selection--single")[0]
  colessee_bank_name = document.getElementById("lease_application_colessee_payment_bank_name")
  colessee_aba_routing_number = document.getElementById("lease_application_colessee_payment_aba_routing_number")
  colessee_account_number = document.getElementById("lease_application_colessee_payment_account_number")
  colessee_account_type_id = document.getElementById("lease_application_colessee_payment_account_type")
  colessee_account_type = document.getElementsByClassName("select2-selection select2-selection--single")[1]
  red_border_color = "1px red solid"
  default_border_color = "1px #c9d0d6 solid"
  red_color = "red"
  default_color = "#5E6469"

  if $('body').hasClass 'lease_bank_information'
    radioValue = $("input[name='lease_application[colessee_account_joint_to_lessee]']:checked").val()
    console.log('this: ', radioValue)
    if (radioValue == 'Yes')
      $("#colessee_banking_information").hide()
    else if (radioValue == 'No')
      $("#colessee_banking_information").show()
    else
      $("#lease_application_colessee_account_joint_to_lessee_yes").attr('checked', 'checked')
      $("#colessee_banking_information").hide()

    $("input[name='lease_application[colessee_account_joint_to_lessee]']").change ->
      if (this.value == "Yes")
        $("#colessee_banking_information").hide()
        $("#lease_application_colessee_payment_bank_name").removeAttr('required')
        $("#lease_application_colessee_payment_aba_routing_number").removeAttr('required')
        $("#lease_application_colessee_payment_account_number").removeAttr('required')
        $("#lease_application_colessee_payment_account_type").removeAttr('required')
      else if (this.value == "No")
        $("#colessee_banking_information").show()
        $("#lease_application_colessee_payment_bank_name").attr('required', 'required')
        $("#lease_application_colessee_payment_aba_routing_number").attr('required', 'required')
        $("#lease_application_colessee_payment_account_number").attr('required', 'required')
        $("#lease_application_colessee_payment_account_type").attr('required', 'required')

    $('#save-lessee-banking-information').on 'click', (e) =>
      if bank_name.value == '' || bank_name.value == null
        bank_name.style.border = red_border_color
        bank_name.labels[0].style.color = red_color
      else
        bank_name.style.border = default_border_color
        bank_name.labels[0].style.color = default_color

      if aba_routing_number.value == '' || aba_routing_number.value == null
        aba_routing_number.style.border = red_border_color
        aba_routing_number.labels[0].style.color = red_color
      else
        aba_routing_number.style.border = default_border_color
        aba_routing_number.labels[0].style.color = default_color

      if account_number.value == '' || account_number.value == null
        account_number.style.border = red_border_color
        account_number.labels[0].style.color = red_color
      else
        account_number.style.border = default_border_color
        account_number.labels[0].style.color = default_color

      if account_type_id.value == '' || account_type_id.value == null
        account_type.style.border = red_border_color
        account_type_id.labels[0].style.color = red_color
      else
        account_type.style.border = default_border_color
        account_type_id.labels[0].style.color = default_color

      if colessee_bank_name.value == '' || colessee_bank_name.value == null
        colessee_bank_name.style.border = red_border_color
        colessee_bank_name.labels[0].style.color = red_color
      else
        colessee_bank_name.style.border = default_border_color
        colessee_bank_name.labels[0].style.color = default_color

      if colessee_aba_routing_number.value == '' || colessee_aba_routing_number.value == null
        colessee_aba_routing_number.style.border = red_border_color
        colessee_aba_routing_number.labels[0].style.color = red_color
      else
        colessee_aba_routing_number.style.border = default_border_color
        colessee_aba_routing_number.labels[0].style.color = default_color

      if colessee_account_number.value == '' || colessee_account_number.value == null
        colessee_account_number.style.border = red_border_color
        colessee_account_number.labels[0].style.color = red_color
      else
        colessee_account_number.style.border = default_border_color
        colessee_account_number.labels[0].style.color = default_color

      if colessee_account_type_id.value == '' || colessee_account_type_id.value == null
        colessee_account_type.style.border = red_border_color
        colessee_account_type_id.labels[0].style.color = red_color
      else
        colessee_account_type.style.border = default_border_color
        colessee_account_type_id.labels[0].style.color = default_color