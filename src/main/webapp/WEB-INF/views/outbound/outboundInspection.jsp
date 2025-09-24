<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>출고 검수</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<link href="${pageContext.request.contextPath}/resources/css/outbound/outboundInspection.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
</head>
 
<body data-context="${pageContext.request.contextPath}">
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content outbound-inspection">
		<!-- 헤더 / 액션 -->
		<div class="d-flex justify-content-between align-items-center mb-3">
			<div>
				<h1 class="card-title">출고 검수</h1>
			</div>
			<div class="page-actions">
				<button id="btnBack" class="btn btn-secondary btn-sm" title="뒤로가기">← 뒤로</button>
				<button id="btnAssignLocation" class="btn btn-primary btn-sm">출고위치지정</button>
				<button id="btnOutboundComplete" class="btn btn-primary btn-sm">출고확정</button>
			</div>
		</div>
		
		<!-- 상단 기본정보 카드 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">기본 정보</div>
				<div class="text-muted">상태:  
					<span class="badge badge-pending">
						<c:out value="${obDetail.status}" default="-" />
					</span>
				</div>
			</div>
			<div class="kv-grid">
				<div class="kv-item">
					<div class="kv-label">출고번호</div>
					<div class="kv-value">
					    <c:out value="${obDetail.obwaitNumber}" default="-" />
					    <input type="hidden" id="outboundLink"
			               data-obwait-idx="${obDetail.obwaitIdx}"
			               data-order-number="${obDetail.obwaitNumber}"
			               data-outbound-order-idx="${obDetail.outboundOrderIdx}" />
					</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">출고일자</div>
					<div class="kv-value"><c:out value="${obDetail.departureDate}" default="-" /></div>
				</div>
				<div class="kv-item">
					<div class="kv-label">프랜차이즈</div>
					<div class="kv-value"><c:out value="${obDetail.franchiseName}" default="-" /></div>
				</div>
				<div class="kv-item">
					<div class="kv-label">담당자</div>
					<div class="kv-value">
						<span id="fieldManagerName">
							<c:out value="${obDetail.manager}" default="-" />
						</span>
					</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">출고위치</div>
					<div class="kv-value">
						<span id="fieldOutboundLocation">
						    <c:out value="${obDetail.outboundLocation}" default="-" />
						</span>
					</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">총 품목 수</div>
					<div class="kv-value"><c:out value="${obDetail.itemCount}" default="0" /> 개</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">총 수량</div>
					<div class="kv-value"><c:out value="${obDetail.totalQuantity}" default="0" /> 개</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">비고</div>
					<div class="kv-value"><c:out value="${obDetail.note}" default="-" /></div>
				</div>
			</div>
		</div>

		<!-- 품목 목록 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">품목 내역</div>
			</div>

			<div class="table-responsive">
				<table id="itemsTable" class="table">
					<thead>
						<tr>
							<th>No</th>
							<th>LOT번호</th>
							<th>상품명</th>
							<th>출고수량</th>
							<th>폐기수량</th>
							<th>검수</th>
						</tr>
					</thead>
					<tbody>
					    <c:choose>
					        <c:when test="${not empty obProductList}">
					            <c:forEach var="item" items="${obProductList}" varStatus="vs">
					                <tr data-item-idx="${item.outboundOrderItemIdx}">
					                    <td><c:out value="${vs.index + 1}" /></td>
					                    <td><c:out value="${item.lotNumber}" /></td>
					                    <td><c:out value="${item.productName}" /></td>
					                    <td><fmt:formatNumber value="${item.quantity}" pattern="#,##0" /></td>
					                    <td><input type="number" class="form-control discard-qty" min="0" max="${item.quantity}" value="0" /></td>
					                    <td><button type="button" class="btn btn-sm btn-primary btn-inspect">검수완료</button></td>
					                </tr>
					            </c:forEach>
					        </c:when>
					        <c:otherwise>
					            <tr>
					                <td colspan="7" class="text-center">출고 품목 정보가 없습니다.</td>
					            </tr>
					        </c:otherwise>
					    </c:choose>
					</tbody>
				</table>
			</div>
		</div>

	</section>

	<script src="${pageContext.request.contextPath}/resources/js/outbound/outboundInspection.js"></script>
	<script>const contextPath = "${pageContext.request.contextPath}";</script>
</body>
<link href="${pageContext.request.contextPath}/resources/css/inbound/modal/detailSmallModal.css" rel="stylesheet" />
</html>
