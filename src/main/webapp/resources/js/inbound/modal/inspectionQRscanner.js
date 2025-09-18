(function() {
	console.log("inspectionQRscanner.js 로드됨");

	const codeReader = new ZXing.BrowserMultiFormatReader();
	let targetInput = null;

	function byId(id) { return document.getElementById(id); }

	// LOT칸 클릭시 모달 열기
	window.openQrModalForRow = function(inputEl) {
		targetInput = inputEl;
		ModalManager.openModalById("modifyLotNumber");
		startCamera();
	};

	// 카메라 시작
	async function startCamera() {
		const videoElement = byId("qrVideo");
		const resultText = byId("qrResultText");

		try {
			await codeReader.decodeFromConstraints(
				{ video: { facingMode: { ideal: "environment" } } },
				videoElement,
				(result, err) => {
					if (result) {
						console.log("스캔 성공:", result.getText());
						resultText.textContent = result.getText();

						try {
							const data = JSON.parse(result.getText());
							if (data.lotNumber && targetInput) {
								targetInput.value = data.lotNumber;
								Swal.fire("QR 스캔 성공", "LOT 번호 입력됨: " + data.lotNumber, "success");
							}
						} catch (e) {
							Swal.fire("오류", "QR 데이터 파싱 실패", "error");
						}

						codeReader.reset();
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
		try { codeReader.reset(); } catch (e) {}
	}

	// 모달 닫힐 때 카메라 정리
	document.addEventListener("DOMContentLoaded", function() {
		const qrModal = byId("modifyLotNumber");
		if (qrModal) {
			const closeBtn = qrModal.querySelector(".modal-close-btn");
			if (closeBtn) closeBtn.addEventListener("click", stopCamera);
			qrModal.addEventListener("click", e => { if (e.target === qrModal) stopCamera(); });
		}

		// 수동 입력 처리
		const btnManual = byId("btnManualInput");
		const manualArea = byId("manualInputArea");
		const btnApply = byId("btnApplyManual");

		if (btnManual && manualArea && btnApply) {
			btnManual.addEventListener("click", () => {
				manualArea.style.display = "block";
			});
			btnApply.addEventListener("click", () => {
				const val = byId("manualLotNumber").value;
				if (val && targetInput) {
					targetInput.value = val;
					ModalManager.closeModalById("modifyLotNumber");
				}
			});
		}
	});
})();
