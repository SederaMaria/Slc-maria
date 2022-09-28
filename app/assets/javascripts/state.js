function toggle_visibility() {
	var select = $('#us_state_tax_jurisdiction_type_id');
	var fields = $('.hidden-fields');
  
	select.on('change', function() {
	  var value = $('#us_state_tax_jurisdiction_type_id option:selected').text();

	  if (value == 'Custom') {
			fields.show()
		} else {
			fields.hide()
		}
	});
}

document.addEventListener('DOMContentLoaded', function() {
	toggle_visibility();
	if ($('#us_state_tax_jurisdiction_type_id option:selected').text() !== 'Custom' ) { $('.hidden-fields').hide(); }
}, false);
