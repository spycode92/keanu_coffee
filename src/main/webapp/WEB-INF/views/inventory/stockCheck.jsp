<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>재고 조회</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style>
    .interval { margin: 5px !important; }
    
    /* 모든 input/select 크기 통일 */
    .interval .form-control {
        height: 38px;
        width: 100%;
        box-sizing: border-box;
    }
    input[type="date"].form-control {
        line-height: normal;
        padding: 0 10px;
    }
    select.form-control {
        padding: 0 10px;
    }

    /* 상태 라벨 */
    .status-label { display:inline-block; padding:3px 8px; border-radius:4px; font-weight:bold; font-size:0.9em; }
    .status-label.imminent { background:#fff3cd; border:1px solid #ffc107; color:#856404; }
    .status-label.expired  { background:#f8d7da; border:1px solid #dc3545; color:#721c24; }
    .status-label.normal   { background:#d4edda; border:1px solid #28a745; color:#155724; }

    /* D-Day 뱃지 */
    .dday-badge { display:inline-block; margin-left:6px; padding:1px 6px; border-radius:999px; border:1px solid rgba(0,0,0,.1); font-size:.8em; font-weight:700; opacity:.9; }
    .dday-warn { background:rgba(255,193,7,.18); border-color:rgba(255,193,7,.65); }
    .dday-danger { background:rgba(220,53,69,.20); border-color:rgba(220,53,69,.70); }

    /* 출고여부 뱃지 */
    .ship-badge { display:inline-block; padding:2px 10px; border-radius:999px; font-weight:700; font-size:.85em; border:1px solid rgba(0,0,0,.1); }
    .ship-yes { background:#e6ffed; border-color:#16a34a; color:#166534; }
    .ship-no  { background:#e5e7eb; border-color:#9ca3af; color:#6b7280; }


    .disabled-row { background:#f3f4f6 !important; color:#6b7280 !important; }
    @media (prefers-color-scheme: dark) {
        .disabled-row { background:#1f2937 !important; color:#9ca3af !important; }
    }

    .logline { display:flex; justify-content:space-between; gap:10px; padding:6px 0; border-bottom:1px dashed #23304a; }
    .logline:last-child { border-bottom:0; }
    .logleft { display:flex; gap:8px; align-items:center; }
    .logright { text-align:right; white-space:nowrap; }

    .filters {
        display: grid;
        grid-template-columns: repeat(3, 1fr) auto;
        gap: 12px;
        padding: 12px 12px 0;
    }
    
    .filters-2 {
        display: grid;
        grid-template-columns: repeat(4, 1fr) 220px;
        gap: 12px;
        padding: 8px 12px 0;
        align-items: end;
    }

    /* 재고상태 / 출고여부 영역 */
    .filters-3 {
        display: grid;
        grid-template-columns: repeat(2, 1fr) auto; /* 두 박스 동일폭 + FIFO 버튼 auto */
        gap: 12px;
        padding: 8px 12px 0;
        align-items: end;
    }

    /* 모달 높이/스크롤 */
    .modal-card.lg { max-height: 90vh; overflow-y: auto; }
    @media (max-width: 1200px) {
        .modal-card.lg { width: 95%; max-height: 85vh; }
    }
    
    /* 📌 stockCheck 전용 테이블 - 줄바꿈 방지 */
	#tblRealtime th,
	#tblRealtime td {
	    white-space: nowrap;   /* 줄바꿈 안 함 */
	    overflow: hidden;      /* 넘치는 텍스트는 숨김 */
	    text-overflow: ellipsis; /* ... 처리 (옵션) */
	}
	
	/* 수량조절 모달 전용 */
#quantityUpdateModal .modal-body {
    display: flex;
    flex-direction: column;
    gap: 16px;
    font-size: 0.95rem;
}

/* 현재 수량 라인 */
#quantityUpdateModal .current-qty {
    font-weight: 600;
    margin-bottom: 0.5em;
    font-size: 1.2rem;
}

/* 값 강조 */
#quantityUpdateModal .current-qty span {
    font-weight: bold;
    margin-left: 4px;
}

/* 입력 박스 */
#quantityUpdateModal input[type="number"] {
    width: 140px;
    padding: 6px 8px;
    border: 1px solid #d1d5db;
    border-radius: 6px;
    font-size: 0.9rem;
    text-align: right;
    margin-bottom: 0.5em;
}

#quantityUpdateModal label {
	font-size: 1.2rem;
	margin-right: 0.2em;
}
</style>
</head>
<body>

    <!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

    <div class="card" style="margin:20px;">
        <div class="card-header">
            <h3 class="card-title">재고 조회</h3>
        </div>

        <!-- 검색 조건 form -->
		<form method="get" action="${pageContext.request.contextPath}/inventory/stockCheck">
		
		    <div class="filters">
		    	<!-- 상품명/코드 -->
		        <div class="interval">
		            <label class="form-label">상품명/코드</label>
		            <input class="form-control" name="keyword" id="prodSearch" 
		                   placeholder="예: 바닐라시럽 / SYR-001" value="${keyword}">
		        </div>
		        
		        <!-- 카테고리 -->
				<div class="interval">
				    <label class="form-label">카테고리</label>
				    <select class="form-control" name="category" id="category">
						<option value="" ${empty category ? 'selected' : ''}>전체</option>
						<c:forEach var="cat" items="${categoryList}">
						    <option value="${cat.commonCodeIdx}"
						        ${not empty category and category eq cat.commonCodeIdx ? 'selected' : ''}>
						        ${cat.commonCodeName}
						    </option>
						</c:forEach>
					</select>
				</div>
						        
		        <!-- 로케이션 -->
		        <div class="interval">
		            <label class="form-label">로케이션</label>
		            <input class="form-control" name="location" id="locSearch" 
		                   placeholder="예: A-1-a1" value="${location}">
		        </div>
		        
		        <!-- 로케이션 유형 -->
		        <div class="interval">
		            <label class="form-label">로케이션 유형</label>
		            <select class="form-control" name="locationType" id="locType">
		                <option value="전체" ${locationType eq '전체' ? 'selected' : ''}>전체</option>
		                <option value="1" ${locationType eq '1' ? 'selected' : ''}>Pallet</option>
		                <option value="2" ${locationType eq '2' ? 'selected' : ''}>Picking</option>
		            </select>
		        </div>
		        <div style="display:flex; align-items:flex-end; gap:8px;">
		            <button type="submit" class="btn btn-primary">조회</button>
		            <button type="button" id="btnReset" class="btn btn-secondary">초기화</button>
		        </div>
		    </div>

	        <!-- 제조/유통 + 정렬 -->
		    <div class="filters-2">
		        <div class="interval">
		            <label class="form-label">제조일자</label>
		            <input type="date" name="mfgDate" class="form-control" value="${mfgDate}">
		        </div>
		        <div class="interval">
		            <label class="form-label">유통기한</label>
		            <input type="date" name="expDate" class="form-control" value="${expDate}">
		        </div>
				<!-- 날짜 정렬 -->
		        <div class="interval">
				    <label class="form-label">날짜 정렬</label>
				    <select name="sortOption" class="form-control">
				        <option value="">전체</option>
				        <option value="manufactureAsc" ${sortOption eq 'manufactureAsc' ? 'selected' : ''}>제조일자 빠른 순</option>
				        <option value="manufactureDesc" ${sortOption eq 'manufactureDesc' ? 'selected' : ''}>제조일자 늦은 순</option>
				        <option value="expireAsc" ${sortOption eq 'expireAsc' ? 'selected' : ''}>유통기한 빠른 순</option>
				        <option value="expireDesc" ${sortOption eq 'expireDesc' ? 'selected' : ''}>유통기한 늦은 순</option>
				    </select>
				</div>
				<!-- 수량 정렬 -->
				<div class="interval">
				    <label class="form-label">수량 정렬</label>
				    <select name="qtySort" class="form-control">
				        <option value="">전체</option>
				        <option value="qtyDesc" ${qtySort eq 'qtyDesc' ? 'selected' : ''}>수량 많은 순</option>
				        <option value="qtyAsc" ${qtySort eq 'qtyAsc' ? 'selected' : ''}>수량 적은 순</option>
				    </select>
				</div>
		    </div>

	        <!-- 재고상태 / 출고여부 -->
		    <div class="filters-3">
		        <div class="interval">
		            <label class="form-label">재고상태</label>
		            <select name="stockStatus" class="form-control">
		                <option value="전체" ${stockStatus eq '전체' ? 'selected' : ''}>전체</option>
		                <option value="WARN" ${stockStatus eq 'WARN' ? 'selected' : ''}>임박</option>
		                <option value="EXPIRED" ${stockStatus eq 'EXPIRED' ? 'selected' : ''}>만료</option>
		                <option value="OK" ${stockStatus eq 'OK' ? 'selected' : ''}>정상</option>
		            </select>
		        </div>
		    </div>
		</form>

        <!-- KPI -->
        <div style="display:flex; gap:20px; align-items:center; padding:12px;">
            <div class="kpi-card">
                <div class="kpi-value" id="kpiSku">–</div>
                <div class="kpi-change">총 SKU</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-value" id="kpiQty">–</div>
                <div class="kpi-change">총 재고 수량</div>
            </div>
        </div>

        <!-- 테이블 -->
	    <div class="table-responsive">
	        <table class="table" id="tblRealtime">
	            <thead>
	                <tr>
	                    <th>로케이션</th>
	                    <th>상품명</th>
	                    <th>상품코드</th>
	                    <th>수량</th>
	                    <th>단위</th>
	                    <th>로케이션유형</th>
	                    <th>제조일자</th>
	                    <th>유통기한</th>
	                    <th>D-Day</th>
	                    <th>재고상태</th>
	                </tr>
	            </thead>
	            <tbody id="tbodyRealtime">
				    <c:forEach var="item" items="${inventoryList}">
				        <tr data-idx="${item.receipt_product_idx}" 
				        	data-location-idx="${item.location_idx}"
				        	data-current-quantity="${item.current_quantity}">
				            <td>${item.location_name}</td>
				            <td>${item.product_name}</td>
				            <td>${item.product_idx}</td>
				            <td ><fmt:formatNumber value="${item.current_quantity}" type="number"/></td>
				            <td>BOX</td>
				            <td>
				                <c:choose>
				                    <c:when test="${item.location_type == 1}">Pallet</c:when>
				                    <c:when test="${item.location_type == 2}">Picking</c:when>
				                    <c:otherwise>미지정</c:otherwise>
				                </c:choose>
				            </td>
				            <td>${item.manufacture_date}</td>
				            <td>${item.expiration_date}</td>
				            <td class="dday-cell" data-exp="${item.expiration_date}"></td>
				            <td class="status-cell" data-exp="${item.expiration_date}"></td>
				        </tr>
				    </c:forEach>
				
				    <!-- 결과가 없을 때 표시 -->
				    <c:if test="${empty inventoryList}">
				        <tr>
				            <td colspan="10" style="text-align:center; padding:20px; color:gray;">
				                조회된 재고가 없습니다.
				            </td>
				        </tr>
				    </c:if>
				</tbody>
	        </table>
	    </div>
	    
	    <!-- 페이징 -->
		<div class="pagination" style="text-align:center; margin:20px 0;">
		
		    <!-- 처음 / 이전 -->
		    <c:if test="${pageInfo.pageNum > 1}">
		        <c:url var="firstPageUrl" value="/inventory/stockCheck">
		            <c:param name="pageNum" value="1"/>
		            <c:param name="keyword" value="${keyword}"/>
		            <c:param name="location" value="${location}"/>
		            <c:param name="locationType" value="${locationType}"/>
		            <c:param name="mfgDate" value="${mfgDate}"/>
		            <c:param name="expDate" value="${expDate}"/>
		            <c:param name="stockStatus" value="${stockStatus}"/>
		            <c:param name="sortOption" value="${sortOption}"/>
		            <c:param name="qtySort" value="${qtySort}"/>
		            <c:param name="category" value="${category}"/>
		        </c:url>
		        <a href="${firstPageUrl}" class="btn btn-secondary">« 처음</a>
		
		        <c:url var="prevPageUrl" value="/inventory/stockCheck">
		            <c:param name="pageNum" value="${pageInfo.pageNum - 1}"/>
		            <c:param name="keyword" value="${keyword}"/>
		            <c:param name="location" value="${location}"/>
		            <c:param name="locationType" value="${locationType}"/>
		            <c:param name="mfgDate" value="${mfgDate}"/>
		            <c:param name="expDate" value="${expDate}"/>
		            <c:param name="stockStatus" value="${stockStatus}"/>
		            <c:param name="sortOption" value="${sortOption}"/>
		            <c:param name="qtySort" value="${qtySort}"/>
		            <c:param name="category" value="${category}"/>
		        </c:url>
		        <a href="${prevPageUrl}" class="btn btn-secondary">‹ 이전</a>
		    </c:if>
		
		    <!-- 페이지 번호 -->
		    <c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
		        <c:choose>
		            <c:when test="${i == pageInfo.pageNum}">
		                <span class="btn btn-primary">${i}</span>
		            </c:when>
		            <c:otherwise>
		                <c:url var="pageUrl" value="/inventory/stockCheck">
		                    <c:param name="pageNum" value="${i}"/>
		                    <c:param name="keyword" value="${keyword}"/>
		                    <c:param name="location" value="${location}"/>
		                    <c:param name="locationType" value="${locationType}"/>
		                    <c:param name="mfgDate" value="${mfgDate}"/>
		                    <c:param name="expDate" value="${expDate}"/>
		                    <c:param name="stockStatus" value="${stockStatus}"/>
		                    <c:param name="sortOption" value="${sortOption}"/>
		                    <c:param name="qtySort" value="${qtySort}"/>
		                    <c:param name="category" value="${category}"/>
		                </c:url>
		                <a href="${pageUrl}" class="btn btn-secondary">${i}</a>
		            </c:otherwise>
		        </c:choose>
		    </c:forEach>
		
		    <!-- 다음 / 끝 -->
		    <c:if test="${pageInfo.pageNum < pageInfo.maxPage}">
		        <c:url var="nextPageUrl" value="/inventory/stockCheck">
		            <c:param name="pageNum" value="${pageInfo.pageNum + 1}"/>
		            <c:param name="keyword" value="${keyword}"/>
		            <c:param name="location" value="${location}"/>
		            <c:param name="locationType" value="${locationType}"/>
		            <c:param name="mfgDate" value="${mfgDate}"/>
		            <c:param name="expDate" value="${expDate}"/>
		            <c:param name="stockStatus" value="${stockStatus}"/>
		            <c:param name="sortOption" value="${sortOption}"/>
		            <c:param name="qtySort" value="${qtySort}"/>
		            <c:param name="category" value="${category}"/>
		        </c:url>
		        <a href="${nextPageUrl}" class="btn btn-secondary">다음 ›</a>
		
		        <c:url var="lastPageUrl" value="/inventory/stockCheck">
		            <c:param name="pageNum" value="${pageInfo.maxPage}"/>
		            <c:param name="keyword" value="${keyword}"/>
		            <c:param name="location" value="${location}"/>
		            <c:param name="locationType" value="${locationType}"/>
		            <c:param name="mfgDate" value="${mfgDate}"/>
		            <c:param name="expDate" value="${expDate}"/>
		            <c:param name="stockStatus" value="${stockStatus}"/>
		            <c:param name="sortOption" value="${sortOption}"/>
		            <c:param name="qtySort" value="${qtySort}"/>
		            <c:param name="category" value="${category}"/>
		        </c:url>
		        <a href="${lastPageUrl}" class="btn btn-secondary">끝 »</a>
		    </c:if>
		
		</div>
	</div>

	<!-- ========================= LOT 상세 모달 ========================= -->
	<div class="modal" id="lotModal">
	    <div class="modal-card lg">
	        <div class="modal-head">
	            <h3>재고 상세</h3>
	            <button class="modal-close-btn" onclick="ModalManager.closeModal(document.getElementById('lotModal'))">✕</button>
	        </div>
	
	        <div class="modal-body">
	            <!-- 상품 정보 -->
	            <div class="card" style="padding:12px;">
	                <div class="card-header"><h3 class="card-title">상품 정보</h3></div>
	                <div class="table-responsive">
	                    <table class="table">
	                        <tbody>
	                            <tr><th>상품명</th><td id="miName">–</td></tr>
	                            <tr><th>상품코드</th><td id="miItem">–</td></tr>
	                            <tr><th>카테고리</th><td id="miCategory">–</td></tr>
	                            <tr><th>LOT</th><td id="miLot">–</td></tr>
	                            <tr><th>제조일자</th><td id="miMfg">–</td></tr>
	                            <tr><th>유통기한</th><td id="miExp">–</td></tr>
	                            <tr><th>D-Day</th><td id="miDday">–</td></tr>
	                            <tr><th>재고상태</th><td id="miStatus">–</td></tr>
	                            <tr><th>단위</th><td id="miUnit">BOX</td></tr>
	                            <tr><th>현재고(합계)</th><td id="miCurrent">–</td></tr>
	                            <tr><th>공급처</th><td id="miSupplier">–</td></tr>
	                        </tbody>
	                    </table>
	                </div>
	            </div>
	
	            <!-- 로케이션 분포 -->
	            <div>
	                <div class="card" style="padding:12px;">
	                    <div class="card-header"><h3 class="card-title">로케이션 분포</h3></div>
	                    <div id="locList">
	                        <div class="logline"><div class="logleft">데이터 없음</div><div class="logright">-</div></div>
	                    </div>
	                </div>
	            </div>
	
	
	        <div class="modal-foot">
	            <button class="btn btn-update" onclick="ModalManager.openModal(document.getElementById('quantityUpdateModal'))">수량 조절</button>
	            <button class="btn btn-secondary" onclick="ModalManager.closeModal(document.getElementById('lotModal'))">닫기</button>
	        </div>
	    	</div>
	    </div>
	</div>
    <!-- ========================= 수량 조절 모달 ========================= -->
    <div class="modal" id="quantityUpdateModal">
     	<div class="modal-card sm">
     		<div class="modal-head">
	            <h3>수량조절</h3>
	            <button class="modal-close-btn" onclick="ModalManager.closeModal(document.getElementById('quantityUpdateModal'))">✕</button>
	        </div>
	        <div class="modal-body">
	        	<form action="/inventory/updateInventory"
	        		  method="post">
	        		<sec:csrfInput/>
	        		<input type="hidden" name="locationIdx" id="currentLocationIdx" />
	        		<input type="hidden" name="receiptProductIdx" id="currentReceiptProductIdx"/>
	        		<input type="hidden" name="isDisposal" id="isDisposal"/>
					<div class="current-qty">
					    현재수량 : <span id="currentQuantity"></span> Box
					</div>
		        	<div>
		        		 <label for="updateQty" id="updateQty">수량 업데이트</label>
		        		 <input type="number" name="adjustQuantity" id="updateQty"/>
		        	</div>
		        	<div>
		        		 <label for="totalQty">변경된 수량</label>
		        		 <input type="number" name="quantity" id="totalQty" readonly/>
		        	</div>
			     	<div class="modal-foot">
			        	<button type="submit" class="btn btn-update" >수정</button>
				        <button type="button" class="btn btn-secondary" onclick="resetLotModal(); ModalManager.closeModal(document.getElementById('quantityUpdateModal'))">닫기</button>
					</div>
	        	</form>
	        </div>
     	</div>
    </div>
    
    
    <!-- ========================= /LOT 상세 모달 ========================= -->

    <script>
	 	// KPI 카드 데이터 채우기
	    $(document).ready(function(){
	        $.getJSON('${pageContext.request.contextPath}/inventory/metrics', function(res){
	        	// 숫자 천 단위 콤마 포맷 함수
	        	function formatNumber(num) {
	        	    if (num === null || num === undefined) return '–';
	        	    return Number(num).toLocaleString('ko-KR'); 
	        	}

	        	$('#kpiSku').text(formatNumber(res.totalSku ?? 0));
	        	$('#kpiQty').text(formatNumber(res.totalQty ?? 0));
	        });
	    });
    	
	    /* ====================== 유틸 ====================== */
	    function toDateOrNull(s){
	        if (s === null || s === undefined) return null;
	        const t = String(s).trim();
	        if (!t) return null;
	        const d = new Date(t + 'T00:00:00');
	        return isNaN(d.getTime()) ? null : d;
	    }
	    function diffDaysFromToday(dateStr){
	        const d = toDateOrNull(dateStr);
	        if (!d) return null;
	        const today = new Date();
	        const base = new Date(today.getFullYear(), today.getMonth(), today.getDate());
	        return Math.ceil((d.getTime() - base.getTime()) / (1000*60*60*24));
	    }
	    function formatDday(d){
	        if (d === null || d === undefined) return '–';
	        if (d < 0) return 'D+' + Math.abs(d);
	        if (d === 0) return 'D-day';
	        return 'D-' + d;
	    }
	    
	    /* fmtDate 추가 */
	    function fmtDate(val){
		    if(val === null || val === undefined) return '–';
		
		    // 숫자인 경우 (타임스탬프)
		    if(typeof val === 'number'){
		        const d = new Date(val);
		        return d.toISOString().split('T')[0]; // "2025-06-20"
		    }
		
		    // 문자열인데 "2025-06-20" 같이 온 경우
		    if(typeof val === 'string'){
		        if(val.includes('-')) return val; // 이미 YYYY-MM-DD
		        const num = parseInt(val, 10);
		        if(!isNaN(num)){
		            const d = new Date(num);
		            return d.toISOString().split('T')[0];
		        }
		    }
		
		    return '–';
		}
	
	    /* 고정 임박 기준값 */
	    const FIXED_THRESHOLD = 60;
	
	    function makeStatusAndDday(expDate, threshold){
	        const d = diffDaysFromToday(expDate);
	        if (d === null){
	            return { status:'OK', labelHtml:'<span class="status-label normal">정상</span>', ddayHtml:'<span class="dday-badge">–</span>', d:null };
	        }
	        let status = 'OK';
	        let labelHtml = '<span class="status-label normal">정상</span>';
	        const ddText = formatDday(d);
	        let ddayClass = '';
	        if (d < 0){ status='EXPIRED'; labelHtml='<span class="status-label expired">만료</span>'; ddayClass='dday-danger'; }
	        else if (d === 0 || d <= threshold){ status='WARN'; labelHtml='<span class="status-label imminent">임박</span>'; ddayClass='dday-warn'; }
	        const ddayHtml = '<span class="dday-badge '+ddayClass+'">'+ddText+'</span>';
	        return { status, labelHtml, ddayHtml, d };
	    }
	
	    /* ====================== 테이블 D-Day & 재고상태 채우기 ====================== */
	    $(document).ready(function(){
	        // D-Day
	        $('.dday-cell').each(function(){
	            const exp = $(this).data('exp');
	            const d = diffDaysFromToday(exp);
	            $(this).html(formatDday(d));
	        });
	
	        // 재고상태
	        $('.status-cell').each(function(){
	            const exp = $(this).data('exp');
	            const { labelHtml } = makeStatusAndDday(exp, FIXED_THRESHOLD);
	            $(this).html(labelHtml);
	        });
	    });
	
	    /* ====================== 모달 ====================== */
	    $('#tbodyRealtime').on('click', 'tr', function() {
	    	const idx = $(this).data('idx');   // ✅ receipt_product_idx 가져오기
		    if (!idx) return;
	    	
	        // 수량 조절 모달창에 필요한 값 input에 넣기
	        const receiptProductIdx = $(this).data('idx');
	        const locationIdx = $(this).data('location-idx');
	        const currentQuantity = $(this).data("current-quantity");
	        
	        $('#currentReceiptProductIdx').val(parseInt(receiptProductIdx));
	        $('#currentLocationIdx').val(parseInt(locationIdx));
	        $("#currentQuantity").text(currentQuantity);
		
		    // Ajax로 상세 데이터 요청
		    $.getJSON('${pageContext.request.contextPath}/inventory/detail', { idx: idx }, function(data) {
		        // 상품 정보 채우기
		        $('#miName').text(data.product_name || '–');
		        $('#miItem').text(data.product_idx || '–');
		        $('#miCategory').text(data.category_name || '–');   // 카테고리 추가
		        
		     	// LOT 번호 넣기
		        $('#miLot').text(data.lot_number || '–');
		        
		        // 콘솔창으로 제조일자, 유통기한 나오는지 확인용
// 		        console.log("제조일자 원본:", data.manufacture_date, typeof data.manufacture_date);
// 		        console.log("new Date() 결과:", new Date(data.manufacture_date));
// 		        console.log("fmtDate() 결과:", fmtDate(data.manufacture_date));
				
				// 제조일자 / 유통기한
				document.getElementById("miMfg").innerText = fmtDate(data.manufacture_date);
				document.getElementById("miExp").innerText = fmtDate(data.expiration_date);
				
				// D-Day & 재고상태
			    const ddayInfo = makeStatusAndDday(fmtDate(data.expiration_date), FIXED_THRESHOLD);
			    $('#miDday').html(ddayInfo.ddayHtml);
			    $('#miStatus').html(ddayInfo.labelHtml);
				
				// 현재고, 공급처
		        $('#miCurrent').text((data.current_quantity || 0) + ' BOX');
		        $('#miSupplier').text(data.supplier_name || '–');
		
		        // 로케이션 분포
		        const $box = $('#locList').empty();
		        if (data.locations && data.locations.length > 0) {
		            let sum = 0;
		            data.locations.forEach(loc => {
		                sum += loc.qty;
		                $box.append(
		                    '<div class="logline">' +
		                        '<div class="logleft">' + loc.location_name + '</div>' +
		                        '<div class="logright"><b>' + loc.qty + ' BOX</b></div>' +
		                    '</div>'
		                );
		            });
		            $box.append(
		                '<div class="logline">' +
		                    '<div class="logleft"><b>합계</b></div>' +
		                    '<div class="logright"><b>' + sum + ' BOX</b></div>' +
		                '</div>'
		            );
		        } else {
		            $box.append('<div class="logline"><div class="logleft">데이터 없음</div><div class="logright">-</div></div>');
		        }
		        // 모달 열기
		        ModalManager.openModalById('lotModal');
		    });
		});
	    /* ====================== 변경 후 수량  ====================== */
	    $(document).on("input", "#updateQty",  function() {
	    	const baseQty = parseInt($("#currentQuantity").text().trim() || "0", 10);
	    	const delta = parseInt($(this).val() || "0", 10);
	    	
	    	const newQty = baseQty + delta;
	    	
	    	if (newQty >= baseQty) {
	    		$("#isDisposal").val(false);
	    	} else {
	    		$("#isDisposal").val(true);
	    	}
	    	
	    	// 변경된 수량
	    	$("#totalQty").val(parseInt(newQty));
	    });
	    
	    // 수량 조절 모달 초기화
	    function resetLotModal() {
	        const form = document.querySelector("#quantityUpdateModal form");
	        if (form) {
	            form.reset();  // form 전체 input 초기화
	        }
	    }
					    
	    /* ====================== 초기화 버튼 ====================== */
	    $('#btnReset').on('click', function(){
	        $('form')[0].reset();

	        $('#prodSearch').val('');
	        $('#locSearch').val('');
	        $('#locType').val('전체');
	        $('input[name="mfgFrom"]').val('');
	        $('input[name="mfgTo"]').val('');
	        $('input[name="expFrom"]').val('');
	        $('input[name="expTo"]').val('');
	        $('select[name="sortBy"]').val('');
	        $('select[name="stockStatus"]').val('전체');

	        window.location.href = "${pageContext.request.contextPath}/inventory/stockCheck?pageNum=1";
	    });
	</script>
</body>
</html>