// 테이블 요소 캐싱
const itemsTable = document.getElementById("itemsTable");
let currentRow = null;

// ------------------------
// 뒤로가기 버튼
// ------------------------
document.getElementById("btnBack").addEventListener("click", function(e) {
	e.preventDefault();
	history.back();
});

// ------------------------
// 검수완료 버튼 AJAX
// ------------------------
itemsTable.querySelectorAll("tbody .inspection input[type=button]").forEach(btn => {
	btn.addEventListener("click", function() {
		const row = btn.closest("tr");

		// 1) 스캔 검증 여부 확인
		if (row.dataset.lotVerified !== "true") {
			Swal.fire("경고", "LOT 번호 스캔 및 일치 확인이 필요합니다 ❌", "warning");
			return;
		}

		// 2) 스캔 LOT 가져오기
		const scannedLot = row.querySelector('input[name=scannedLotNumber]')?.value || "";
		if (!scannedLot) {
			Swal.fire("경고", "스캔된 LOT 번호가 없습니다 ❌", "warning");
			return;
		}

		const payload = {
		    ibwaitIdx:  document.getElementById("inboundLink").dataset.ibwaitIdx,
		    productIdx: row.dataset.productIdx,
		    lotNumber:  scannedLot,
		    quantity:   row.querySelector(".quantity").value,
		    unitPrice:  row.querySelector(".unitPrice").value,
		    amount:     row.querySelector(".amount").dataset.value,
		    tax:        row.querySelector(".tax").dataset.value,
		    totalPrice: row.querySelector(".totalPrice").dataset.value,
		    supplierIdx: document.getElementById("inboundLink").dataset.supplierIdx
		};

		const { token, header } = getCsrf();

		$.ajax({
			url: "/inbound/inspectionComplete",
			type: "POST",
			data: JSON.stringify(payload),
			contentType: "application/json",
			beforeSend: function(xhr) {
				if (header && token) xhr.setRequestHeader(header, token);
			},
			success: function(res) {
				if (res.ok) {
					Swal.fire("성공", "검수완료 처리됨 ✅", "success");

					// 입력/버튼 잠금
					row.querySelector(".quantity").disabled  = true;
					row.querySelector(".unitPrice").disabled = true;

					// 검수완료 버튼 상태 변경
					btn.value = "검수완료됨";
					btn.classList.remove("btn-secondary");
					btn.classList.add("btn-confirmed");
					btn.disabled = true;

					// LOT 스캔 버튼 비활성화
					const lotBtn = row.querySelector(".btn-lotScan");
					if (lotBtn) {
						lotBtn.disabled = true;
						lotBtn.classList.remove("btn-sm");
						lotBtn.classList.add("btn-confirmed");
					}

					// 전체 완료 시 입고확정 활성화
					const allDone = Array.from(itemsTable.querySelectorAll("tbody .inspection input[type=button]"))
						.every(b => b.disabled);
					if (allDone) {
						const commitBtn = document.getElementById("btnCommit");
						commitBtn.disabled = false; // ✅ 확실하게 활성화
					}

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

// ------------------------
// 입고확정 버튼 AJAX
// ------------------------
document.getElementById("btnCommit").addEventListener("click", function() {
	// 사용자가 F12로 disabled 제거해도 방어
	if (this.disabled) {
		Swal.fire("경고", "모든 품목 검수완료 후 확정할 수 있습니다 ❌", "warning");
		return;
	}

	const ibwaitIdx = document.getElementById("inboundLink").dataset.ibwaitIdx;
	const { token, header } = getCsrf();

	Swal.fire({
		title: "입고확정",
		text: "모든 검수완료 품목을 확정 처리하시겠습니까?",
		icon: "question",
		showCancelButton: true,
		confirmButtonText: "예",
		cancelButtonText: "아니오"
	}).then(result => {
		if (result.isConfirmed) {
			$.ajax({
				url: "/inbound/commitInbound",
				type: "POST",
				data: JSON.stringify({ ibwaitIdx: ibwaitIdx }),
				contentType: "application/json",
				beforeSend: function(xhr) {
					if (header && token) xhr.setRequestHeader(header, token);
				},
				success: function(res) {
				    if (res.ok) {
				        Swal.fire("성공", "입고확정 처리 완료 ✅", "success")
				            .then(() => {
				                const ibwaitIdx = document.getElementById("inboundLink").dataset.ibwaitIdx;
				                const orderNumber = document.getElementById("inboundLink").dataset.orderNumber;
				
				                location.href = `/inbound/inboundDetail?orderNumber=${orderNumber}&ibwaitIdx=${ibwaitIdx}`;
				            });
				    } else {
				        Swal.fire("실패", "입고확정 처리 실패 ❌", "error");
				    }
				},
				error: function(xhr) {
					Swal.fire("에러", "서버 오류 발생: " + xhr.status, "error");
				}
			});
		}
	});
});

// ------------------------
// 수동 입력 (모달 안에서 expectedLot 비교)
// ------------------------
document.addEventListener("DOMContentLoaded", () => {
    const btnManualInput  = document.getElementById("btnManualInput");
    const manualInputArea = document.getElementById("manualInputArea");
    const manualLotNumber = document.getElementById("manualLotNumber");
    const btnApplyManual  = document.getElementById("btnApplyManual");
    const qrModal         = document.getElementById("qrModal");

    // ① 수동 입력 버튼 클릭 → 입력칸 보이기
    btnManualInput?.addEventListener("click", () => {
        manualInputArea.style.display = "block";
        manualLotNumber.focus();
    });

    // ② 적용 버튼 클릭 → 현재 행의 expectedLot과 비교
    btnApplyManual?.addEventListener("click", () => {
	    const lotValue = manualLotNumber.value.trim();
	    const expectedLot = document.getElementById("qrModal").dataset.expectedLot;
	
	    if (!lotValue) {
	        Swal.fire("알림", "LOT 번호를 입력하세요 ❌", "warning");
	        return;
	    }
	
	    if (lotValue === expectedLot) {
	        currentRow.querySelector("input[name=scannedLotNumber]").value = lotValue;
	        currentRow.querySelector(".lotNumberDisplay").textContent = lotValue;
	        currentRow.dataset.lotVerified = "true";
			
			//  스캔 버튼 숨기기
			const lotBtn = currentRow.querySelector(".btn-lotScan");
			if (lotBtn) {
			    lotBtn.style.display = "none";   // 버튼 아예 안 보이게
			}
			
	        Swal.fire("성공", "LOT 번호가 일치합니다 ✅", "success").then(() => {
	            ModalManager.closeModalById("qrModal");
	        });
	    } else {
	        Swal.fire("실패", `LOT 번호가 일치하지 않습니다 ❌<br>기대값: ${expectedLot}`, "error");
	    }
	});


});

