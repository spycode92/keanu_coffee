const MYPAGE_DISPATCH_DETAIL_URL = "/transport/mypage/dispatch/detail";
const MYPAGE_DISPATCH_COMPLETE_URL = "/transport/mypage/dispatch/completed";
const MYPAGE_DISPATCH_START_URL = "/transport/mypage/delivery/start";
const MYPAGE_DELIVERY_COMPLETE_URL = "/transport/mypage/delivery/completed";
const MYPAGE_DELIVERY_RETURN_URL = "/transport/mypage/delivery/return";

const { token, header } = getCsrf();

let franchises = [];
let currentDispatch;

// 모달 열기 + 배차 상세 데이터 불러오기
$(document).on("click", ".load-btn", function() {
	ModalManager.openModalById('orderModal');
	const parent = $(this).closest("tr");

	const dispatchIdx = parseInt(parent.data("dispatch-idx"));
	const vehicleIdx = parseInt(parent.data("vehicle-idx"));

	$("#currentDispatchIdx").val(dispatchIdx);
	$("#currentVehicleIdx").val(vehicleIdx);

	$.getJSON(`${MYPAGE_DISPATCH_DETAIL_URL}/${dispatchIdx}/${vehicleIdx}`)
		.done(function(dispatch) {
			franchises = dispatch.franchises || [];
			// 배차 메타 정보 표시
			$("#orderMeta").text("배차일 " + formatDate(dispatch.dispatchDate));

			// 지점 카드 + 품목 테이블 그리기
			let html = "";
			franchises.forEach(fr => {
				let itemsHtml = "";
				fr.items?.forEach(item => {
					itemsHtml += `
            <tr class="border-b"
				 data-outbound-order-idx="${item.outboundOrderIdx}"
      			 data-outbound-order-item-idx="${item.outboundOrderItemIdx}">
              <td class="p-2">${item.productName || "-"}</td>
              <td class="p-2 text-right">${item.quantity}</td>
              <td class="p-2 text-right">${item.productVolume}</td>
            </tr>
          `;
				});

				html += `
          	<div class="p-4 border rounded-2xl mb-4 shadow franchise-block" data-franchise-idx="${fr.franchiseIdx}">
	            <div class="font-bold text-lg mb-2">
	              <input type="checkbox" class="franchise-check mr-2" data-franchise-idx="${fr.franchiseIdx}" data-order-idx="${fr.outboundOrderIdx}"/>
	              ${fr.franchiseName || "-"} (${fr.regionName || ""})
	            </div>
	            <table class="w-full text-sm" id="dispatchLoad">
	              <thead>
	                <tr class="border-b">
	                  <th class="text-left p-2">상품명</th>
	                  <th class="text-right p-2">수량</th>
	                  <th class="text-right p-2">부피</th>
	                </tr>
	              </thead>
	              <tbody>
	                ${itemsHtml}
	              </tbody>
	            </table>
          </div>
        `;
			});

			$("#groupWrap").html(html);
			updatePickedSummary(); // 초기화
		})
		.fail(() => {
			Swal.fire({
				icon: 'error',
				text: '배차 정보를 불러오지 못했습니다. 다시 시도해주세요.'
			});
		});
});

// 체크박스 클릭 시 선택한 지점의 품목들 합산
$(document).on("change", ".franchise-check", function() {
	updatePickedSummary();
});

