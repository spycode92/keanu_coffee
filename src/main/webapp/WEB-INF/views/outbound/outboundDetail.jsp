<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <script>const contextPath = "${pageContext.request.contextPath}";</script>
	<title>출고 상세</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<link href="${pageContext.request.contextPath}/resources/css/outbound/outboundDetail.css" rel="stylesheet" />
	<link href="${pageContext.request.contextPath}/resources/css/inbound/modal/detailSmallModal.css" rel="stylesheet" />
</head>

<body data-context="${pageContext.request.contextPath}">
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content outbound-detail" data-app-root="1">
		<!-- 헤더 / 액션 -->
		<div class="d-flex justify-content-between align-items-center mb-3">
			<div>
				<h1 class="card-title">출고 상세</h1>
			</div>
			<div class="page-actions">
				<sec:authorize access="hasAuthority('OUTBOUND_WRITE')">
					<button id="btnInspection" type="button"
						class="btn btn-primary btn-sm"
						data-ibwait-idx="${obDetail.obwaitIdx}"
						data-order-number="${obDetail.obwaitNumber}"
						data-status="${obDetail.status}"
						data-manager="${obDetail.manager}"
						data-current-username="${currentUserName}"
						data-outbound-order-idx="${obDetail.outboundOrderIdx}">
						검수
					</button>
				</sec:authorize>
				<button id="btnPrint" class="btn btn-secondary btn-sm">인쇄</button>
				<button id="btnBack" class="btn btn-secondary btn-sm" title="뒤로가기">← 뒤로</button>
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
					</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">출고일자</div>
					<div class="kv-value">
						<c:out value="${obDetail.departureDate}" default="-" />
					</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">프랜차이즈</div>
					<div class="kv-value">
						<c:out value="${obDetail.franchiseName}" default="-" />
					</div>
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
							<c:choose>
					            <c:when test="${obDetail.outboundLocation == '9994'}">Location_A</c:when>
					            <c:when test="${obDetail.outboundLocation == '9995'}">Location_B</c:when>
					            <c:when test="${obDetail.outboundLocation == '9996'}">Location_C</c:when>
					            <c:otherwise>-</c:otherwise>
					        </c:choose>
						</span>
					</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">총 품목 수</div>
					<div class="kv-value">
						<c:out value="${obDetail.itemCount}" default="0" /> 개
					</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">총 수량</div>
					<div class="kv-value">
						<c:out value="${obDetail.totalQuantity}" default="0" /> 개
					</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">비고</div>
					<div class="kv-value">
						<c:out value="${obDetail.note}" default="-" />
					</div>
				</div>
			</div>
		</div>
		
		<!-- 품목 목록 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">품목 내역</div>
				<div class="muted">-</div>
			</div>

			<div class="table-responsive">
				<table id="itemsTable" class="table">
					<thead>
						<tr>
							<th>No</th>
							<th colspan="2">LOT번호</th>
							<th colspan="2">상품명</th>
							<th>규격/단위</th>
							<th>폐기</th>
							<th>출고수량</th>
							<th colspan="1">비고</th>							
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${not empty obProductList}">
								<c:forEach var="item" items="${obProductList}" varStatus="vs">
									<tr>
										<td><c:out value="${vs.index + 1}" /></td>
										<td colspan="2"><c:out value="${item.lotNumber}" /></td>
										<td colspan="2"><c:out value="${item.productName}" /></td>
										<td><fmt:formatNumber value="${item.productVolume}" pattern="#호" /></td>
										<td><c:out value="-" /></td>
										<td><fmt:formatNumber value="${item.quantity}" pattern="#,##0" /></td>
										<td colspan="1"><c:out value="-" /></td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="5" class="text-center">출고 품목 정보가 없습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
		</div>

		<!-- 첨부 / 메모 / 로그 -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="card-title">첨부 / 메모 / 변경이력</div>
			</div>

			<div class="row mb-3">
				<div class="col-md-6">
					<div class="muted">첨부파일</div>
					<div class="attachments">
						<div class="attachment-item">shipping_label_OB20250909-006.pdf</div>
						<div class="attachment-item">outbound_photo_1.jpg</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="muted">메모</div>
					<div class="kv-value" style="min-height:80px;">
						출고 전 최종 검수 필요. 파손 유의.
					</div>
				</div>
			</div>

		</div>
	</section>

	<jsp:include page="/WEB-INF/views/inbound/modal/modifyManager.jsp" />
	<jsp:include page="/WEB-INF/views/inbound/modal/modifyLocation.jsp" />

	<!-- JS 모음 -->
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/inbound/modal/modify.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/outbound/outboundDetail.js"></script>
</body>

</html>
