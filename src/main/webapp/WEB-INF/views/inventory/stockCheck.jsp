<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>재고 조회 / 검수</title>
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
	
	/* 테이블 컬럼 넓히기 & 줄바꿈 방지 */
	#tblRealtime th:nth-child(1),   /* 로케이션 */
	#tblRealtime td:nth-child(1),
	#tblRealtime th:nth-child(3),   /* 상품코드 */
	#tblRealtime td:nth-child(3),
	#tblRealtime th:nth-child(4),   /* 수량 */
	#tblRealtime td:nth-child(4),
	#tblRealtime th:nth-child(6),   /* 로케이션유형 */
	#tblRealtime td:nth-child(6),
	#tblRealtime th:nth-child(7),   /* D-Day */
	#tblRealtime td:nth-child(7),
	#tblRealtime th:nth-child(8),   /* D-Day */
	#tblRealtime td:nth-child(8),
	#tblRealtime th:nth-child(9),   /* D-Day */
	#tblRealtime td:nth-child(9),
	#tblRealtime th:nth-child(10),  /* 재고상태 */
	#tblRealtime td:nth-child(10),
	#tblRealtime th:nth-child(11),  /* 출고여부 */
	#tblRealtime td:nth-child(11) {
	    min-width: 100px;   /* 원하는 폭, 100~120px 권장 */
	    white-space: nowrap; /* 줄바꿈 방지 */
	}

    /* 상태 라벨 */
    .status-label { display:inline-block; padding:3px 8px; border-radius:4px; font-weight:bold; font-size:0.9em; }
    .status-label.imminent { background:#fff3cd; border:1px solid #ffc107; color:#856404; }
    .status-label.expired  { background:#f8d7da; border:1px solid #dc3545; color:#721c24; }
    .status-label.normal   { background:#d4edda; border:1px solid #28a745; color:#155724; }
    .status-label.disposed { background:#e5e7eb; border:1px solid #6b7280; color:#111827; }

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


    /* 폐기 처리 전용 */
    #lotModal .panel-disposal {
        border:1px dashed #334155;
        border-radius:10px;
        padding:12px;
        background:#0f172a;
        color:#e2e8f0;
    }
    #lotModal .panel-disposal .form {

        display:flex;
        flex-direction:column;
        gap:12px;
    }
    #lotModal .panel-disposal .field {
        display:flex;
        flex-direction:column;
        gap:6px;
        width:100%;
    }
    #lotModal .panel-disposal .form-control {
        width:100%;
        box-sizing:border-box;
        background:#0b1220;
        border:1px solid #334155;
        color:#e2e8f0;
        border-radius:10px;
        padding:10px 12px;

    }
    #lotModal .panel-disposal textarea.form-control {
        min-height:110px;
        resize:vertical;
    }
    .hidden { display:none; }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

    <div class="card" style="margin:20px;">
        <div class="card-header">
            <h3 class="card-title">실시간 재고 조회</h3>
        </div>

        <!-- 검색 조건 form -->
		<form method="get" action="${pageContext.request.contextPath}/inventory/stockCheck">
		
		    <div class="filters">
		        <div class="interval">
		            <label class="form-label">상품명/코드</label>
		            <input class="form-control" name="keyword" id="prodSearch" 
		                   placeholder="예: 바닐라시럽 / SYR-001" value="${keyword}">
		        </div>
		        <div class="interval">
		            <label class="form-label">로케이션</label>
		            <input class="form-control" name="location" id="locSearch" 
		                   placeholder="예: A-1-a1" value="${location}">
		        </div>
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
		                <option value="DISPOSED" ${stockStatus eq 'DISPOSED' ? 'selected' : ''}>폐기</option>
		            </select>
		        </div>
		        <div class="interval">
		            <label class="form-label">출고 여부</label>
		            <select name="outboundStatus" class="form-control">
		                <option value="전체" ${outboundStatus eq '전체' ? 'selected' : ''}>전체</option>
		                <option value="YES" ${outboundStatus eq 'YES' ? 'selected' : ''}>가능</option>
		                <option value="NO" ${outboundStatus eq 'NO' ? 'selected' : ''}>불가능</option>
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
	                    <th>출고 여부</th>
	                </tr>
	            </thead>
	            <tbody id="tbodyRealtime">
				    <c:forEach var="item" items="${inventoryList}">
						<tr data-idx="${item.inventory_idx}">
						    <td>${item.location_name}</td>
						    <td>${item.product_name}</td>
						    <td>${item.product_idx}</td>
						    <td>${item.current_quantity}</td>
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
						    <td>
							    <c:choose>
							        <c:when test="${item.stockStatus eq 'EXPIRED' or item.stockStatus eq 'DISPOSED'}">
							            <span class="ship-badge ship-no">불가능</span>
							        </c:when>
							        <c:otherwise>
							            <span class="ship-badge ship-yes">가능</span>
							        </c:otherwise>
							    </c:choose>
							</td>
						</tr>
				    </c:forEach>
				</tbody>
	        </table>
	    </div>
	    
	    <!-- ✅ 페이징 -->
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
		            <c:param name="outboundStatus" value="${outboundStatus}"/>
		            <c:param name="sortOption" value="${sortOption}"/>
		            <c:param name="qtySort" value="${qtySort}"/>
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
		            <c:param name="outboundStatus" value="${outboundStatus}"/>
		            <c:param name="sortOption" value="${sortOption}"/>
		            <c:param name="qtySort" value="${qtySort}"/>
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
		                    <c:param name="outboundStatus" value="${outboundStatus}"/>
		                    <c:param name="sortOption" value="${sortOption}"/>
		                    <c:param name="qtySort" value="${qtySort}"/>
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
		            <c:param name="outboundStatus" value="${outboundStatus}"/>
		            <c:param name="sortOption" value="${sortOption}"/>
		            <c:param name="qtySort" value="${qtySort}"/>
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
		            <c:param name="outboundStatus" value="${outboundStatus}"/>
		            <c:param name="sortOption" value="${sortOption}"/>
		            <c:param name="qtySort" value="${qtySort}"/>
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
	
	            <!-- 폐기 처리 -->
