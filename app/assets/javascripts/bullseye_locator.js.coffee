bullseyeListener = (e) ->
  regex = new RegExp('^..bullseyelocations.com.$', 'i')
  if regex.test(e.origin)
    document.getElementById('bullseye_iframe').height = Math.round(e.data)
  return

$(document).ready ->
  if window.addEventListener
    addEventListener 'message', bullseyeListener, false
  else
    attachEvent 'onmessage', bullseyeListener