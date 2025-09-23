(function () {
	console.log("managementQRscanner.js 로드됨 (Outbound 전용)");

	const codeReader = new ZXing.BrowserMultiFormatReader();

	function byId(id) { return document.getElementById(id); }

	// ===== 카메라 시작 =====
	async function startCamera() {
		const videoElement = byId("qrVideo");
		const resultText = byId("qrResultText");

		try {
			await codeReader.decodeFromConstraints(
				{ video: { facingMode: { ideal: "environment" } } }, // ✅ 후면 카메라 우선
				videoElement,
				(result, err) => {
					if (result) {
						console.log("스캔 성공:", result.getText());
						resultText.textContent = result.getText();

						try {
							// ✅ QR 코드 내용은 JSON이어야 함
							const data = JSON.parse(result.getText());
							console.log("파싱된 데이터:", data);

							// ✅ 아웃바운드 데이터 구조에 맞춤
							if (data.obwaitNumber && data.outboundOrderIdx) {
								const targetUrl =
									contextPath +
									"/outbound/outboundDetail?obwaitNumber=" +
									encodeURIComponent(data.obwaitNumber) +
									"&outboundOrderIdx=" +
									encodeURIComponent(data.outboundOrderIdx);

								Swal.fire({
									title: "QR 스캔 성공",
									html:
										"<b>출고번호:</b> " + data.obwaitNumber +
										"<br><b>출고주문 IDX:</b> " + data.outboundOrderIdx,
									icon: "success",
									showCancelButton: true,
									confirmButtonText: "상세로 이동",
									cancelButtonText: "취소"
								}).then((result) => {
									if (result.isConfirmed) {
										window.location.href = targetUrl;
									}
								});
							} else {
								Swal.fire("오류", "QR 데이터에 출고번호/IDX가 없습니다.", "error");
							}
						} catch (e) {
							console.error("QR 데이터 파싱 실패:", e);
							Swal.fire("오류", "QR 데이터 파싱 실패", "error");
						}

						// ✅ 스캔 1회 후 카메라 종료
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
			console.warn("QR 스캐너: 버튼 또는 모달 요소 없음");
			return;
		}

		// ✅ 버튼 클릭 → 모달 열고 카메라 시작
		btnScanQR.addEventListener("click", async function () {
			console.log("QR 버튼 클릭됨 (Outbound)");
			ModalManager.openModalById("qrScannerModal");
			await startCamera();
		});

		// ✅ 모달 닫기 → 카메라 종료
		qrModal.querySelectorAll("[data-close], .modal-close-btn").forEach((btn) =>
			btn.addEventListener("click", stopCamera)
		);
		qrModal.addEventListener("click", (e) => {
			if (e.target === qrModal) stopCamera();
		});
	}

	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", init);
	} else {
		init();
	}
})();
