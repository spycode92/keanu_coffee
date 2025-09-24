/**
 * inboundManagement.js - 입고관리 전용 스크립트
 * 기존 기능 + 행 전체 클릭 이동 기능 + Ajax 페이징
 */

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

	// --- 간단 검색 ---
	const simpleForm = document.getElementById("simpleSearchForm");
	if (simpleForm) {
		simpleForm.addEventListener("submit", function (e) {
			const keyword = document.getElementById("simpleItemKeyword").value.trim();
			if (!keyword) {
				e.preventDefault();
				Swal.fire({
					icon: "warning",
					title: "입력 필요",
					text: "발주번호 또는 입고번호를 입력하세요.",
					confirmButtonText: "확인"
				});
			}
		});
	}

	// --- 상세 검색 ---
	const detailForm = document.getElementById("detailSearchForm");
	if (detailForm) {
		detailForm.addEventListener("submit", function (e) {
			const status = document.getElementById("status").value;
			const orderInboundKeyword = document.getElementById("orderInboundKeyword").value.trim();
			const vendorKeyword = document.getElementById("vendorKeyword").value.trim();
			const inStartDate = document.getElementById("inStartDate").value;
			const inEndDate = document.getElementById("inEndDate").value;

			if (!status && !orderInboundKeyword && !vendorKeyword && !inStartDate && !inEndDate) {
				e.preventDefault();
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

			if (selectAll) selectAll.checked = false;
			document.querySelectorAll('tbody input[name="selectedOrder"]').forEach(cb => cb.checked = false);

			updateSelectedCount();
		});
	}

	// --- F5 새로고침 막기 ---
	document.addEventListener("keydown", function (e) {
		if (e.key === "F5" || e.keyCode === 116) {
			e.preventDefault();
			Swal.fire({
				icon: "question",
				title: "페이지를 초기화하시겠습니까?",
				html: "확인 시 현재 입력값 모두 초기화되고<br>목록이 처음부터 표시됩니다.",
				showCancelButton: true,
				confirmButtonText: "예",
				cancelButtonText: "아니오"
			}).then(result => {
				if (result.isConfirmed) {
					window.location.href = `${contextPath}/inbound/management`;
				}
			});
		}
	});

	// --- 내 담당건만 보기 필터 ---
	const btnMyListFilter = document.getElementById("btnMyListFilter");
	if (btnMyListFilter) {
	    btnMyListFilter.addEventListener("click", function () {
	        const active = this.dataset.active === "true";
	        const newActive = !active;
	        this.dataset.active = newActive;
	        this.classList.toggle("active", newActive);

	        const params = new URLSearchParams(window.location.search);
	        if (newActive) {
	            params.set("myOnly", "Y");
	        } else {
	            params.delete("myOnly");
	        }

	        // 무조건 첫 페이지부터 시작
	        params.set("pageNum", "1");

	        fetchData(params);
	    });
	}

	const initialParams = new URLSearchParams(window.location.search);
	if (!initialParams.has("pageNum")) {
	    initialParams.set("pageNum", "1");
	}
	fetchData(initialParams);

});

// ================================
// Ajax 데이터 요청 함수
// ================================
function fetchData(params) {
    fetch(`${contextPath}/inbound/management/data?${params.toString()}`)
        .then(res => res.json())
        .then(data => {
            renderTable(data.list);
            renderPaging(data.pageInfo, params);
            document.querySelector(".card-title span strong").textContent = data.totalCount;
        });
}

// ================================
// 테이블 렌더링
// ================================
function renderTable(list) {
    const tbody = document.querySelector("tbody");
    tbody.innerHTML = "";

    if (list.length === 0) {
        tbody.innerHTML = `<tr><td colspan="11" class="text-center">입고 데이터가 존재하지 않습니다.</td></tr>`;
        return;
    }

    list.forEach(order => {
        const row = document.createElement("tr");
        row.classList.add("clickable-row");
        row.innerHTML = `
            <td><input type="checkbox" name="selectedOrder" value="${order.ibwaitIdx}"></td>
            <td>${order.orderNumber ?? "-"}</td>
            <td>${order.ibwaitNumber ?? "-"}</td>
            <td>${order.arrivalDateStr ?? "-"}</td>
            <td>${order.supplierName ?? "-"}</td>
            <td>${order.inboundStatus ?? "-"}</td>
            <td>${order.numberOfItems ?? "-"}</td>
            <td>${order.quantity ?? "-"}</td>
            <td>${order.manager ?? "-"}</td>
            <td>${order.note ?? "-"}</td>
        `;
        tbody.appendChild(row);
    });
}

// ================================
// 페이징 렌더링
// ================================
function renderPaging(pageInfo, params) {
    const pageNum = pageInfo.pageNum;
    const maxPage = pageInfo.maxPage;
    const pagingButtons = document.getElementById("pagingButtons");

    document.getElementById("pageNum").textContent = pageNum;
    document.getElementById("maxPage").textContent = maxPage;

    pagingButtons.innerHTML = "";

    // « 처음
    if (pageNum > 1) {
        const first = createPageButton("« 처음", 1, params);
        pagingButtons.appendChild(first);
        const prev = createPageButton("‹ 이전", pageNum - 1, params);
        pagingButtons.appendChild(prev);
    }

    const maxButtons = 5;
    let start = pageNum - Math.floor((maxButtons - 1) / 2);
    let end = start + maxButtons - 1;

    if (start < 1) {
        start = 1;
        end = Math.min(maxButtons, maxPage);
    }
    if (end > maxPage) {
        end = maxPage;
        start = Math.max(1, end - (maxButtons - 1));
    }

    for (let i = start; i <= end; i++) {
        const btn = createPageButton(i, i, params, i === pageNum);
        pagingButtons.appendChild(btn);
    }

    // 다음 › , 끝 »
    if (pageNum < maxPage) {
        const next = createPageButton("다음 ›", pageNum + 1, params);
        pagingButtons.appendChild(next);
        const last = createPageButton("끝 »", maxPage, params);
        pagingButtons.appendChild(last);
    }
}

function createPageButton(label, page, params, active = false) {
    const btn = document.createElement("button");
    btn.textContent = label;
    btn.className = `btn btn-sm ${active ? "btn-primary" : "btn-secondary"}`;
    btn.addEventListener("click", function () {
        params.set("pageNum", page);
        fetchData(params);
    });
    return btn;
}
