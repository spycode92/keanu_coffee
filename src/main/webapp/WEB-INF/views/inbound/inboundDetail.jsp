<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>입고 상세</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<link href="${pageContext.request.contextPath}/resources/css/inbound/inboundDetailAndInspection.css" rel="stylesheet" />
	<link href="${pageContext.request.contextPath}/resources/css/inbound/inboundDetail.css" rel="stylesheet" />
	
	
	<!-- ============================================ 가격 계산 ============================================ -->
	<script>
		function formatCurrency(value) {
		    return "₩ " + Number(value).toLocaleString();       
		}
		
		function recalculate(index) {
		    const qtyInput = document.querySelector(`input.quantity[data-index='${index}']`);
		    const priceInput = document.querySelector(`input.unitPrice[data-index='${index}']`);
		
		    const quantity = parseFloat(qtyInput.value) || 0;
		    const unitPrice = parseFloat(priceInput.value) || 0;
		
		    const amount = quantity * unitPrice;
		    const tax = amount * 0.1;
		    const total = amount + tax;
		
		    document.querySelector(`.amount[data-index='${index}']`).textContent = formatCurrency(amount);
		    document.querySelector(`.tax[data-index='${index}']`).textContent = formatCurrency(tax);
		    document.querySelector(`.totalPrice[data-index='${index}']`).textContent = formatCurrency(total);
		
		    updateGrandTotal(); // 전체 합계도 갱신
		}
		
		function updateGrandTotal() {
		    let total = 0;
		    document.querySelectorAll(".totalPrice").forEach(cell => {
		        const text = cell.textContent.replace(/[^\d]/g, "");
		        total += parseInt(text) || 0;
		    });
		    document.getElementById("grandTotalCell").textContent = formatCurrency(total);
		}
		
		// 이벤트 연결
		document.querySelectorAll("input.quantity, input.unitPrice").forEach(input => {
		    input.addEventListener("input", () => {<fmt:formatDate value="${dto.arrivalDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
		        const index = input.getAttribute("data-index");
		        recalculate(index);
		    });
		});
	</script>
	<!-- ============================================ 가격 계산 ============================================ -->
	
</head>
 
<body data-context="${pageContext.request.contextPath}">
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content inbound-detail" data-app-root="1">
		<!-- 헤더 / 액션 -->
		<div class="d-flex justify-content-between align-items-center mb-3">
			<div>
				<h1 class="card-title">입고 상세</h1>
			</div>
			
			<div class="page-actions">
				<button id="btnPrint" class="btn btn-secondary btn-sm">인쇄</button>
				<sec:authorize access="hasAuthority('INBOUND_WRITE')">
					<button id="btnEdit"
					        class="btn btn-primary btn-sm"
					        data-ibwait-idx="${inboundDetailData.ibwaitIdx}"
					        data-order-number="${inboundDetailData.orderNumber}"
					        data-status="${inboundDetailData.inboundStatus}"
					        data-manager="${inboundDetailData.managerName}">
					    검수
					</button>
				</sec:authorize>
				<button id="btnBack" class="btn btn-secondary btn-sm" title="뒤로가기">← 뒤로</button>
			</div>
		</div>
		
		<!-- 상단 기본정보 카드 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">기본 정보</div>
				<div class="text-muted">상태: 	<span class="badge badge-pending">
													<c:out value="${inboundDetailData.inboundStatus}" default="-"/>
												</span></div>
			</div>
			<div class="kv-grid">
				<div class="kv-item">
					<div class="kv-label">입고번호</div>
					<div class="kv-value">
					    <c:out value="${inboundDetailData.ibwaitNumber}" default="-" />
					    
					</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">입고일자</div>
					<div class="kv-value">
