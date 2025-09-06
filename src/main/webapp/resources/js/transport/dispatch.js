const DISPATCH_LIST_URL = "/transport/dispatch/list";
const DISPATCH_AVAILABLE_DRIVERS_URL = "/transport/dispatch/availableDrivers";
const ADD_DISPATCH_URL = "/transport/dispatch/add";
const CANCEL_DISPATCH_URL = "/transport/dispatch/cancel";
const DISPATCH_DETAIL_URL = "/transport/dispatch/detail";

let assignedDrivers = [];
let totalVolume = 0;

// 배차 등록 버튼 클릭 시 배차 요청 리스트
function openAddDispatchModal() {
	ModalManager.openModalById('assignModal');
		
	// 배차 요청 리스트
	$.getJSON(DISPATCH_LIST_URL)
		.done(function(dispatchs) {
			const html = dispatchs.map((dispatch) => `
				<tr data-order-ids="${dispatch.orderIds}">
					<td><input type="radio" name="dispatchPick"/></td>
					<td data-dispatch-date="${dispatch.dispatchDate}">${formatDate(dispatch.dispatchDate)}</td>
					<td>${dispatch.startSlot}</td>
					<td data-region-idx="${dispatch.regionIdx}">${dispatch.regionName}</td>
					<td>${dispatch.totalVolume}</td>
					<td data-urgent="${dispatch.urgent}">${dispatch.urgent === "Y" ? "긴급" : dispatch.status}</td>
				</tr>
			`).join("");
			$("#assignList tbody").html(html);
		});
	
	// 가용 가능한 기사 목록	
	loadAvailableDrivers()
}

// 배차 요청 리스트 클릭 이벤트
$(document).on("click", "input[name='dispatchPick']", function() {
	// 이전 선택 초기화
    assignedDrivers = [];                  // 배열 초기화
    $("#assignedDriverList").empty();      // 배정된 기사 목록 비우기
    $("#primaryDriverSelect").val("");     // 기본 기사 선택 초기화
    $("#extraDriverSelect").val("");       // 추가 기사 선택 초기화
    $("#capacityInfo").val("");            // 용량 표시 초기화
    $("#extraDriverBlock").hide();         // 추가기사 블럭 숨김

	// 기사 목록 다시 로드
    loadAvailableDrivers();

	const requestData = dispatchRequestData();
	
	const row = $(this).closest("tr");
	const region = row.find("td:eq(3)").text();
	const status = row.find("td:eq(5)").text();
	totalVolume = row.find("td:eq( 4)").text();
	
	if (requestData) {
		const summary = `${formatDate(requestData.dispatchDate)} ${requestData.startSlot} / ${region} / ${totalVolume}L`;
		// 선택한 배차 정보 표시
		$("#selAssignSummary").val(summary);
	}
	
	// 배차완료시에만 배차 취소 버튼 활성화
	if (status === "배차완료") {
		$("#btnCancelAssign").prop('disabled', false);
		
	} else {
		$("#btnCancelAssign").prop('disabled', true);
	}
	
	// 기사 선택시 
	$("#primaryDriverSelect").off("change").on("change", function() {
		const volume = Number($(this).find(":selected").data("vehicle-volume") || 0);
		const available = volume * 0.8; // 80% 가용 용량
		
		$("#capacityInfo").val(`${totalVolume}L / ${available}L`);
		
	});
});

// 기사 배정 버튼 클릭 시

function assignBtn() {
	const selected = $("#primaryDriverSelect option:selected");
	const vehicleIdx = selected.val();
	const driverName = selected.data("emp-name");
	const vehicleType = selected.data("vehicle-type");
	const volume = selected.data("volume");
	const empIdx = selected.data("emp-idx");
	const capacity = selected.data("capacity") === 1000 ? "1.0t" : "1.5t";
	
	if (!vehicleIdx) {
		return;
	}
	
	// 배정된 기사 목록에 추가
	assignedDrivers.push({
		vehicleIdx, driverName, vehicleType, volume, empIdx
	});
	
	$("#assignedDriverList").append(`
		<div class="driver-item" data-vehicle-idx="${vehicleIdx}">
			<span>${driverName} ${capacity} (${vehicleType})</span>
			<button class="removeDriverBtn">X</button>
		</div>`);
	
	// 이미 선택한 기사 목록에서 비활성화
	selected.prop("disabled", true);
	
	// 가용 용량 계산
	const totalCapacity = assignedDrivers.reduce((sum, d) => {
	    return sum + d.volume * 0.8;
	}, 0);
	 $("#capacityInfo").val(`${totalVolume} / ${totalCapacity}`);

	// 가용 용량 초과 시 추가 배차 안내 문구 출력
	if (totalVolume > totalCapacity) {
		$("#extraDriverBlock").show();
	} else {
		$("#extraDriverBlock").hide();
	}	
}

// 기사 목록 로딩 
function loadAvailableDrivers() {
	// 가용 가능한 기사 목록	
	$.getJSON(DISPATCH_AVAILABLE_DRIVERS_URL)
		.done(function(drivers) {
			// 기본 안내 옵션
			let html = `<option value="">-- 기사를 선택하세요 --</option>`;
			// 서버에서 받은 가용 가능한 기사 리스트 html로 변환
			html += drivers.map(driver => `
			    <option value="${driver.vehicleIdx}"
			            data-emp-name="${driver.empName}"
			            data-vehicle-type="${driver.vehicleType}"
			            data-volume="${driver.volume}"
						data-capacity="${driver.capacity}"
						data-emp-idx=${driver.empIdx}>
			        ${driver.empName} ${driver.capacity === 1000 ? "1.0t" : "1.5t"} (${driver.vehicleType})
			    </option>
			`).join("");
			
			 $("#primaryDriverSelect").html(html);
			$("#extraDriverSelect").html(html);
		});
}

