//Zxing 객체 생성
const codeReader = new ZXing.BrowserMultiFormatReader();
function byId(id) {
	return document.getElementById(id);
}

// ===== 카메라 시작 =====
function startCamera(onScanComplete) {
	//비디오태그
	const videoElement = byId("qrVideo");
	const resultText = byId("qrResultText");
	return codeReader.decodeFromConstraints(
		{
			video: { facingMode: { ideal: "environment" } } // 후면 카메라 우선
		},
		videoElement, // 화면에 표시할 비디오태그
		(result, err) => { //스캔 결과를 처리할 콜백함수
			if (result) {
				// QR코드를 찾았을 때
				console.log("스캔 성공:", result.getText());
				
				resultText.textContent = result.getText();
				
				// 스캔 완료 후 카메라 종료
				codeReader.reset();
				ModalManager.closeModalById("qrScannerModal");
				
                // 콜백 함수 호출
                if (typeof onScanComplete === 'function') {
                    onScanComplete(result.getText());
                }
			}
			if (err && !(err instanceof ZXing.NotFoundException)) {
				// 에러가 발생했을 때 (NotFoundException은 "못 찾음"이라 무시)
				codeReader.reset();
			}
		})
//	.then(() => {
//	}).catch(() => {
//        Swal.fire('카메라 인식 실패', '카메라를 찾을수 없습니다.', 'warning');
//	});
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