// 합산 표시 함수 (수량만 합산)
function updatePickedSummary() {
	let productMap = {}; // { productName: qty }

	$(".franchise-check:checked").each(function() {
		const orderIdx = $(this).data("order-idx");
		const franchiseIdx = $(this).data("franchise-idx");
		const franchise = franchises.find(f => 
		      f.franchiseIdx === franchiseIdx && f.outboundOrderIdx === orderIdx);

		if (franchise && franchise.items) {
			franchise.items.forEach(item => {
				if (!productMap[item.productName]) {
					productMap[item.productName] = 0;
				}
				productMap[item.productName] += item.quantity || 0;
			});
		}
	});

	if (Object.keys(productMap).length === 0) {
		$("#pickedSummary").text("선택 없음");
		$("#pickedTotal").text("0 박스");
		return;
	}

	// 품목별 합계 문자열을 줄바꿈으로 연결
	let summaryHtml = Object.entries(productMap)
		.map(([name, qty]) => `<div>${name} ${qty}박스</div>`)
		.join("");

	$("#pickedSummary").html(summaryHtml);

	// 전체 수량 합계
	const totalQty = Object.values(productMap).reduce((sum, q) => sum + q, 0);
	$("#pickedTotal").text(totalQty + " 박스");
}

// 선택 초기화
$(document).on("click", "#btnClearPick", function() {
	$(".franchise-check").prop("checked", false);
	updatePickedSummary(); // 합산 결과도 초기화
});

// 적재하기 버튼 클릭 시
function loadCompleted() {
	const selectedStops = [];
	const grouped = {};
	$(".franchise-check:checked").each(function() {
		const orderIdx = $(this).data("order-idx");
		const franchiseIdx = $(this).data("franchise-idx");
		const franchise = franchises.find(f => 
		      f.franchiseIdx === franchiseIdx && f.outboundOrderIdx === orderIdx);

		// outboundOrderIdx 값 가져오기
		franchise.items.forEach(item => {
			if (!grouped[item.outboundOrderIdx]) {
				grouped[item.outboundOrderIdx] = [];
			}
			grouped[item.outboundOrderIdx].push(item);
		});

		Object.entries(grouped).forEach(([outboundOrderIdx, items]) => {
			const stopData = {
				franchiseIdx: franchise.franchiseIdx,
				outboundOrderIdx: parseInt(outboundOrderIdx),
				items: items.map(item => ({
					outboundOrderItemIdx: item.outboundOrderItemIdx,
					productIdx: item.productIdx,
					itemName: item.productName,
					orderedQty: item.quantity,
					deliveredQty: item.quantity
				}))
			};
			selectedStops.push(stopData);
		});
	});

	const capacity = $("#capacity").val() === 1000 ? 3000 : 4500;

	const totalVolume = calculateTotalCapacity(grouped);

	if (selectedStops.length === 0) {
		Swal.fire({ icon: 'warning', text: '선택된 지점이 없습니다.' });
		return;
	}

	const requestData = {
		dispatchIdx: parseInt($("#currentDispatchIdx").val()),
		vehicleIdx: parseInt($("#currentVehicleIdx").val()),
		requiresAdditional: $("#assignTable tbody tr").data("requires-additional"),
		stops: selectedStops
	};

	Swal.fire({
		title: "적재를 완료하시겠습니까?",
		showCancelButton: true,
		confirmButtonText: "예",
		cancelButtonText: "아니오"
	}).then((result) => {
		if (result.isConfirmed) {

			if (capacity * 0.9 < totalVolume) {
				Swal.fire("에러", "적재 용량을 초과하였습니다.", "error");
				return;
			}
			const { token, header } = getCsrf();
			$.ajax({
				url: MYPAGE_DISPATCH_COMPLETE_URL,
				type: "POST",
				contentType: "application/json",
				data: JSON.stringify(requestData),
				beforeSend(xhr) {
					if (token && header) xhr.setRequestHeader(header, token);
				},
				success: function() {
					Swal.fire("적재 완료", "적재가 완료되었습니다.", "success").then(() => {
						location.reload();
					});
				},
				error: function(xhr) {
					Swal.fire("에러", xhr.responseText, "error");
				}
			});
		}
	})
}

// 선택한 지점 총량 계산하기
function calculateTotalCapacity(grouped) {
	const volumeMap = {
		3: 18,
		4: 36,
		5: 60
	};

	return Object.values(grouped)
		.flat()
		.reduce((total, item) => {
			const realVolume = volumeMap[item.productVolume] || 0;
			return total + (realVolume * item.quantity);
		}, 0);
}