<%-- 						<c:out value="${fn:substringBefore(inboundDetailData.arrivalDate, 'T')}" default="-" /> --%>
						<c:out value="${inboundDetailData.arrivalDateFormatted}" default="-" />
					</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">발주번호</div>
					<div class="kv-value"><c:out value="${inboundDetailData.orderNumber}" default="-"/></div>
				</div>
				<div class="kv-item">
					<div class="kv-label">입고구분</div>
					<div class="kv-value"><c:out value="${inboundDetailData.inboundClassification}" default="-"/></div>
				</div>

				<div class="kv-item">
					<div class="kv-label">공급업체</div>
					<div class="kv-value"><c:out value="${inboundDetailData.supplierName}" default="-"/></div>
				</div>
				
				<div class="kv-item">
					<div class="kv-label">담당자</div>
					<div class="kv-value">
						<span id="fieldManagerName">
							<c:out value="${inboundDetailData.managerName}" default="-"/>
						</span>
					</div>
				</div>
				
				<div class="kv-item">
					<div class="kv-label">(PO)</div>
					<div class="kv-value"><c:out value="${inboundDetailData.orderNumber}" default="-"/></div>
				</div>
				
				<div class="kv-item">
					<div class="kv-label">입고위치</div>
					<div class="kv-value">
						<span id="fieldInboundLocation">
							<c:out value="${inboundDetailData.inboundLocation}" default="-"/>
						</span>
					</div>
				</div>

				<div class="kv-item">
					<div class="kv-label">총 품목 수</div>
					<div class="kv-value"><c:out value="${inboundDetailData.numberOfItems}" default="-"/></div>
				</div>
				<div class="kv-item">
					<div class="kv-label">총 수량</div>
					<div class="kv-value"><c:out value="${inboundDetailData.quantity}" default="-"/></div>
				</div>
				<div class="kv-item">
					<div class="kv-label">총 금액</div>
					<div class="kv-value"><fmt:formatNumber value="${inboundDetailData.totalPrice}" pattern="₩ #,##0" /></div>
				</div>
				<div class="kv-item">
					<div class="kv-label">비고</div>
					<div class="kv-value"><c:out value="${inboundDetailData.note}" default="-"/></div>
				</div>
			</div>
		</div>

		<!-- 상태 타임라인 -->
		<div class="card mb-3">
			<div class="timeline-container">
			    <c:set var="steps" value="${fn:split('운송중,대기,검수중,검수완료,재고등록완료', ',')}" />
				<ul class="timeline">
				    <c:forEach var="step" items="${steps}" varStatus="st">
				        <c:set var="matchedTime" value="" />
				        <!-- historyList에서 해당 step의 시간 가져오기 -->
				        <c:forEach var="h" items="${historyList}">
				            <c:if test="${h.status == step}">
				                <c:set var="matchedTime" value="${h.changedAtStr}" />
				            </c:if>
				        </c:forEach>
				
				        <li class="timeline-step ${not empty matchedTime ? 'done' : 'pending'}">
				            <div class="circle">${st.index + 1}</div>
				            <div class="label">${step}</div>
				            <div class="time">
				                <c:choose>
				                    <c:when test="${not empty matchedTime}">
				                        ${matchedTime}
				                    </c:when>
				                    <c:otherwise>-</c:otherwise>
				                </c:choose>
				            </div>
				        </li>
				    </c:forEach>
				</ul>
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
							<th colspan="2">품목명 / 규격</th>
							<th>LOT번호</th>
							<th>수량</th>
							<th>단위</th>
							<th>단가</th>
							<th>공급가액</th>
							<th>부가세</th>
							<th>총액</th>
						</tr>
					</thead>
	<!-- ==============================================================================================================리스트 존========= -->
					<tbody>
					    <c:choose>
					        <c:when test="${not empty ibProductDetail}">
					            <c:forEach var="item" items="${ibProductDetail}" varStatus="vs">
					                <tr>
					                    <!-- No. -->
					                    <td>
					                        <c:out value="${vs.index + 1}" />
					                    </td>
					
					                    <!-- 상품명 -->
					                    <td colspan="2">
					                        <c:out value="${item.productName}" />
					                    </td>
										
										<!-- LOT넘버 -->
					                    <td><c:out value="${item.lotNumber}" /></td>
										
					                    <!-- 수량 -->
					                    <td>
					                        <fmt:formatNumber value="${item.quantity}" pattern="#개,##0" />
					                    </td>
					
					                    <!-- 단위 -->
					                    <td>
					                        <fmt:formatNumber value="${item.productVolume}" pattern="#호" />
					                    </td>
					
					                    <!-- 단가 -->
					                    <td>
					                        <fmt:formatNumber value="${item.unitPrice}" pattern="₩ #,##0" />
					                    </td>
					
					                    <!-- 공급가액 -->
					                    <td>
					                        <fmt:formatNumber value="${item.amount}" pattern="₩ #,##0" />
					                    </td>
					
					                    <!-- 부가세 -->
					                    <td>
					                        <fmt:formatNumber value="${item.tax}" pattern="₩ #,##0" />
					                    </td>
					
					                    <!-- 총액 -->
					                    <td>
					                        <fmt:formatNumber value="${item.totalPrice}" pattern="₩ #,##0" />
					                    </td>
					
					                    
					                </tr>
					            </c:forEach>
					        </c:when>
					        <c:otherwise>
					            <tr>
					                <td colspan="10" class="text-center">입고 품목 정보가 없습니다.</td>
					            </tr>
					        </c:otherwise>
					    </c:choose>
					</tbody>
					
					<c:set var="grandTotal" value="0" />
					<c:forEach var="item" items="${ibProductDetail}">
					    <c:set var="grandTotal" value="${grandTotal + item.totalPrice}" />
					</c:forEach>
					
					<tfoot>
					    <tr>
					        <td colspan="8"></td>
					        <td>합계</td>
					        <td><fmt:formatNumber value="${grandTotal}" pattern="₩ #,##0" /></td>
					    </tr>
					</tfoot>
	<!-- ==============================================================================================================리스트 존========= -->
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
						<div class="attachment-item">packing_list_20250811.pdf</div>
						<div class="attachment-item">inspection_photo_1.jpg</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="muted">메모</div>
					<div class="kv-value" style="min-height:80px;">검수 후 입고확정 필요 — 외관 손상 일부. 공급사에 통보 예정.</div>
				</div>
			</div>
		</div>
	</section>
	
	<!-- ============================================================================================================ js 모음 -->
	<sec:authorize access="isAuthenticated()">
		<script>
			// 로그인 사용자
			window.currentUserNo = "<sec:authentication property='principal.username' htmlEscape='false'/>";
			window.currentUserName = "<sec:authentication property='principal.empName' htmlEscape='false'/>";
			
			// 버튼에 들어간 담당자(manager) 값 읽기
			document.addEventListener("DOMContentLoaded", () => {
				const btnEdit = document.getElementById("btnEdit");
				if (btnEdit) {
					console.log("✅ 로그인 사용자 사번:", window.currentUserNo);
					console.log("✅ 로그인 사용자 이름:", window.currentUserName);
					console.log("✅ 페이지에 표시된 담당자(manager):", btnEdit.dataset.manager);
				}
			});
		</script>
	</sec:authorize>
	<script> 
		const contextPath = "${pageContext.request.contextPath}";
	</script>
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/inbound/modal/modify.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/inbound/inboundDetail.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/inbound/refresh.js"></script>
</body>
<link href="${pageContext.request.contextPath}/resources/css/inbound/modal/detailSmallModal.css" rel="stylesheet" />
</html>
