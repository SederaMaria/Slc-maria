// https://jsfiddle.net/angelmarde/perqpp9f/2/
$.fn.select2.amd.define('select2/data/googleAutocompleteAdapter', ['select2/data/array', 'select2/utils'], function (ArrayAdapter, Utils) {
  function GoogleAutocompleteDataAdapter($element, options) {
    GoogleAutocompleteDataAdapter.__super__.constructor.call(this, $element, options)
  }

  Utils.Extend(GoogleAutocompleteDataAdapter, ArrayAdapter)

  GoogleAutocompleteDataAdapter.prototype.query = function (params, callback) {
    var returnSuggestions = function (predictions, status) {
      var data = { results: [] }
      if (status != google.maps.places.PlacesServiceStatus.OK) {
        callback(data)
      }
      if (predictions) {
        for (var i = 0; i < predictions.length; i++) {
          data.results.push({ id: predictions[i].place_id, text: predictions[i].description, prediction: predictions[i] })
        }
      }
      callback(data)
    }

    if (params.term && params.term != '') {
      var service = new google.maps.places.AutocompleteService()
      service.getPlacePredictions(
        {
          input: params.term,
          componentRestrictions: {
            country: ['us'],
          },
          types: ['address'],
        },
        returnSuggestions
      )
    } else {
      var data = { results: [] }
      callback(data)
    }
  }

  return GoogleAutocompleteDataAdapter
})

$(document).ready(function () {
  function formatRepo(repo) {
    if (repo.loading) {
      return repo.text
    }

    var markup = "<div class='select2-result-repository clearfix'>" + "<div class='select2-result-title'>" + repo.text + '</div>'
    return markup
  }

  function formatRepoSelection(repo) {
    return repo.text
  }

  var googleAutocompleteAdapter = $.fn.select2.amd.require('select2/data/googleAutocompleteAdapter')

  var placeService;
  function placesGetDetails(prediction, onPlacesGetDetailsResult) {
    if (!placeService && window.google) {
      placeService = new window.google.maps.places.PlacesService(document.createElement('div'))
    }

    placeService.getDetails({ placeId: prediction.place_id, fields: ['address_components'] }, function(placeResult, placeServiceStatus) {
      onPlacesGetDetailsResult(placeResult, placeServiceStatus)
    })
  }

  // Integration with `app/assets/javascripts/override_address.js`
  function inputParentIdToCheckboxId(input_parent_id) {
    // #override-address-lessee-home
    // #override-address-colessee-home
    // #override-address-lessee-mailing
    // #override-address-colessee-mailing
    return '#override-address-' + (input_parent_id.includes('colessee') ? 'colessee' : 'lessee') + (input_parent_id.includes('mailing') ? '-mailing' : '-home')
  }

  function checkPlaceResult(placeResult, check) {
    address_components = ['Zip Code', 'State', 'County/Parish/Etc.', 'City']
    placeResult.address_components.map((component) => {
      // Zip Code
      if (component.types.includes('postal_code')) {
        address_components = _.difference(address_components, ['Zip Code'])
      }

      // State
      if (component.types.includes('administrative_area_level_1')) {
        address_components = _.difference(address_components, ['State'])
      }

      // County
      if (component.types.includes('administrative_area_level_2')) {
        address_components = _.difference(address_components, ['County/Parish/Etc.'])
      }

      // City
      if (component.types.includes('locality')) {
        address_components = _.difference(address_components, ['City'])
      }
    })

    if (check) {
      return (address_components.length == 0)
    } else {
      return address_components
    }
  }

  // Zip Code, State, County, City
  function fillUpPlaceResult(input_parent_id, placeResult) {
    placeResult.address_components.map((component) => {
      // Zip Code
      if (component.types.includes('postal_code')) {
        $(input_parent_id + '_zipcode').val(component.long_name).trigger('keyup')
      }

      // State
      if (component.types.includes('administrative_area_level_1')) {
        $(input_parent_id + '_state').val(component.short_name).trigger('change')
      }

      setTimeout(function() {
        // County
        if (component.types.includes('administrative_area_level_2')) {
          $(input_parent_id + '_county').val(component.short_name.toLowerCase().replace(' county', '').toUpperCase()).trigger('change')
        }

        setTimeout(function() {
          // City
          if (component.types.includes('locality')) {
            $(input_parent_id + '_city_id').val(
              $(input_parent_id + "_city_id > option:contains('" + component.long_name.toUpperCase() + "')").val()
            ).trigger('change')
          }
        }, 1000)
      }, 1000)
    })

    // Integration with `app/assets/javascripts/override_address.js`
    $(inputParentIdToCheckboxId(input_parent_id)).trigger('address-autocomplete')
  }

  function attachOnSelect2SelectEventHandler(input_parent_id) {
    $(input_parent_id + '_search_address').on('select2:select', function (event) {
      var prediction = event.params.data.prediction

      // Fill up street address
      $(input_parent_id + '_street1').val(prediction.structured_formatting.main_text).trigger('change')

      // Get more details to fill up zip, state, county, city
      placesGetDetails(prediction, function(placeResult, placeServiceStatus) {
        if (placeServiceStatus == 'OK') {
          // Check ahead if address components are complete
          if (checkPlaceResult(placeResult, true)) {
            fillUpPlaceResult(input_parent_id, placeResult)
          } else {
            address_components = checkPlaceResult(placeResult, false)
            alert("Search Address: " + address_components + " not found. Please use override to manually input address")
          }
        }
      })
    })
  }

  $('.select2-address-autocomplete').select2({
    dataAdapter: googleAutocompleteAdapter,
    escapeMarkup: function (markup) {
      return markup
    },
    minimumInputLength: 2,
    templateResult: formatRepo,
    templateSelection: formatRepoSelection,
  })

  var searchInputParentIds = [
    '#lease_application_lessee_attributes_home_address_attributes',
    '#lease_application_lessee_attributes_mailing_address_attributes',
    '#lease_application_colessee_attributes_home_address_attributes',
    '#lease_application_colessee_attributes_mailing_address_attributes'
  ]

  searchInputParentIds.forEach(attachOnSelect2SelectEventHandler)
})
