// /resources/js/inbound/modal/qrScanner.js
// QR 코드 스캐너 모달 제어 (ZXing 사용) - JSON 데이터 → 확인창 → URL 이동

(function() {
	console.log("qrScanner.js 로드됨");

	const codeReader = new ZXing.BrowserMultiFormatReader();

	function byId(id) {
		return document.getElementById(id);
	}

	// ===== 카메라 시작 =====
	async function startCamera() {
		const videoElement = byId("qrVideo");
		const resultText = byId("qrResultText");

		try {
			await codeReader.decodeFromConstraints(
				{
					video: { facingMode: { ideal: "environment" } } // 후면 카메라 우선
				},
				videoElement,
				(result, err) => {
					if (result) {
						console.log("스캔 성공:", result.getText());
						resultText.textContent = result.getText();

						try {
							// QR 안에 있는 JSON 파싱
							const data = JSON.parse(result.getText());
							console.log("파싱된 데이터:", data);

							if (data.orderNumber && data.ibwaitIdx) {
								// 이동할 URL 구성
								const targetUrl =
									contextPath +
									"/inbound/inboundDetail?orderNumber=" +
									encodeURIComponent(data.orderNumber) +
									"&ibwaitIdx=" +
									encodeURIComponent(data.ibwaitIdx);

								console.log("이동할 주소:", targetUrl);

								// SweetAlert2 확인창 띄우기
								Swal.fire({
									title: "QR 스캔 성공",
									html:
										"<b>발주번호:</b> " +
										data.orderNumber +
										"<br><b>입고대기 IDX:</b> " +
										data.ibwaitIdx,
									icon: "success",
									showCancelButton: true,
									confirmButtonText: "이동하기",
									cancelButtonText: "취소"
								}).then((result) => {
									if (result.isConfirmed) {
										window.location.href = targetUrl;
									} else {
										console.log("사용자가 이동을 취소했습니다.");
									}
								});
							}
						} catch (e) {
							console.error("QR 데이터 파싱 실패:", e);
							Swal.fire("오류", "QR 데이터 파싱 실패", "error");
						}

						// 스캔 완료 후 카메라 종료
						codeReader.reset();
					}

					if (err && !(err instanceof ZXing.NotFoundException)) {
						console.error("스캔 오류:", err);
					}
				}
			);

			console.log("카메라 시작됨 (후면 우선)");
		} catch (err) {
			console.error("카메라 시작 오류:", err);
			alert("카메라 접근 실패: " + err.message);
		}
	}

	// ===== 카메라 종료 =====
	function stopCamera() {
		try {
			codeReader.reset();
			console.log("카메라 종료됨");
		} catch (e) {
			console.warn("카메라 종료 오류:", e);
		}
	}

	// ===== 초기화 =====
	function init() {
		const btnScanQR = byId("btnScanQR");
		const qrModal = byId("qrScannerModal");

		if (!btnScanQR || !qrModal) {
			console.warn("QR 스캐너: 버튼 또는 모달 요소를 찾을 수 없습니다.");
			return;
		}

		// 버튼 클릭 → 모달 열고 카메라 시작
		btnScanQR.addEventListener("click", async function() {
			console.log("QR 버튼 클릭됨");
			ModalManager.openModalById("qrScannerModal");
			await startCamera();
		});

		// 모달 닫힐 때 카메라 종료
		const closeBtn = qrModal.querySelector(".modal-close-btn");
		if (closeBtn) {
			closeBtn.addEventListener("click", stopCamera);
		}
		qrModal.addEventListener("click", function(e) {
			if (e.target === qrModal) stopCamera();
		});
	}

	// ===== DOM 준비되면 초기화 =====
	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", init);
	} else {
		init();
	}
})();
