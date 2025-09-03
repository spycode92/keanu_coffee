const DISPATCH_LIST_URL = "/transport/dispatch/lsit"
const DISPATCH_AVAILABLE_DRIVERS_URL = "/transport/dispatch/availableDrivers";

// 배차 등록 버튼 클릭 시 배차 요청 리스트
function addDispatch() {
	ModalManager.openModalById('assignModal');
		
	// 배차 요청 리스트
	$.getJSON(DISPATCH_LIST_URL)
		.done(function(dispatchs) {
						
			const html = dispatchs.map((dispatch) => `
				<tr data-idx="${dispatch.outboundOrderIdx}">
					<td><input type="radio" name="dispatchPick"/></td>
					<td>${formatDate(dispatch.dispatchDate)}</td>
					<td>${dispatch.startSlot}</td>
					<td>${dispatch.regionName}</td>
					<td>${dispatch.totalVolume}</td>
					<td>${dispatch.urgentFlag === "Y" ? "긴급" : dispatch.status}</td>
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
	
	const summary = `${date} ${slot} / ${region} / ${totalVolume} 적재`;
	
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
	
	if (!vehicleIdx) {
		return;
	}
	
	// 배정된 기사 목록에 추가
	assignedDrivers.push({
		vehicleIdx, driverName, vehicleType, volume
	});
	$("#assignedDriverList").append(`<li>${driverName} (${vehicleType})</li>`);
	
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
			            data-volume="${driver.volume}">
			        ${driver.empName} (${driver.vehicleType})
			    </option>
			`).join("");
			
			 $("#primaryDriverSelect").html(html);
			$("#extraDriverSelect").html(html);
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
	 $("#openRegister").on("click", addDispatch);
	 $("#btnAssignDriver").on("click", assignBtn);
})