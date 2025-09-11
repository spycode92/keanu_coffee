const FRANCHISE_ROUTE_URL = "/transport/franchise/route";
const FRANCHISE_ROUTE_REORDER_URL = "/transport/franchise/reorder"

let  allData = [];

$("#routeRegionSelect").change(function() {
	const regionName = $(this).val();
	
	$.getJSON(FRANCHISE_ROUTE_URL)
		.done(function(data) {
			allData = data;
			
			let filtered = allData;
			if (regionName) {
				filtered = allData.filter(item => item.commonCodeName == regionName);
			}
			
			renderTable(filtered);
		})
		.fail(function(error) {
			console.error("데이터 로드 실패:", err);
		})
});

function renderTable(list) {
	const tbody = $("#franchiseTable tbody");
	tbody.empty();
	
	$.each(list, function(index, row) {
		tbody.append(`
			<tr id="fr-${row.franchiseIdx}">
		        <td>${row.franchiseName}</td>
		    	<td class="seq">${index + 1}</td>
		    </tr>
		`);
	});
	
    // Drag & Drop 활성화
    tbody.sortable({
    	placeholder: "ui-state-highlight",
	 	update: function(event, ui) {
			$("#franchiseTable tbody tr").each(function(i) {
				$(this).find("td.seq").text(i + 1);
			})
		}
    }).disableSelection();
}

// 순서 저장 버튼 클릭 시
$("#saveRouteBtn").on("click", function() {
	let regionIdx = $("#routeRegionSelect option:selected").data("idx");
	
	regionIdx = parseInt(regionIdx);
	
	// 현재 tbody의 순서대로 franchiseIdx 읽기
  	const newOrder = $("#franchiseTable tbody tr").map(function(i) {
    	return {
		regionIdx: regionIdx,
      	franchiseIdx: $(this).attr("id").replace("fr-", ""),
      	deliverySequence: i + 1
    	};
  	}).get();
	
	if (!regionIdx || newOrder.length === 0) {
		Swal.fire("순서 변경 내역이 없습니다", "", "warning");
    	return;
	}
	
	const { token, header } = getCsrf();
	$.ajax({
		url: FRANCHISE_ROUTE_REORDER_URL,
		type: "POST",
		contentType: "application/json",
		data: JSON.stringify(newOrder),
		beforeSend(xhr) {
     	    if (token && header) xhr.setRequestHeader(header, token);
    	},
		success: function() {
			Swal.fire("순서저장완료", "", "success");
		},
		error: function() {
			Swal.fire("다시 시도해주세요", "", "error");
		}
	});
});