<!-- 	            <div class="card" style="padding:12px; grid-column:1 / -1;"> -->
<!-- 	                <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;"> -->
<!-- 	                    <h3 class="card-title">폐기 처리</h3> -->
<!-- 	                    <button type="button" id="btn-disposal-toggle" class="btn btn-destructive" aria-expanded="false" aria-controls="disposalPanel">폐기 처리</button> -->
<!-- 	                </div> -->
	
<!-- 	                <div id="disposalPanel" class="panel-disposal hidden"> -->
<!-- 	                    <form id="disposalForm" class="form"> -->
<!-- 	                        <input type="hidden" id="df-lotNumber" name="lotNumber"> -->
<!-- 	                        <input type="hidden" id="df-productCode" name="productCode"> -->
<!-- 	                        <input type="hidden" id="df-locationCode" name="locationCode"> -->
	
<!-- 	                        <div class="field"> -->
<!-- 	                            <label>현재 재고</label> -->
<!-- 	                            <div> -->
<!-- 	                                <span id="df-currentQtyText">0</span> -->
<!-- 	                                <span id="df-unitText">BOX</span> -->
<!-- 	                            </div> -->
<!-- 	                        </div> -->
	
<!-- 	                        <div class="field"> -->
<!-- 	                            <label for="df-disposalAmount">폐기 수량</label> -->
<!-- 	                            <input type="number" id="df-disposalAmount" name="disposalAmount" class="form-control" min="1" required> -->
<!-- 	                        </div> -->
	
<!-- 	                        <div class="field"> -->
<!-- 	                            <label for="df-note">폐기 사유</label> -->
<!-- 	                            <textarea id="df-note" name="note" class="form-control" placeholder="폐기 사유를 입력하세요" required></textarea> -->
<!-- 	                        </div> -->
	
