var CopyLesseeDetails = (function () {

  var setup = function() {
    $("#same-as-lessee").on("change", function(){
      if(this.checked) {
        handleCheck();
      } else {
        clearFields();
      }
    });
  }

  var handleCheck = function() { 
    if(lesseeFields().length !== 0){
      copyFromLesseeFields();
    } else if(gon.lessee_home_address.length !== 0) {
      copyFromGon();
    } else {
      console.log('Could not find either Lessee fields on page, nor fields from Gon');
    }
  }

  var copyFromGon = function() {
    var fieldNames = Object.keys(gon.lessee_home_address);
    for(var i = 0, len = fieldNames.length; i < len; ++i){
      var fieldName = fieldNames[i];
      colesseeFieldBy(fieldName).val(gon.lessee_home_address[fieldName]).trigger('change');
    }
  }

  var colesseeFieldBy = function(column) {
    return $("[name*='[home_address_attributes][" + column + "]']");
  }

  var copyFromLesseeFields = function() {
    var fields = lesseeFields();
    for(var i = 0, len = fields.length; i < len; ++i) {
      var lesseeField = $(fields[i]);
      var colesseeField = $("[name='" + fields[i].name.replace('lessee_', 'colessee_') + "']");
      if(colesseeField.data('copy-from-lessee') && lesseeField.val()) {
        if (fields[i].name.includes('zipcode')) {
          // We need to trigger blur to run API calls when changing zip code
          colesseeField.val(lesseeField.val()).trigger('change').trigger('keyup');
        } else if (fields[i].name.includes('county')) {
          let lessee_county_field = lesseeField
          let colessee_county_field = colesseeField
          // Similar to auto_complete_address.js, delay county
          setTimeout(function() {
            colessee_county_field.val(lessee_county_field.val()).trigger('change');
          }, 1000)
        } else if (fields[i].name.includes('city_id')) {
          let lessee_city_id_field = lesseeField
          let colessee_city_id_field = colesseeField
          // Similar to auto_complete_address.js, delay city further than county
          setTimeout(function() {
            colessee_city_id_field.val(lessee_city_id_field.val()).trigger('change');
          }, 2000)
        } else {
          colesseeField.val(lesseeField.val()).trigger('change');
        }
      }
    }
  }

  var lesseeFields = function() {
    return $("[name*='[lessee_attributes]']");
  }

  var colesseeFields = function() {
    return $("[name*='[colessee_attributes]']");
  }

  var clearFields = function() {
    var fields = colesseeFields();
    for(var i = 0, len = fields.length; i < len; ++i) {
      var field = $(fields[i]);
      if(field.data('copy-from-lessee')) {
        if ($(fields[i]).val()) {
          $(fields[i]).val('').trigger('change');
        }
      }
    }
  }

  return {
    setup: setup
  };
})();

$(document).ready(function(){
  CopyLesseeDetails.setup();
});
