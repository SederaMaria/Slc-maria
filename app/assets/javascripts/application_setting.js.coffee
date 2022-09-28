class ApplicationSetting
  toggleGlobalDepositInfo = ->
    $('#application_setting_enable_global_security_deposit').click (event) ->
      $('#application_setting_global_security_deposit').toggle();

  init: ->
    if !$('#application_setting_enable_global_security_deposit').prop('checked')
      $('#application_setting_global_security_deposit').toggle();
    toggleGlobalDepositInfo();

$(document).ready ->
  setting = new ApplicationSetting
  setting.init()