// 배송 현황 관련 데이터
let timelineData = [];
// 납품 완료 후 전송할 데이터
//let complateRequestData;

$(document).on("click", ".detail-btn", function() {
	ModalManager.openModalById('progressModal');

	const row = $(this).closest("tr");
	const status = row.find("td:eq(4)").text();
	const btn = $("#detailActionBtn");
	const dispatchIdx = row.data("dispatch-idx");
	const vehicleIdx = row.data("vehicle-idx");
	let requiresAdditional = "";

	timelineData = [];

	// --------------
	// 화면 구현
	$.getJSON(`${MYPAGE_DISPATCH_DETAIL_URL}/${dispatchIdx}/${vehicleIdx}`)
		.done(function(dispatch) {
			currentDispatch= dispatch;
			$("#progMeta").text("배차일 " + formatDate(dispatch.dispatchDate));
			requiresAdditional = dispatch.requiresAdditional;
			let detailHtml = "";
			dispatch.franchises?.forEach((stop) => {
				timelineData.push({
					franchiseIdx: stop.franchiseIdx,
					franchiseName: stop.franchiseName,
					arrivalTime: stop.arrivalTime,
					completeTime: stop.completeTime,
					status: stop.dispatchStopStatus || "대기 중"
				});
				const items = stop.deliveryConfirmations?.[0]?.items || [];
				if (stop.deliveryConfirmations) {
					stop.deliveryConfirmations.forEach((dc) => {
						dc.items?.forEach((item, index) => {
							const orderItems = dc.items;
							detailHtml += `
							<tr data-confirmation-item-idx="${item.confirmationItemIdx}"
							    data-outbound-order-idx="${dc.outboundOrderIdx}">
								${index === 0 ? `<td rowspan="${orderItems.length}" data-label="지점명">${stop.franchiseName}</td>` : ""}
								<td data-label="품목명">${item.itemName}</td>
								<td data-label="주문수량">${item.orderedQty}</td>
							  	<td data-label="납품수량">
								    <input type="number"
								           class="delivered-qty"
								           data-ordered-qty="${item.orderedQty}"
								           min="0"
								           max="${item.orderedQty}"
								           value="${item.deliveredQty != null ? item.deliveredQty : 0}" 
										   ${item.status === "OK" || item.status === "REFUND" || item.status === "PARTIAL_REFUND" ? "disabled" : ""}
											 />
							  	</td>
								<td class="status-cell">${stop.completeTime == null ? "대기" : item.status === "OK" ? "완료" : item.status === "PARTIAL_REFUND" ? "부분반품" : "전량반품" || "-"}</td>
								${index === 0 ? `
								      <td rowspan="${orderItems.length}" class="btn-cell btn-pc">
								          <button class="complateBtn btn btn-secondary"
								                  data-franchise-idx="${stop.franchiseIdx}" 
								                  data-dispatch-stop-idx="${stop.dispatchStopIdx}" 
								                  data-order-idx="${dc.outboundOrderIdx}"
								                  data-confirmation-item-idx="${item.confirmationItemIdx}" disabled>
								            납품완료
								          </button>
								      </td>` : ""}
								
								  ${index === orderItems.length - 1 ? `
								      <td class="btn-cell btn-mobile">
								          <button class="complateBtn btn btn-secondary"
								                  data-franchise-idx="${stop.franchiseIdx}" 
								                  data-dispatch-stop-idx="${stop.dispatchStopIdx}" 
								                  data-order-idx="${dc.outboundOrderIdx}"
								                  data-confirmation-item-idx="${item.confirmationItemIdx}" disabled>
								            납품완료
								          </button>
								      </td>` : ""}
							</tr>
						`;
						});
					});
				}
			});
			renderTimeline();

			$("#detailItems tbody").html(detailHtml);
			renderDispatchMap("mapContainer", dispatch.franchises);
		});

	// 버튼 클릭 시 
	if (status === "적재완료") {
		btn.text("운송시작");
		// 운송 시작 상태 변경 
		btn.off("click").on("click", function() {
			$.ajax({
				url: MYPAGE_DISPATCH_START_URL,
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				data: JSON.stringify({
					dispatchIdx: parseInt(dispatchIdx),
					vehicleIdx: parseInt(vehicleIdx),
					requiresAdditional
				}),
				beforeSend(xhr) {
					if (token && header) xhr.setRequestHeader(header, token);
				},
				success: function() {
					Swal.fire("운송시작", "운행을 시작합니다.", "success").then(() => {
						location.reload();
					});

				},
				error: function(xhr) {
					Swal.fire("에러", xhr.responseText, "error");
				}
			})
		});
	} else if (status === "운행중") {
		btn.text("복귀");
		const allDone = timelineData.every(s => s.status === "납품완료");
		console.log("allDone", allDone);
		console.log("timelineData11", timelineData);

		if (!allDone) {
			btn.prop("disabled", !allDone);
		}

		btn.off("click").on("click", function() {
			Swal.fire({
				title: "복귀하시겠습니까?",
				showDenyButton: true,
				confirmButtonText: "복귀",
				denyButtonText: "취소"
			}).then((result) => {
				if (result.isConfirmed) {
					$.ajax({
						url: MYPAGE_DELIVERY_RETURN_URL,
						type: "POST",
						contentType: "application/json; charset=UTF-8",
						data: JSON.stringify({
							dispatchIdx: parseInt(dispatchIdx),
							vehicleIdx: parseInt(vehicleIdx),
							requiresAdditional
						}),
						beforeSend(xhr) {
							if (token && header) xhr.setRequestHeader(header, token);
						},
						success: function() {
							Swal.fire("운행종료", "운행을 종료합니다.", "success").then(() => {
								location.reload();
							});
						},
						error: function(xhr) {
							Swal.fire("에러", xhr.responseText, "error");
						}
					});
				}
			})
		});
	}
});

