$(document).ready ->
  if $('form#edit_credit_tier').length || $('form#new_credit_tier').length
    $('#credit_tier_make_id').on 'change', ->
      $.ajax('/credit_tiers/model_group_options?make_id=' + $(this).val()).done (response) ->
        model_group_select = $("#credit_tier_model_group_id")
        model_group_select.empty()
        $.each response.model_group_options, (index, option) ->
          $option = $('<option></option>').attr('value', option[0]).text(option[1])
          model_group_select.append $option