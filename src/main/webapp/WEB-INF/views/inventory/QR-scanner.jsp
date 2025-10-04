<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>QR 스케너</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
  <script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
  <link rel="stylesheet" rel="preload" as="style" onload="this.rel='stylesheet';this.onload=null"
    href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic">
<!--   <link rel="stylesheet" rel="preload" as="style" onload="this.rel='stylesheet';this.onload=null" -->
<!--     href="https://unpkg.com/normalize.css@8.0.0/normalize.css"> -->
<!--   <link rel="stylesheet" rel="preload" as="style" onload="this.rel='stylesheet';this.onload=null" -->
<!--     href="https://unpkg.com/milligram@1.3.0/dist/milligram.min.css"> -->
	<style type="text/css">
		.wrapper {
			width: 1200px;
			margin: 0 auto;
		}
		#button-div {
			margin-bottom: 30px;
		}
	</style>
</head>
<body>
   <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	
  <main class="wrapper" style="padding-top:2em">
    <section class="container" id="demo-content">
      <h1 class="title">QR 스케너</h1>
    
      <p>기기의 비디오 카메라에서 지원되는 1D/2D 코드를 스캔하세요.</p>
      <div id="button-div">
        <a class="btn btn-primary" id="startButton">시작</a>
        <a class="btn btn-primary" id="resetButton">다시 놓기</a>
      </div>
      <div>
        <video id="video" width="800" height="400" style="border: 1px solid gray"></video>
      </div>
      <div id="sourceSelectPanel" style="display:none">
        <label for="sourceSelect">비디오 소스 변경:</label>
        <select id="sourceSelect" style="max-width:800px">
        </select>
      </div>
      <label>Result:</label>
      <pre><code id="result"></code></pre>
    </section>
  </main>
  <script type="text/javascript" src="https://unpkg.com/@zxing/library@latest/umd/index.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/common/QRScript.js" defer></script>

  
</body>
</html>