<!-- 	                        <div style="display:flex; justify-content:flex-end; gap:8px;"> -->
<!-- 	                            <button type="submit" class="btn btn-primary">등록</button> -->
<!-- 	                            <button type="button" class="btn btn-secondary" id="btn-disposal-cancel">취소</button> -->
<!-- 	                        </div> -->
<!-- 	                    </form> -->
<!-- 	                </div> -->
<!-- 	            </div> -->
<!-- 	        </div> -->
	
	        <div class="modal-foot">
	            <button class="btn btn-secondary" onclick="ModalManager.closeModal(document.getElementById('lotModal'))">닫기</button>
	        </div>
	    	</div>
	    </div>
	</div>
    <!-- ========================= /LOT 상세 모달 ========================= -->

    <script>
	 	// ✅ KPI 카드 데이터 채우기
	    $(document).ready(function(){
	        $.getJSON('${pageContext.request.contextPath}/inventory/metrics', function(res){
	            $('#kpiSku').text(res.totalSku ?? '–');
	            $('#kpiQty').text(res.totalQty ?? '–');
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
		
		    // Ajax로 상세 데이터 요청
		    $.getJSON('${pageContext.request.contextPath}/inventory/detail', { idx: idx }, function(data) {
		        // 상품 정보 채우기
		        $('#miName').text(data.product_name || '–');
		        $('#miItem').text(data.product_idx || '–');
		        
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
					    
// 	    /* ====================== 폐기 패널 토글 ====================== */
// 	    $('#btn-disposal-toggle').on('click', function(){
// 	        const $panel = $('#disposalPanel');
// 	        const expanded = $(this).attr('aria-expanded') === 'true';
// 	        if(expanded){
// 	            $(this).attr('aria-expanded','false').text('폐기 처리');
// 	            $panel.addClass('hidden');
// 	        }else{
// 	            $(this).attr('aria-expanded','true').text('닫기');
// 	            $panel.removeClass('hidden');
// 	            setTimeout(()=> $('#df-disposalAmount').trigger('focus'),80);
// 	        }
// 	    });
	
// 	    $('#btn-disposal-cancel').on('click', function(){
// 	        $('#btn-disposal-toggle').attr('aria-expanded','false').text('폐기 처리');
// 	        $('#disposalPanel').addClass('hidden');
// 	        $('#disposalForm')[0].reset();
// 	    });
	
// 	    $('#disposalForm').on('submit', function(e){
// 	        e.preventDefault(); // 기본 submit 막음 (지금은 DB 연동 전이니까)
	
// 	        const currentQty = parseInt($('#df-currentQtyText').text().replace(/[^0-9]/g,''), 10) || 0;
// 	        const amount = parseInt($('#df-disposalAmount').val(), 10) || 0;
// 	        const note = ($('#df-note').val() || '').trim();
	
// 	        if(amount <= 0){
// 	            alert('폐기 수량은 1 이상이어야 합니다.');
// 	            $('#df-disposalAmount').focus();
// 	            return;
// 	        }
// 	        if(amount > currentQty){
// 	            alert('폐기 수량이 현재 재고보다 많습니다.');
// 	            $('#df-disposalAmount').focus();
// 	            return;
// 	        }
// 	        if(note.length < 2){
// 	            alert('폐기 사유를 두 글자 이상 입력하세요.');
// 	            $('#df-note').focus();
// 	            return;
// 	        }
	
// 	        // 상태를 폐기로 업데이트
// 	        const lotNo = $('#df-lotNumber').val();
// 	        const row = realtimeData.find(x => x.lotNo === lotNo);
// 	        if(row){
// 	            row.qty -= amount; // 재고 차감
// 	            if(row.qty <= 0){
// 	                row.qty = 0;
// 	            }
// 	            // 재고가 남았어도 폐기 상태로 표시되게 강제
// 	            row.status = 'DISPOSED';
// 	        }
	
// 	        // 모달 닫고 테이블 갱신
// 	        ModalManager.closeModal(document.getElementById('lotModal'));
// 	        renderTable(true);
	
// 	        alert('폐기 처리가 완료되었습니다.');
// 	    });
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
	        $('select[name="outboundStatus"]').val('전체');

	        window.location.href = "${pageContext.request.contextPath}/inventory/stockCheck?pageNum=1";
	    });
	    
	    $(document).ready(function(){
	        const urlParams = new URLSearchParams(window.location.search);
	        const lotNumber = urlParams.get('keyword');
	        if (lotNumber) {
	            $("#tbodyRealtime tr").filter(function() {
	                return $(this).find("td:nth-child(3)").text().trim() === lotNumber;
	            }).css("background-color", "#fff3cd"); // 노란색 강조
	        }
	    });
	</script>
</body>
</html>