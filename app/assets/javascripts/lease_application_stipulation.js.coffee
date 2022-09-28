class LeaseApplicationStipulation
  onLeaseApplicationStipulation: ->
    $('form#new_lease_application_stipulation').length

  setup: ->
    setupStipulationDropdownCallback()
    setupStatusRadioButtons()
    setupNotesTextFields()
    setupRemoteUpdateNotifications()

  setupRemoteUpdateNotifications = ->
    $('.lease_application_stipulations_list .col-status').on 'ajax:success', (e) ->
      $.notify 'Stipulation status successfully updated.', type: 'success'

  setupStipulationDropdownCallback = ->
    $('#lease_application_stipulation_stipulation_id').on 'change', (e) ->
      $target = $(e.currentTarget)
      $.getJSON(
        "/admins/stipulations/#{$target.val()}",
        (data) ->
          defaultStatus =
            if data.required
              'Required'
            else
              'Not Required'
          $('#new_lease_application_stipulation').find(":radio[value='" + defaultStatus + "']").click()
      )

  setupStatusRadioButtons = ->
    $('.stipulation_status').on 'change', (e) ->
      e.stopImmediatePropagation()
      $target = $(e.currentTarget)
      $form = $target.closest('form')
      $form.submit()

  setupNotesTextFields = ->
    $('.stipulation_notes').on 'keyup', _.throttle((
      (e) ->
        e.stopImmediatePropagation()
        $target = $(e.currentTarget)
        $form = $target.closest('form')
        $form.submit()
    ), 3000)

$(document).ready ->
  leaseApplicationStipulation = new LeaseApplicationStipulation
  if leaseApplicationStipulation.onLeaseApplicationStipulation()
    leaseApplicationStipulation.setup()
