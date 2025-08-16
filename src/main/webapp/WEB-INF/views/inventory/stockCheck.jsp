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
	/* 재고 상태 라벨 기본 스타일 */
	.status-label {
	    display: inline-block;
	    padding: 3px 8px;
	    border-radius: 4px;
	    font-weight: bold;
	    font-size: 0.9em;
	}
	
	/* 임박 라벨 */
	.status-label.imminent {
	    background-color: #fff3cd; /* 연한 노랑 */
	    border: 1px solid #ffc107; /* 노랑 테두리 */
	    color: #856404;            /* 진한 갈색 글씨 */
	}
	
	/* 만료 라벨 */
	.status-label.expired {
	    background-color: #f8d7da; /* 연한 빨강 */
	    border: 1px solid #dc3545; /* 빨강 테두리 */
	    color: #721c24;            /* 진한 빨강 글씨 */
	}
	
	/* 정상 라벨 */
	.status-label.normal {
	    background-color: #d4edda; /* 연한 초록 */
	    border: 1px solid #28a745; /* 초록 테두리 */
	    color: #155724;            /* 진한 초록 글씨 */
	}
	
	/* *** 추가: D-Day 배지 (숫자/텍스트 강조) */
	.dday-badge {
	    display:inline-block; margin-left:6px; padding:1px 6px;
	    border-radius:999px; border:1px solid rgba(0,0,0,.1);
	    font-size:.8em; font-weight:700; opacity:.9;
	}
	.dday-warn   { background:rgba(255,193,7,.18);  border-color:rgba(255,193,7,.65); }
	.dday-danger { background:rgba(220,53,69,.20);  border-color:rgba(220,53,69,.70); }

	
	/* 모달 */
    .modal-backdrop { position: fixed; inset: 0; display: none; align-items: center; justify-content: center; background: rgba(0,0,0,.45); z-index: 1000; }
    .modal-backdrop.on { display: flex; }
    .modal-dialog { width: 720px; background: #ffffff; color: #e2e8f0; border: 1px solid #334155; border-radius: 14px; overflow: hidden; }
    .modal-header { display: flex; align-items: center; justify-content: space-between; padding: 14px 16px; background: #0b1220; border-bottom: 1px solid #334155; }
    .modal-body { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; padding: 16px; }
    .kv { background: #0f172a; border: 1px solid #334155; border-radius: 10px; padding: 12px; }
    .kv h4 { margin: 0 0 8px 0; font-size: 13px; color: #94a3b8; }
    .kv .row { display: flex; justify-content: space-between; padding: 6px 0; border-bottom: 1px dashed #23304a; }
    .kv .row:last-child { border-bottom: 0; }
    .btn-ghost { padding: 8px 14px; border: 1px solid #334155; background: #ffffff; color: #0b1220; border-radius: 10px; cursor: pointer; }
    .btn-ghost:hover { background: #8C8C8C; }
    .small-muted { color: #94a3b8; font-size: 12px; }

    /* *** 추가: 로그 뱃지 */
	.badge { display:inline-block; padding:2px 8px; border-radius:999px; font-size:12px; border:1px solid rgba(255,255,255,.15); }
	.badge-out { background:rgba(220,53,69,.15); }     /* 출고 */
	.badge-move { background:rgba(13,110,253,.15); }   /* 이동 */
	.badge-dispose { background:rgba(108,117,125,.15);}/* 폐기 */
	.badge-adjust { background:rgba(255,193,7,.15);}   /* 조정 */

	/* *** 추가: 로그 행 2줄 레이아웃 */
	.logline { display:flex; justify-content:space-between; gap:10px; padding:6px 0; border-bottom:1px dashed #23304a; }
	.logline:last-child { border-bottom:0; }
	.logleft { display:flex; gap:8px; align-items:center; }
	.logright { text-align:right; white-space:nowrap; }
</style>
</head>
<body>
	
	<!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	
	<!-- 실시간 재고 조회 -->
	<div class="card" style="margin:20px;">
		<div class="card-header">
			<h3 class="card-title">실시간 재고 조회</h3>
		</div>
		<div>
			<!-- 검색 조건 -->
			<div style="display:grid; grid-template-columns:1fr 1fr 1fr auto auto; gap:12px; padding:12px 12px 0;">
				<div>
					<label class="form-label">로케이션</label>
					<input class="form-control" id="locSearch" placeholder="예: A-01">
				</div>
				<div>
					<label class="form-label">상품명/코드</label>
					<input class="form-control" id="prodSearch" placeholder="예: 바닐라시럽 / SYR-001">
				</div>
				<div>
                    <!-- *** 변경: 로케이션 유형 영문 표기 -->
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
			
			<!-- *** 추가: 제조/유통기한 툴바 -->
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
                <span style="font-size:12px; opacity:.75;">※ 임박(D ≤ 기준), 당일(D-day), 만료(D &lt; 0 → D+), 출고 시 FIFO 참고.</span>
            </div>
			
			<!-- 지표 -->
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

			<!-- 재고 테이블 -->
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
					<tbody id="tbodyRealtime"></tbody> 
				</table>
				<p class="small-muted" style="margin:8px 12px;">행을 클릭하면 “입고정보 + 로케이션 분포(같은 LOT 묶음)” 모달이 열립니다.</p>
			</div>
		</div>
	</div>
	
	<!-- LOT 상세 모달 -->
    <div id="lotModal" class="modal-backdrop" aria-hidden="true">
        <div class="modal-dialog" role="dialog" aria-modal="true">
            <div class="modal-header">
                <h4 style="margin:0;">LOT 상세</h4>
                <button class="btn-ghost" onclick="closeLotModal()"><b>닫기</b></button>
            </div>
            <div class="modal-body">
                <!-- 좌: 입고/현재고 비교 -->
                <div class="kv">
                    <h4>입고 정보</h4>
                    <div class="row"><span>상품코드</span><b id="miItem">-</b></div>
                    <div class="row"><span>LOT</span><b id="miLot">-</b></div>
                    <div class="row"><span>제조일자</span><b id="miMfg">-</b></div>
                    <div class="row"><span>유통기한</span><b id="miExp">-</b></div>
                    <div class="row"><span>단위</span><b id="miUnit">-</b></div>
                    <!-- *** 추가: 비교 값 -->
                    <div class="row"><span>입고수량</span><b id="miInbound">-</b></div>
                    <div class="row"><span>현재고(합계)</span><b id="miCurrent">-</b></div>
                    <div class="row"><span>차이</span><b id="miDelta">-</b></div>
                    <div class="row"><span>공급처</span><b id="miSupplier">-</b></div>
                </div>

                <!-- 우: 로케이션 분포 + 로그 -->
                <div>
                    <div class="kv">
                        <h4>로케이션 분포(동일 LOT)</h4>
                        <div id="locList"><div class="row"><span>데이터 없음</span><b>-</b></div></div>
                    </div>
                    <!-- *** 추가: 출고/이동 로그 -->
                    <div class="kv" style="margin-top:12px;">
                        <h4>출고/이동 내역</h4>
                        <div id="moveLog">
                            <div class="logline"><div class="logleft">로그 없음</div><div class="logright">-</div></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

	
	<script>
		/* ===== Mock 데이터 (뷰 전용) ===== */
		const realtimeData = [
		  { loc: 'A-01', name: '바닐라 시럽',       code: 'SYR-001', qty: 42,  unit: 'BOX', locType: 'Picking', manDate: '2025-02-20', expDate: '2025-08-20', lotNo: 'LOT-SYR-001-20250220-01' },
		  { loc: 'A-02', name: '카라멜 시럽',       code: 'SYR-002', qty: 6,   unit: 'BOX', locType: 'Picking', manDate: '2025-01-15', expDate: '2025-08-05', lotNo: 'LOT-SYR-002-20250115-01' },
		  { loc: 'B-01', name: '원두(하우스블렌드)', code: 'BEAN-001', qty: 0,  unit: 'BOX', locType: 'Pallet',  manDate: '2024-12-01', expDate: '2025-08-01', lotNo: 'LOT-BEAN-001-20241201-01' },
		  { loc: 'C-03', name: '아이스컵 16oz',     code: 'CUP-016',  qty: 180, unit: 'BOX', locType: 'Picking', manDate: '2026-01-10', expDate: '2026-06-01', lotNo: 'LOT-CUP-016-20260110-01' }
		];
		
		const inboundByLot = {
		  'LOT-SYR-001-20250220-01': { itemCode: 'SYR-001', lotNo: 'LOT-SYR-001-20250220-01', mfgDate: '2025-02-20', expDate: '2025-08-20', unit: 'BOX', qtyInbound: 60,  supplier: '케아누식품' },
		  'LOT-SYR-002-20250115-01': { itemCode: 'SYR-002', lotNo: 'LOT-SYR-002-20250115-01', mfgDate: '2025-01-15', expDate: '2025-08-05', unit: 'BOX', qtyInbound: 12,  supplier: '케아누식품' },
		  'LOT-BEAN-001-20241201-01': { itemCode: 'BEAN-001', lotNo: 'LOT-BEAN-001-20241201-01', mfgDate: '2024-12-01', expDate: '2025-08-01', unit: 'BOX', qtyInbound: 10, supplier: '부산로스터리' },
		  'LOT-CUP-016-20260110-01': { itemCode: 'CUP-016', lotNo: 'LOT-CUP-016-20260110-01', mfgDate: '2026-01-10', expDate: '2026-06-01', unit: 'BOX', qtyInbound: 200, supplier: '패키지코리아' }
		};
		
		const locationsByLot = {
		  'LOT-SYR-001-20250220-01': [{ loc: 'A-01', qty: 42 }, { loc: 'A-02', qty: 6 }],
		  'LOT-SYR-002-20250115-01': [{ loc: 'A-02', qty: 6 }],
		  'LOT-BEAN-001-20241201-01': [{ loc: 'B-01', qty: 0 }],
		  'LOT-CUP-016-20260110-01': [{ loc: 'C-01', qty: 20 }, { loc: 'C-03', qty: 180 }]
		};
		
		/* *** 추가: 출고/이동/폐기/조정 로그(Mock) — 실제에선 WMS 로그 테이블 조회 */
		const movementLogs = {
		  'LOT-SYR-001-20250220-01': [
		    { type: 'MOVE', qty: 6, when: '2025-03-03 09:10', user: '김담당', from: 'A-01', to: 'A-02', memo: '피킹영역 보강' }
// 		    { type: 'OUT', qty: 12, when: '2025-03-03 09:11', user: '김담당', from: 'A-02', to: '출고', memo: 'SO-240401-021' }
		    // 예: { type:'ADJUST', sign:'-', qty:12, when:'2025-03-05 11:10', user:'관리자', memo:'실사 차감' }
		  ],
		  'LOT-SYR-002-20250115-01': [
		    { type: 'OUT', qty: 6, when: '2025-04-01 10:21', user: '이피커', from: 'A-02', to: '출고', memo: 'SO-240401-001' }
		  ],
		  'LOT-BEAN-001-20241201-01': [
		    { type: 'OUT', qty: 10, when: '2025-02-15 15:32', user: '박피커', from: 'B-01', to: '출고', memo: 'SO-250215-077' }
		  ],
		  'LOT-CUP-016-20260110-01': [
		    { type: 'MOVE', qty: 20, when: '2026-02-01 14:05', user: '최담당', from: 'C-01', to: 'C-03', memo: '집중배치' }
		  ]
		};

		/* ===== 유틸 ===== */
		function diffDaysFromToday(dateStr) {
		  const today = new Date();
		  const base = new Date(today.getFullYear(), today.getMonth(), today.getDate());
		  const d = new Date(dateStr + 'T00:00:00');
		  return Math.ceil((d.getTime() - base.getTime()) / (1000 * 60 * 60 * 24));
		}
		
		/* *** 추가: D-Day 표기 규칙: 남음=D-7, 당일=D-day, 경과=D+3 */
		function formatDday(d) {
		  if (d < 0) return 'D+' + Math.abs(d);
		  if (d === 0) return 'D-day';
		  return 'D-' + d;
		}

		/* *** 추가: LOT별 로그 합계 계산 유틸(단일 타입) */
		function sumLogQty(lotNo, type) {
		  const logs = movementLogs[lotNo] || [];
		  return logs
		    .filter(ev => ev.type === type)
		    .reduce((acc, ev) => acc + (Number(ev.qty) || 0), 0);
		}

		/* *** 추가: 지정 타입들의 합계 */
		function sumLogQtyTypes(lotNo, types) {
		  const logs = movementLogs[lotNo] || [];
		  return logs
		    .filter(ev => types.includes(ev.type))
		    .reduce((acc, ev) => acc + (Number(ev.qty) || 0), 0);
		}

		/* *** 추가: 조정(ADJUST) 합계 – sign: '+' | '-' */
		function sumAdjust(lotNo, sign) {
		  const logs = movementLogs[lotNo] || [];
		  return logs
		    .filter(ev => ev.type === 'ADJUST' && ev.sign === sign)
		    .reduce((acc, ev) => acc + (Number(ev.qty) || 0), 0);
		}
		
		/* *** 변경: 상태/라벨 + D-day 뱃지 생성 로직 */
		function makeStatusAndDday(expDate, threshold) {
		  const d = diffDaysFromToday(expDate);
		
		  let status = 'OK';
		  let labelHtml = '<span class="status-label normal">정상</span>';
		
		  const ddText = formatDday(d);
		
		  let ddayClass = '';
		  if (d < 0) {
		    status = 'EXPIRED';
		    labelHtml = '<span class="status-label expired">만료</span>';
		    ddayClass = 'dday-danger';
		  } else if (d === 0 || d <= threshold) {
		    status = 'WARN';
		    labelHtml = '<span class="status-label imminent">임박</span>';
		    ddayClass = 'dday-warn';
		  }
		
		  const ddayHtml = '<span class="dday-badge ' + ddayClass + '">' + ddText + '</span>';
		  return { status, labelHtml, ddayHtml, d };
		}
		
		/* ===== 테이블 렌더 ===== */
		function renderTable(opts = {}) {
		  const tbody = document.getElementById('tbodyRealtime');
		  tbody.innerHTML = '';
		
		  const showAll = !!opts.showAll;
		  const kwLoc = showAll ? '' : document.getElementById('locSearch').value.trim().toLowerCase();
		  const kwProd = showAll ? '' : document.getElementById('prodSearch').value.trim().toLowerCase();
		  const type = showAll ? '' : document.getElementById('locType').value;
		  const threshold = Number(document.getElementById('threshold').value || 7);
		  const statusFilter = document.getElementById('statusFilter').value || 'ALL';
		
		  let data = realtimeData.filter(r => {
		    const ok1 = !kwLoc || r.loc.toLowerCase().includes(kwLoc);
		    const ok2 = !kwProd || r.name.toLowerCase().includes(kwProd) || r.code.toLowerCase().includes(kwProd);
		    const ok3 = !type || r.locType === type;
		    return ok1 && ok2 && ok3;
		  });
		
		  if (opts.sortExpAsc) {
		    data = data.slice().sort((a, b) => new Date(a.expDate) - new Date(b.expDate));
		  }
		
		  let totalQty = 0;
		  const skuSet = new Set();
		
		  data.forEach(r => {
		    const { status, labelHtml, ddayHtml } = makeStatusAndDday(r.expDate, threshold);
		    if (statusFilter !== 'ALL' && status !== statusFilter) return;
		
		    totalQty += r.qty;
		    skuSet.add(r.code);
		
		    const tr = document.createElement('tr');
		    tr.setAttribute('data-lot', r.lotNo);
		    tr.innerHTML =
		      '<td>' + r.loc + '</td>' +
		      '<td>' + r.name + '</td>' +
		      '<td>' + r.code + '</td>' +
		      '<td>' + r.qty + '</td>' +
		      '<td>' + r.unit + '</td>' +
		      '<td>' + r.locType + '</td>' +
		      '<td>' + r.manDate + '</td>' +
		      '<td>' + r.expDate + '</td>' +
		      '<td>' + ddayHtml + '</td>' +
		      '<td>' + labelHtml + '</td>';
		
		    tbody.appendChild(tr);
		  });
		
		  document.getElementById('kpiSku').textContent = skuSet.size;
		  document.getElementById('kpiQty').textContent = totalQty.toLocaleString('ko-KR');
		}
		
		/* ===== 모달 ===== */
		$('#tbodyRealtime').on('click', 'tr', function () {
		  const lotNo = $(this).data('lot');
		  if (!lotNo) return;
		  openLotModal(lotNo);
		});
		
		function openLotModal(lotNo) {
		  console.log('[VIEW LOG] action=SEARCH, lot=', lotNo, 'at', new Date().toLocaleString('ko-KR'));
		
		  const mi = inboundByLot[lotNo] || {};
		  const locs = locationsByLot[lotNo] || [];
		  const unit = mi.unit || 'BOX';
		
		  // 좌측: 기본 + 비교 값
		  $('#miItem').text(mi.itemCode || '-');
		  $('#miLot').text(mi.lotNo || lotNo || '-');
		  $('#miMfg').text(mi.mfgDate || '-');
		  $('#miExp').text(mi.expDate || '-');
		  $('#miUnit').text(unit);
		  $('#miSupplier').text(mi.supplier || '-');
		
		  // 우측: 로케이션 분포
		  const $box = $('#locList').empty();
		  let sum = 0;
		
		  if (locs.length === 0) {
		    $box.append('<div class="row"><span>데이터 없음</span><b>-</b></div>');
		  } else {
		    locs.forEach(x => {
		      sum += Number(x.qty) || 0;
		      $box.append('<div class="row"><span>' + x.loc + '</span><b>' + x.qty + ' ' + unit + '</b></div>');
		    });
		    $box.append('<div class="row"><span><b>합계</b></span><b>' + sum + ' ' + unit + '</b></div>');
		  }
		
		  // 좌측: 입고/현재/차이
		  const inbound = Number(mi.qtyInbound) || 0;
		  const diff = sum - inbound; // (참고용, 화면 표시는 아래 로직)

		  /* *** 추가: 출고/폐기/조정(±) 누계 반영하여 '정상/불일치/초과/출고완료' 판정 */
		  const outSum       = sumLogQtyTypes(lotNo, ['OUT']);       // 출고 누계
		  const disposeSum   = sumLogQtyTypes(lotNo, ['DISPOSE']);   // 폐기 누계
		  const adjustMinus  = sumAdjust(lotNo, '-');                 // 조정(-)
		  const adjustPlus   = sumAdjust(lotNo, '+');                 // 조정(+)
		  // MOVE(이동)는 내부 재배치 → 총량 변동 0, 제외
		  const expectedCurrent = inbound - (outSum + disposeSum + adjustMinus) + adjustPlus;

		  $('#miInbound').text(inbound + ' ' + unit);
		  $('#miCurrent').text(sum + ' ' + unit);

		  /* *** 변경: 상황별 라벨링 + 힌트 */
		  if (inbound === outSum && disposeSum === 0 && adjustMinus === 0 && adjustPlus === 0 && sum === 0) {
		    $('#miDelta').html('<span class="status-label normal">출고 완료 (잔여 0 ' + unit + ')</span>');
		  } else if (expectedCurrent === sum) {
		    $('#miDelta').html('<span class="status-label normal">일치 (출고/폐기/조정 반영)</span>');
		  } else if (expectedCurrent > sum) {
		    const lack = expectedCurrent - sum;
		    $('#miDelta').html('<span class="status-label expired">불일치 ' + lack + ' ' + unit + '</span><span class="small-muted" style="margin-left:6px;">로그 누락(출고/폐기/조정-) 의심</span>');
		  } else {
		    const excess = sum - expectedCurrent;
		    $('#miDelta').html('<span class="status-label imminent">초과 +' + excess + ' ' + unit + '</span><span class="small-muted" style="margin-left:6px;">과입고/조정+ 또는 집계 오류 의심</span>');
		  }
		
		  // 출고/이동/조정/폐기 로그
		  const logs = movementLogs[lotNo] || [];
		  const $log = $('#moveLog').empty();
		
		  if (logs.length === 0) {
		    $log.append('<div class="logline"><div class="logleft">로그 없음</div><div class="logright">-</div></div>');
		  } else {
		    logs.forEach(ev => {
		      const kind =
		        ev.type === 'OUT' ? '출고' :
		        ev.type === 'MOVE' ? '이동' :
		        ev.type === 'DISPOSE' ? '폐기' :
		        ev.type === 'ADJUST' ? ('조정' + (ev.sign === '-' ? '(-)' : '(+)')) :
		        ev.type;

		      const badgeClass =
		        ev.type === 'OUT' ? 'badge-out' :
		        ev.type === 'MOVE' ? 'badge-move' :
		        ev.type === 'DISPOSE' ? 'badge-dispose' : 'badge-adjust';
		
		      const route =
		        ev.type === 'MOVE'
		          ? (ev.from || '-') + ' → ' + (ev.to || '-')
		          : (ev.from ? (ev.from + ' → ' + kind) : kind);
		
		      $log.append(
		        '<div class="logline">' +
		          '<div class="logleft">' +
		            '<span class="badge ' + badgeClass + '">' + kind + '</span>' +
		            '<span style="opacity:.85;">' + (ev.when || '-') + '</span>' +
		            '<span style="opacity:.7;">' + (ev.user || '-') + '</span>' +
		          '</div>' +
		          '<div class="logright">' +
		            '<div><b>' + (ev.qty || 0) + ' ' + unit + '</b></div>' +
		            (route ? '<div style="opacity:.8;">' + route + '</div>' : '') +
		            (ev.memo ? '<div style="opacity:.6;">' + ev.memo + '</div>' : '') +
		          '</div>' +
		        '</div>'
		      );
		    });
		  }
		
		  $('#lotModal').addClass('on');
		}
		
		function closeLotModal() {
		  $('#lotModal').removeClass('on');
		}
		
		/* ===== 초기 렌더 ===== */
		document.addEventListener('DOMContentLoaded', function () {
		  $('#btnSearch').on('click', () => renderTable());
		  $('#btnClear').on('click', () => {
		    $('#locSearch').val('');
		    $('#prodSearch').val('');
		    $('#locType').val('');
		    $('#threshold').val(7);
		    $('#statusFilter').val('ALL');
		    renderTable(true);
		  });
		  $('#threshold').on('change', () => renderTable());
		  $('#statusFilter').on('change', () => renderTable());
		  $('#btnSortExpAsc').on('click', () => renderTable({ sortExpAsc: true }));
		  renderTable(true);
		});
	</script>
	
</body>
</html>