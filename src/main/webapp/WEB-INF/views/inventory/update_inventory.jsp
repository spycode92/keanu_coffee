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
<style>
	section {
		width: 1200px;
		margin: 0 auto;
	}
		form {
		margin-top: 50px;
	
	}
	table {
/* 		border: 1px solid #fff; */
		padding: 50px;
		width: 500px;
	
	}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	<section >
		
<!-- 		<form action="/inventory/updateInventory" method="post"> -->
<!-- 			<label for="inventoryId">재고 ID</label> -->
<!-- 			<input id="inventoryID" type="text" name="inventoryId"> -->
		
<!-- 			<label for="increaseQty">수량을 늘리다</label> -->
<!-- 			<input id="increaseQty" type="number" name="increaseQty"> -->
<!-- 			<label for="decreaseQty">감소 수량 금액</label> -->
<!-- 			<input id="decreaseQty" type="number" name="decreaseQty"> -->
<!-- 			<select> -->
<!-- 				<option value="">수량 수정 사유</option> -->
<!-- 				<option> -->
<%-- 	<%-- 			 <c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				 재고 수량</option> -->
<!-- 				<option > -->
<%-- 	<%-- 			<c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				손상됨 / 파손됨</option> -->
<!-- 				<option > -->
<%-- 	<%-- 			<c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				도난당한 재고</option> -->
<!-- 				<option > -->
<%-- 	<%-- 			<c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				다른 이유</option> -->
<!-- 			</select> -->
<!-- 			<input type="submit"> -->
<!-- 		</form> -->
			<form class="card" action="/inventory/updateInventory" method="post">
			   <h1 class="card-header">재고 업데이트</h1>
			  <table>
			  	   <tr>
			      <td class="form-label">직원 ID:</td>
			      <td>
			        <p>John</p>
			        <input class="form-control" type="text" name="employee_id" value="John" hidden>
			      </td>
			    </tr>
			    <tr>
			      <td><label  class="form-label" for="inventoryId">재고 ID</label></td>
			      <td><input class="form-control" id="inventoryID" type="text" name="inventoryId" required></td>
			    </tr>
			    <tr>
			      <td><label  class="form-label" for="increaseQty">수량을 늘리다</label></td>
			      <td><input class="form-control" id="increaseQty" type="number" name="increaseQty" min="0"></td>
			    </tr>
			    <tr>
			      <td><label  class="form-label" for="decreaseQty">감소 수량 금액</label></td>
			      <td><input class="form-control" id="decreaseQty" type="number" name="decreaseQty" min="0"></td>
			    </tr>
			    <tr>
			      <td><label  class="form-label" for="adjustReason">수량 수정 사유</label></td>
			      <td>
			        <select class="form-control" id="adjustReason" name="adjustReason" required>
			          <option value="">사유를 선택하세요</option>
			          <option value="재고 수량">재고 수량</option>
			          <option value="손상됨 / 파손됨">손상됨 / 파손됨</option>
			          <option value="도난당한 재고">도난당한 재고</option>
			          <option value="다른 이유">다른 이유</option>
			        </select>
			      </td>
			    </tr>
			    <tr>
			      <td colspan="2" style="text-align: center;"><br>
			        <input class="btn btn-primary"  type="submit" value="업데이트">
			      </td>
			    </tr>
			  </table>
			</form>
			<div class="d-flex justify-content-between align-items-center p-3">
      
	</section>
</body>
</html>