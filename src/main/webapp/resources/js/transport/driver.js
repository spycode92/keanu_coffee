const DRIVER_INFO_URL = "/transport/drivers/detail";

function driverDetail() {
	
	ModalManager.openModalById('formModal');
	
	const empIdx = $(this).data('driverIdx');
	console.log("idx",empIdx );
	
	$.getJSON(DRIVER_INFO_URL, {idx: empIdx})
		.done(function(driver) {
			console.log(driver);
			$("#empNo").val(driver.empNo);
			$("#empName").val(driver.empName);
			$("#empPhone").val(driver.empPhone);
			$("#empStatus").val(driver.empStatus);
		})
}


// 이벤트 바인딩
$(document).ready(function () {
	 $("#driverTbody tr.driverInfo").on("click", driverDetail);
});