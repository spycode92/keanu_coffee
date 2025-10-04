/**
 * inboundManagement.js (최종 수정 버전)
 * - 상세검색 토글 / 새로고침 / 행 클릭 이동 / Ajax 페이징
 * - safeNavigate 수정 (about:blank 방지)
 * - fetchPage → /management/data 전용으로 고정
 */

function clearInput(id) {
	const el = document.getElementById(id);
	if (el) { el.value = ""; el.focus(); }
}

function updateSelectedCount() {
	const count = document.querySelectorAll('input[name="selectedOrder"]:checked').length;
	const el = document.getElementById("selectedCount");
	if (el) el.textContent = count;
}

function paramsToObj(params) {
	if (params instanceof URLSearchParams) return Object.fromEntries(params.entries());
	return params || {};
}

/* ✅ safeNavigate: contextPath 기반 절대경로 이동 */
function safeNavigate(rawUrl) {
	if (!rawUrl) return;
	if (rawUrl.startsWith("http")) {
		window.location.href = rawUrl;
	} else {
		window.location.href = `${contextPath}${rawUrl}`;
	}
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

	// --- 상세검색 토글 ---
	const toggleDetailBtn = document.getElementById("toggleDetailSearchBtn");
	const backToSimpleBtn = document.getElementById("backToSimpleBtn");
	const detailForm = document.getElementById("detailSearchForm");
	const simpleForm = document.getElementById("simpleSearchForm");

	if (toggleDetailBtn) {
		toggleDetailBtn.addEventListener("click", function () {
			if (!detailForm || !simpleForm) return;
			if (detailForm.style.display === "none" || detailForm.style.display === "") {
				detailForm.style.display = "block";
				simpleForm.style.display = "none";
				this.textContent = "상세검색 닫기";
			} else {
				detailForm.style.display = "none";
				simpleForm.style.display = "block";
				this.textContent = "상세검색";
			}
		});
	}

	if (backToSimpleBtn) {
		backToSimpleBtn.addEventListener("click", function () {
			if (detailForm) detailForm.style.display = "none";
			if (simpleForm) simpleForm.style.display = "block";
			if (toggleDetailBtn) toggleDetailBtn.textContent = "상세검색";
		});
	}

	// --- 새로고침 ---
	const reloadBtn = document.getElementById("btnReload");
	if (reloadBtn) {
		reloadBtn.addEventListener("click", function (e) {
			e.preventDefault();

			const simpleKeyword = document.getElementById("simpleItemKeyword");
			if (simpleKeyword) simpleKeyword.value = "";
			if (detailForm) {
				detailForm.reset();
				["status","orderInboundKeyword","vendorKeyword","inStartDate","inEndDate"].forEach(id=>{
					const el = document.getElementById(id);
					if (el) el.value = "";
				});
			}
			const btnMyListFilter = document.getElementById("btnMyListFilter");
			if (btnMyListFilter) {
				btnMyListFilter.dataset.active = "false";
				btnMyListFilter.classList.remove("active");
			}

			const params = new URLSearchParams();
			params.set("pageNum", "1");

			fetchPage(params)
				.then(data => {
					renderTable(data.list);
					renderPaging(data.pageInfo, params);
					const totalEl = document.querySelector(".card-title span strong");
					if (totalEl) totalEl.textContent = data.totalCount;
					Swal.fire({ icon:"success", title:"초기화 완료", text:"검색조건과 담당 필터가 초기화되었습니다 ✅" });
				})
				.catch(err => console.error("reload ajax error:", err));
		});
	}

	// --- 전체선택 ---
	const selectAll = document.querySelector(".select-all");
	if (selectAll) {
		selectAll.addEventListener("change", function (e) {
			const checked = e.target.checked;
			document.querySelectorAll('tbody input[name="selectedOrder"]').forEach(cb => cb.checked = checked);
			updateSelectedCount();
		});
	}
	document.addEventListener("change", function (e) {
		if (e.target.matches('input[name="selectedOrder"]')) {
			const boxes = document.querySelectorAll('tbody input[name="selectedOrder"]');
			const allChecked = boxes.length > 0 && Array.from(boxes).every(cb => cb.checked);
			if (selectAll) selectAll.checked = allChecked;
			updateSelectedCount();
		}
	});

	// --- 간단 검색 유효성 ---
	if (simpleForm) {
		simpleForm.addEventListener("submit", function (e) {
			const keywordEl = document.getElementById("simpleItemKeyword");
			const keyword = keywordEl ? keywordEl.value.trim() : "";
			if (!keyword) {
				e.preventDefault();
				Swal.fire({ icon:"warning", title:"입력 필요", text:"발주번호 또는 입고번호를 입력하세요." });
			}
		});
	}

	// --- 상세 검색 유효성 ---
	if (detailForm) {
		detailForm.addEventListener("submit", function (e) {
			const status = document.getElementById("status").value;
			const orderInboundKeyword = document.getElementById("orderInboundKeyword").value.trim();
			const vendorKeyword = document.getElementById("vendorKeyword").value.trim();
			const inStartDate = document.getElementById("inStartDate").value;
			const inEndDate = document.getElementById("inEndDate").value;
			const managerKeyword = document.getElementById("managerKeyword").value.trim();

			if (!status && !orderInboundKeyword && !vendorKeyword && !inStartDate && !inEndDate && !managerKeyword) {
				e.preventDefault();
				Swal.fire({ icon:"warning", title:"검색 조건 없음", text:"최소 한 가지 조건을 입력하세요." });
			}
		});
	}
	
	
	
	// --- F5 방지 → 초기화 여부 질의 ---
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

	// --- 담당건만 보기 토글 ---
	const btnMyListFilter = document.getElementById("btnMyListFilter");
	if (btnMyListFilter) {
		btnMyListFilter.addEventListener("click", function () {
			const active = this.dataset.active === "true";
			const newActive = !active;
			this.dataset.active = newActive;
			this.classList.toggle("active", newActive);

			const params = new URLSearchParams(window.location.search);
			if (newActive) params.set("myOnly", "Y"); else params.delete("myOnly");
			params.set("pageNum", "1");

			fetchPage(params)
				.then(data => {
					renderTable(data.list);
					renderPaging(data.pageInfo, params);
					const totalEl = document.querySelector(".card-title span strong");
					if (totalEl) totalEl.textContent = data.totalCount;
				})
				.catch(err => console.error("myOnly ajax error:", err));
		});
	}

	// --- 행 클릭 시 상세 이동 ---
	document.addEventListener("click", function(e) {
		const row = e.target.closest("tr.clickable-row");
		if (!row) return;
		if (e.target.closest("input[type=checkbox], button, a")) return;

		const url = row.getAttribute("data-url");
		if (!url) return;

		Swal.fire({
			title: "입고 상세 페이지로 이동",
			text: "선택한 입고건 상세 페이지로 이동하시겠습니까?",
			icon: "question",
			showCancelButton: true,
			confirmButtonText: "이동",
			cancelButtonText: "취소"
		}).then(result => {
			if (result.isConfirmed) {
				safeNavigate(url);
			}
		});
	});

	// --- 초기 로드 ---
	const initialParams = new URLSearchParams(window.location.search);
	if (!initialParams.has("pageNum")) initialParams.set("pageNum", "1");

	fetchPage(initialParams)
		.then(data => {
			renderTable(data.list);
			renderPaging(data.pageInfo, initialParams);
			const totalEl = document.querySelector(".card-title span strong");
			if (totalEl) totalEl.textContent = data.totalCount;
		})
		.catch(err => console.error("initial ajax error:", err));
});

