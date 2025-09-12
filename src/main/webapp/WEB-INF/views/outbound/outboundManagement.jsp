<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

</head>
<body>
	<!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<!-- 반드시 content 안에서 시작 -->
	<section class="content">

		<!-- 페이지 타이틀 -->
		<div class="d-flex justify-content-between align-items-center mb-2">
		     <h1 class="card-title" style="margin:0;">출고관리</h1>
		</div>

		<!-- 간단 검색바 -->
		<div class="card mb-3 inbound-simple-search d-flex align-items-center p-3 gap-2">
		    <input type="text" class="form-control" id="simpleItemKeyword" placeholder="품목 코드/명 검색" />
		    <button class="btn btn-primary btn-sm" id="simpleSearchBtn">검색</button>
		    <button class="btn btn-secondary btn-sm" id="toggleDetailSearchBtn">상세검색</button>
		</div>
		
		<!-- 검색/필터 -->
		<div class="card mb-4 inbound-filters" id="detailSearchCard" style="display:none;">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">검색 / 필터</div>
			</div>

			<!-- 날짜 + 기준 -->
			<div class="row">
				<div class="col-md-3">
					<label class="form-label">검색 기준</label>
					<select class="form-control search-select" id="dateBasis">
						<option value="start" selected>시작일 기준</option>
						<option value="end">종료일(완료일) 기준</option>
						<option value="range">기간 기준</option>
					</select>
				</div>

				<div class="col-md-3 date-field date-start">
					<label class="form-label">출고 시작일</label>
					<input type="date" class="form-control search-input" id="inStartDate" />
				</div>

				<div class="col-md-3 date-field date-end" style="display:none;">
					<label class="form-label">출고 종료일(완료일)</label>
					<input type="date" class="form-control search-input" id="inEndDate" />
				</div>

				<div class="col-md-3 date-field date-range" style="display:none;">
					<label class="form-label">기간(시작)</label>
					<input type="date" class="form-control search-input" id="inRangeStart" />
				</div>
				<div class="col-md-3 date-field date-range" style="display:none;">
					<label class="form-label">기간(종료)</label>
					<input type="date" class="form-control search-input" id="inRangeEnd" />
				</div>
			</div>

			<!-- 1줄: 창고 · 상태 · 품목 -->
			<div class="row">
				<div class="col-md-3">
					<label class="form-label">창고</label>
					<select class="form-control search-select" id="warehouse">
						<option value="">전체</option>
						<option>중앙창고</option>
						<option>동부창고</option>
						<option>서부창고</option>
					</select>
				</div>
				<div class="col-md-3">
					<label class="form-label">상태</label>
					<select class="form-control search-select" id="status">
						<option value="">전체</option>
						<option value="PENDING">대기</option>
						<option value="CONFIRMED">확정</option>
						<option value="COMPLETED">완료</option>
					</select>
				</div>
				<div class="col-md-3">
					<label class="form-label">품목 코드/명</label>
					<input type="text" class="form-control search-input" placeholder="예) SKU-0001" id="itemKeyword" />
				</div>
				<div class="col-md-3"></div>
			</div>

			<!-- 2줄: 공급업체만 -->
			<div class="row">
				<div class="col-md-3">
					<label class="form-label">공급업체</label>
					<input type="text" class="form-control search-input" placeholder="업체명/코드 검색" id="vendorKeyword" />
				</div>
				<div class="col-md-9"></div>
			</div>

			<!-- 버튼 -->
			<div class="row">
				<div class="col-md-12 d-flex align-items-center gap-2 mt-3">
					<button class="btn btn-primary btn-search">검색</button>
					<button class="btn btn-secondary btn-reset">초기화</button>
				</div>
			</div>
		</div>

		
		<!-- 액션 바 (rail로 좌우 여백 통일) -->
		<div class="card">
		    <div class="card-header d-flex justify-content-between align-items-center">
		        <div class="card-title">
		            출고 목록
		            <span class="text-muted" style="font-size: 0.9em;">검색결과: 총 <strong id="resultCount"></strong>건</span>
		        </div>
		        <div class="d-flex gap-2">
					<a href="/order/insert" class="btn btn-primary btn-sm">새 출고 등록</a>
					<a href="#" id="btnReadyOutbound" class="btn btn-primary btn-sm">출고준비 처리</a>
		            <a href="#" class="btn btn-secondary btn-sm">엑셀 다운로드</a>
					<a href="#" id="settings-button" class="btn btn-secondary btn-sm">설정</a>
		            <a href="#" class="btn btn-secondary btn-sm">선택삭제</a>
		        </div>
		    </div>
			<div class="table-responsive">
				<table class="table">
					<thead>
						<tr>
							<th style="width:36px;"><input type="checkbox" class="select-all" /></th>
							<th>출고번호</th>
							<th>출고일자</th>
							<th>출고위치</th>
							<th>프렌차이즈 업체</th>
							<th>상태</th>
							<th>품목수</th>
