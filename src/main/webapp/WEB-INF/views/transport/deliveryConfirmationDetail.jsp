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
<%-- <link href="${pageContext.request.contextPath}/resources/css/common/common_sample.css" rel="stylesheet"> --%>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/dispatch.js"></script>
<style type="text/css">
/* 전체 레이아웃 */
body {
	font-family: "맑은 고딕", sans-serif;
	background-color: #f9f9f9;
	padding: 30px;
}

/* 문서 영역 */
.confirmation-container {
	background: #fff;
	border: 1px solid #ddd;
	padding: 30px 40px;
	border-radius: 6px;
	max-width: 900px;
	margin: 0 auto;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

/* 제목 */
.confirmation-container h1 {
	text-align: center;
	font-size: 26px;
	margin-bottom: 30px;
	border-bottom: 2px solid #000;
	padding-bottom: 10px;
}

/* 기본 정보 테이블 */
.confirmation-container table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

.confirmation-container th, .confirmation-container td {
	border: 1px solid #ccc;
	padding: 10px 12px;
	text-align: left;
	font-size: 14px;
}

.confirmation-container th {
	background-color: #f2f2f2;
	width: 20%;
}

/* 필드 (기사 정보 등) */
.confirmation-container .field {
	margin: 15px 0;
}

.confirmation-container .field label {
	font-weight: bold;
	display: inline-block;
	margin-bottom: 6px;
}

/* 카드 스타일 */
.card {
	border: 1px solid #ddd;
	border-radius: 4px;
	overflow: hidden;
}

.card-header {
	background-color: #333;
	color: #fff;
	padding: 8px 12px;
	font-weight: bold;
}

.table {
	width: 100%;
	border-collapse: collapse;
}

.table th, .table td {
	border: 1px solid #ccc;
	padding: 8px 10px;
	text-align: center;
	font-size: 13px;
}

.table th {
	background-color: #fafafa;
}

/* 파일 다운로드 */
.download-area {
	margin-top: 15px;
	padding: 10px;
	background-color: #f7f7f7;
	border: 1px dashed #aaa;
	border-radius: 4px;
	font-size: 0.9rem;
}

.download-area input[type="button"] {
	background: #007bff;
	border: none;
	color: #fff;
	padding: 6px 12px;
	border-radius: 4px;
	cursor: pointer;
}

.download-area input[type="button"]:hover {
	background: #0056b3;
}

</style>
</head>
<body>
	<div class="confirmation-container">
		<h1>수주확인서</h1>
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

			<c:if test="${not empty confirmationDTO.file}">
				<div class="download-area">
					${confirmationDTO.file.originalFileName} <a
						href="/file/${confirmationDTO.file.fileIdx}"> <input
						type="button" value="다운로드" />
					</a>
				</div>
			</c:if>
		</div>
	</div>
</body>
</html>