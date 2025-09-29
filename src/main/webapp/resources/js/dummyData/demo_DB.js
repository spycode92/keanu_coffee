document.addEventListener('DOMContentLoaded', function() {
	
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    const makePOBtn = document.getElementById('purchaseOrderToInboundWaiting');


    makePOBtn.addEventListener('click', () => {
        console.log(startDateInput.value);
        console.log(endDateInput.value);
		ajaxPost("/Demo/makePO_IBW"
			, {startDate : startDateInput.value
				, endDate : endDateInput.value});
		
    });
});