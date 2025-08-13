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
		<h1>이동할 재고</h1><br>
		
		<div class="table-responsive">
		<table class="table">
	    <thead>
	      <tr>
	      	<th>재고 ID</th>
	        <th>재고 이름</th>
	        <th>현재 위치</th>
	        <th>목표 위치</th>
	        <th>재고 수량</th>
	       
	      </tr>
	    </thead>
	    <tbody>
	      <tr>
	        <td>202</td>
	        <td>Ethiopian Coffee</td>
	        <td>LOC101</td>
	        <td>LOC201</td>
	     	<td>5</td>
	      </tr>
	      <tr>
	        <td>203</td>
	        <td>cups</td>
	        <td>LOC102</td>
	        <td>LOC202</td>
			<td>7</td>
	      </tr>
	      <tr>
	        <td>204</td>
	        <td>caramel</td>
	        <td>LOC103</td>
	        <td>LOC203</td>
	   		<td>3</td>
	      </tr>
	      <tr>
	        <td>205</td>
	        <td>straws</td>
	        <td>LOC104</td>
	        <td>LOC204</td>
	   		<td>6</td>
	      </tr>
	      <tr>
	        <td>206</td>
	        <td>napkins</td>
	        <td>LOC105</td>
	        <td>LOC205</td>
	        <td>4</td>
	      </tr>
	    </tbody>
	  </table>
	  </div>
	</section>
</body>
</html>