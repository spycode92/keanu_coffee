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

    /* 재고 상태 라벨 */
    .status-label { display:inline-block; padding:3px 8px; border-radius:4px; font-weight:bold; font-size:0.9em; }
    .status-label.imminent { background:#fff3cd; border:1px solid #ffc107; color:#856404; }
    .status-label.expired  { background:#f8d7da; border:1px solid #dc3545; color:#721c24; }
    .status-label.normal   { background:#d4edda; border:1px solid #28a745; color:#155724; }

    /* D-Day 뱃지 */
    .dday-badge { display:inline-block; margin-left:6px; padding:1px 6px; border-radius:999px; border:1px solid rgba(0,0,0,.1); font-size:.8em; font-weight:700; opacity:.9; }
    .dday-warn { background:rgba(255,193,7,.18); border-color:rgba(255,193,7,.65); }
    .dday-danger { background:rgba(220,53,69,.20); border-color:rgba(220,53,69,.70); }

    /* 모달 */
    .modal-backdrop { position: fixed; inset: 0; display: none; align-items: center; justify-content: center; background: rgba(0,0,0,.45); z-index: 1000; }
    .modal-backdrop.on { display: flex; }
    .modal-dialog { width: 720px; background: #ffffff; color: #0b1220; border: 1px solid #334155; border-radius: 14px; overflow: hidden; }
    .modal-header { display: flex; align-items: center; justify-content: space-between; padding: 14px 16px; background: #0b1220; color:#e2e8f0; border-bottom: 1px solid #334155; }
    .modal-body { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; padding: 16px; }
    .kv { background: #0f172a; border: 1px solid #334155; border-radius: 10px; padding: 12px; color:#e2e8f0; }
    .kv h4 { margin: 0 0 8px 0; font-size: 13px; color: #94a3b8; }
    .kv .row { display: flex; justify-content: space-between; padding: 6px 0; border-bottom: 1px dashed #23304a; }
    .kv .row:last-child { border-bottom: 0; }
    .btn-ghost { padding: 8px 14px; border: 1px solid #334155; background: #ffffff; color: #0b1220; border-radius: 10px; cursor: pointer; }
    .btn-ghost:hover { background: #8C8C8C; }
    .small-muted { color: #94a3b8; font-size: 12px; }

    /* 로그 뱃지 */
    .badge { display:inline-block; padding:2px 8px; border-radius:999px; font-size:12px; border:1px solid rgba(255,255,255,.15); }
    .badge-out { background:rgba(220,53,69,.15); }
    .badge-move { background:rgba(13,110,253,.15); }
    .badge-dispose { background:rgba(108,117,125,.15); }
    .badge-adjust { background:rgba(255,193,7,.15); }

    .logline { display:flex; justify-content:space-between; gap:10px; padding:6px 0; border-bottom:1px dashed #23304a; }
    .logline:last-child { border-bottom:0; }
    .logleft { display:flex; gap:8px; align-items:center; }
    .logright { text-align:right; white-space:nowrap; }

    /* 필터 라인 */
    .filters { display:grid; grid-template-columns:1fr 1fr 1fr auto auto; gap:12px; padding:12px 12px 0; }
    .filters-2 { display:grid; grid-template-columns:repeat(4, 1fr) 220px; gap:12px; padding:8px 12px 0; align-items:end; }
    .form-inline { display:flex; align-items:center; gap:6px; }

    /* 출고여부 뱃지 */
    .ship-badge { display:inline-block; padding:2px 10px; border-radius:999px; font-weight:700; font-size:.85em; border:1px solid rgba(0,0,0,.1); }
    .ship-yes { background:#e6ffed; border-color:#16a34a; color:#166534; }
    .ship-no  { background:#e5e7eb; border-color:#9ca3af; color:#6b7280; }

    /* 불가능 행 회색 처리 */
    .disabled-row { background:#f3f4f6 !important; color:#6b7280 !important; }
    @media (prefers-color-scheme: dark){
        .disabled-row { background:#1f2937 !important; color:#9ca3af !important; }
    }

    /* ================== 추가: 폐기 패널/버튼/폼 ================== */
    .panel-disposal { border:1px dashed #334155; border-radius:10px; padding:12px; background:#0f172a; color:#e2e8f0; grid-column:1 / -1; }
    .hidden { display:none; }
    .btn-danger { padding:8px 14px; border-radius:10px; border:1px solid #7f1d1d; background:#b91c1c; color:#fff; cursor:pointer; }
    .btn-danger:hover { filter:brightness(1.06); }

    .disp-form .form-row { display:flex; flex-direction:column; gap:6px; margin:10px 0; }
    .disp-form input[type="number"], .disp-form textarea { background:#0b1220; color:#e2e8f0; border:1px solid #334155; border-radius:8px; padding:10px; }

    /* 요청사항: 폐기 사유 텍스트 영역 가로 확장 */
    .disp-form textarea { width:100%; resize:vertical; min-height:90px; }

    .disp-form .form-actions { display:flex; gap:8px; justify-content:flex-end; }

    /* 요청사항: 버튼 모양 동일, 색상만 다르게 */
    .disp-form .btn-action { flex:1; padding:10px; border-radius:8px; border:1px solid transparent; font-weight:bold; cursor:pointer; }
    .disp-form .btn-submit { background:#2563eb; border-color:#1d4ed8; color:#fff; }
    .disp-form .btn-submit:hover { filter:brightness(1.08); }
    .disp-form .btn-cancel { background:#6b7280; border-color:#4b5563; color:#fff; }
    .disp-form .btn-cancel:hover { filter:brightness(1.08); }
    .small-hint { color:#94a3b8; font-size:12px; margin-left:6px; }
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<div class="card" style="margin:20px;">
	    <div class="card-header">
	        <h3 class="card-title">실시간 재고 조회</h3>
	    </div>
	    <div>
	        <!-- 검색 조건 -->
	        <div style="display:grid; grid-template-columns:1fr 1fr 1fr auto auto; gap:12px; padding:12px 12px 0;">
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
	                <label class="form-label">정렬</label>
	                <select id="sortOption" class="form-control">
	                    <option value="">정렬 선택</option>
	                    <option value="manufactureAsc">제조일자 빠른 순</option>
	                    <option value="manufactureDesc">제조일자 늦은 순</option>
	                    <option value="expireAsc">유통기한 빠른 순</option>
	                    <option value="expireDesc">유통기한 늦은 순</option>
	                </select>
	            </div>
	        </div>
	
	        <div style="display:flex; gap:16px; align-items:center; padding:12px;">
	            <label class="form-label" style="display:flex; align-items:center; gap:6px; margin:0;">
	                임박 기준(D-)
	                <input id="threshold" type="number" min="1" value="7" style="width:80px;">
	            </label>
	            <label class="form-label" style="display:flex; align-items:center; gap:6px; margin:0;">
	                상태 필터
	                <select id="statusFilter" class="form-control" style="width:140px;">
	                    <option value="ALL">전체</option>
	                    <option value="WARN">임박</option>
	                    <option value="EXPIRED">만료</option>
	                    <option value="OK">정상</option>
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
	</div>
	
	<!-- LOT 상세 모달 -->
	<div id="lotModal" class="modal-backdrop" aria-hidden="true">
	    <div class="modal-dialog" role="dialog" aria-modal="true">
	        <div class="modal-header">
	            <h4 style="margin:0;">재고 상세</h4>
	            <button class="btn-ghost" onclick="closeLotModal()"><b>닫기</b></button>
	        </div>
	        <div class="modal-body">
	            <div class="kv">
	                <h4>입고 정보</h4>
	                <div class="row"><span>상품명</span><b id="miName">-</b></div>
	                <div class="row"><span>상품코드</span><b id="miItem">-</b></div>
	                <div class="row"><span>LOT</span><b id="miLot">-</b></div>
	                <div class="row"><span>제조일자</span><b id="miMfg">-</b></div>
	                <div class="row"><span>유통기한</span><b id="miExp">-</b></div>
	                <div class="row"><span>단위</span><b id="miUnit">-</b></div>
	                <div class="row"><span>입고수량</span><b id="miInbound">-</b></div>
	                <div class="row"><span>현재고(합계)</span><b id="miCurrent">-</b></div>
	                <div class="row"><span>차이</span><b id="miDelta">-</b></div>
	                <div class="row"><span>공급처</span><b id="miSupplier">-</b></div>
	            </div>
	
	            <div>
	                <div class="kv">
	                    <h4>로케이션 분포(동일 LOT)</h4>
	                    <div id="locList"><div class="row"><span>데이터 없음</span><b>-</b></div></div>
	                </div>
	                <div class="kv" style="margin-top:12px;">
	                    <h4>출고/이동 내역</h4>
	                    <div id="moveLog">
	                        <div class="logline"><div class="logleft">로그 없음</div><div class="logright">-</div></div>
	                    </div>
	                </div>
	            </div>
	
	            <!-- 폐기 처리 섹션 -->
	            <div class="kv" style="margin-top:12px; grid-column:1 / -1;">
	                <div style="display:flex; justify-content:space-between; align-items:center;">
	                    <h4 style="margin:0;">폐기 처리</h4>
	                    <button type="button" id="btn-disposal-toggle" class="btn-danger" aria-expanded="false" aria-controls="disposalPanel">폐기 처리</button>
	                </div>
	
	                <div id="disposalPanel" class="panel-disposal hidden" role="region" aria-labelledby="btn-disposal-toggle">
	                    <form id="disposalForm" class="disp-form" method="post" action="${pageContext.request.contextPath}/inventory/disposal/write">
	                        <!-- hidden 값은 모달 오픈 시 채움 -->
	                        <input type="hidden" name="lotNumber" id="df-lotNumber">
	                        <input type="hidden" name="productCode" id="df-productCode">
	                        <input type="hidden" name="locationCode" id="df-locationCode">
	                        <input type="hidden" name="empIdx" id="df-empIdx" value="${loginEmpIdx}">
	
	                        <div class="form-row">
	                            <label for="df-disposalAmount"><b>폐기 수량</b></label>
	                            <input type="number" min="1" step="1" name="disposalAmount" id="df-disposalAmount" placeholder="예: 5" required>
	                            <span class="small-hint">현재 재고 합계: <span id="df-currentQtyText">0</span> <span id="df-unitText">BOX</span></span>
	                        </div>
	
	                        <div class="form-row">
	                            <label for="df-note"><b>폐기 사유</b></label>
	                            <textarea id="df-note" name="note" rows="4" placeholder="예: 파손, 오염, 유통기한 경과 등" required></textarea>
	                        </div>
	
	                        <div class="form-actions">
	                            <button type="submit" class="btn-action btn-submit">폐기 등록</button>
	                            <button type="button" class="btn-action btn-cancel" id="btn-disposal-cancel">취소</button>
	                        </div>
	                    </form>
	                </div>
	            </div>
	            <!-- // 폐기 처리 섹션 -->
	        </div>
	    </div>
	</div>

	<script>
	    /* ====================== Mock 데이터 ====================== */
	    const realtimeData = [
	        { loc: 'A-01', name: '바닐라 시럽',      code: 'SYR-001', qty: 42,  unit: 'BOX', locType: 'Picking', manDate: '2025-02-20', expDate: '2025-08-23', lotNo: 'LOT-SYR-001-20250220-01' },
	        { loc: 'A-02', name: '카라멜 시럽',      code: 'SYR-002', qty: 6,   unit: 'BOX', locType: 'Picking', manDate: '2025-01-15', expDate: '2025-08-05', lotNo: 'LOT-SYR-002-20250115-01' },
	        { loc: 'B-01', name: '원두(하우스블렌드)', code: 'BEAN-001', qty: 5,   unit: 'BOX', locType: 'Pallet',  manDate: '2024-12-01', expDate: '2025-08-01', lotNo: 'LOT-BEAN-001-20241201-01' },
	
	        // 비식품: 제조/유통일자 없음(null)
	        { loc: 'C-01', name: '종이컵 12oz',     code: 'CUP-012', qty: 30, unit: 'BOX',  locType: 'Picking', manDate: null, expDate: null, lotNo: 'LOT-CUP-012-2025001' },
	        { loc: 'C-02', name: '플라스틱 빨대',   code: 'STD-001', qty: 90, unit: 'BOX',  locType: 'Picking', manDate: null, expDate: null, lotNo: 'LOT-STD-001-2025001' },
	        { loc: 'C-03', name: '아이스컵 16oz',   code: 'CUP-016', qty: 180, unit: 'BOX', locType: 'Picking', manDate: null, expDate: null, lotNo: 'LOT-CUP-016-20260110-01' }
	    ];
	
	    const inboundByLot = {
	        'LOT-SYR-001-20250220-01': { itemCode: 'SYR-001', lotNo: 'LOT-SYR-001-20250220-01', mfgDate: '2025-02-20', expDate: '2025-08-23', unit: 'BOX', qtyInbound: 60,  supplier: '케아누식품' },
	        'LOT-SYR-002-20250115-01': { itemCode: 'SYR-002', lotNo: 'LOT-SYR-002-20250115-01', mfgDate: '2025-01-15', expDate: '2025-08-05', unit: 'BOX', qtyInbound: 12,  supplier: '케아누식품' },
	        'LOT-BEAN-001-20241201-01': { itemCode: 'BEAN-001', lotNo: 'LOT-BEAN-001-20241201-01', mfgDate: '2024-12-01', expDate: '2025-08-01', unit: 'BOX', qtyInbound: 10,  supplier: '부산로스터리' },
	
	        // 비식품 inbound (mfg/exp null)
	        'LOT-CUP-012-2025001':     { itemCode: 'CUP-012', lotNo: 'LOT-CUP-012-2025001',     mfgDate: null, expDate: null, unit: 'BOX', qtyInbound: 50,  supplier: '패키지코리아' },
	        'LOT-STD-001-2025001':     { itemCode: 'STD-001', lotNo: 'LOT-STD-001-2025001',     mfgDate: null, expDate: null, unit: 'BOX', qtyInbound: 100, supplier: '패키지코리아' },
	        'LOT-CUP-016-20260110-01': { itemCode: 'CUP-016', lotNo: 'LOT-CUP-016-20260110-01', mfgDate: null, expDate: null, unit: 'BOX', qtyInbound: 200, supplier: '패키지코리아' }
	    };
	
	    const locationsByLot = {
	        'LOT-SYR-001-20250220-01': [{ loc: 'A-01', qty: 42 }, { loc: 'A-02', qty: 6 }],
	        'LOT-SYR-002-20250115-01': [{ loc: 'A-02', qty: 6 }],
	        'LOT-BEAN-001-20241201-01': [{ loc: 'B-01', qty: 5 }],
	
	        // 비식품 분포
	        'LOT-CUP-012-2025001':     [{ loc: 'C-01', qty: 30 }],
	        'LOT-STD-001-2025001':     [{ loc: 'C-02', qty: 90 }],
	        'LOT-CUP-016-20260110-01': [{ loc: 'C-01', qty: 20 }, { loc: 'C-03', qty: 180 }]
	    };
	
	    /* 출고/이동/조정 로그(Mock) — 폐기(DISPOSE) 제거, 수량 정합성 맞춤 */
	    const movementLogs = {
	        'LOT-SYR-001-20250220-01': [
	            { type: 'MOVE', qty: 6, when: '2025-03-03 09:10', user: '김담당', from: 'A-01', to: 'A-02', memo: '피킹영역 보강' }
	        ],
	        'LOT-SYR-002-20250115-01': [
	            { type: 'OUT', qty: 6, when: '2025-04-01 10:21', user: '이피커', from: 'A-02', to: '출고', memo: 'SO-240401-001' }
	        ],
	        'LOT-BEAN-001-20241201-01': [
	            { type: 'OUT', qty: 5, when: '2025-02-15 15:32', user: '박피커', from: 'B-01', to: '출고', memo: 'SO-250215-077' }
	        ],
	
	        // 비식품
	        'LOT-CUP-012-2025001': [
	            { type: 'OUT', qty: 20, when: '2025-07-10 11:20', user: '오피커', from: 'C-01', to: '출고', memo: 'SO-250710-012' }
	        ],
	        'LOT-STD-001-2025001': [
	            { type: 'OUT', qty: 10, when: '2025-07-15 13:00', user: '김플라', from: 'C-02', to: '출고', memo: 'SO-250715-089' }
	        ],
	        'LOT-CUP-016-20260110-01': [
	            { type: 'MOVE', qty: 20, when: '2026-02-01 14:05', user: '최담당', from: 'C-03', to: 'C-01', memo: '집중배치' }
	        ]
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
	
	    function sumLogQtyTypes(lotNo, types){
	        const logs = movementLogs[lotNo] || [];
	        return logs.filter(ev => types.includes(ev.type)).reduce((a, ev) => a + (Number(ev.qty)||0), 0);
	    }
	    function sumAdjust(lotNo, sign){
	        const logs = movementLogs[lotNo] || [];
	        return logs.filter(ev => ev.type === 'ADJUST' && ev.sign === sign).reduce((a, ev) => a + (Number(ev.qty)||0), 0);
	    }
	
	    function makeStatusAndDday(expDate, threshold){
	        const d = diffDaysFromToday(expDate);
	        if (d === null){
	            return {
	                status: 'OK',
	                labelHtml: '해당 없음',
	                ddayHtml: '<span class="dday-badge">–</span>',
	                d: null
	            };
	        }
	        let status = 'OK';
	        let labelHtml = '<span class="status-label normal">정상</span>';
	        const ddText = formatDday(d);
	        let ddayClass = '';
	        if (d < 0){
	            status = 'EXPIRED';
	            labelHtml = '<span class="status-label expired">만료</span>';
	            ddayClass = 'dday-danger';
	        }else if (d === 0 || d <= threshold){
	            status = 'WARN';
	            labelHtml = '<span class="status-label imminent">임박</span>';
	            ddayClass = 'dday-warn';
	        }
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
	
	        const mfgStart = toDateOrNull($('#mfgStart').val());
	        const mfgEnd   = toDateOrNull($('#mfgEnd').val());
	        const expStart = toDateOrNull($('#expStart').val());
	        const expEnd   = toDateOrNull($('#expEnd').val());
	
	        const threshold = Number($('#threshold').val() || 7);
	        const statusFilter = $('#statusFilter').val() || 'ALL';
	        const sortOption = opts.sortExpAsc ? 'expireAsc' : ($('#sortOption').val() || '');
	
	        /* 1) 기본 필터 */
	        let data = realtimeData.filter(r=>{
	            const ok1 = !kwLoc || r.loc.toLowerCase().includes(kwLoc);
	            const ok2 = !kwProd || r.name.toLowerCase().includes(kwProd) || r.code.toLowerCase().includes(kwProd);
	            const ok3 = !type || r.locType === type;
	
	            const mfg = toDateOrNull(r.manDate);
	            const okMfgStart = !mfgStart || (mfg && mfg >= mfgStart);
	            const okMfgEnd   = !mfgEnd   || (mfg && mfg <= mfgEnd);
	
	            const exp = toDateOrNull(r.expDate);
	            const okExpStart = !expStart || (exp && exp >= expStart);
	            const okExpEnd   = !expEnd   || (exp && exp <= expEnd);
	
	            return ok1 && ok2 && ok3 && okMfgStart && okMfgEnd && okExpStart && okExpEnd;
	        });
	
	        /* 2) 정렬 */
	        if (sortOption){
	            data = data.slice().sort((a,b)=>{
	                if (sortOption === 'manufactureAsc')  return new Date(a.manDate) - new Date(b.manDate);
	                if (sortOption === 'manufactureDesc') return new Date(b.manDate) - new Date(a.manDate);
	                if (sortOption === 'expireAsc')       return new Date(a.expDate) - new Date(b.expDate);
	                if (sortOption === 'expireDesc')      return new Date(b.expDate) - new Date(a.expDate);
	                return 0;
	            });
	        }
	
	        /* 3) 상태 필터 & 렌더 */
	        let totalQty = 0;
	        const skuSet = new Set();
	
	        data.forEach(r=>{
	            const { status, labelHtml, ddayHtml } = makeStatusAndDday(r.expDate, threshold);
	            if (statusFilter !== 'ALL' && status !== statusFilter) return;
	
	            totalQty += r.qty;
	            skuSet.add(r.code);
	
	            const shippable = (status !== 'EXPIRED');
	            const shipHtml = shippable
	                ? '<span class="ship-badge ship-yes">가능</span>'
	                : '<span class="ship-badge ship-no">불가능</span>';
	
	            const tr = document.createElement('tr');
	            tr.setAttribute('data-lot', r.lotNo);
	
	            if (!shippable){ tr.classList.add('disabled-row'); }
	
	            tr.innerHTML =
	                '<td>'+r.loc+'</td>'+
	                '<td>'+r.code+'</td>'+
	                '<td>'+r.name+'</td>'+
	                '<td>'+r.qty+'</td>'+
	                '<td>'+r.unit+'</td>'+
	                '<td>'+r.locType+'</td>'+
	                '<td>'+(r.manDate ? r.manDate : '–')+'</td>'+
	                '<td>'+(r.expDate ? r.expDate : '–')+'</td>'+
	                '<td>'+ddayHtml+'</td>'+
	                '<td>'+labelHtml+'</td>'+
	                '<td>'+shipHtml+'</td>';
	
	            tbody.appendChild(tr);
	        });
	
	        $('#kpiSku').text(skuSet.size);
	        $('#kpiQty').text(totalQty.toLocaleString('ko-KR'));
	    }
	
	    /* ====================== 모달 ====================== */
	    $('#tbodyRealtime').on('click','tr',function(){
	        const lotNo = $(this).data('lot');
	        if (!lotNo) return;
	        openLotModal(lotNo);
	    });
	
	    function openLotModal(lotNo){
	        const mi = inboundByLot[lotNo] || {};
	        const locs = locationsByLot[lotNo] || [];
	        const unit = mi.unit || 'BOX';
	        const row = realtimeData.find(x => x.lotNo === lotNo);
	
	        // 모달 데이터 세팅 (상품명 포함)
	        $('#miName').text(row?.name || '–');
	        $('#miItem').text(mi.itemCode || '–');
	        $('#miLot').text(mi.lotNo || lotNo || '–');
	        $('#miMfg').text(mi.mfgDate ? mi.mfgDate : '–');
	        $('#miExp').text(mi.expDate ? mi.expDate : '–');
	        $('#miUnit').text(unit);
	        $('#miSupplier').text(mi.supplier || '–');
	
	        const $box = $('#locList').empty();
	        let sum = 0;
	        if (locs.length === 0){
	            $box.append('<div class="row"><span>데이터 없음</span><b>-</b></div>');
	        }else{
	            locs.forEach(x=>{
	                sum += Number(x.qty)||0;
	                $box.append('<div class="row"><span>'+x.loc+'</span><b>'+x.qty+' '+unit+'</b></div>');
	            });
	            $box.append('<div class="row"><span><b>합계</b></span><b>'+sum+' '+unit+'</b></div>');
	        }
	
	        // 기대재고 = 입고 - 출고 - 조정(-) + 조정(+)
	        const inbound = Number(mi.qtyInbound)||0;
	        const outSum = sumLogQtyTypes(lotNo,['OUT']);
	        const adjustMinus = sumAdjust(lotNo,'-');
	        const adjustPlus  = sumAdjust(lotNo,'+');
	        const expectedCurrent = inbound - (outSum + adjustMinus) + adjustPlus;
	
	        $('#miInbound').text(inbound+' '+unit);
	        $('#miCurrent').text(sum+' '+unit);
	
	        if (inbound===outSum && adjustMinus===0 && adjustPlus===0 && sum===0){
	            $('#miDelta').html('<span class="status-label normal">출고 완료 (잔여 0 '+unit+')</span>');
	        }else if (expectedCurrent === sum){
	            $('#miDelta').html('<span class="status-label normal">재고 일치</span>');
	        }else if (expectedCurrent > sum){
	            const lack = expectedCurrent - sum;
	            $('#miDelta').html('<span class="status-label expired">재고 불일치 '+lack+' '+unit+'</span><span class="small-muted" style="margin-left:6px;">로그 누락(출고/조정-) 의심</span>');
	        }else{
	            const excess = sum - expectedCurrent;
	            $('#miDelta').html('<span class="status-label imminent">초과 +'+excess+' '+unit+'</span><span class="small-muted" style="margin-left:6px;">과입고/조정+ 또는 집계 오류 의심</span>');
	        }
	
	        // 로그 렌더링 (DISPOSE 숨김)
	        const logs = (movementLogs[lotNo] || []).filter(ev => ev.type !== 'DISPOSE');
	        const $log = $('#moveLog').empty();
	        if (logs.length === 0){
	            $log.append('<div class="logline"><div class="logleft">로그 없음</div><div class="logright">-</div></div>');
	        }else{
	            logs.forEach(ev=>{
	                const kind =
	                    ev.type==='OUT'   ? '출고' :
	                    ev.type==='MOVE'  ? '이동' :
	                    ev.type==='ADJUST'? ('조정'+(ev.sign==='-'?'(-)':'(+)')) : ev.type;
	
	                const badgeClass =
	                    ev.type==='OUT'   ? 'badge-out' :
	                    ev.type==='MOVE'  ? 'badge-move' : 'badge-adjust';
	
	                const route =
	                    ev.type==='MOVE' ? ((ev.from||'-')+' → '+(ev.to||'-'))
	                    : (ev.from ? (ev.from+' → '+kind) : kind);
	
	                $log.append(
	                    '<div class="logline">'+
	                        '<div class="logleft">'+
	                            '<span class="badge '+badgeClass+'">'+kind+'</span>'+
	                            '<span style="opacity:.85;">'+(ev.when||'-')+'</span>'+
	                            '<span style="opacity:.7;">'+(ev.user||'-')+'</span>'+
	                        '</div>'+
	                        '<div class="logright">'+
	                            '<div><b>'+(ev.qty||0)+' '+unit+'</b></div>'+
	                            (route?'<div style="opacity:.8;">'+route+'</div>':'')+
	                            (ev.memo?'<div style="opacity:.6;">'+ev.memo+'</div>':'')+
	                        '</div>'+
	                    '</div>'
	                );
	            });
	        }
	
	        /* 폐기 폼 데이터 주입 */
	        $('#df-lotNumber').val(lotNo);
	        $('#df-productCode').val($('#miItem').text().trim() || '');
	
	        // 분포 첫 로우의 로케이션을 기본값으로 (여러 분산 시 서버에서 실제 차감 대상 결정)
	        const $first = $('#locList .row span:first').first();
	        const firstLoc = ($first.text() || '').trim();
	        $('#df-locationCode').val(firstLoc && firstLoc!=='데이터 없음' ? firstLoc : '');
	
	        // 합계/단위 표시
	        const unitTxt = $('#miUnit').text().trim() || 'BOX';
	        const sumTxt  = ($('#miCurrent').text() || '0').trim(); // "48 BOX"
	        const sumNum  = parseInt(sumTxt.replace(/[^0-9]/g,''), 10) || 0;
	        $('#df-currentQtyText').text(sumNum.toLocaleString('ko-KR'));
	        $('#df-unitText').text(unitTxt);
	
	        // 패널은 기본 닫힘
	        $('#btn-disposal-toggle').attr('aria-expanded','false').text('폐기 처리');
	        $('#disposalPanel').hide().addClass('hidden');
	
	        $('#lotModal').addClass('on');
	    }
	    function closeLotModal(){ $('#lotModal').removeClass('on'); }
	
	    /* ====================== 바인딩 ====================== */
	    $(function () {
	        $('#btnSearch').on('click', ()=>renderTable());
	        $('#btnClear').on('click', ()=>{
	            $('#locSearch, #prodSearch').val('');
	            $('#locType').val('');
	            $('#mfgStart, #mfgEnd, #expStart, #expEnd').val('');
	            $('#sortOption').val('');
	            $('#threshold').val(7);
	            $('#statusFilter').val('ALL');
	            renderTable(true);
	        });
	
	        $('#threshold, #statusFilter, #sortOption, #mfgStart, #mfgEnd, #expStart, #expEnd').on('change', ()=>renderTable());
	        $('#btnSortExpAsc').on('click', ()=>{
	            $('#sortOption').val('expireAsc');
	            renderTable({ sortExpAsc:true });
	        });
	
	        renderTable(true);
	    });
	
	    /* ====================== 폐기 패널 토글/검증 ====================== */
	    $('#btn-disposal-toggle').on('click', function(){
	        const $panel = $('#disposalPanel');
	        const expanded = $(this).attr('aria-expanded') === 'true';
	        if(expanded){
	            $(this).attr('aria-expanded','false').text('폐기 처리');
	            $panel.slideUp(160).addClass('hidden');
	        }else{
	            $(this).attr('aria-expanded','true').text('닫기');
	            $panel.removeClass('hidden').hide().slideDown(160);
	            setTimeout(()=> $('#df-disposalAmount').trigger('focus'),120);
	        }
	    });
	
	    $('#btn-disposal-cancel').on('click', function(){
	        $('#btn-disposal-toggle').attr('aria-expanded','false').text('폐기 처리');
	        $('#disposalPanel').slideUp(160).addClass('hidden');
	        $('#disposalForm')[0].reset();
	    });
	
	    $('#disposalForm').on('submit', function(e){
	        const currentQty = parseInt($('#df-currentQtyText').text().replace(/[^0-9]/g,''), 10) || 0;
	        const amount = parseInt($('#df-disposalAmount').val(), 10) || 0;
	        const note = ($('#df-note').val() || '').trim();
	
	        if(amount <= 0){
	            alert('폐기 수량은 1 이상이어야 합니다.');
	            $('#df-disposalAmount').focus();
	            e.preventDefault(); return;
	        }
	        if(amount > currentQty){
	            alert('폐기 수량이 현재 재고보다 많습니다.');
	            $('#df-disposalAmount').focus();
	            e.preventDefault(); return;
	        }
	        if(note.length < 2){
	            alert('폐기 사유를 두 글자 이상 입력하세요.');
	            $('#df-note').focus();
	            e.preventDefault(); return;
	        }
	        // 통과 → 일반 submit (뷰만, 서버 검증 별도)
	    });
	</script>

	
</body>
</html>