$(document).ready(function() {
  function toggleDisplayAddressFields(id, checked) {
    switch (id) {
      case "override-address-lessee-home":
        $("#lessee-home-address-form-container .override-address-input-container").each(function() {
          if (checked) {
            $(this).removeClass("override-address-hidden")
          } else {
            $(this).addClass("override-address-hidden")
          }
        })
        break;
      case "override-address-colessee-home":
        $("#colessee-home-address-form-container .override-address-input-container").each(function() {
          if (checked) {
            $(this).removeClass("override-address-hidden")
          } else {
            $(this).addClass("override-address-hidden")
          }
        })
        break;
      case "override-address-lessee-mailing":
        $("#lessee-mail-address-form-container .override-address-input-container").each(function() {
          if (checked) {
            $(this).removeClass("override-address-hidden")
          } else {
            $(this).addClass("override-address-hidden")
          }
        })
        break;
      case "override-address-colessee-mailing":
        $("#colessee-mail-address-form-container .override-address-input-container").each(function() {
          if (checked) {
            $(this).removeClass("override-address-hidden")
          } else {
            $(this).addClass("override-address-hidden")
          }
        })
        break;
    }
  }

  function toggleOverrideAddressFields(id, override) {
    switch (id) {
      case "override-address-lessee-home":
        $("#lessee-home-address-form-container .override-address-input").each(function() {
          if (override) {
            $(this).removeAttr("disabled")
          } else {
            $(this)[0].disabled = true;
          }
        })
        break;
      case "override-address-colessee-home":
        $("#colessee-home-address-form-container .override-address-input").each(function() {
          if (override) {
            $(this).removeAttr("disabled")
          } else {
            $(this)[0].disabled = true;
          }
        })
        break;
      case "override-address-lessee-mailing":
        $("#lessee-mail-address-form-container .override-address-input").each(function() {
          if (override) {
            $(this).removeAttr("disabled")
          } else {
            $(this)[0].disabled = true;
          }
        })
        break;
      case "override-address-colessee-mailing":
        $("#colessee-mail-address-form-container .override-address-input").each(function() {
          if (override) {
            $(this).removeAttr("disabled")
          } else {
            $(this)[0].disabled = true;
          }
        })
        break;
    }
  }

  $("#override-address-lessee-home, #override-address-colessee-home, #override-address-lessee-mailing, #override-address-colessee-mailing").on("change", function() {
    toggleOverrideAddressFields($(this).attr('id'), this.checked)
    toggleDisplayAddressFields($(this).attr('id'), true)
  });

  $("#override-address-lessee-home, #override-address-colessee-home, #override-address-lessee-mailing, #override-address-colessee-mailing").on("address-autocomplete", function() {
    toggleDisplayAddressFields($(this).attr('id'), true)
  });
})
