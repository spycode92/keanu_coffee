<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수주확인서</title>
<link href="${pageContext.request.contextPath}/resources/css/transport/common.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/transport/deliveryConfirmationDetail.css" rel="stylesheet">
<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/dispatch.js"></script>
</head>
<body>
	<div class="confirmation-container">
		<h2>수주확인서</h2>
		<table>
			<colgroup>
				<col width="30%">
				<col width="70%">
			</colgroup>
			<tr>
				<th>수주확인서번호</th>
				<td>${confirmationDTO.deliveryConfirmationIdx}</td>
			</tr>
			<tr>
				<th>출고주문번호</th>
				<td>${confirmationDTO.outboundOrderIdx}</td>
			</tr>
			<tr>
				<th>지점명</th>
				<td>${confirmationDTO.franchiseName}</td>
			</tr>
			<tr>
				<th>수령자</th>
				<td>${confirmationDTO.receiverName}</td>
			</tr>
			<tr>
				<th>담당기사</th>
				<td>${driverName}</td>
			</tr>
		</table>
		<div class="card" style="margin-top: 20px" id="summary">
			<div class="card-header">주문서(품목)</div>
			<table class="table" id="summaryInfo">
				<thead>
					<tr>
						<th>품목명</th>
						<th>주문수량</th>
						<th>납품수량</th>
						<th>반품수량</th>
						<th>상태</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="item" items="${confirmationDTO.items}">
						<tr>
							<td>${item.itemName}</td>
							<td>${item.orderedQty}</td>
							<td>${item.orderedQty - item.deliveredQty}</td>
							<td>${item.deliveredQty}</td>
							<td><c:choose>
									<c:when test="${item.status eq 'OK'}">완료</c:when>
									<c:when test="${item.status eq 'PARTIAL_REFUND'}">부분 반품</c:when>
									<c:when test="${item.status eq 'REFUND'}">전량 반품</c:when>
								</c:choose></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<c:if test="${not empty confirmationDTO.fileList}">
				<div class="download-area">
					<c:forEach var="file" items="${confirmationDTO.fileList}">
						${file.originalFileName} 
						<a href="/file/${file.fileIdx}"> 
						<input type="button" value="다운로드" id="btn"/>
					</a>
					<br>
					</c:forEach>
				</div>
			</c:if>
		</div>
	</div>
</body>
</html>