<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>출고 상세</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<link href="${pageContext.request.contextPath}/resources/css/outbound/outboundDetail.css" rel="stylesheet" />
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
				<button id="btnPrint" class="btn btn-secondary btn-sm">인쇄</button>
				<button id="btnAssignManager" class="btn btn-primary btn-sm">담당자지정</button>
				<button id="btnAssignLocation" class="btn btn-primary btn-sm">출고위치지정</button>
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
							<c:out value="${obDetail.outboundLocation}" default="-" />
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

		<!-- 타임라인 -->
		<div class="card mb-3">
			<div class="card-header">
				<div class="card-title">상태 이력 (타임라인)</div>
			</div>
			<div class="timeline p-2">
				<div class="timeline-step active">
					<div class="timeline-dot"></div>
					<div class="muted" style="font-size:.85rem;">등록</div>
					<div style="font-size:.85rem;">2025-09-10<br/><span class="muted">관리자</span></div>
				</div>
				<div class="timeline-step">
					<div class="timeline-dot"></div>
					<div class="muted" style="font-size:.85rem;">피킹대기</div>
					<div style="font-size:.85rem;">(미완료)</div>
				</div>
				<div class="timeline-step">
					<div class="timeline-dot"></div>
					<div class="muted" style="font-size:.85rem;">출고확정</div>
					<div style="font-size:.85rem;">-</div>
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
							<th>상품명</th>
							<th>규격/단위</th>
							<th>LOT번호</th>
							<th>출고수량</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${not empty obProductList}">
								<c:forEach var="item" items="${obProductList}" varStatus="vs">
									<tr>
										<td><c:out value="${vs.index + 1}" /></td>
										<td><c:out value="${item.productName}" /></td>
										<td><c:out value="${item.productVolume}" /></td>
										<td><c:out value="${item.lotNumber}" /></td>
										<td><fmt:formatNumber value="${item.quantity}" pattern="#,##0" /></td>
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

			<div>
				<div class="muted">변경 이력</div>
				<table class="table" style="margin-top:.5rem;">
					<thead>
						<tr>
							<th style="width:160px;">시간</th>
							<th style="width:160px;">사용자</th>
							<th>변경내용</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>2025-09-10 09:30</td>
							<td>관리자</td>
							<td>출고 요청 등록</td>
						</tr>
						<tr>
							<td>2025-09-11 15:20</td>
							<td>홍길동</td>
							<td>출고수량 수정 (100 → 80)</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</section>

<%-- 	<jsp:include page="/WEB-INF/views/inbound/modal/modifyManager.jsp" /> --%>
<%-- 	<jsp:include page="/WEB-INF/views/inbound/modal/modifyLocation.jsp" /> --%>

	<!-- JS 모음 -->
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/outbound/modal/modify.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/outbound/outboundDetail.js"></script>
</body>
<link href="${pageContext.request.contextPath}/resources/css/outbound/modal/detailSmallModal.css" rel="stylesheet" />
</html>