<!-- 							<th>총수량</th> -->
							<th>출고예정수량</th>
							<th>담당자</th>
							<th>비고</th>
						</tr>
					</thead>
	<!-- ==============================================================================================================리스트 존========= -->				
					<tbody>
					    <!-- 출력 카운터 초기화 -->
					    <c:set var="displayCount" value="0" />
					
					    <c:forEach var="order" items="${obManagement}">
					        <c:if test="${not empty order.outboundOrderIdx}">
					            <tr>
					                <!-- 체크박스 -->
					                <td>
					                    <input type="checkbox" name="selectedOrder" value="${order.outboundOrderIdx}" />
					                </td>
					
					                <!-- 출고번호 (링크) -->
					                <td>
					                    <c:url var="detailUrl" value="/outbound/outboundDetail">
					                        <c:param name="obwaitNumber" value="${order.obwaitNumber}" />
					                        <c:param name="outboundOrderIdx" value="${order.outboundOrderIdx}" />
					                    </c:url>
					                    <a href="${detailUrl}" class="link-order-number">
					                        <c:out value="${order.obwaitNumber}" default="-" />
					                    </a>
					                </td>
					
					                <!-- 출고일자 -->
					                <td><c:out value="${order.departureDate}" default="-" /></td>
					
					                <!-- 출고위치 -->
					                <td><c:out value="${order.outboundLocation}" default="-" /></td>
					
					                <!-- 주문프랜차이즈 -->
					                <td><c:out value="${order.franchiseName}" default="-" /></td>
					
					                <!-- 상태 -->
					                <td><c:out value="${order.status}" default="-" /></td>
					
					                <!-- 품목수 -->
					                <td><c:out value="${order.itemCount}" default="0" /></td>
					
					                <!-- 출고예정수량 -->
					                <td><c:out value="${order.totalQuantity}" default="0" /></td>
					
					                <!-- 담당자 -->
					                <td class="manager-cell" data-modal-target="changeManager">
									    <c:out value="${order.manager}" default="-" />
									</td>
					
					                <!-- 비고 -->
					                <td><c:out value="${order.note}" default="-" /></td>
					            </tr>
					
					            <!-- 출력 카운트 증가 -->
					            <c:set var="displayCount" value="${displayCount + 1}" />
					        </c:if>
					    </c:forEach>
					
					    <!-- 출력된 행이 하나도 없을 경우 안내문 -->
					    <c:if test="${displayCount == 0}">
					        <tr>
					            <td colspan="10" class="text-center">출고 데이터가 존재하지 않습니다.</td>
					        </tr>
					    </c:if>
					</tbody>

	<!-- ==============================================================================================================리스트 존========= -->				
				</table>
			</div>
	
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
		</div>

	</section>
	<jsp:include page="/WEB-INF/views/outbound/modal/changeManager.jsp"></jsp:include>
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/outbound/management.js"></script>
</body>
</html>
 