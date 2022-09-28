class FundingDelayAjax
  onFundingDelayPage: ->
    $('form#new_funding_delay').length

  setup: ->
    setupStatusRadioButtons()
    setupNotesTextFields()
    setupRemoteUpdateNotifications()

  setupRemoteUpdateNotifications = ->
    $('.funding_delay_list .col-status, .funding_delay_list .col-notes', ).on 'ajax:success', (e) ->
      $.notify 'Funding Delay successfully updated.', type: 'success'

  setupStatusRadioButtons = ->
    $('.funding_delay_status').on 'change', (e) ->
      e.stopImmediatePropagation()
      $target = $(e.currentTarget)
      $form = $target.closest('form')
      $form.submit()

  setupNotesTextFields = ->
    $('.funding_delay_notes').on 'keyup', _.throttle((
      (e) ->
        e.stopImmediatePropagation()
        $target = $(e.currentTarget)
        $form = $target.closest('form')
        $form.submit()
    ), 3000)

$(document).ready ->
  FundingDelayAjax = new FundingDelayAjax
  if FundingDelayAjax.onFundingDelayPage()
    FundingDelayAjax.setup()
