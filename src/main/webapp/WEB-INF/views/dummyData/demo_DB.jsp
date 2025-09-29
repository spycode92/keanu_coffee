<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>demo DB</title>
<sec:csrfMetaTags/>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/dummyData/demo_DB.js"></script>
</head>
<body>
	<h1>더미데이터</h1>
	시작일	<input type="date" id="startDate">
	종료일 	<input type="date" id="endDate">
	<br><br>
	<input type="button" value="발주데이터생성" id="purchaseOrderToInboundWaiting">
</body>
</html>