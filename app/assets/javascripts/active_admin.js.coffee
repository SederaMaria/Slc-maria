# = require active_admin/base
#= require activeadmin_addons/all
# = require underscore
# = require fancybox
# = require calculator
# = require lease_application
# = require credit_tier
# = require lease_application_stipulation
# = require funding_delay_ajax
# = require bootstrap
# = require jasny-bootstrap.min
# = require copy_lessee_details
# = require amortization_button
# = require cable
# = require bootstrap-notify.min
# = require calculator_validator
# = require dealership_form
# = require application_setting
# = require lease_verification_form
# = require select2-tab-fix
# = require lease_verification_form_js
# = require state
# = require nada_dummy_bike
# = require js.cookie
# = require police_bike_rule
# = require click_limit
# = require auto_complete_address
# = require override_address
# = require lessee_banking_information


$(document).ready ->
  
  $('a.fancybox').fancybox()
  offset = (new Date()).getTimezoneOffset()
  timezones = {
      '-12': 'Pacific/Kwajalein',
      '-11': 'Pacific/Samoa',
      '-10': 'Pacific/Honolulu',
      '-9': 'America/Juneau',
      '-8': 'America/Los_Angeles',
      '-7': 'America/Denver',
      '-6': 'America/Mexico_City',
      '-5': 'America/New_York',
      '-4': 'America/Caracas',
      '-3.5': 'America/St_Johns',
      '-3': 'America/Argentina/Buenos_Aires',
      '-2': 'Atlantic/Azores',
      '-1': 'Atlantic/Azores',
      '0': 'Europe/London',
      '1': 'Europe/Paris',
      '2': 'Europe/Helsinki',
      '3': 'Europe/Moscow',
      '3.5': 'Asia/Tehran',
      '4': 'Asia/Baku',
      '4.5': 'Asia/Kabul',
      '5': 'Asia/Karachi',
      '5.5': 'Asia/Calcutta',
      '6': 'Asia/Colombo',
      '7': 'Asia/Bangkok',
      '8': 'Asia/Singapore',
      '9': 'Asia/Tokyo',
      '9.5': 'Australia/Darwin',
      '10': 'Pacific/Guam',
      '11': 'Asia/Magadan',
      '12': 'Asia/Kamchatka' 
  };
  tz = timezones[-offset / 60]
  if Intl.DateTimeFormat() != 'undefined'
    tz = Intl.DateTimeFormat().resolvedOptions().timeZone;
  Cookies.set('timezone', tz, { expires: 7, path: '/' });
  
  banner_elem = document.getElementById("footer_banner_info")
  if banner_elem
    banner_headline = banner_elem.getAttribute('data-bheadline')
    banner_message = banner_elem.getAttribute('data-bmessage')
    banner_active = banner_elem.getAttribute('data-bactive')
    banner_image = banner_elem.getAttribute('data-bimage')
    dealers_can_see = banner_elem.getAttribute('data-can-see')
    is_dealer = banner_elem.getAttribute('is-dealer')
    show_banner = banner_active == "true"
    show_banner = false if (is_dealer == "true") && (dealers_can_see != "true")
    if show_banner
      $('body').prepend('
          <div style="text-align:center; background-color: #42E493; padding:10px 5px 10px 5px;" class="banner-wrapper">
          <div class="banner-row">
              <div class="banner-header">
                  <img style="vertical-align:middle;" alt="spaceship" src='+banner_image+' class="banner-image">
                  <div style="display:inline-block; vertical-align:middle;" class="banner-headline">
                      <p style="margin: 0px; font-weight: 700; font-size: 2em; vertical-align:middle;">'+banner_headline+'</p>
                  </div>
                </div>
            </div>
            <div class="row"><div class="column">
              <p class="banner-text">'+banner_message+'</p>
            </div>
          </div>
        </div>
      ')
    
  isOpera = ! !window.opr and ! !opr.addons or ! !window.opera or navigator.userAgent.indexOf(' OPR/') >= 0
  # Firefox 1.0+
  isFirefox = typeof InstallTrigger != 'undefined'
  # Safari 3.0+ "[object HTMLElementConstructor]" 
  isSafari = /constructor/i.test(window.HTMLElement) or ((p) ->
    p.toString() == '[object SafariRemoteNotification]'
  )(!window['safari'] or typeof safari != 'undefined' and safari.pushNotification)
  # Internet Explorer 6-11
  isIE = false or ! !document.documentMode
  # Edge 20+
  isEdge = !isIE and ! !window.StyleMedia
  # Chrome 1 - 71
  isChrome = ! !window.chrome and (! !window.chrome.webstore or ! !window.chrome.runtime)

  # if (!isFirefox and !isChrome) or isOpera or isSafari or isIE or isEdge
  #   $('body').prepend('
  #       <div style="text-align:center; background-color: red; padding:10px 5px 10px 5px;" class="banner-wrapper">
  #     	<div class="banner-row">
  #         	<div class="banner-header">
  #               <div style="display:inline-block; vertical-align:middle;" class="banner-headline">
  #                   <p style="margin: 0px; font-weight: 700; font-size: 1.5em; vertical-align:middle; color:#ffffff;">Please use Google Chrome or Firefox</p>
  #               </div>
  #           	</div>
  #         </div>
  #        </div>
  #     </div>
  #   ')
$(document).on 'click', '.dropdown-menu', (e) ->
  if $(this).hasClass('keep-open-on-click')
    e.stopPropagation()
  return
  