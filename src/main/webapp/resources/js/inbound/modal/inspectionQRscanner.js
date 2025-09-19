(function() {
	console.log("inspectionQRscanner.js 로드됨");

	const codeReader = new ZXing.BrowserMultiFormatReader();
	let scanning = false; // ✅ 중복 방지 플래그

	function byId(id) { return document.getElementById(id); }

	// LOT칸 "스캔하기" 버튼 클릭 시 모달 열기
	window.openQrModalForRow = function(btnEl) {
		currentRow = btnEl.closest("tr"); // 버튼이 속한 행 기억
		scanning = true;
		
		const expectedLot = currentRow.querySelector("input[name=expectedLotNumber]")?.value || "";
		byId("qrModal").dataset.expectedLot = expectedLot;
		
		ModalManager.openModalById("qrModal"); // qrModal 모달 열기
		startCamera();
	};

	// 카메라 시작
	async function startCamera() {
		const videoElement = byId("qrVideo");

		try {
			await codeReader.decodeFromConstraints(
				{ video: { facingMode: { ideal: "environment" } } },
				videoElement,
				(result, err) => {
					if (!scanning) return; // ✅ 중복 방지
					
					if (result) {
					    let scannedLot = null;
					    try {
					        const data = JSON.parse(result.getText());
					        scannedLot = data.lotNumber;
					    } catch(e) {
					        Swal.fire("오류", "QR 데이터 파싱 실패 ❌", "error");
					        return;
					    }
					
					    if (!scannedLot) {
					        Swal.fire("경고", "QR에 LOT 번호가 없습니다 ❌", "warning");
					        return;
					    }
					
					    const expectedLot = currentRow.querySelector("input[name=expectedLotNumber]").value;
					
					    if (expectedLot && expectedLot !== scannedLot) {
					        Swal.fire("오류", "LOT 번호 불일치 ❌<br>기대한 값: "
					            + expectedLot + "<br>스캔된 값: " + scannedLot, "error");
					        return;
					    }
					
					    // 일치 → scannedLotNumber 채우고 화면 반영
					    currentRow.querySelector("input[name=scannedLotNumber]").value = scannedLot;
					    currentRow.querySelector(".lotNumberDisplay").textContent = scannedLot;
						
						// 성공시 lotVerified 변경
    					currentRow.dataset.lotVerified = "true";
						scanning = false;
						
					    Swal.fire("성공", "LOT 번호 확인 완료 ✅<br>" + scannedLot, "success");
	
						//  스캔 버튼 숨기기
						const lotBtn = currentRow.querySelector(".btn-lotScan");
						if (lotBtn) {
						    lotBtn.style.display = "none";   // 버튼 아예 안 보이게
						}
					
					    ModalManager.closeModalById("qrModal");
					    stopCamera();
					}


					if (err && !(err instanceof ZXing.NotFoundException)) {
						console.error("스캔 오류:", err);
					}
				}
			);
		} catch (err) {
			alert("카메라 접근 실패: " + err.message);
		}
	}

	// 카메라 종료
	function stopCamera() {
		try {
			scanning = false;
			codeReader.reset();
		} catch (e) {}
	}

	// 모달 닫힐 때 카메라 정리
	document.addEventListener("DOMContentLoaded", function() {
		const qrModal = byId("qrModal");
		if (qrModal) {
			const closeBtn = qrModal.querySelector(".modal-close-btn");
			if (closeBtn) closeBtn.addEventListener("click", stopCamera);
			qrModal.addEventListener("click", e => { if (e.target === qrModal) stopCamera(); });
		}
	});
})();

