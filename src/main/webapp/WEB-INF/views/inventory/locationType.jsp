<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로케이션 지정</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
</head>
<body>
	
	<!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	
	<h2>📦 로케이션 지정</h2>
	
	<div class="location-type">
	    <form method="get" action="">
	        <label><input type="radio" name="locationType" value="picking" checked> 피킹존 로케이션</label>
	        <label><input type="radio" name="locationType" value="pallet"> 파렛트 로케이션</label>
	        <button type="submit">조회</button>
	    </form>
	</div>
	
	<table>
	    <thead>
	        <tr>
	            <th>로케이션 코드</th>
	            <th>구역</th>
	            <th>보관 가능 수량</th>
	            <th>현재 수량</th>
	            <th>타입</th>
	        </tr>
	    </thead>
	    <tbody>
	        <!-- 예시 데이터 반복문 -->
	        <c:forEach var="loc" items="${locationList}">
	            <tr>
	                <td>${loc.locationCode}</td>
	                <td>${loc.zone}</td>
	                <td>${loc.maxQty}</td>
	                <td>${loc.currentQty}</td>
	                <td>
	                    <c:choose>
	                        <c:when test="${loc.locationType == 'picking'}">피킹존</c:when>
	                        <c:otherwise>파렛트</c:otherwise>
	                    </c:choose>
	                </td>
	            </tr>
	        </c:forEach>
	    </tbody>
	</table>
	
</body>
</html>