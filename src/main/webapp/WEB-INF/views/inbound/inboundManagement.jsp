<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>입고 관리</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
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
		<form id="simpleSearchForm" method="get" action="${pageContext.request.contextPath}/inbound/management">
			<div class="card mb-3 inbound-simple-search d-flex align-items-center p-3 gap-2">
			    <input type="text" class="form-control" name="simpleKeyword" id="simpleItemKeyword"
			           placeholder="발주번호/입고번호 검색" value="${param.simpleKeyword}" />
			    <button type="submit" class="btn btn-primary btn-sm" id="simpleSearchBtn">검색</button>
			    <button type="button" class="btn btn-secondary btn-sm" id="toggleDetailSearchBtn">상세검색</button>
			</div>
		</form>
		
		
		<!-- 검색/필터 ========================================================================================================-->
		<form id="detailSearchForm" method="get" action="${pageContext.request.contextPath}/inbound/management"
		      class="card mb-4 inbound-filters" style="display:none;">
		    <div class="card-header d-flex justify-content-between align-items-center">
		        <div class="card-title">검색 / 필터</div>
		    </div>
		    
		    <!-- 입고일자 기간 -->
		    <div class="row">
		        <div class="col-md-3">
		            <label class="form-label">입고 시작일</label>
		            <input type="date" class="form-control search-input" name="inStartDate" id="inStartDate"
		                   value="${param.inStartDate}" />
		        </div>
		        <div class="col-md-3">
		            <label class="form-label">입고 종료일</label>
		            <input type="date" class="form-control search-input" name="inEndDate" id="inEndDate"
		                   value="${param.inEndDate}" />
		        </div>
		    </div>
		    
		    <!-- 1줄: 상태 · 발주번호/입고번호 · 공급업체 -->
		    <div class="row">
		        <div class="col-md-3">
		            <label class="form-label">상태</label>
		            <select class="form-control search-select" name="status" id="status">
		                <option value="" <c:if test="${empty param.status}">selected</c:if>>전체</option>
		                <option value="운송중" <c:if test="${param.status=='운송중'}">selected</c:if>>운송중</option>
		                <option value="대기" <c:if test="${param.status=='대기'}">selected</c:if>>대기</option>
		                <option value="검수중" <c:if test="${param.status=='검수중'}">selected</c:if>>검수중</option>
		                <option value="검수완료" <c:if test="${param.status=='검수완료'}">selected</c:if>>검수완료</option>
		                <option value="재고등록완료" <c:if test="${param.status=='재고등록완료'}">selected</c:if>>재고등록완료</option>
		                <option value="취소" <c:if test="${param.status=='취소'}">selected</c:if>>취소</option>
		                <option value="반려" <c:if test="${param.status=='반려'}">selected</c:if>>반려</option>
		            </select>
		        </div>
		
		        <div class="col-md-3 position-relative">
		            <label class="form-label">발주번호/입고번호</label>
		            <input type="text" class="form-control search-input" name="orderInboundKeyword" id="orderInboundKeyword"
		                   placeholder="예: PO20250901 또는 IB20250901-001" value="${param.orderInboundKeyword}" />
		            <button type="button" class="btn btn-clear-input" onclick="clearInput('orderInboundKeyword')">×</button>
		        </div>
		
		        <div class="col-md-3 position-relative">
		            <label class="form-label">공급업체</label>
		            <input type="text" class="form-control search-input" name="vendorKeyword" id="vendorKeyword"
		                   placeholder="업체명/코드 검색" value="${param.vendorKeyword}" />
		            <button type="button" class="btn btn-clear-input" onclick="clearInput('vendorKeyword')">×</button>
		        </div>
		    </div>
		
		    <!-- 버튼 -->
		    <div class="row">
			    <div class="col-md-12 d-flex align-items-center gap-2 mt-3">
			        <button type="submit" class="btn btn-primary btn-search">검색</button>
			        <button type="reset" class="btn btn-secondary btn-reset">초기화</button>
			        <button type="button" class="btn btn-light" id="backToSimpleBtn">간단검색</button>
			    </div>
			</div>
		</form>
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
					<button id="btnMyListFilter" class="btn btn-outline-primary btn-sm" data-active="false">담당</button>
		        	<sec:authorize access="hasAuthority('INBOUND_WRITE')">
			        	<div class="page-actions">
						   	<button id="btnScanQR" class="btn btn-primary btn-sm">QR 스캔</button>
							<button id="btnAssignManager" class="btn btn-primary btn-sm">담당자지정</button>
						</div>
					</sec:authorize>
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
					    <c:set var="displayCount" value="0" />
					    
						<sec:authorize access="hasAuthority('INBOUND_READ')">
					    <c:forEach var="order" items="${orderList}">
					        <c:if test="${not empty order.orderNumber}">
					            <c:url var="detailUrl" value="/inbound/inboundDetail">
					                <c:param name="orderNumber" value="${order.orderNumber}" />
					                <c:param name="ibwaitIdx" value="${order.ibwaitIdx}" />
					            </c:url>
					
					            <tr class="clickable-row" data-url="${detailUrl}" tabindex="0">
					                <td>
					                    <input type="checkbox" name="selectedOrder" value="${order.ibwaitIdx}" 
					                           onclick="event.stopPropagation();" />
					                </td>
					
					                <td><c:out value="${order.orderNumber}" default="-" /></td>
					                <td><c:out value="${order.ibwaitNumber}" /></td>
					                <td><c:out value="${order.arrivalDateStr}" default="-" /></td>
					                <td><c:out value="${order.supplierName}" /></td>
					                <td><c:out value="${order.inboundStatus}" /></td>
					                <td><c:out value="${order.numberOfItems}" /></td>
					                <td><c:out value="${order.quantity}" /></td>
					                <td><c:out value="${order.manager}" /></td>
					                <td><c:out value="${order.note}" /></td>
					            </tr>
					
					            <c:set var="displayCount" value="${displayCount + 1}" />
					        </c:if>
					    </c:forEach>
						</sec:authorize>
						
					    <c:if test="${displayCount == 0}">
					        <tr>
					            <td colspan="11" class="text-center">입고 데이터가 존재하지 않습니다.</td>
					        </tr>
					    </c:if>
					</tbody>
	<!-- ==============================================================================================================리스트 존========= -->				
				</table>
			</div>
			
			<!-- 페이징 (Ajax 전용) -->
			<div id="pagingArea" class="d-flex justify-content-between align-items-center p-3">
			    <div class="text-muted">페이지 <span id="pageNum">1</span> / <span id="maxPage">1</span></div>
			    <div class="d-flex gap-2" id="pagingButtons">
			        <!-- JS에서 버튼 렌더링 -->
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
		    const detailForm = document.getElementById('detailSearchForm');
		    const simpleForm = document.getElementById('simpleSearchForm');
	
		    if (detailForm.style.display === 'none') {
		        // 상세검색 열기
		        detailForm.style.display = 'block';
		        simpleForm.style.display = 'none';
		        this.textContent = '상세검색 닫기';
		    } else {
		        // 상세검색 닫기
		        detailForm.style.display = 'none';
		        simpleForm.style.display = 'block';
		        this.textContent = '상세검색';
		    }
		});
		
		document.getElementById('backToSimpleBtn').addEventListener('click', function() {
		    document.getElementById('detailSearchForm').style.display = 'none';
		    document.getElementById('simpleSearchForm').style.display = 'block';
		    document.getElementById('toggleDetailSearchBtn').textContent = '상세검색';
		});
		
		document.addEventListener("click", function(e) {
		    const row = e.target.closest("tr.clickable-row");
		    if (!row) return;

		    const url = row.getAttribute("data-url");
		    if (!url) return;

		    // SweetAlert 확인창
		    Swal.fire({
		        title: "상세 페이지로 이동하시겠습니까?",
		        text: "현재 페이지에서 벗어나게 됩니다.",
		        icon: "question",
		        showCancelButton: true,
		        confirmButtonText: "예",
		        cancelButtonText: "아니오"
		    }).then((result) => {
		        if (result.isConfirmed) {
		            window.location.href = url;
		        }
		    });
		});
	</script>
	<sec:authorize access="isAuthenticated()">
		<script>
			window.currentUserName = "<sec:authentication property='principal.empName' htmlEscape='false'/>";
		</script>
</sec:authorize>
</body>
</html>
