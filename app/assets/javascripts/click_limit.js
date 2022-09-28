$(document).ready(function () {
  $('.click-limit').on('click', function (event) {
    if ($(this).data('click-limit') === 1) {
      event.stopImmediatePropagation()
      event.preventDefault()
    } else {
      $(this).data('click-limit', 1)
    }
  })
})
