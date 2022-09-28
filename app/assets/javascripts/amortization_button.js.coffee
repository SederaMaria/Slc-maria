class AmortizationButton
  constructor: ->
    @form = $('#edit_lease_calculator')
    @button = $('[data-function="amortization-remote"]')

  setLoadingButton: ->
    @button.text('Loading..')

  resetForm: ->
    @form.removeAttr('data-remote')
    @form.removeData("remote");

  handleSuccess: (newWindow) ->
    newWindow.location.href = @button.attr('href')
    newWindow.focus()
    @button.text('Amortization Schedule')
    @form.off 'ajax:success'

  handleFailure: (newWindow, xhr) ->
    if xhr.responseJSON.error == 'calculator_locked'
      newWindow.location.href = @button.attr('href')
      newWindow.focus()
    else
      newWindow.close()
      alert('Error loading Amortization Schedule')
    @button.text('Amortization Schedule')
    @form.off 'ajax:error'

  performRemoteSubmit: ->
    @form.attr('data-remote', true)
    @form.submit()
    @setLoadingButton()
    newWindow = window.open('', "_blank")
    newWindow.blur()
    @form.on 'ajax:success', (e) =>
      @handleSuccess(newWindow)
    @form.on 'ajax:error', (e, xhr, settings) =>
      @handleFailure(newWindow, xhr)

$(document).ready ->
  return true unless $('#edit_lease_calculator')
  handler = new AmortizationButton
  handler.button.click (e) ->
    e.preventDefault()
    handler.performRemoteSubmit()
    handler.resetForm()
