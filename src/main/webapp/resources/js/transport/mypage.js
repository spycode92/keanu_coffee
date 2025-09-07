const MYPAGE_DISPATCH_DETAIL_URL = "/transport/mypage/dispatch/detail";
const MYPAGE_DISPATCH_COMPLETE_URL = "/transport/mypage/dispatch/complete";

let franchises = [];

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
      console.log(dispatch);

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
              <input type="checkbox" class="franchise-check mr-2" data-franchise-idx="${fr.franchiseIdx}" />
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
        icon:'error',
        text:'배차 정보를 불러오지 못했습니다. 다시 시도해주세요.'
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
    const idx = $(this).data("franchise-idx");
    const franchise = franchises.find(f => f.franchiseIdx === idx);

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
	
	$(".franchise-check:checked").each(function() {
		const idx = $(this).data("franchise-idx");
		const franchise = franchises.find((franchise) => franchise.franchiseIdx  === idx);
		
		// outboundOrderIdx 값 가져오기
		const grouped = {};
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
	
	if (selectedStops.length === 0) {
		Swal.fire({ icon: 'warning', text: '선택된 지점이 없습니다.' });
    	return;
	}
	
	const requestData = {
		dispatchIdx: parseInt($("#currentDispatchIdx").val()),
		vehicleIdx: parseInt($("#currentVehicleIdx").val()),
		urgent: $("#assignTable tbody tr").data("urgent"),
		stops: selectedStops
	};
	
	Swal.fire({
		title: "적재를 완료하시겠습니까?",
	    showCancelButton: true,
	    confirmButtonText: "예",
	    cancelButtonText: "아니오"
	}).then((result) => {
		if (result.isConfirmed) {
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
					Swal.fire({ icon: "error", text: "적재 완료 처리 중 오류가 발생했습니다." });
				}
			});
		}
	})
}

$(document).on("click", ".detail-btn", function() {
	ModalManager.openModalById('progressModal');
});


// 날짜 변환
function formatDate(timestamp) {
	const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
}

$(document).ready(function () {
	$("#btnLoadCompleted").on("click", loadCompleted);

});