// 반품 수량 입력할 때 이벤트
$(document).on("input", ".delivered-qty", function() {
	const tr = $(this).closest("tr");
	const tbody = $(this).closest("tbody");
	const deliverd = parseInt($(this).val() || "0", 10);
	const orderedQty = parseInt($(this).data("ordered-qty"), 10);
	const orderIdx = tr.data("outbound-order-idx");

	let statusText = "대기 중";
	let statusCode = null;

	if (deliverd === 0) {
		statusText = "완료";
		statusCode = "OK";
	} else if (deliverd < orderedQty && deliverd > 0) {
		statusText = "부분 반품";
		statusCode = "PARTIAL_REFUND";
	} else if (deliverd === orderedQty) {
		statusText = "전량 반품";
		statusCode = "REFUND";
	}

	// 상태 화면 표시
	tr.find(".status-cell").text(statusText);

	// 전송할 데이터에 status도 담기 위해 data 속성 업데이트
	tr.find(".delivered-qty").data("status-code", statusCode);

	// 같은 지점의 반품 수량 및 상태 확인
	let allFilled = true;
	
  	tbody.find(`tr[data-outbound-order-idx="${orderIdx}"]`).each(function() {
    	const row = $(this);
        const returned = parseInt(row.find(".delivered-qty").val() || -1, 10);
    	const code = row.find(".delivered-qty").data("status-code");

	    if (isNaN(returned) || returned < 0 || !code) {
	      allFilled = false;
	      return false;
	    }

		if (code === "REFUND" || code === "PARTIAL_REFUND") {
			$("#files").show();
		} else {
			$("#files").hide();
		}
    });

	// 주문 단위로 반품 수량 입력 여부로 버튼 활성/비활성
	const btn = tbody.find(`.complateBtn[data-order-idx="${orderIdx}"]`);
    btn.prop("disabled", !allFilled);
});

