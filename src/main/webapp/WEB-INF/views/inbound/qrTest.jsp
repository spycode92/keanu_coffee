<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>QR 테스트</title>
  <script src="https://cdn.jsdelivr.net/npm/qrcode/build/qrcode.min.js"></script>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; padding: 2em; }
    #qrcode { margin-top: 20px; }
  </style>
</head>
<body>
  <h1>QR 테스트 페이지</h1>
  <p>아래 QR 코드를 카메라로 스캔하면 콘솔에 결과가 찍힙니다.</p>
  <div id="qrcode"></div>
  <script>
  const data = {
			orderNumber: "PO-20250810-001" ,
			ibwaitIdx: 3310
		};
		QRCode.toCanvas(JSON.stringify(data), { width: 200 }, function (err, canvas) {
		  if (err) console.error(err);
		  document.getElementById("qrcode").appendChild(canvas);
		});
  </script>
</body>
</html>
