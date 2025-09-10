const DRIVER_INFO_URL = "/transport/drivers/detail";
const VEHICLE_AVAILABLE_URL = "/transport/vehicle/available";
const MODIFY_DRIVER_INFO_URL = "/transport/vehicle/edit";

// 운전기사 상세정보
function driverDetail() {
	// 모달 열기(공통 JS 파일에서 가져와서 사용)
	ModalManager.openModalById('formModal');
	
	const empIdx = $(this).data('driverIdx');
	
	$.getJSON(DRIVER_INFO_URL, {idx: empIdx})
		.done(function(driver) {
			$("#empIdx").val(driver.empIdx);
			$("#empNo").val(driver.empNo);
			$("#empName").val(driver.empName);
			$(".empPhone").val(driver.empPhone);
			$("#empStatus").val(driver.empStatus);
			
			if (!driver.vehicleIdx) { // 배정된 차량이 없을 경우 
				$('#vehicleEmpty').show();
				$('#vehicleDiv').hide();
				$('#vehicleTableWrap').hide()
			} else { // 배정된 차량이 있을 경우
				$("#vehicleTableWrap").hide();
          		$("#vehicleEmpty").hide();
				$("#vehicleDiv .vehicle-empty-text").html(`
					<strong data-idx="${driver.vehicleIdx}">
				    	${driver.vehicleNumber}
				  	</strong> (${driver.vehicleType}, ${driver.capacity})
				`);
          		$("#vehicleDiv").show();
			}
			
			const isModify = (driver.status === '운행중');
			
			if (driver.status === "운행중") {
				$("#vehicleAssignBtn").prop('disabled', isModify).addClass("disabled");
			} else {
				$("#vehicleAssignBtn").prop('disabled', isModify).removeClass("disabled");
			}
		})
		.fail(() => {
			Swal.fire({icon:'error', text:'기사 정보를 불러오지 못했습니다. 다시 시도해주세요.'});
		})
}

// 차량 배정 버튼 클릭 시
function vehicleAssignBtn() {
	$('#vehicleEmpty').hide();
	$('#vehicleTableWrap').show();
	
	$.getJSON(VEHICLE_AVAILABLE_URL, {status: '미배정'})
		.done((res) => {
			const vehicles = res || [];
			
			if (vehicles.length === 0) {
				$('#vehicleRows').html(`
		        	<tr>
						<td colspan="5" style="text-align:center;color:#888;">
		          			배정 가능한 차량이 없습니다.
		          		</td>
					</tr>`);
       			 return;
			}
			
			const html = vehicles.map((vehicle) => `
				<tr data-idx="${vehicle.vehicleIdx}">
		        	<td><input type="radio" name="vehiclePick"></td>
		          	<td>${vehicle.vehicleNumber}</td>
		          	<td>${vehicle.vehicleType}</td>
		          	<td>${vehicle.capacity === 1000 ? "1.0t" : "1.5t"}</td>
		        </tr>
			`).join('');
			$("#vehicleRows").html(html);
		})
		.fail(() => {
			Swal.fire({icon:'error', text:'차량정보를 불러오지 못했습니다. 다시 시도해주세요.'}); 
    });
}

// 배정할 차량 클릭 시 동작
$(document).on('change', 'input[name="vehiclePick"]', function() {
	const row = $(this).closest('tr');
	const vehicleIdx = row.data("idx");
	const empIdx = $("#empIdx").val();
	
	Swal.fire({
	  title: "차량을 배정하시겠습니까?",
	  showDenyButton: true,
	  confirmButtonText: "배정",
	  denyButtonText: `취소`
	}).then((result) => {
		// 배정 버튼 클릭 시 차량 테이블에 운전자 등록
	  if (result.isConfirmed) {
		const { token, header } = getCsrf();
		$.ajax({
			url: MODIFY_DRIVER_INFO_URL,
			type: 'POST',
			contentType: 'application/json; charset=utf-8',
			data: JSON.stringify({ vehicleIdx: vehicleIdx, empIdx: empIdx, isAssign: false }),
			beforeSend(xhr) {
     			if (token && header) xhr.setRequestHeader(header, token);
    		},
			success: function(res) {
				$("#vehicleTableWrap").hide();
          		$("#vehicleDiv .vehicle-empty-text").html(`
					<strong data-idx="${res.vehicleIdx}">
				    	${res.vehicleNumber}
				    </strong> (${res.vehicleType}, ${res.capacity === 1000 ? "1.0t" : "1.5t"})
				  `);
          		$("#vehicleDiv").show();
			}
		});
	    Swal.fire("차량 배정이 완료되었습니다.", "", "success");
		$("#vehicleTableWrap").hide();
	  } 
	})
});

// 배정 해제 버튼 클릭 시
function onVehicleAssignBtn() {
	const vehicleIdx = $("#vehicleDiv .vehicle-empty-text strong").data("idx");
	const empIdx = $("#empIdx").val();
	
	Swal.fire({
	  title: "차량을 해제하시겠습니까?",
	  showDenyButton: true,
	  confirmButtonText: "해제",
	  denyButtonText: `취소`
	}).then((result) => {
	  if (result.isConfirmed) {
		const { token, header } = getCsrf();
		$.ajax({
			url: MODIFY_DRIVER_INFO_URL,
			type: 'POST',
			contentType: 'application/json; charset=utf-8',
			data: JSON.stringify({ vehicleIdx: vehicleIdx, empIdx: empIdx, isAssign: true }),
			beforeSend(xhr) {
     			if (token && header) xhr.setRequestHeader(header, token);
    		},
			success: function() {
		    // UI 업데이트: vehicleDiv 숨기고 vehicleEmpty 보여주기
		    $("#vehicleDiv").hide();
		    $("#vehicleTableWrap").hide();
		    $("#vehicleEmpty").show();
  			},
			error: function() {
				Swal.fire({icon:'error', text:'다시 시도해주세요'}); 
			}
		});
	    Swal.fire("차량 배정이 해제되었습니다.", "", "success");
	  } 
	});	
}

function closeModal() {
	ModalManager.closeModalById('formModal');
	location.reload();
}

// 이벤트 바인딩
$(document).ready(function () {
	 $("#driverTbody tr.driverInfo").on("click", driverDetail);
	 $(".modal-close-btn").on("click", closeModal);
	 $("#vehicleAssignInlineBtn").on("click", vehicleAssignBtn);
	 $("#vehicleAssignBtn").on("click", onVehicleAssignBtn);
});