// 기사 삭제 버튼 클릭
$(document).on("click", ".removeDriverBtn", function() {
	const parent = $(this).closest(".driver-item");
	const vehicleIdx = parent.data("vehicle-idx");
	const empIdx = parent.data("emp-idx");
	// 1) DOM에서 삭제
	parent.remove();

  	// 2) 배열에서 제거
  	assignedDrivers = assignedDrivers.filter(d => d.vehicleIdx != vehicleIdx);
  	assignedDrivers = assignedDrivers.filter(d => d.empIdx != empIdx);

  	// 3) select 옵션 다시 활성화
  	$(`#primaryDriverSelect option[value="${vehicleIdx}"]`).prop("disabled", false);
});


// 배차 등록
function addDispatch() {	
	const requestData = dispatchRequestData();
	
	if (!requestData) {
		Swal.fire({icon:'error', text:'등록할 배차를 선택해주세요!'}); 
		return;
	}
	
	if (requestData.drivers.length === 0) {
		Swal.fire({icon:'error', text:'기사 배정 후 배차가 가능합니다!'}); 
		return;
	}
	
	const { token, header } = getCsrf();
	
	// 등록 요청
	$.ajax({
		url: ADD_DISPATCH_URL,
		type: "POST",
		contentType: "application/json; charset=UTF-8",
		data: JSON.stringify(requestData),
		beforeSend(xhr) {
     		if (token && header) xhr.setRequestHeader(header, token);
     	},
		success: function() {
			Swal.fire("등록완료", "배차 등록이 완료되었습니다.", "success").then(() => {
				location.reload();
			});
		},
		error : function(xhr) {
			Swal.fire("에러", xhr.responseText, "error");
		}
	});
}

// 취소 버튼 로직
function cancelDispatch() {
	const request = dispatchRequestData();
	
	if (request.status != "배차완료") {
		return;
	}
	
	const { token, header } = getCsrf();
	
	$.ajax({
		url: CANCEL_DISPATCH_URL,
		type: "POST",
		contentType: "application/json; charset=UTF-8",
		data: JSON.stringify({
			orderIds: request.orderIds,
			status: request.status
		}),		
		beforeSend(xhr) {
     		if (token && header) xhr.setRequestHeader(header, token);
     	},
		success: function() {
			Swal.fire("취소완료", "배차 취소가 완료되었습니다.", "success").then(() => {
				location.reload();
			});
		},
		error: function(xhr) {
			Swal.fire("에러", xhr.responseText, "error");
		}
	})
}

// 배차 상세 보기
$(document).on("click", ".dispatchInfo", function() {
	ModalManager.openModalById('detailModal');
	
	const dispatchIdx = parseInt($(this).data("dispatch-idx"));
	const vehicleIdx = parseInt($(this).data("vehicle-idx"));
	
	$.getJSON((`${DISPATCH_DETAIL_URL}/${dispatchIdx}/${vehicleIdx}`))
		.done(function(dispatch) {
			$("#detailDriver").val(`${dispatch.driverName} / ${dispatch.vehicleNumber} / ${dispatch.capacity === 1000 ? "1.0t" : "1.5t"}`)
			
			if (dispatch.status === "예약" || dispatch.status === "취소") {
				$("#detail").hide();
				$("#summary").show();
				
				const html = `
					<tr>
						<td>${formatDate(dispatch.dispatchDate)}</td>
						<td>${dispatch.startSlot}</td>				
						<td>${dispatch.regionName}</td>			
						<td>${dispatch.totalVolume}</td>			
						<td>${dispatch.status}</td>			
					</tr>
				`
				$("#summary tbody").html(html);
			} else {
				$("#summary").hide();
				$("#detail").show();
			}
		}) 
});

function dispatchRequestData() {
	const selected = $("input[name='dispatchPick']:checked");
	
	if (selected.length === 0) {
		return null;
	}
	
	// 선택된 라디오 버튼이 속한 행
	const row = selected.closest("tr");
	const orderIds = row.data("order-ids");
	const dispatchDate = row.find("td:eq(1)").data("dispatch-date");
	const startSlot = row.find("td:eq(2)").text();
	const urgent = row.find("td:eq(5)").data("urgent");
	const status = row.find("td:eq(5)").text();
	const regionIdx = parseInt(row.find("td:eq(3)").data("region-idx"));
	
	// 기사 배열화
	const drivers = assignedDrivers.map((driver) => ({
		vehicleIdx: driver.vehicleIdx,
		empIdx: driver.empIdx
	}));
	
	return {
		orderIds,
		dispatchDate,
		startSlot,
		urgent,
		regionIdx,
		drivers,
		status
	}
	
}


// 날짜 변환
function formatDate(timestamp) {
	const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
}

$(document).ready(function () {
	 $("#openRegister").on("click", openAddDispatchModal);
	 $("#btnAssignDriver").on("click", assignBtn);
	 $("#btnSaveAssign").on("click", addDispatch);
	 $("#btnCancelAssign").on("click", cancelDispatch);
})