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

document.addEventListener("DOMContentLoaded", function () {

	// --- 인쇄 ---
	const printBtn = document.getElementById("btnPrint");
	if (printBtn) {
		printBtn.addEventListener("click", function (e) {
			e.preventDefault();
			window.print();
		});
	}


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

	// --- 간단 검색 (form submit 이벤트) ---
	const simpleForm = document.getElementById("simpleSearchForm");
	if (simpleForm) {
		simpleForm.addEventListener("submit", function (e) {
			const keyword = document.getElementById("simpleItemKeyword").value.trim();
			if (!keyword) {
				e.preventDefault(); // submit 막기
				Swal.fire({
					icon: "warning",
					title: "입력 필요",
					text: "발주번호 또는 입고번호를 입력하세요.",
					confirmButtonText: "확인"
				});
			}
		});
	}

	// --- 상세 검색 (form submit 이벤트) ---
	const detailForm = document.getElementById("detailSearchForm");
	if (detailForm) {
		detailForm.addEventListener("submit", function (e) {
			const status = document.getElementById("status").value;
			const orderInboundKeyword = document.getElementById("orderInboundKeyword").value.trim();
			const vendorKeyword = document.getElementById("vendorKeyword").value.trim();
			const inStartDate = document.getElementById("inStartDate").value;
			const inEndDate = document.getElementById("inEndDate").value;

			// 조건 없는 경우
			if (!status && !orderInboundKeyword && !vendorKeyword && !inStartDate && !inEndDate) {
				e.preventDefault(); // submit 막기
				Swal.fire({
					icon: "warning",
					title: "검색 조건 없음",
					text: "최소 한 가지 조건을 입력하세요.",
					confirmButtonText: "확인"
				});
			}
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
});

// 새로고침 (검색조건 리셋 + 확인창)
document.addEventListener("DOMContentLoaded", function () {
    const reloadBtn = document.getElementById("btnReload");
    if (reloadBtn) {
        reloadBtn.addEventListener("click", function () {
            Swal.fire({
                icon: "question",
                title: "검색조건을 초기화하시겠습니까?",
                text: "확인 시 현재 검색 조건이 모두 초기화되고 목록이 처음부터 표시됩니다.",
                showCancelButton: true,
                confirmButtonText: "예",
                cancelButtonText: "아니오"
            }).then(result => {
                if (result.isConfirmed) {
                    // ✅ 검색조건 초기화 → 기본 목록으로 이동
                    window.location.href = `${contextPath}/inbound/management`;
                }
            });
        });
    }
});

document.addEventListener("keydown", function (e) {
    // F5 키 코드 = 116
    if (e.key === "F5" || e.keyCode === 116) {
        e.preventDefault(); // ✅ 기본 새로고침 막기
        Swal.fire({
            icon: "question",
            title: "검색조건을 초기화하시겠습니까?",
            text: "확인 시 현재 검색 조건이 모두 초기화되고 목록이 처음부터 표시됩니다.",
            showCancelButton: true,
            confirmButtonText: "예",
            cancelButtonText: "아니오"
        }).then(result => {
            if (result.isConfirmed) {
                // ✅ 검색조건 리셋 후 첫 페이지 이동
                window.location.href = `${contextPath}/inbound/management`;
            }
        });
    }
});