// 납품 완료 버튼 클릭 시 
$(document).on("click", ".complateBtn", function() {
  	const stopIdx = parseInt($(this).data("dispatch-stop-idx"));
  	const orderIdx = parseInt($(this).data("order-idx"));
	const stop = currentDispatch.franchises.find(s => s.dispatchStopIdx === stopIdx);
 	const confirmation = stop?.deliveryConfirmations.find(dc => dc.outboundOrderIdx === orderIdx);
	
	const complateRequestData = {
	    deliveryConfirmationIdx: confirmation.deliveryConfirmationIdx,
	    dispatchIdx: currentDispatch.dispatchIdx,
	    vehicleIdx: currentDispatch.vehicleIdx,
	    requiresAdditional: currentDispatch.requiresAdditional,
	    outboundOrderIdx: confirmation.outboundOrderIdx,
	    dispatchStopIdx: stop.dispatchStopIdx,
	    receiverName: currentDispatch.franchiseManagerName,
	    items: []
	};

  	const tbody = $(this).closest("table").find("tbody");
	tbody.find("tr").each(function() {
	    const row = $(this);
	    const confirmationItemIdx = row.data("confirmation-item-idx");
	    const delivered = parseInt(row.find(".delivered-qty").val() || 0, 10);
	    const statusCode = row.find(".delivered-qty").data("status-code");
	
	    complateRequestData.items.push({
	      confirmationItemIdx,
	      deliveredQty: delivered,
	      status: statusCode
	    });
	});
	
	const formData = new FormData();
	
	// formData 데이터 입력
	formData.append("request", new Blob([JSON.stringify(complateRequestData)], { type: "application/json" }));
	
	// 파일 추가
	const files = $('input[name="files"]')[0].files;
	for (let i = 0; i < files.length; i++) {
	  formData.append("files", files[i]); // List<MultipartFile>로 매핑됨
	}
	
	Swal.fire({
		title: "납품을 완료하시겠습니까?",
		showDenyButton: true,
		confirmButtonText: "완료",
		denyButtonText: "취소"
	}).then((result) => {
		if (result.isConfirmed) {
			$.ajax({
				url: MYPAGE_DELIVERY_COMPLETE_URL,
				type: "POST",
				contentType: "json",
				data: formData,
				processData: false,
				contentType: false,
				headers: {
 					"X-CSRF-TOKEN": token
 				},
				beforeSend(xhr) {
					if (token && header) xhr.setRequestHeader(header, token);
				},
				success: function() {
					Swal.fire("납품완료되었습니다..", "", "success").then(() => {
						location.reload();
					});
				}
			});
		}
	});


});

function renderTimeline() {
	let html = "";

	// 지점별 상태 표시
	timelineData.forEach(stop => {
		html += `
      <div class="timeline-item">
        <div class="timeline-point"></div>
        <div class="timeline-content">
          <div class="font-bold">${stop.franchiseName} (${stop.status})</div>
        </div>
      </div>
    `;
	});

	// DOM에 반영
	$("#timeline").html(html);
}

// 배송 현황 단계 추가 
function addTimelineStep(label, subText = "") {
	const html = `
		<div class="timeline-item">
	    	<div class="timeline-point"></div>
	      		<div class="timeline-content">
	        	<div class="font-bold">${label}</div>
	        	${subText ? `<div class="text-sm text-gray-600">${subText}</div>` : ""}
	      	</div>
	    </div>
		<br>
	`;
	$("#timeline").append(html);
}

// 날짜 변환
function formatDate(timestamp) {
	const date = new Date(timestamp);
	const year = date.getFullYear();
	const month = String(date.getMonth() + 1).padStart(2, "0");
	const day = String(date.getDate()).padStart(2, "0");
	return `${year}-${month}-${day}`;
}

$(document).ready(function() {
	$("#btnLoadCompleted").on("click", loadCompleted);

});