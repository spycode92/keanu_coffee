<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
<script src="https://unpkg.com/@zxing/browser@latest"></script>	
	
<video id="webcam-preview"></video>
<p id="result"></p>

<script>
  const codeReader = new ZXing.BrowserQRCodeReader();
  codeReader.decodeFromVideoDevice(null, 'webcam-preview', (result, err) => {
    if (result) {
      document.getElementById('result').textContent = result.text;
    }
    if (err && !(err instanceof ZXing.NotFoundException)) {
      console.error(err);
    }
  });
</script>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
</body>
</html>