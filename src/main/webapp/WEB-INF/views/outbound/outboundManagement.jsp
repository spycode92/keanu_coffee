<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="_csrf" content="${_csrf.token}" />
	<meta name="_csrf_header" content="${_csrf.headerName}" />

	<title>출고 관리</title>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/outbound/management.css" rel="stylesheet" />
	<link href="${pageContext.request.contextPath}/resources/css/inbound/modal/detailSmallModal.css" rel="stylesheet" />
</head>

<body data-context="${pageContext.request.contextPath}">
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content">
		<div class="d-flex justify-content-between align-items-center mb-2">
			<h1 class="card-title" style="margin:0;">출고관리</h1>
		</div>
		
		<!--  간단 검색바 -->
		<div class="card mb-3 outbound-simple-search d-flex align-items-center p-3 gap-2">
			<input type="text" class="form-control" id="simpleItemKeyword" placeholder="출고번호 검색" />
			<button class="btn btn-primary btn-sm" id="simpleSearchBtn">검색</button>
			<button class="btn btn-secondary btn-sm" id="toggleDetailSearchBtn">상세검색</button>
		</div>

		<!--  상세 검색 -->
		<div class="card mb-4 outbound-filters" id="detailSearchCard" style="display:none;">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">검색 / 필터</div>
			</div>
			<div class="row">
				<div class="col-md-3">
					<label class="form-label">검색 기준</label>
					<select class="form-control search-select" id="dateBasis">
						<option value="request" selected>요청일 기준</option>
						<option value="expect">출고예정일 기준</option>
						<option value="range">기간 기준</option>
					</select>
				</div>
				<div class="col-md-3 date-field date-request">
					<label class="form-label">출고일자</label>
					<input type="date" class="form-control search-input" id="outRequestDate" />
				</div>
				<div class="col-md-3 date-field date-expect" style="display:none;">
					<label class="form-label">출고예정일</label>
					<input type="date" class="form-control search-input" id="outExpectDate" />
				</div>
				<div class="col-md-3 date-field date-range" style="display:none;">
					<label class="form-label">기간(시작)</label>
					<input type="date" class="form-control search-input" id="outRangeStart" />
				</div>
				<div class="col-md-3 date-field date-range" style="display:none;">
					<label class="form-label">기간(종료)</label>
					<input type="date" class="form-control search-input" id="outRangeEnd" />
				</div>
			</div>
			<div class="row mt-2">
				<div class="col-md-3">
					<label class="form-label">프랜차이즈</label>
					<input type="text" class="form-control search-input" id="franchiseKeyword" placeholder="업체명/코드 검색" />
				</div>
				<div class="col-md-3">
					<label class="form-label">상태</label>
					<select class="form-control search-select" id="status">
						<option value="">전체</option>
						<option value="대기">대기</option>
						<option value="출고준비">출고준비</option>
						<option value="배차대기">배차대기</option>
						<option value="배차완료">배차완료</option>
						<option value="적재완료">적재완료</option>
						<option value="출고완료">출고완료</option>
						<option value="운송완료">운송완료</option>
						<option value="취소">취소</option>
					</select>
				</div>
				<div class="col-md-3">
					<label class="form-label">출고번호 검색</label>
					<input type="text" class="form-control search-input" id="itemKeyword" placeholder="예) OBW-0001" />
				</div>
				<div class="col-md-3 d-flex align-items-end gap-2">
					<button type="button" id="detailSearchBtn" class="btn btn-primary">검색</button>
					<button class="btn btn-secondary btn-reset">초기화</button>
					<button type="button" class="btn btn-light" id="backToSimpleBtn">간단검색</button>
				</div>
			</div>
		</div>
		<a href="${pageContext.request.contextPath}/outbound/qrTest" class="btn btn-secondary btn-sm">QR 테스트</a>
		<!-- 액션 바 -->
		<div class="card">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">
					출고 목록
					<span class="text-muted" style="font-size:0.9em;">
						검색결과: 총 <c:out value="${totalPages}" default="-" />건
					</span>
				</div>
				<div class="d-flex gap-2">
					<sec:authorize access="hasAuthority('OUTBOUND_WRITE')">
						<a href="/order/insert" class="btn btn-primary btn-sm">새 출고 등록</a>
					</sec:authorize>
					<sec:authorize access="hasAuthority('OUTBOUND_WRITE')">
						<div class="page-actions">
							<a href="#" id="btnReadyOutbound" class="btn btn-primary btn-sm">출고준비 처리</a>
							<button id="btnScanQR" class="btn btn-primary btn-sm">QR 스캔</button>
							<button id="btnAssignManager" class="btn btn-primary btn-sm">담당자지정</button>
						</div>
					</sec:authorize>
						<button id="btnPrint" class="btn btn-secondary btn-sm">인쇄</button>
			   			<button id="btnReload" class="btn btn-secondary btn-sm">새로고침</button>
				</div>
			</div>

			<div class="table-responsive">
				<table class="table">
					<thead>
						<tr>
							<th><input type="checkbox" class="select-all" /></th>
							<th>출고번호</th>
							<th>출고일자</th>
							<th>출고위치</th>
							<th>프렌차이즈 업체</th>
							<th>상태</th>
							<th>품목수</th>
							<th>출고예정수량</th>
							<th>담당자</th>
							<th>비고</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="order" items="${obManagement}">
							<c:url var="detailUrl" value="/outbound/outboundDetail">
								<c:param name="obwaitNumber" value="${order.obwaitNumber}" />
								<c:param name="outboundOrderIdx" value="${order.outboundOrderIdx}" />
							</c:url>
					
							<tr data-href="${detailUrl}">
								<td><input type="checkbox" name="selectedOrder" value="${order.outboundOrderIdx}" /></td>
								<td><c:out value="${order.obwaitNumber}" /></td>
								<td><c:out value="${order.departureDate}" /></td>
								<td><c:out value="${order.outboundLocation}" /></td>
								<td><c:out value="${order.franchiseName}" /></td>
								<td><c:out value="${order.status}" /></td>
								<td><c:out value="${order.itemCount}" /></td>
								<td><c:out value="${order.totalQuantity}" /></td>
								<td><c:out value="${order.manager}" /></td>
								<td><c:out value="${order.note}" /></td>
							</tr>
						</c:forEach>
					</tbody>

				</table>
			</div>
			
			<!-- 페이징 ============================================================================ -->
			<div class="d-flex justify-content-between align-items-center p-3">
				<div class="text-muted">
					페이지 ${pageNum} / ${totalPages} (총 ${totalCount}건)
				</div>
				<div class="d-flex gap-2">
					<c:if test="${pageNum > 1}">
						<a href="?pageNum=1
							&simpleKeyword=${param.simpleKeyword}
							&outboundNumber=${param.outboundNumber}
							&franchiseKeyword=${param.franchiseKeyword}
							&status=${param.status}
							&outRequestDate=${param.outRequestDate}
							&outExpectDate=${param.outExpectDate}
							&outRangeStart=${param.outRangeStart}
							&outRangeEnd=${param.outRangeEnd}"
						   class="btn btn-secondary btn-sm">« 처음</a>
			
						<a href="?pageNum=${pageNum - 1}
							&simpleKeyword=${param.simpleKeyword}
							&outboundNumber=${param.outboundNumber}
							&franchiseKeyword=${param.franchiseKeyword}
							&status=${param.status}
							&outRequestDate=${param.outRequestDate}
							&outExpectDate=${param.outExpectDate}
							&outRangeStart=${param.outRangeStart}
							&outRangeEnd=${param.outRangeEnd}"
						   class="btn btn-secondary btn-sm">‹ 이전</a>
					</c:if>
			
					<%-- 버튼 최대 갯수 --%>
					<c:set var="maxButtons" value="5" />
					<c:set var="half" value="${(maxButtons - 1) / 2}" />
			
					<%-- 기본 start/end 계산 (현재페이지를 가운데 정렬) --%>
					<c:set var="start" value="${pageNum - half}" />
					<c:set var="end" value="${start + maxButtons - 1}" />
			
					<%-- start 보정 (1보다 작을 때) --%>
					<c:if test="${start < 1}">
					    <c:set var="start" value="1" />
					    <c:set var="end" value="${maxButtons}" />
					</c:if>
			
					<%-- end 보정 (totalPages 넘어갈 때) --%>
					<c:if test="${end > totalPages}">
					    <c:set var="end" value="${totalPages}" />
					    <c:set var="start" value="${totalPages - (maxButtons - 1)}" />
					</c:if>
			
					<%-- start가 음수가 되지 않도록 보정 --%>
					<c:if test="${start < 1}">
					    <c:set var="start" value="1" />
					</c:if>
			
					<%-- 페이지 버튼 출력 --%>
					<c:forEach var="i" begin="${start}" end="${end}">
						<c:if test="${i >= 1 && i <= totalPages}">
							<c:choose>
								<c:when test="${i == pageNum}">
									<span class="btn btn-primary btn-sm">${i}</span>
								</c:when>
								<c:otherwise>
									<c:url var="pageUrl" value="/outbound/outboundManagement">
										<c:param name="simpleKeyword" value="${param.simpleKeyword}" />
										<c:param name="outboundNumber" value="${param.outboundNumber}" />
										<c:param name="franchiseKeyword" value="${param.franchiseKeyword}" />
										<c:param name="status" value="${param.status}" />
										<c:param name="outRequestDate" value="${param.outRequestDate}" />
										<c:param name="outExpectDate" value="${param.outExpectDate}" />
										<c:param name="outRangeStart" value="${param.outRangeStart}" />
										<c:param name="outRangeEnd" value="${param.outRangeEnd}" />
										<c:param name="pageNum" value="${i}" />
									</c:url>
									<a href="${pageUrl}" class="btn btn-secondary btn-sm">${i}</a>
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:forEach>
			
					<c:if test="${pageNum < totalPages}">
						<a href="?pageNum=${pageNum + 1}
							&simpleKeyword=${param.simpleKeyword}
							&outboundNumber=${param.outboundNumber}
							&franchiseKeyword=${param.franchiseKeyword}
							&status=${param.status}
							&outRequestDate=${param.outRequestDate}
							&outExpectDate=${param.outExpectDate}
							&outRangeStart=${param.outRangeStart}
							&outRangeEnd=${param.outRangeEnd}"
						   class="btn btn-secondary btn-sm">다음 ›</a>
			
						<a href="?pageNum=${totalPages}
							&simpleKeyword=${param.simpleKeyword}
							&outboundNumber=${param.outboundNumber}
							&franchiseKeyword=${param.franchiseKeyword}
							&status=${param.status}
							&outRequestDate=${param.outRequestDate}
							&outExpectDate=${param.outExpectDate}
							&outRangeStart=${param.outRangeStart}
							&outRangeEnd=${param.outRangeEnd}"
						   class="btn btn-secondary btn-sm">끝 »</a>
					</c:if>
				</div>
			</div>

			<!-- 페이징 ============================================================================ -->
		</div>
	</section>
	
	
	
	<!-- ✅ 담당자 모달 포함 -->
	<jsp:include page="/WEB-INF/views/outbound/modal/changeManager.jsp"></jsp:include>
	<!-- JS -->
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/outbound/modal/modify.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/outbound/management.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script src="https://unpkg.com/@zxing/library@latest/umd/index.min.js"></script>
	<script> const contextPath = "${pageContext.request.contextPath}";</script>
	<jsp:include page="/WEB-INF/views/outbound/modal/qrScannerModal.jsp"></jsp:include>
	<script src="${pageContext.request.contextPath}/resources/js/outbound/modal/managementQRscanner.js"></script>
</body>
</html>
