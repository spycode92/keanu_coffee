console.log("inboundInspection.js loaded");

document.addEventListener("DOMContentLoaded", function() {

	// ------------------------
	// 뒤로가기 버튼
	// ------------------------
	const backBtn = document.getElementById("btnBack");
	if (backBtn) {
		backBtn.addEventListener("click", function(e) {
			e.preventDefault();
			history.back();
		});
	}

	// ------------------------
	// 금액 포맷
	// ------------------------
	function formatCurrency(value) {
		return "₩ " + Number(value).toLocaleString();
	}

	// ------------------------
	// 전체 합계 갱신
	// ------------------------
	function updateGrandTotal() {
		let grandTotal = 0;
		document.querySelectorAll("#itemsTable tbody .totalPrice").forEach(td => {
			const val = td.dataset.value ? parseFloat(td.dataset.value) : 0;
			grandTotal += val;
		});

		// 하단 합계
		const grandTotalCell = document.getElementById("grandTotalCell");
		if (grandTotalCell) grandTotalCell.textContent = formatCurrency(grandTotal);

		// 상단 총 금액
		const overallTotalPrice = document.getElementById("overallTotalPrice");
		if (overallTotalPrice) overallTotalPrice.textContent = formatCurrency(grandTotal);
	}

	// ------------------------
	// 행 계산
	// ------------------------
	function recalcRow(row) {
		const qtyInput  = row.querySelector(".quantity");
		const unitInput = row.querySelector(".unitPrice");

		const quantity  = parseFloat(qtyInput?.value)  || 0;
		const unitPrice = parseFloat(unitInput?.value) || 0;

		const amount     = quantity * unitPrice;
		const tax        = amount * 0.1;
		const totalPrice = amount + tax;

		const amountCell = row.querySelector(".amount");
		const taxCell    = row.querySelector(".tax");
		const totalCell  = row.querySelector(".totalPrice");

		if (amountCell) {
			amountCell.textContent = formatCurrency(amount);
			amountCell.dataset.value = amount;
		}
		if (taxCell) {
			taxCell.textContent = formatCurrency(tax);
			taxCell.dataset.value = tax;
		}
		if (totalCell) {
			totalCell.textContent = formatCurrency(totalPrice);
			totalCell.dataset.value = totalPrice;
		}

		updateGrandTotal();
	}

	// ------------------------
	// itemsTable 존재하는 경우에만 실행
	// ------------------------
	const itemsTable = document.getElementById("itemsTable");
	if (!itemsTable) {
		console.log("No itemsTable on this page. JS aborted.");
		return; // 로그인 화면 같은 곳에서는 바로 종료
	}

	// ------------------------
	// 초기화: 모든 행의 dataset 채우기 + 이벤트 바인딩
	// ------------------------
	itemsTable.querySelectorAll("tbody tr").forEach(row => {
		const amountCell = row.querySelector(".amount");
		const taxCell    = row.querySelector(".tax");
		const totalCell  = row.querySelector(".totalPrice");

		if (amountCell) amountCell.dataset.value = amountCell.textContent.replace(/[^0-9.-]/g, "") || 0;
		if (taxCell)    taxCell.dataset.value    = taxCell.textContent.replace(/[^0-9.-]/g, "") || 0;
		if (totalCell)  totalCell.dataset.value  = totalCell.textContent.replace(/[^0-9.-]/g, "") || 0;

		// 이벤트 바인딩
		const qtyInput  = row.querySelector(".quantity");
		const unitInput = row.querySelector(".unitPrice");

		if (qtyInput)  qtyInput.addEventListener("input", () => recalcRow(row));
		if (unitInput) unitInput.addEventListener("input", () => recalcRow(row));
	});

	// 페이지 로드시 합계 갱신
	updateGrandTotal();

	// ------------------------
	// CSRF 토큰 가져오기 (없으면 기본 null)
	// ------------------------
	let token = null;
	let header = null;
	const csrfMeta = document.querySelector("meta[name='_csrf']");
	const csrfHeaderMeta = document.querySelector("meta[name='_csrf_header']");
	if (csrfMeta && csrfHeaderMeta) {
		token = csrfMeta.getAttribute("content");
		header = csrfHeaderMeta.getAttribute("content");
		console.log("CSRF token loaded");
	} else {
		console.warn("CSRF meta tags not found");
	}

	// ------------------------
	// 검수완료 버튼 AJAX
	// ------------------------
	itemsTable.querySelectorAll("tbody .inspection input[type=button]").forEach(btn => {
	    btn.addEventListener("click", function() {
	        const row = btn.closest("tr");

	        const payload = {
	            ibwaitIdx: document.getElementById("inboundLink").dataset.ibwaitIdx,
			    productIdx: row.dataset.productIdx,
			    lotNumber:  row.querySelector("input[name=lotNumber]").value,
			    quantity:   row.querySelector(".quantity").value,
			    unitPrice:  row.querySelector(".unitPrice").value,
			    amount:     row.querySelector(".amount").dataset.value,
			    tax:        row.querySelector(".tax").dataset.value,
			    totalPrice: row.querySelector(".totalPrice").dataset.value
	        };

	        $.ajax({
	            url: "/inbound/inspectionComplete",
	            type: "POST",
	            data: JSON.stringify(payload),
	            contentType: "application/json",
	            beforeSend: function(xhr) {
	                if (header && token) {
	                    xhr.setRequestHeader(header, token);  // ✅ CSRF 토큰 헤더 추가
	                }
	            },
	            success: function(res) {
	                if (res.ok) {
	                    Swal.fire("성공", "검수완료 처리됨 ✅", "success");
	                    btn.disabled = true;
	                } else {
	                    Swal.fire("실패", "처리 실패 ❌", "error");
	                }
	            },
	            error: function(xhr) {
	                Swal.fire("에러", "서버 오류 발생: " + xhr.status, "error");
	            }
	        });
	    });
	});
});
