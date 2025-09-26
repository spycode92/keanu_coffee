/**
 * inboundInspection.js - 입고 검수 페이지 전용 스크립트
 * SweetAlert2, jQuery 필요
 */

document.addEventListener("DOMContentLoaded", () => {

	// ===== 캐싱 =====
	const itemsTable = document.getElementById("itemsTable");
	const btnBack    = document.getElementById("btnBack");
	const btnCommit  = document.getElementById("btnCommit");

	// ❌ let currentRow = null;  → 전역(window.currentRow) 사용

	// ------------------------
	// 뒤로가기 버튼
	// ------------------------
	btnBack?.addEventListener("click", (e) => {
		e.preventDefault();
		history.back();
	});

	// ------------------------
	// 검수완료 버튼 AJAX
	// ------------------------
	itemsTable?.querySelectorAll("tbody .inspection input[type=button]").forEach(btn => {
		btn.addEventListener("click", function () {
			const row = btn.closest("tr");
			window.currentRow = row;

			// 1) 스캔 검증 여부
			if (row.dataset.lotVerified !== "true") {
				Swal.fire("경고", "LOT 번호 스캔 및 일치 확인이 필요합니다 ❌", "warning");
				return;
			}

			// 2) 스캔 LOT 번호 가져오기
			const scannedLot = row.querySelector('input[name=scannedLotNumber]')?.value || "";
			if (!scannedLot) {
				Swal.fire("경고", "스캔된 LOT 번호가 없습니다 ❌", "warning");
				return;
			}

			const payload = {
				ibwaitIdx:       document.getElementById("inboundLink").dataset.ibwaitIdx,
				productIdx:      row.dataset.productIdx,
				lotNumber:       scannedLot,
				quantity:        row.querySelector(".quantity").value,
				unitPrice:       row.querySelector(".unitPrice").value,
				amount:          row.querySelector(".amount").value,
				tax:             row.querySelector(".tax").value,
				totalPrice:      row.querySelector(".totalPrice").value,
				supplierIdx:     document.getElementById("inboundLink").dataset.supplierIdx,
				manufactureDate: row.querySelector("input[name=manufactureDate]").value,
				expirationDate:  row.querySelector("input[name=expirationDate]").value,
				receiptProductIdx: row.querySelector('input[name="receiptProductIdx"]')?.value
			};

			const { token, header } = getCsrf();

			        $.ajax({
			            url: "/inbound/inspectionComplete",
			            type: "POST",
			            data: JSON.stringify(payload),
			            contentType: "application/json",
			            beforeSend: xhr => {
			                if (header && token) xhr.setRequestHeader(header, token);
			            },
			            success: (res) => {
			                if (res.ok) {
			                    let hidden = row.querySelector("input[name=receiptProductIdx]");
			                    if (!hidden) {                                                             
			                        hidden = document.createElement("input");
			                        hidden.type = "hidden";
			                        hidden.name = "receiptProductIdx";
			                        row.appendChild(hidden);
			                    }
			                    hidden.value = res.receiptProductIdx;
			
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
			
			                    // 모든 품목 완료 시 입고확정 버튼 활성화
			                    const allDone = Array.from(itemsTable.querySelectorAll("tbody .inspection input[type=button]"))
			                        .every(b => b.disabled);
			                    if (allDone && btnCommit) btnCommit.disabled = false;
			                } else {
			                    Swal.fire("실패", "처리 실패 ❌", "error");
			                }
			            },
			            error: xhr => {
			                Swal.fire("에러", "서버 오류 발생: " + xhr.status, "error");
			            }
			        });
			    });
			});


	// ------------------------
	// 입고확정 버튼 AJAX
	// ------------------------
	btnCommit?.addEventListener("click", function () {
	    if (this.disabled) {
	        Swal.fire("경고", "모든 품목 검수완료 후 확정할 수 있습니다 ❌", "warning");
	        return;
	    }
	
	    const fieldInboundLocation = document.getElementById("fieldInboundLocation");
	    const locationIdx  = fieldInboundLocation?.dataset.idx;
	    const locationName = fieldInboundLocation?.textContent.trim();
	
	    if (!locationIdx || !locationName || locationName === "-") {
	        Swal.fire("경고", "입고위치가 지정되지 않았습니다 ❌", "warning");
	        return;
	    }
	
	    const ibwaitIdx = document.getElementById("inboundLink").dataset.ibwaitIdx;
	
	    // 품목 리스트 수집
	    const items = [];
	    document.querySelectorAll("#itemsTable tbody tr").forEach(row => {
	        if (row.dataset.productIdx) {
	            items.push({
				    productIdx: row.dataset.productIdx,
				    receiptProductIdx: row.querySelector("input[name=receiptProductIdx]")?.value, 
				    lotNumber: row.querySelector("input[name=scannedLotNumber]").value,
				    quantity: row.querySelector(".quantity").value,
				    manufactureDate: row.querySelector("input[name=manufactureDate]").value,
				    expirationDate: row.querySelector("input[name=expirationDate]").value,
				    locationIdx: locationIdx,
				    locationName: locationName
				});
	        }
	    });
	
	    const payload = { ibwaitIdx, items };
	
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
	                data: JSON.stringify(payload),
	                contentType: "application/json",
	                beforeSend: xhr => {
	                    if (header && token) xhr.setRequestHeader(header, token);
	                },
	                success: res => {
					    if (res.ok) {
					        const ibwaitIdx   = document.getElementById("inboundLink").dataset.ibwaitIdx;
					        const orderNumber = document.getElementById("inboundLink").dataset.orderNumber;
					
					        Swal.fire("성공", "입고확정 처리 완료 ✅", "success")
					            .then(() => {
					                // ✅ detail 페이지로 이동
					                window.location.href = contextPath + "/inbound/inboundDetail?ibwaitIdx=" + ibwaitIdx + "&orderNumber=" + orderNumber;
					            });
					    } else {
					        Swal.fire("실패", "입고확정 처리 실패 ❌", "error");
					    }
					},
	                error: xhr => {
	                    Swal.fire("에러", "서버 오류 발생: " + xhr.status, "error");
	                }
	            });
	        }
	    });
	});

	// ------------------------
	// 수동 입력 처리
	// ------------------------
	const btnManualInput  = document.getElementById("btnManualInput");
	const manualInputArea = document.getElementById("manualInputArea");
	const manualLotNumber = document.getElementById("manualLotNumber");
	const btnApplyManual  = document.getElementById("btnApplyManual");

	btnManualInput?.addEventListener("click", () => {
		manualInputArea.style.display = "block";
		manualLotNumber.focus();
	});

	btnApplyManual?.addEventListener("click", () => {
		if (!window.currentRow) {
			Swal.fire("에러", "적용할 행을 찾을 수 없습니다 ❌", "error");
			return;
		}

		const lotValue    = manualLotNumber.value.trim();
		const expectedLot = document.getElementById("qrModal").dataset.expectedLot;

		if (!lotValue) {
			Swal.fire("알림", "LOT 번호를 입력하세요 ❌", "warning");
			return;
		}
		if (lotValue === expectedLot) {
			const targetInput = window.currentRow.querySelector("input[name=scannedLotNumber]");
			if (!targetInput) {
				Swal.fire("에러", "LOT 입력 필드를 찾을 수 없습니다 ❌", "error");
				return;
			}
			targetInput.value = lotValue;
			window.currentRow.querySelector(".lotNumberDisplay").textContent = lotValue;
			window.currentRow.dataset.lotVerified = "true";

			Swal.fire("성공", "LOT 번호가 일치합니다 ✅", "success")
				.then(() => ModalManager.closeModalById("qrModal"));
		} else {
			Swal.fire("실패", `LOT 번호가 일치하지 않습니다 ❌<br>기대값: ${expectedLot}`, "error");
		}
	});

	// ------------------------
	// 금액 계산
	// ------------------------
	function recalcTotals() {
		let grandTotal = 0;

		document.querySelectorAll("#itemsTable tbody tr").forEach(row => {
			const qtyInput      = row.querySelector(".quantity");
			const unitPriceInput= row.querySelector(".unitPrice");
			if (!qtyInput || !unitPriceInput) return;

			const quantity  = parseInt(qtyInput.value) || 0;
			const unitPrice = parseFloat(unitPriceInput.value) || 0;

			const amount     = quantity * unitPrice;
			const tax        = amount * 0.1;
			const totalPrice = amount + tax;

			row.querySelector(".amount").value      = amount;
			row.querySelector(".tax").value         = tax;
			row.querySelector(".totalPrice").value  = totalPrice;

			grandTotal += totalPrice;
		});

		const overallTotal = document.getElementById("overallTotalPrice");
		if (overallTotal) {
			overallTotal.textContent = "₩ " + grandTotal.toLocaleString();
		}
	}

	document.querySelectorAll(".quantity").forEach(input => {
		input.addEventListener("input", recalcTotals);
	});
	document.querySelectorAll(".unitPrice").forEach(input => {
		input.addEventListener("input", recalcTotals);
	});
	recalcTotals();

	// ------------------------
	// F5 새로고침 차단
	// ------------------------
	document.addEventListener("keydown", (e) => {
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
					window.location.href = window.location.pathname + window.location.search;
				}
			});
		}
	});

	// ------------------------
	// 모달 닫힘 시 aria-hidden 강제 제거 (버튼 클릭 차단 방지)
	// ------------------------
	document.querySelectorAll(".modal").forEach(modal => {
		modal.addEventListener("transitionend", () => {
			if (!modal.classList.contains("open")) {
				modal.removeAttribute("aria-hidden"); // ✅ 버튼 차단 해제
			}
		});
	});

});
