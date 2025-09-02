const DISPATCH_LIST_URL = "/transport/dispatch/lsit"

function addDispatch() {
	ModalManager.openModalById('assignModal');
	
	$.getJSON(DISPATCH_LIST_URL)
		.done(function(dispatch) {
			console.log(dispatch);
		})
}

$(document).ready(function () {
	 $("#openRegister").on("click", addDispatch);
})