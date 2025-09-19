<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>입고 관리</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/inbound/inboundManagement.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/inbound/modal/pageJumpModal.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/inbound/modal/detailSmallModal.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

</head>
<body>
	<!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<!-- 반드시 content 안에서 시작 -->
	<section class="content">

		<!-- 페이지 타이틀 -->
		<div class="d-flex justify-content-between align-items-center mb-2">
		     <h1 class="card-title" style="margin:0;">입고관리</h1>
		</div>

		<!-- 간단 검색바 -->
		<div class="card mb-3 inbound-simple-search d-flex align-items-center p-3 gap-2">
		    <input type="text" class="form-control" id="simpleItemKeyword" placeholder="발주번호/입고번호 검색" />
		    <button class="btn btn-primary btn-sm" id="simpleSearchBtn">검색</button>
		    <button class="btn btn-secondary btn-sm" id="toggleDetailSearchBtn">상세검색</button>
		</div>
		
		<!-- 검색/필터 ========================================================================================================-->
		<div class="card mb-4 inbound-filters" id="detailSearchCard" style="display:none;">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">검색 / 필터</div>
			</div>
			
			<!-- 입고일자 기간 -->
			<div class="row">
			    <div class="col-md-3">
			        <label class="form-label">입고 시작일</label>
			        <input type="date" class="form-control search-input" id="inStartDate" />
			    </div>
			    <div class="col-md-3">
			        <label class="form-label">입고 종료일</label>
			        <input type="date" class="form-control search-input" id="inEndDate" />
			    </div>
			</div>
			
			<!-- 1줄: 상태 · 발주번호/입고번호 · 공급업체 -->
			<div class="row">
				<div class="col-md-3">
					<label class="form-label">상태</label>
					<select class="form-control search-select" id="status">
						<option value="">전체</option>
						<option value="운송중">운송중</option>
						<option value="대기">대기</option>
						<option value="검수중">검수중</option>
						<option value="검수완료">검수완료</option>
						<option value="재고등록완료">재고등록완료</option>
						<option value="취소">취소</option>
						<option value="반려">반려</option>
					</select>
				</div>
		
				<div class="col-md-3 position-relative">
					<label class="form-label">발주번호/입고번호</label>
					<input type="text" class="form-control search-input" id="orderInboundKeyword" placeholder="예: PO20250901 또는 IB20250901-001" />
					<button type="button" class="btn btn-clear-input" onclick="clearInput('orderInboundKeyword')">×</button>
				</div>
		
				<div class="col-md-3 position-relative">
					<label class="form-label">공급업체</label>
					<input type="text" class="form-control search-input" id="vendorKeyword" placeholder="업체명/코드 검색" />
					<button type="button" class="btn btn-clear-input" onclick="clearInput('vendorKeyword')">×</button>
				</div>
			</div>
		
			<!-- 버튼 -->
			<div class="row">
				<div class="col-md-12 d-flex align-items-center gap-2 mt-3">
					<button class="btn btn-primary btn-search">검색</button>
					<button class="btn btn-secondary btn-reset">초기화</button>
				</div>
			</div>
		</div>
		<!-- 검색/필터 끝 ========================================================================================================-->

		
		<!-- 액션 바 (rail로 좌우 여백 통일) -->
		<div class="card">
		    <div class="card-header d-flex justify-content-between align-items-center">
		        <div class="card-title">
		            입고 목록
		            <span class="text-muted" style="font-size: 0.9em;">
					    검색결과: 총 <strong>${totalCount}</strong>건
					</span>
		        </div>
		        <div class="d-flex gap-2">
					<a href="${pageContext.request.contextPath}/inbound/qrTest" class="btn btn-secondary btn-sm">QR 테스트</a>
		        	<div class="page-actions">
					    <button id="btnScanQR" class="btn btn-primary btn-sm">QR 스캔</button>
						<button id="btnAssignManager" class="btn btn-primary btn-sm">담당자지정</button>
					</div>
		            <a href="${pageContext.request.contextPath}/inbound/management/excel?
				    	status=${param.status}&orderInboundKeyword=${param.orderInboundKeyword}
				    	&vendorKeyword=${param.vendorKeyword}&inStartDate=${param.inStartDate}
				    	&inEndDate=${param.inEndDate}&simpleKeyword=${param.simpleKeyword}"
				   		class="btn btn-secondary btn-sm">엑셀 다운로드</a>
				   	<button id="btnPrint" class="btn btn-secondary btn-sm">인쇄</button>
				   	<button id="btnReload" class="btn btn-secondary btn-sm">새로고침</button>
		        </div>
		    </div>
			<div class="table-responsive">
				<table class="table">
					<thead>
						<tr>
							<th><input type="checkbox" class="select-all" /></th>
							<th>발주번호</th>
							<th>입고번호</th>
							<th>입고일자</th>
							<th>공급업체</th>
							<th>상태</th>
							<th>품목수</th>
