function openDeliveryConfirmationDetail(deliveryConfirmationIdx) {
	console.log(deliveryConfirmationIdx);
	window.open(`/transport/deliveryConfirmation/${deliveryConfirmationIdx}`, "수주확인서","width=700px,height=800px"); 
}