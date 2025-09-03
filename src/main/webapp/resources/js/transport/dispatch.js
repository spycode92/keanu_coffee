const DISPATCH_LIST_URL = "/transport/dispatch/lsit"

// 배차 등록 버튼 클릭 시 배차 요청 리스트
function addDispatch() {
	ModalManager.openModalById('assignModal');
	
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
		})
}

$(document).on("click", "input[name='dispatchPick']", function() {
	const row = $(this).closest("tr td");
	console.log(row);
})



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
})