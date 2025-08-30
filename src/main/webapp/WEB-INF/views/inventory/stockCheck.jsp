<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고 조회 / 검수</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style>
    .interval { margin: 5px !important; }


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

    .filters { display:grid; grid-template-columns:1fr 1fr 1fr auto auto; gap:12px; padding:12px 12px 0; }
    .filters-2 { display:grid; grid-template-columns:repeat(4, 1fr) 220px; gap:12px; padding:8px 12px 0; align-items:end; }

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

        <!-- 검색 조건 -->
        <div class="filters">
            <div class="interval">
                <label class="form-label">로케이션</label>
                <input class="form-control" id="locSearch" placeholder="예: A-01">
            </div>
            <div class="interval">
                <label class="form-label">상품명/코드</label>
                <input class="form-control" id="prodSearch" placeholder="예: 바닐라시럽 / SYR-001">
            </div>
            <div class="interval">
                <label class="form-label">로케이션 유형</label>
                <select class="form-control" id="locType">
                    <option value="">전체</option>
                    <option value="Picking">Picking</option>
                    <option value="Pallet">Pallet</option>
                </select>
            </div>
            <div style="display:flex; align-items:flex-end; gap:8px;">
                <button class="btn btn-primary" id="btnSearch">조회</button>
                <button class="btn btn-secondary" id="btnClear">초기화</button>
            </div>
        </div>

        <!-- 제조/유통 + 정렬 -->
        <div class="filters-2">
            <div class="interval">
                <label class="form-label">제조일자</label>
                <input type="date" id="mfgEnd" class="form-control">
            </div>
            <div class="interval">
                <label class="form-label">유통기한</label>
                <input type="date" id="expStart" class="form-control">
            </div>
            <div class="interval">

                <label class="form-label">재고 정렬 기준</label>
                <select id="sortOption" class="form-control">
                    <option value="">전체</option>
                    <option value="manufactureAsc">제조일자 빠른 순</option>
                    <option value="manufactureDesc">제조일자 늦은 순</option>
                    <option value="expireAsc">유통기한 빠른 순</option>
                    <option value="expireDesc">유통기한 늦은 순</option>
                </select>
            </div>
        </div>


        <!-- 임박 기준 입력칸 제거, 상태 필터만 유지 -->
        <div style="display:flex; gap:16px; align-items:center; padding:12px;">
            <label class="form-label" style="display:flex; align-items:center; gap:6px; margin:0;">
                재고상태
                <select id="statusFilter" class="form-control" style="width:140px;">
                    <option value="ALL">전체</option>
                    <option value="WARN">임박</option>
                    <option value="EXPIRED">만료</option>
                    <option value="OK">정상</option>
                    <option value="DISPOSED">폐기</option>
                </select>
            </label>
            <button class="btn btn-outline" id="btnSortExpAsc">유통기한 오름차순(FIFO)</button>
        </div>

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
	            <tbody id="tbodyRealtime"></tbody>
	        </table>
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
	                    <div class="card-header"><h3 class="card-title">로케이션 분포(동일 LOT)</h3></div>
	                    <div id="locList">
	                        <div class="logline"><div class="logleft">데이터 없음</div><div class="logright">-</div></div>
	                    </div>
	                </div>
	            </div>
	
	            <!-- 폐기 처리 -->
	            <div class="card" style="padding:12px; grid-column:1 / -1;">
	                <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
	                    <h3 class="card-title">폐기 처리</h3>
	                    <button type="button" id="btn-disposal-toggle" class="btn btn-destructive" aria-expanded="false" aria-controls="disposalPanel">폐기 처리</button>
	                </div>
	
	                <div id="disposalPanel" class="panel-disposal hidden">
	                    <form id="disposalForm" class="form">
	                        <input type="hidden" id="df-lotNumber" name="lotNumber">
	                        <input type="hidden" id="df-productCode" name="productCode">
	                        <input type="hidden" id="df-locationCode" name="locationCode">
	
	                        <div class="field">
	                            <label>현재 재고</label>
	                            <div>
	                                <span id="df-currentQtyText">0</span>
	                                <span id="df-unitText">BOX</span>
	                            </div>
	                        </div>
	
	                        <div class="field">
	                            <label for="df-disposalAmount">폐기 수량</label>
	                            <input type="number" id="df-disposalAmount" name="disposalAmount" class="form-control" min="1" required>
	                        </div>
	
	                        <div class="field">
	                            <label for="df-note">폐기 사유</label>
	                            <textarea id="df-note" name="note" class="form-control" placeholder="폐기 사유를 입력하세요" required></textarea>
	                        </div>
	
	                        <div style="display:flex; justify-content:flex-end; gap:8px;">
	                            <button type="submit" class="btn btn-primary">등록</button>
	                            <button type="button" class="btn btn-secondary" id="btn-disposal-cancel">취소</button>
	                        </div>
	                    </form>
	                </div>
	            </div>
	        </div>
	
	        <div class="modal-foot">
	            <button class="btn btn-secondary" onclick="ModalManager.closeModal(document.getElementById('lotModal'))">닫기</button>
	        </div>
	    </div>
	</div>
    <!-- ========================= /LOT 상세 모달 ========================= -->

    <script>
        /* ====================== Mock 데이터 ====================== */
        const realtimeData = [
            { loc:'A-01', name:'바닐라 시럽', code:'SYR-001', qty:42, unit:'BOX', locType:'Picking', manDate:'2025-02-20', expDate:'2025-09-03', lotNo:'LOT-SYR-001-20250220-01' },
            { loc:'A-02', name:'카라멜 시럽', code:'SYR-002', qty:6, unit:'BOX', locType:'Picking', manDate:'2025-01-15', expDate:'2025-08-05', lotNo:'LOT-SYR-002-20250115-01' },
            { loc:'B-01', name:'원두(하우스블렌드)', code:'BEAN-001', qty:5, unit:'BOX', locType:'Pallet', manDate:'2024-12-01', expDate:'2025-08-01', lotNo:'LOT-BEAN-001-20241201-01' },
            { loc:'C-01', name:'종이컵 12oz', code:'CUP-012', qty:30, unit:'BOX', locType:'Picking', manDate:null, expDate:null, lotNo:'LOT-CUP-012-2025001' },
            { loc:'C-02', name:'플라스틱 빨대', code:'STD-001', qty:90, unit:'BOX', locType:'Picking', manDate:null, expDate:null, lotNo:'LOT-STD-001-2025001' },
            { loc:'C-03', name:'아이스컵 16oz', code:'CUP-016', qty:180, unit:'BOX', locType:'Picking', manDate:null, expDate:null, lotNo:'LOT-CUP-016-20260110-01' }
        ];

        const inboundByLot = {
            'LOT-SYR-001-20250220-01': { itemCode:'SYR-001', lotNo:'LOT-SYR-001-20250220-01', mfgDate:'2025-02-20', expDate:'2025-09-03', unit:'BOX', supplier:'케아누식품' },
            'LOT-SYR-002-20250115-01': { itemCode:'SYR-002', lotNo:'LOT-SYR-002-20250115-01', mfgDate:'2025-01-15', expDate:'2025-08-05', unit:'BOX', supplier:'케아누식품' },
            'LOT-BEAN-001-20241201-01': { itemCode:'BEAN-001', lotNo:'LOT-BEAN-001-20241201-01', mfgDate:'2024-12-01', expDate:'2025-08-01', unit:'BOX', supplier:'부산로스터리' },
            'LOT-CUP-012-2025001':     { itemCode:'CUP-012', lotNo:'LOT-CUP-012-2025001', mfgDate:null, expDate:null, unit:'BOX', supplier:'패키지코리아' },
            'LOT-STD-001-2025001':     { itemCode:'STD-001', lotNo:'LOT-STD-001-2025001', mfgDate:null, expDate:null, unit:'BOX', supplier:'패키지코리아' },
            'LOT-CUP-016-20260110-01': { itemCode:'CUP-016', lotNo:'LOT-CUP-016-20260110-01', mfgDate:null, expDate:null, unit:'BOX', supplier:'패키지코리아' }
        };

        const locationsByLot = {
            'LOT-SYR-001-20250220-01': [{ loc:'A-01', qty:42 }, { loc:'A-02', qty:6 }],
            'LOT-SYR-002-20250115-01': [{ loc:'A-02', qty:6 }],
            'LOT-BEAN-001-20241201-01': [{ loc:'B-01', qty:5 }],
            'LOT-CUP-012-2025001':     [{ loc:'C-01', qty:30 }],
            'LOT-STD-001-2025001':     [{ loc:'C-02', qty:90 }],
            'LOT-CUP-016-20260110-01': [{ loc:'C-01', qty:20 }, { loc:'C-03', qty:180 }]
        };

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

        /* 고정 임박 기준값 */
        const FIXED_THRESHOLD = 7;

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

        /* ====================== 테이블 렌더 ====================== */
        function renderTable(opts = {}){
            const tbody = document.getElementById('tbodyRealtime');
            tbody.innerHTML = '';

            const showAll = !!opts.showAll;
            const kwLoc = showAll ? '' : $('#locSearch').val().trim().toLowerCase();
            const kwProd = showAll ? '' : $('#prodSearch').val().trim().toLowerCase();
            const type = showAll ? '' : $('#locType').val();

            const mfgEnd   = toDateOrNull($('#mfgEnd').val());
            const expStart = toDateOrNull($('#expStart').val());

            const threshold = FIXED_THRESHOLD;   // 입력 대신 고정값 사용
            const statusFilter = $('#statusFilter').val() || 'ALL';
            const sortOption = opts.sortExpAsc ? 'expireAsc' : ($('#sortOption').val() || '');

            let data = realtimeData.filter(r=>{
                const ok1 = !kwLoc || r.loc.toLowerCase().includes(kwLoc);
                const ok2 = !kwProd || r.name.toLowerCase().includes(kwProd) || r.code.toLowerCase().includes(kwProd);
                const ok3 = !type || r.locType === type;

                const mfg = toDateOrNull(r.manDate);
                const okMfgEnd   = !mfgEnd   || (mfg && mfg <= mfgEnd);

                const exp = toDateOrNull(r.expDate);
                const okExpStart = !expStart || (exp && exp >= expStart);

             	// 상태 계산
                let currentStatus = r.status || '';
                if(currentStatus !== 'DISPOSED'){  
                    const result = makeStatusAndDday(r.expDate, threshold);
                    currentStatus = result.status; // OK / WARN / EXPIRED
                }

                const okStatus = (statusFilter === 'ALL') || (currentStatus === statusFilter);

                return ok1 && ok2 && ok3 && okMfgEnd && okExpStart && okStatus;
            });

            if (sortOption){
                data = data.slice().sort((a,b)=>{
                    if (sortOption === 'manufactureAsc')  return new Date(a.manDate) - new Date(b.manDate);
                    if (sortOption === 'manufactureDesc') return new Date(b.manDate) - new Date(a.manDate);
                    if (sortOption === 'expireAsc')       return new Date(a.expDate) - new Date(b.expDate);
                    if (sortOption === 'expireDesc')      return new Date(b.expDate) - new Date(a.expDate);
                    return 0;
                });
            }

            let totalQty = 0;
            const skuSet = new Set();

            data.forEach(r=>{
                let statusHtml = '';
                let ddayHtml = '–';
                let shippable = true;

                if(r.status === 'DISPOSED'){   // ✅ 정상이어도 폐기 누르면 이 분기로 들어옴
                    statusHtml = '<span class="status-label disposed">폐기</span>';
                    shippable = false;
                } else {
                    const result = makeStatusAndDday(r.expDate, threshold);
                    statusHtml = result.labelHtml;
                    ddayHtml   = result.ddayHtml;
                    if(result.status === 'EXPIRED'){ 
                        shippable = false; 
                    }
                }

                const shipHtml = shippable
                    ? '<span class="ship-badge ship-yes">가능</span>'
                    : '<span class="ship-badge ship-no">불가능</span>';

                const tr = document.createElement('tr');
                tr.setAttribute('data-lot', r.lotNo);
                if (!shippable){ tr.classList.add('disabled-row'); }
                tr.innerHTML =
                    '<td>'+r.loc+'</td>'+
                    '<td>'+r.name+'</td>'+
                    '<td>'+r.code+'</td>'+
                    '<td>'+r.qty+'</td>'+
                    '<td>'+r.unit+'</td>'+
                    '<td>'+r.locType+'</td>'+
                    '<td>'+(r.manDate ? r.manDate : '–')+'</td>'+
                    '<td>'+(r.expDate ? r.expDate : '–')+'</td>'+
                    '<td>'+ddayHtml+'</td>'+
                    '<td>'+statusHtml+'</td>'+
                    '<td>'+shipHtml+'</td>';
                tbody.appendChild(tr);
                
		    	 // ✅ 누적 합산 (빠져있던 부분)
		        totalQty += r.qty;
		        skuSet.add(r.code);
            });

            $('#kpiSku').text(skuSet.size);
            $('#kpiQty').text(totalQty.toLocaleString('ko-KR'));
        }

        /* ====================== 모달 ====================== */
        $('#tbodyRealtime').on('click', 'tr', function(){
            const lotNo = $(this).data('lot');
            if (!lotNo) return;
            openLotModal(lotNo);
        });

        function openLotModal(lotNo){
            const mi = inboundByLot[lotNo] || {};
            const locs = locationsByLot[lotNo] || [];
            const unit = mi.unit || 'BOX';
            const row = realtimeData.find(x => x.lotNo === lotNo);
			
         	// 상세값 세팅
            $('#miName').text(row?.name || '–');
            $('#miItem').text(mi.itemCode || '–');
            $('#miLot').text(mi.lotNo || lotNo || '–');
            $('#miMfg').text(mi.mfgDate ? mi.mfgDate : '–');
            $('#miExp').text(mi.expDate ? mi.expDate : '–');
            $('#miUnit').text(unit);
            $('#miSupplier').text(mi.supplier || '–');
			
            // D-Day & 재고상태 추가
            const threshold = FIXED_THRESHOLD;   // 모달에서도 고정값
            const { labelHtml, ddayHtml } = makeStatusAndDday(mi.expDate, threshold);
            $('#miDday').html(ddayHtml);
            $('#miStatus').html(labelHtml);
			
            // 로케이션 분포
            const $box = $('#locList').empty();
            let sum = 0;
            if (locs.length === 0){
                $box.append('<div class="logline"><div class="logleft">데이터 없음</div><div class="logright">-</div></div>');
            } else {
                locs.forEach(x=>{
                    sum += Number(x.qty)||0;
                    $box.append(
                        '<div class="logline">'+
                            '<div class="logleft">'+x.loc+'</div>'+
                            '<div class="logright"><b>'+x.qty+' '+unit+'</b></div>'+
                        '</div>'
                    );
                });
                $box.append(
                    '<div class="logline">'+
                        '<div class="logleft"><b>합계</b></div>'+
                        '<div class="logright"><b>'+sum+' '+unit+'</b></div>'+
                    '</div>'
                );
            }
            
         	// 현재고 표시
            $('#miCurrent').text(sum+' '+unit);
			
         // 폐기 패널 초기화
            $('#df-lotNumber').val(lotNo);
            $('#df-productCode').val($('#miItem').text().trim() || '');
            const $firstRow = $('#locList .logline .logleft').first();
            const firstLoc = ($firstRow.text() || '').trim();
            $('#df-locationCode').val(firstLoc && firstLoc!=='데이터 없음' ? firstLoc : '');
            const unitTxt = $('#miUnit').text().trim() || 'BOX';
            $('#df-currentQtyText').text(sum.toLocaleString('ko-KR'));
            $('#df-unitText').text(unitTxt);

            $('#btn-disposal-toggle').attr('aria-expanded','false').text('폐기 처리');
            $('#disposalPanel').addClass('hidden');

            // ✅ 폼 리셋 추가 (수량/사유 초기화)
            $('#disposalForm')[0].reset();

            ModalManager.openModalById('lotModal');
        }

        /* ====================== 바인딩 ====================== */
        $(function () {
            $('#btnSearch').on('click', ()=>renderTable());
            $('#btnClear').on('click', ()=>{
                $('#locSearch, #prodSearch').val('');
                $('#locType').val('');
                $('#mfgEnd, #expStart').val('');
                $('#sortOption').val('');
                $('#statusFilter').val('ALL');
                renderTable(true);
            });
            $('#statusFilter, #sortOption, #mfgEnd, #expStart').on('change', ()=>renderTable());
            $('#btnSortExpAsc').on('click', ()=>{
                $('#sortOption').val('expireAsc');
                renderTable({ sortExpAsc:true });
            });
            renderTable(true);
        });
        
        /* ====================== 폐기 패널 토글 ====================== */
	    $('#btn-disposal-toggle').on('click', function(){
	        const $panel = $('#disposalPanel');
	        const expanded = $(this).attr('aria-expanded') === 'true';
	        if(expanded){
	            $(this).attr('aria-expanded','false').text('폐기 처리');
	            $panel.addClass('hidden');
	        }else{
	            $(this).attr('aria-expanded','true').text('닫기');
	            $panel.removeClass('hidden');
	            setTimeout(()=> $('#df-disposalAmount').trigger('focus'),80);
	        }
	    });
	
	    $('#btn-disposal-cancel').on('click', function(){
	        $('#btn-disposal-toggle').attr('aria-expanded','false').text('폐기 처리');
	        $('#disposalPanel').addClass('hidden');
	        $('#disposalForm')[0].reset();
	    });
	
	    $('#disposalForm').on('submit', function(e){
	        e.preventDefault(); // 기본 submit 막음 (지금은 DB 연동 전이니까)

	        const currentQty = parseInt($('#df-currentQtyText').text().replace(/[^0-9]/g,''), 10) || 0;
	        const amount = parseInt($('#df-disposalAmount').val(), 10) || 0;
	        const note = ($('#df-note').val() || '').trim();

	        if(amount <= 0){
	            alert('폐기 수량은 1 이상이어야 합니다.');
	            $('#df-disposalAmount').focus();
	            return;
	        }
	        if(amount > currentQty){
	            alert('폐기 수량이 현재 재고보다 많습니다.');
	            $('#df-disposalAmount').focus();
	            return;
	        }
	        if(note.length < 2){
	            alert('폐기 사유를 두 글자 이상 입력하세요.');
	            $('#df-note').focus();
	            return;
	        }

	     	// 상태를 폐기로 업데이트
	        const lotNo = $('#df-lotNumber').val();
	        const row = realtimeData.find(x => x.lotNo === lotNo);
	        if(row){
	            row.qty -= amount; // 재고 차감
	            if(row.qty <= 0){
	                row.qty = 0;
	            }
	            // ✅ 재고가 남았어도 폐기 상태로 표시되게 강제
	            row.status = 'DISPOSED';
	        }

	     	// 모달 닫고 테이블 갱신
	        ModalManager.closeModal(document.getElementById('lotModal'));
	        renderTable(true);

	        alert('폐기 처리가 완료되었습니다.');
	    });
    </script>
</body>
</html>