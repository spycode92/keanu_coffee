(function() {
	console.log("inspectionQRscanner.js 로드됨");

	const codeReader = new ZXing.BrowserMultiFormatReader();
	let scanning = false; // ✅ 중복 방지 플래그

	// 전역 currentRow 선언
	window.currentRow = null;

	function byId(id) { return document.getElementById(id); }

	// LOT칸 "스캔하기" 버튼 클릭 시 모달 열기
	window.openQrModalForRow = function(btnEl) {
		window.currentRow = btnEl.closest("tr"); // ✅ 전역 currentRow 세팅
		scanning = true;

		const expectedLot = window.currentRow.querySelector("input[name=expectedLotNumber]")?.value || "";
		byId("qrModal").dataset.expectedLot = expectedLot;

		ModalManager.openModalById("qrModal");
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
					if (!scanning) return;

					if (result) {
						console.log("QR 원본:", result.getText());
						let scannedLot = null;
						let manufactureDate = null;
						let expirationDate = null;

						try {
							const data = JSON.parse(result.getText());
							scannedLot      = data.lotNumber;
							manufactureDate = data.manufactureDate;
							expirationDate  = data.expirationDate;
							console.log("파싱된 데이터:", data);
						} catch (e) {
							console.error("QR 데이터 파싱 실패:", e);
							Swal.fire("오류", "QR 데이터 파싱 실패 ❌", "error");
							return;
						}

						if (!scannedLot) {
							Swal.fire("경고", "QR에 LOT 번호가 없습니다 ❌", "warning");
							return;
						}

						const expectedLot = window.currentRow.querySelector("input[name=expectedLotNumber]").value;

						if (expectedLot && expectedLot !== scannedLot) {
							Swal.fire(
								"오류",
								"LOT 번호 불일치 ❌<br>기대한 값: "
									+ expectedLot + "<br>스캔된 값: " + scannedLot,
								"error"
							);
							return;
						}

						// ✅ LOT 반영
						window.currentRow.querySelector("input[name=scannedLotNumber]").value = scannedLot;
						window.currentRow.querySelector(".lotNumberDisplay").textContent = scannedLot;

						// ✅ 제조일, 유통기한 자동 반영
						if (manufactureDate) {
							const mDateInput = window.currentRow.querySelector("input[name=manufactureDate]");
							if (mDateInput) mDateInput.value = manufactureDate;
						}
						if (expirationDate) {
							const eDateInput = window.currentRow.querySelector("input[name=expirationDate]");
							if (eDateInput) eDateInput.value = expirationDate;
						}

						// 성공시 lotVerified 변경
						window.currentRow.dataset.lotVerified = "true";
						scanning = false;

						Swal.fire("성공", "LOT 번호 확인 완료 ✅<br>" + scannedLot, "success");

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
		} catch (e) {
			console.warn("카메라 종료 오류:", e);
		}
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