<!-- 							<th>총수량</th> -->
							<th>입고예정수량</th>
							<th>담당자</th>
							<th>비고</th>
						</tr>
					</thead>
	<!-- ==============================================================================================================리스트 존========= -->				
					<tbody>
					    <!-- 출력 카운터 초기화 -->
					    <c:set var="displayCount" value="0" />
					
					    <c:forEach var="order" items="${orderList}">
					        <c:if test="${not empty order.orderNumber}">
					            <tr>
					                <!-- 체크박스 -->
					                <td><input type="checkbox" name="selectedOrder" value="${order.ibwaitIdx}" /></td>
					
					                <!-- 발주번호 (링크) -->
					                <td>
					                    <c:url var="detailUrl" value="/inbound/inboundDetail">
					                        <c:param name="orderNumber" value="${order.orderNumber}" />
					                        <c:param name="ibwaitIdx" value="${order.ibwaitIdx}" />
					                    </c:url>
					                    <a href="${detailUrl}" class="link-order-number">
					                        <c:out value="${order.orderNumber}" default="-" />
					                    </a>
					                </td>
					
					                <!-- 입고번호 -->
					                <td><c:out value="${order.ibwaitNumber}" /></td>
					
					                <!-- 입고일자 -->
					                <td><c:out value="${order.arrivalDateStr}" default="-" /></td>
					
					                <!-- 공급업체 -->
					                <td><c:out value="${order.supplierName}" /></td>
					                
					                <!-- 상태 -->
					                <td><c:out value="${order.inboundStatus}" /></td>
					
					                <!-- 품목수 -->
					                <td><c:out value="${order.numberOfItems}" /></td>
					
					                <!-- 입고예정수량 -->
					                <td><c:out value="${order.quantity}" /></td>
					
					                <!-- 담당자 -->
					                <td><c:out value="${order.manager}" /></td>
					
					                <!-- 비고 -->
					                <td><c:out value="${order.note}" /></td>
					            </tr>
					
					            <!-- 출력 카운트 증가 -->
					            <c:set var="displayCount" value="${displayCount + 1}" />
					        </c:if>
					    </c:forEach>
					
					    <!-- 출력된 행이 하나도 없을 경우 안내문 -->
					    <c:if test="${displayCount == 0}">
					        <tr>
					            <td colspan="11" class="text-center">입고 데이터가 존재하지 않습니다.</td>
					        </tr>
					    </c:if>
					</tbody>
	<!-- ==============================================================================================================리스트 존========= -->				
				</table>
			</div>
			
			<!-- 페이징 -->
			<div class="d-flex justify-content-between align-items-center p-3">
				<div class="text-muted">페이지 ${pageInfo.pageNum} / ${pageInfo.maxPage}</div>
				<div class="d-flex gap-2">
					<c:if test="${pageInfo.pageNum > 1}">
						<a href="?pageNum=1" class="btn btn-secondary btn-sm">« 처음</a>
						<a href="?pageNum=${pageInfo.pageNum - 1}" class="btn btn-secondary btn-sm">‹ 이전</a>
					</c:if>
			
					<%-- 버튼 최대 갯수 --%>
					<c:set var="maxButtons" value="5" />
			
					<%-- 시작/끝 페이지 계산 --%>
					<c:choose>
						<%-- 현재 페이지가 마지막 5개 안에 들어가면 마지막 구간 고정 --%>
						<c:when test="${pageInfo.pageNum > pageInfo.maxPage - (maxButtons - 1)}">
						    <c:set var="start" value="${pageInfo.maxPage - (maxButtons - 1)}" />
						    <c:set var="end" value="${pageInfo.maxPage}" />
						</c:when>
						<%-- 그 외에는 현재 페이지를 맨 앞에 --%>
						<c:otherwise>
						    <c:set var="start" value="${pageInfo.pageNum}" />
						    <c:set var="end" value="${pageInfo.pageNum + (maxButtons - 1)}" />
						</c:otherwise>
					</c:choose>
					
					<c:if test="${start < 1}">
					    <c:set var="start" value="1" />
					</c:if>
			
					<%-- 페이지 버튼 출력 --%>
					<c:forEach var="i" begin="${start}" end="${end}">
						<c:if test="${i >= 1 && i <= pageInfo.maxPage}">
							<c:choose>
								<c:when test="${i == pageInfo.pageNum}">
									<a href="?pageNum=${i}" class="btn btn-primary btn-sm">${i}</a>
								</c:when>
								<c:otherwise>
									<a href="?pageNum=${i}" class="btn btn-secondary btn-sm">${i}</a>
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:forEach>
			
					<%-- 다음 구간이 더 있으면 점프 모달 --%>
					<c:if test="${end < pageInfo.maxPage}">
						<button class="btn btn-light btn-sm" onclick="ModalManager.openModalById('pageJumpModal')">...</button>
					</c:if>
			
					<c:if test="${pageInfo.pageNum < pageInfo.maxPage}">
						<a href="?pageNum=${pageInfo.pageNum + 1}" class="btn btn-secondary btn-sm">다음 ›</a>
						<a href="?pageNum=${pageInfo.maxPage}" class="btn btn-secondary btn-sm">끝 »</a>
					</c:if>
				</div>
			</div>
			
		</div>

		<!-- 공통 설정 모달 -->
		<div id="settings-modal" class="settings-modal" aria-hidden="true">
			<div class="settings-content">
				<div class="settings-header">
					<div class="card-title">페이지 설정</div>
					<button id="settings-close" class="settings-close" aria-label="닫기">&times;</button>
				</div>
				<div class="mb-3">
					<label class="form-label">기본 정렬</label>
					<select class="form-control">
						<option>입고일자 최신순</option>
						<option>입고번호 오름차순</option>
						<option>상태순</option>
					</select>
				</div>
				<div class="d-flex justify-content-between">
					<button id="settings-cancel" class="btn btn-secondary">취소</button>
					<button class="btn btn-primary">저장</button>
				</div>
			</div>
		</div>
	</section>
	
	<jsp:include page="/WEB-INF/views/inbound/modal/pageJumpModal.jsp" />
	<script src="${pageContext.request.contextPath}/resources/js/inbound/modal/pageJumpModal.js"></script>
	<jsp:include page="/WEB-INF/views/inbound/modal/modifyManager.jsp" />
	<script src="${pageContext.request.contextPath}/resources/js/inbound/modal/modify.js"></script>
	<jsp:include page="/WEB-INF/views/inbound/modal/qrScannerModal.jsp" />
	<script src="https://unpkg.com/@zxing/library@latest/umd/index.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/inbound/modal/managementQRscanner.js"></script>
	
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script> const contextPath = "${pageContext.request.contextPath}";</script>
	<script src="${pageContext.request.contextPath}/resources/js/inbound/inboundManagement.js"></script>
	
	<script>
		document.getElementById('toggleDetailSearchBtn').addEventListener('click', function() {
		    const detailCard = document.getElementById('detailSearchCard');
		    if (detailCard.style.display === 'none') {
		        detailCard.style.display = '';
		        this.textContent = '상세검색 닫기';
		    } else {
		        detailCard.style.display = 'none';
		        this.textContent = '상세검색';
		    }
		});
	</script>
	
</body>
</html>
