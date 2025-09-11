<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>출고 상세</title>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
	<style>
		.outbound-detail {
			padding: 20px;
		}
		.outbound-detail h2 {
			margin-bottom: 1rem;
		}
		.table {
			width: 100%;
			border-collapse: collapse;
			margin-bottom: 1.5rem;
		}
		.table th, .table td {
			border: 1px solid #ddd;
			padding: 8px;
			text-align: center;
		}
		.table th {
			background-color: #f8f9fa;
		}
		.actions {
			margin-top: 20px;
		}
		.actions button {
			padding: 8px 16px;
			margin-right: 8px;
			cursor: pointer;
		}
		.summary {
			margin-top: 10px;
			font-weight: bold;
		}
	</style>
</head>
<body class="outbound-detail">

	<h2>출고 상세정보</h2>

	<!-- 출고 기본정보 -->
	<table class="table">
		<tr>
			<th>출고번호</th>
			<td>${obDetail.obwaitNumber}</td>
			<th>출고일자</th>
			<td>${obDetail.departureDate}</td>
		</tr>
		<tr>
			<th>프랜차이즈</th>
			<td>${obDetail.franchiseName}</td>
			<th>상태</th>
			<td>${obDetail.status}</td>
		</tr>
		<tr>
			<th>담당자</th>
			<td>${obDetail.manager}</td>
			<th>비고</th>
			<td>${obDetail.note}</td>
		</tr>
	</table>

	<!-- 출고 품목 리스트 -->
	<h3>출고 품목</h3>
	<table class="table">
		<thead>
			<tr>
				<th>상품명</th>
				<th>규격/단위</th>
				<th>출고수량</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="item" items="${obProductList}">
				<tr>
					<td>${item.productName}</td>
					<td>${item.productVolume}</td>
					<td>${item.quantity}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>

	<!-- 요약 -->
	<div class="summary">
		총 품목수: ${obDetail.itemCount}개 /
		총 출고수량: ${obDetail.totalQuantity}개
	</div>

	<!-- 버튼 영역 -->
	<div class="actions">
		<button type="button" onclick="history.back()">뒤로가기</button>
		<!-- 추후 기능 확장 대비 -->
		<!--
		<button type="button">출고검수</button>
		<button type="button">출고피킹</button>
		<button type="button">출고확정</button>
		-->
	</div>

</body>
</html>
