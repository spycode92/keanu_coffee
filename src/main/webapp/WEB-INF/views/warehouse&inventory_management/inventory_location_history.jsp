<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style type="text/css">
	section {
		width: 1200px;
		margin: 0 auto;
	}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	<section>
		<h1>제품 위치 기록</h1>
		
  <form id="searchForm" action="inventory/productHistorySearch" method="get">
    <label for="searchInput">Product Name:</label>
    <input type="text" id="searchInput" placeholder="제품 이름이나 아이디를 입력하세요..." >
    <input class="btn btn-sm btn-primary" type="submit"><br>
  </form><br>
		
<!-- 		<div class="table-responsive"> -->
		<table class="table">
	    <thead>
	      <tr>
	      	<th>재고 ID</th>
	        <th>재고 이름</th>
	        <th>위치 ID</th>
	        <th>타임스탬프</th>
	        <th>직원 ID</th>
	      </tr>
	    </thead>
	    <tbody>
	      <tr>
	        <td>202</td>
	        <td>Ethiopian Coffee</td>
	        <td>LOC101</td>
	        <td>2025-08-01 08:15</td>
	        <td>emp1111</td>
	      </tr>
	      <tr>
	        <td>202</td>
	        <td>Ethiopian Coffee</td>
	        <td>LOC102</td>
	        <td>2025-08-03 14:30</td>
	        <td>emp1111</td>
	      </tr>
	      <tr>
	        <td>202</td>
	        <td>Ethiopian Coffee</td>
	        <td>LOC103</td>
	        <td>2025-08-05 09:45</td>
	        <td>emp1111</td>
	      </tr>
	      <tr>
	        <td>202</td>
	        <td>Ethiopian Coffee</td>
	        <td>LOC104</td>
	        <td>2025-08-07 16:20</td>
	        <td>emp1111</td>
	      </tr>
	      <tr>
	        <td>202</td>
	        <td>Ethiopian Coffee</td>
	        <td>LOC105</td>
	        <td>2025-08-10 11:00</td>
	        <td>emp1111</td>
	      </tr>
	    </tbody>
	  </table>
	  </div>
	</section>
</body>
</html>