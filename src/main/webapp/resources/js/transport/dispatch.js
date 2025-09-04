const DISPATCH_LIST_URL = "/transport/dispatch/list";
const DISPATCH_AVAILABLE_DRIVERS_URL = "/transport/dispatch/availableDrivers";
const ADD_DISPATCH_URL = "/transport/dispatch/add";

// 배차 등록 버튼 클릭 시 배차 요청 리스트
function openAddDispatchModal() {
	ModalManager.openModalById('assignModal');
		
	// 배차 요청 리스트
	$.getJSON(DISPATCH_LIST_URL)
		.done(function(dispatchs) {
			console.log(dispatchs);
			const html = dispatchs.map((dispatch) => `
				<tr data-order-ids="${dispatch.orderIds}">
					<td><input type="radio" name="dispatchPick"/></td>
					<td data-dispatch-date="${dispatch.dispatchDate}">${formatDate(dispatch.dispatchDate)}</td>
					<td>${dispatch.startSlot}</td>
					<td data-region-idx="${dispatch.regionIdx}">${dispatch.regionName}</td>
					<td>${dispatch.totalVolume}</td>
					<td data-urgentFlag="${dispatch.urgentFlag}">${dispatch.urgentFlag === "Y" ? "긴급" : "대기"}</td>
				</tr>
			`).join("");
			$("#assignList tbody").html(html);
		});
	
	// 가용 가능한 기사 목록	
	loadAvailableDrivers()
}

let assignedDrivers = [];
let totalVolume = 0;

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
	
	const row = $(this).closest("tr");
	const date = row.find("td:eq(1)").text();
	const slot = row.find("td:eq(2)").text();
	const region = row.find("td:eq(3)").text();
	totalVolume = row.find("td:eq( 4)").text();
	
	const summary = `${date} ${slot} / ${region} / ${totalVolume}L`;
	
	// 선택한 배차 정보 표시
	$("#selAssignSummary").val(summary);
	
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
	const capacity = selected.data("capacity") === 1000 ? "1.0t" : "1.5t";
	
	if (!vehicleIdx) {
		return;
	}
	
	// 배정된 기사 목록에 추가
	assignedDrivers.push({
		vehicleIdx, driverName, vehicleType, volume
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
	// 1) DOM에서 삭제
	parent.remove();

  	// 2) 배열에서 제거
  	assignedDrivers = assignedDrivers.filter(d => d.vehicleIdx != vehicleIdx);

  	// 3) select 옵션 다시 활성화
  	$(`#primaryDriverSelect option[value="${vehicleIdx}"]`).prop("disabled", false);
});


// 배차 등록
function addDispatch() {
	const selected = $("input[name='dispatchPick']:checked");
	
	if (selected.length === 0) {
		Swal.fire({icon:'error', text:'등록할 배차를 선택해주세요!'}); 
		return;
	}
	
	// 선택된 라디오 버튼이 속한 행
    const row = selected.closest("tr");
    const orderIds = row.data("order-ids");
	const dispatchDate = row.find("td:eq(1)").data("dispatch-date");
	const startSlot = row.find("td:eq(2)").text();
	const urgentFlag = row.find("td:eq(5)").data("urgentFlag");
	const regionIdx = parseInt(row.find("td:eq(3)").data("region-idx"));
	
	// 선택된 기사
	const driverSelected = $("#primaryDriverSelect option:selected");
	const vehicleIdx = parseInt(driverSelected.val());
	const empIdx = parseInt(driverSelected.data("emp-idx"));
	
	const requestData = {
		orderIds, vehicleIdx, empIdx, startSlot, urgentFlag, regionIdx, dispatchDate
	};
	
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
})