// ================================
// Ajax XHR with common.js
// ================================
function fetchPage(params) {
	// ✅ 항상 /management/data 로 호출
	return ajaxGet(`${contextPath}/inbound/management/data`, paramsToObj(params));
}

// ================================
// 테이블 렌더링
// ================================
function renderTable(list) {
	const tbody = document.querySelector("tbody");
	tbody.innerHTML = "";

	if (!list || list.length === 0) {
		tbody.innerHTML = `<tr><td colspan="11" class="text-center">입고 데이터가 존재하지 않습니다.</td></tr>`;
		return;
	}

	list.forEach(order => {
		const row = document.createElement("tr");
		row.classList.add("clickable-row");

		const orderNumber = order.orderNumber ? encodeURIComponent(order.orderNumber) : "";
		const ibwaitIdx = order.ibwaitIdx != null ? encodeURIComponent(order.ibwaitIdx) : "";

		row.setAttribute("data-url", `${contextPath}/inbound/inboundDetail?orderNumber=${orderNumber}&ibwaitIdx=${ibwaitIdx}`);
		
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
	
	console.log(maxPage);
	
	if (maxPage <= 1) return;
	
	if (pageNum > 1) {
		pagingButtons.appendChild(createPageButton("« 처음", 1, params));
		pagingButtons.appendChild(createPageButton("‹ 이전", pageNum - 1, params));
	}

	const maxButtons = 5;
	let start = pageNum - Math.floor((maxButtons - 1) / 2);
	let end = start + maxButtons - 1;

	if (start < 1) { start = 1; end = Math.min(maxButtons, maxPage); }
	if (end > maxPage) { end = maxPage; start = Math.max(1, end - (maxButtons - 1)); }

	for (let i = start; i <= end; i++) {
		pagingButtons.appendChild(createPageButton(i, i, params, i === pageNum));
	}

	if (pageNum < maxPage) {
		pagingButtons.appendChild(createPageButton("다음 ›", pageNum + 1, params));
		pagingButtons.appendChild(createPageButton("끝 »", maxPage, params));
	}
}

function createPageButton(label, page, params, active = false) {
	const btn = document.createElement("button");
	btn.textContent = label;
	btn.className = `btn btn-sm ${active ? "btn-primary" : "btn-secondary"}`;
	btn.addEventListener("click", function () {
		params.set("pageNum", page);
		fetchPage(params)
			.then(data => {
				renderTable(data.list);
				renderPaging(data.pageInfo, params);
				const totalEl = document.querySelector(".card-title span strong");
				if (totalEl) totalEl.textContent = data.totalCount;
			})
			.catch(err => console.error("paging ajax error:", err));
	});
	return btn;
}

// ================================
// 상세검색 초기화 버튼 (모든 입력값 null 처리 + Swal 알림)
// ================================
document.addEventListener("DOMContentLoaded", function () {
	const resetBtn = document.querySelector("#detailSearchForm .btn-reset");
	if (resetBtn) {
		resetBtn.addEventListener("click", function (e) {
			e.preventDefault(); // 기본 reset 동작 막기

			const inputs = document.querySelectorAll("#detailSearchForm input, #detailSearchForm select");
			inputs.forEach(el => {
				if (el.tagName === "SELECT") {
					el.selectedIndex = 0; // select는 첫 옵션으로
				} else {
					el.value = ""; // input은 비우기
				}
			});

			Swal.fire({
				icon: "success",
				title: "초기화 완료",
				text: "상세검색 조건이 모두 초기화되었습니다 ✅"
			});
		});
	}
});
