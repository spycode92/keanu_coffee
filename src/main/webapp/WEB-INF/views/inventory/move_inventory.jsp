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
		border: 1px solid #fff;
		padding: 50px;
		width: 500px;
	
	}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	<section>
		<h1>재고를 옮기다</h1>
		
<!-- 		<form action="/inventory/updateInventory" method="post"> -->
<!-- 			<p>직원 ID: John</p> -->
<!-- 			<input type="text" name="employee_id" value="John" hidden><br> -->
<!-- 			<label for="inventoryId">재고 ID</label> -->
<!-- 			<input id="inventoryID" type="text" name="inventoryId"><br> -->
			
<!-- 			<label for="qtyMoving">이동할 양</label> -->
<!-- 			<input id="qtyMoving" type="number" name="qtyMoving" min="0"><br> -->
			
			
<!-- 			<select> -->
<!-- 				<option value="">목적지</option> -->
<!-- 				<option> -->
<%-- 			 <c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				 팔레트 보관</option> -->
<!-- 				<option > -->
<%-- 			<c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				저장 선택</option> -->
<!-- 				<option > -->
<%-- 			<c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				포장 구역</option> -->
<!-- 				<option > -->
<%-- 			<c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				쓰레기통</option> -->
<!-- 			</select> -->
<!-- 			<input type="submit"> -->
<!-- 		</form> -->
			<form action="/inventory/updateInventory" method="post">
			  <table>
			    <tr>
			      <td class="form-label">직원 ID:</td>
			      <td>
			        <p>John</p>
			        <input type="text" name="employee_id" value="John" hidden>
			      </td>
			    </tr>
			    <tr>
			      <td><label class="form-label" for="inventoryId">재고 ID</label></td>
			      <td><input class="form-control" id="inventoryID" type="text" name="inventoryId" required></td>
			    </tr>
			    <tr>
			      <td><label class="form-label"  for="qtyMoving">이동할 양</label></td>
			      <td><input class="form-control" id="qtyMoving" type="number" name="qtyMoving" min="0" required></td>
			    </tr>
			    <tr>
			      <td><label class="form-label"  for="destination">목적지</label></td>
			      <td>
			        <select class="form-control" id="destination" name="destination" required>
			          <option value="">목적지를 선택하세요</option>
			          <option value="팔레트 보관">팔레트 보관</option>
			          <option value="저장 선택">저장 선택</option>
			          <option value="포장 구역">포장 구역</option>
			          <option value="쓰레기통">쓰레기통</option>
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
        <div class="text-muted">페이지 1 / 13</div>
        <div class="d-flex gap-2">
          <a href="#" class="btn btn-secondary btn-sm">« 처음</a>
          <a href="#" class="btn btn-secondary btn-sm">‹ 이전</a>
          <a href="#" class="btn btn-primary btn-sm">1</a>
          <a href="#" class="btn btn-secondary btn-sm">2</a>
          <a href="#" class="btn btn-secondary btn-sm">3</a>
          <a href="#" class="btn btn-secondary btn-sm">다음 ›</a>
          <a href="#" class="btn btn-secondary btn-sm">끝 »</a>
        </div>
      </div>
	</section>
</body>
</html>