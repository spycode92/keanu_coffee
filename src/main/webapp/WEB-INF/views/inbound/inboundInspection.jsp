<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>입고 검수</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<link href="${pageContext.request.contextPath}/resources/css/inbound/inboundInspection.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
</head>
 
<body data-context="${pageContext.request.contextPath}">
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content inbound-detail">
		<!-- 헤더 / 액션 -->
		<div class="d-flex justify-content-between align-items-center mb-3">
			<div>
				<h1 class="card-title">입고 검수</h1>
			</div>
			<div class="page-actions">
				<button id="btnAssignLocation" class="btn btn-primary btn-sm">입고위치지정</button>
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
					    <input type="hidden" id="inboundLink"
						       data-ibwait-idx="${inboundDetailData.ibwaitIdx}"
						       data-order-number="${inboundDetailData.orderNumber}" />
					</div>
					<input type="hidden" id="currentUser" data-emp-idx="${inboundDetailData.managerIdx}" />
				</div>
				<div class="kv-item">
					<div class="kv-label">입고일자</div>
					<div class="kv-value"><c:out value="${inboundDetailData.arrivalDate}" default="-"/></div>
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
					<div class="kv-label">발주번호(PO)</div>
					<div class="kv-value"><c:out value="${inboundDetailData.orderNumber}" default="-"/></div>
				</div>
				
				<div class="kv-item">
					<div class="kv-label">입고위치</div>
					<div class="kv-value">
						<span id="fieldInboundLocation" data-idx="${inboundDetailData.locationIdx}"> 
						    <c:out value="${inboundDetailData.locationName}" default="-" />
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
					<div class="kv-value" id="overallTotalPrice">
						<fmt:formatNumber value="${inboundDetailData.totalPrice}" pattern="₩ #,##0" />
					</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">비고</div>
					<div class="kv-value"><c:out value="${inboundDetailData.note}" default="-"/></div>
				</div>
			</div>
		</div>

		
		<!-- 품목 목록 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">품목 내역</div>
				<a href="${pageContext.request.contextPath}/inbound/qrTest" class="btn btn-secondary btn-sm">QR 테스트</a>
			</div>

			<div class="table-responsive">
				<table id="itemsTable" class="table">
					<thead>
						<tr>
							<th>No</th>
							<th colspan="2">품목명 / 규격</th>
							<th>LOT번호</th>
							<th>단가</th>
							<th>수량</th>
							<th>제조일</th>
							<th>유통기한</th>
							<th>QR스캔</th>
							<th>검수</th>
						</tr>
					</thead>
	<!-- ==============================================================================================================리스트 존========= -->
					<tbody>
						<c:choose>
							<c:when test="${not empty ibProductDetail}">
								<c:forEach var="item" items="${ibProductDetail}" varStatus="vs">
									<tr data-product-idx="${item.productIdx}" data-lot-verified="false">
										<!-- No. -->
										<td><c:out value="${vs.index + 1}" /></td>
					
										<!-- 상품명 / 규격 -->
										<td colspan="2"><c:out value="${item.productName}" /></td>
					
										<!-- LOT넘버 -->
										<td>
											<input type="hidden" name="expectedLotNumber" value="${item.lotNumber}" />
											<input type="hidden" name="scannedLotNumber" value="" />
											<span class="lotNumberDisplay">-</span>
										</td>
										
										<td>
											₩<input type="number" class="unitPrice"
											        value="${item.unitPrice}"
											        data-index="${vs.index}"
											        style="width:60%" />
										</td>
					
										<!-- 수량 -->
										<td>
											<input type="number" class="quantity"
											       value="${item.quantity}"
											       data-index="${vs.index}"
											       style="width:40%;" />개
										</td>
					
										<!-- 제조일 -->
										<td>
											<input type="date" name="manufactureDate"
											       class="form-control"
											       value="${item.manufactureDate}" />
										</td>
					
										<!-- 유통기한 -->
										<td>
											<input type="date" name="expirationDate"
											       class="form-control"
											       value="${item.expirationDate}" />
										</td>
					
										<!-- QR 스캔 버튼 -->
										<td>
											<input type="button"
											       class="btn btn-primary btn-sm btn-lotScan"
											       value="QR 스캔"
											       onclick="openQrModalForRow(this)" />
										</td>
					
										<!-- 검수 버튼 -->
										<td class="inspection">
											<input type="button" class="btn btn-secondary btn-sm" value="검수완료">
										</td>
					
										<!-- 가격 관련 hidden input (계산용) -->
										<td style="display:none;">
											<input type="hidden" class="unitPrice" value="${item.unitPrice}" data-index="${vs.index}" />
											<input type="hidden" class="amount" value="${item.amount}" data-index="${vs.index}" />
											<input type="hidden" class="tax" value="${item.tax}" data-index="${vs.index}" />
											<input type="hidden" class="totalPrice" value="${item.totalPrice}" data-index="${vs.index}" />
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
							<td colspan="9"></td>
							<td>
								<button id="btnCommit" class="btn btn-secondary btn-sm" title="입고확정" disabled>입고확정</button>
							</td>
						</tr>
					</tfoot>
	<!-- ==============================================================================================================리스트 존========= -->
				</table>
			</div>
		</div>

		<!-- 첨부 / 메모  -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="card-title">첨부 / 메모 </div>
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
	<script src="https://unpkg.com/@zxing/library@latest/umd/index.min.js"></script>
	
	<jsp:include page="/WEB-INF/views/inbound/modal/modifyLocation.jsp" />
	<script src="${pageContext.request.contextPath}/resources/js/inbound/modal/modify.js"></script>
	<jsp:include page="/WEB-INF/views/inbound/modal/modifyLotNumber.jsp" />
	<script src="${pageContext.request.contextPath}/resources/js/inbound/modal/inspectionQRscanner.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/inbound/modal/changeLocationIdx.js"></script>
	
	<script src="${pageContext.request.contextPath}/resources/js/inbound/inboundInspection.js"></script>
	
	<script> const contextPath = "${pageContext.request.contextPath}";</script>
</body>
<link href="${pageContext.request.contextPath}/resources/css/inbound/modal/detailSmallModal.css" rel="stylesheet" />
</html>
