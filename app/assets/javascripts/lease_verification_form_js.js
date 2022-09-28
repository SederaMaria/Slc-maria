const isReadyForLeasePak = (ele) => {
	let ready = false;
	
	let selectedOption = ele.options[ele.selectedIndex].text.toLowerCase();
	if ( selectedOption == 'funded' || selectedOption == 'funding approved' || selectedOption == 'lease package received') ready = true;

	return { ready: ready, value: selectedOption };		
}

const toggleLeasePakFields = () => {
	const documentStatusElement = document.getElementById('lease_application_document_status');

	if (documentStatusElement) {
		let { ready, value } = isReadyForLeasePak(documentStatusElement);
		const fundedDate = document.getElementById('lease_application_funded_on');
	
		switch (value) {
			
			case 'funded':
				toggleRequired(fundedDate, true);
				break;
			case 'funding approved':
				toggleRequired(fundedDate, false);
				break;
				
			default:
				toggleRequired(fundedDate, false);
		}

		let lpcRequiredFields = Array.from(document.querySelectorAll('.lpc-required'));

		if(value == 'lease package received'){
			lpcRequiredFields.forEach(lpcField => toggleRequired(lpcField, false));
			lpcRequiredFields = Array.from(document.querySelectorAll('.payment-required'));
		}

		if (ready == true ) {
			lpcRequiredFields.forEach(lpcField => toggleRequired(lpcField, true));
		} else {
			lpcRequiredFields.forEach(lpcField => toggleRequired(lpcField, false));
		}
	}
}

const statusListener = ()=>{
	const status = document.getElementById('lease_application_document_status');
	
	const adminFirstName = document.querySelector('.firstName');
	const adminLastName = document.querySelector('.lastName');

	let approver = document.getElementById('lease_application_the_approver')
	let reviewer = document.getElementById('lease_application_the_reviewer');
	
	if (status.value == "funding_approved") {
		approver.value = adminFirstName.innerText + " " + adminLastName.innerText;
	} else if (status.value == "documents_requested") {
		reviewer.value = adminFirstName.innerText + " " + adminLastName.innerText;
	} else {
		approver.value = $(approver).data('cache') || ''
		reviewer.value = $(reviewer).data('cache') || ''
	}
}

document.addEventListener('DOMContentLoaded', function() {
	toggleLeasePakFields();

	$('#lease_application_document_status').on('change', function(event) {
		statusListener();
	})
}, false);