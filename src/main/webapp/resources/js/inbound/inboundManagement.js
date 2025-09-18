// ===== 유틸: 입력창 clear =====
function clearInput(id) {
	const el = document.getElementById(id);
	if (el) {
		el.value = "";
		el.focus();
	}
}

// ===== 선택 건수 표시 =====
function updateSelectedCount() {
	const count = document.querySelectorAll('input[name="selectedOrder"]:checked').length;
	const el = document.getElementById("selectedCount");
	if (el) el.textContent = count;
}

// ===== DOM 준비 후 =====
document.addEventListener("DOMContentLoaded", function () {

	// --- 전체선택 체크박스 ---
	const selectAll = document.querySelector(".select-all");
	if (selectAll) {
		selectAll.addEventListener("change", function (e) {
			const checked = e.target.checked;
			document.querySelectorAll('tbody input[name="selectedOrder"]').forEach(cb => {
				cb.checked = checked;
			});
			updateSelectedCount();
		});
	}

	// --- 개별 체크박스 클릭 시 전체선택 상태 갱신 ---
	document.addEventListener("change", function (e) {
		if (e.target.matches('input[name="selectedOrder"]')) {
			const boxes = document.querySelectorAll('tbody input[name="selectedOrder"]');
			const allChecked = boxes.length > 0 && Array.from(boxes).every(cb => cb.checked);
			if (selectAll) selectAll.checked = allChecked;
			updateSelectedCount();
		}
	});

	// --- 상세 검색 버튼 ---
	const btnSearch = document.querySelector(".btn-search");
	if (btnSearch) {
		btnSearch.addEventListener("click", function () {
			const status = document.getElementById("status").value;
			const orderInboundKeyword = document.getElementById("orderInboundKeyword").value.trim();
			const vendorKeyword = document.getElementById("vendorKeyword").value.trim();
			const inStartDate = document.getElementById("inStartDate").value;
			const inEndDate = document.getElementById("inEndDate").value;

			// 조건 없는 경우
			if (!status && !orderInboundKeyword && !vendorKeyword && !inStartDate && !inEndDate) {
				Swal.fire({
					icon: "warning",
					title: "검색 조건 없음",
					text: "최소 한 가지 조건을 입력하세요.",
					confirmButtonText: "확인"
				});
				return;
			}

			// 쿼리스트링 구성
			const params = new URLSearchParams();
			if (status) params.append("status", status);
			if (orderInboundKeyword) params.append("orderInboundKeyword", orderInboundKeyword);
			if (vendorKeyword) params.append("vendorKeyword", vendorKeyword);
			if (inStartDate) params.append("inStartDate", inStartDate);
			if (inEndDate) params.append("inEndDate", inEndDate);

			// 검색결과 페이지 이동
			location.href = `${contextPath}/inbound/management?${params.toString()}`;
		});
	}

	// --- 초기화 버튼 ---
	const btnReset = document.querySelector(".btn-reset");
	if (btnReset) {
		btnReset.addEventListener("click", function () {
			document.getElementById("status").value = "";
			clearInput("orderInboundKeyword");
			clearInput("vendorKeyword");
			document.getElementById("inStartDate").value = "";
			document.getElementById("inEndDate").value = "";

			// 체크박스 초기화
			if (selectAll) selectAll.checked = false;
			document.querySelectorAll('tbody input[name="selectedOrder"]').forEach(cb => cb.checked = false);

			updateSelectedCount();
		});
	}

	// --- 간단 검색 버튼 ---
	const btnSimpleSearch = document.getElementById("simpleSearchBtn");
	if (btnSimpleSearch) {
		btnSimpleSearch.addEventListener("click", function () {
			const keyword = document.getElementById("simpleItemKeyword").value.trim();
			if (!keyword) {
				Swal.fire({
					icon: "warning",
					title: "입력 필요",
					text: "발주번호 또는 입고번호를 입력하세요.",
					confirmButtonText: "확인"
				});
				return;
			}
			location.href = `${contextPath}/inbound/management?simpleKeyword=${encodeURIComponent(keyword)}`;
		});
	}
	
	
});


// 새로고침
document.addEventListener("DOMContentLoaded", function () {
	const reloadBtn = document.getElementById("btnReload");
	if (reloadBtn) {
		reloadBtn.addEventListener("click", function () {
			location.reload(); // ✅ 현재 페이지 새로고침
		});
	}
});
