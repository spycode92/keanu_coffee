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

/* [추가] 작은 배지(DDAY 숫자 강조) */
.dday-badge {
    display:inline-block; margin-left:6px; padding:1px 6px; border-radius:999px;
    border:1px solid rgba(0,0,0,.1); font-size:.8em; font-weight:700; opacity:.9;
}
.dday-warn   { background:rgba(255,193,7,.18);  border-color:rgba(255,193,7,.65); }
.dday-danger { background:rgba(220,53,69,.20);  border-color:rgba(220,53,69,.70); }
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
                    <!-- [변경] 로케이션 유형: Picking / Pallet(영문) -->
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
			
			<!-- [추가] 제조/유통기한 전용 툴바 -->
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
                <span style="font-size:12px; opacity:.75;">※ 임박(D ≤ 기준), 만료(D &lt; 0). 출고 시 FIFO 참고.</span>
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
			</div>
		</div>
	</div>

	<script>
	    // ===== 예시 데이터 (뷰 확인용) =====
	    // [추가] 제조일자(manDate) 포함
	    const realtimeData = [
	        { loc: 'A-01', name: '바닐라 시럽', code: 'SYR-001', qty: 42, unit: 'BOX', locType: 'Picking', manDate: '2025-02-20', expDate: '2025-08-20' },
	        { loc: 'A-02', name: '카라멜 시럽', code: 'SYR-002', qty: 6, unit: 'BOX', locType: 'Picking', manDate: '2025-01-15', expDate: '2025-08-05' },
	        { loc: 'B-01', name: '원두(하우스블렌드)', code: 'BEAN-001', qty: 0, unit: 'EA', locType: 'Pallet', manDate: '2024-12-01', expDate: '2025-08-01' },
	        { loc: 'C-03', name: '아이스컵 16oz', code: 'CUP-016', qty: 180, unit: 'PK', locType: 'Picking', manDate: '2026-01-10', expDate: '2026-06-01' }
	    ];
	
	    // [추가] 유틸: 날짜차이(일)
	    function diffDaysFromToday(dateStr) {
	        const today = new Date();
	        const d = new Date(dateStr + 'T00:00:00');
	        const diff = d.getTime() - new Date(today.getFullYear(), today.getMonth(), today.getDate()).getTime();
	        return Math.ceil(diff / (1000 * 60 * 60 * 24));
	    }
	
	    // [추가] 상태/라벨 텍스트 구성
	    function makeStatusAndDday(expDate, threshold) {
	        const d = diffDaysFromToday(expDate);
	        let status = 'OK';
	        let labelHtml = '<span class="status-label normal">정상</span>';
	        let ddayHtml = '<span class="dday-badge">D-' + d + '</span>';
	
	        if (d < 0) {
	            status = 'EXPIRED';
	            labelHtml = '<span class="status-label expired">만료</span>';
	            ddayHtml = '<span class="dday-badge dday-danger">D-' + Math.abs(d) + '</span>';
	        } else if (d <= threshold) {
	            status = 'WARN';
	            labelHtml = '<span class="status-label imminent">임박</span>';
	            ddayHtml = '<span class="dday-badge dday-warn">D-' + d + '</span>';
	        }
	        return { status, labelHtml, ddayHtml, d };
	    }
	
	    // 테이블 렌더링
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
	
	            const rowHtml =
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
	
	            const tr = document.createElement('tr');
	            tr.innerHTML = rowHtml;
	            tbody.appendChild(tr);
	        });
	
	        document.getElementById('kpiSku').textContent = skuSet.size;
	        document.getElementById('kpiQty').textContent = totalQty.toLocaleString('ko-KR');
	    }
	
	    document.addEventListener('DOMContentLoaded', function () {
	        document.getElementById('btnSearch').addEventListener('click', () => renderTable());
	        document.getElementById('btnClear').addEventListener('click', () => {
	            document.getElementById('locSearch').value = '';
	            document.getElementById('prodSearch').value = '';
	            document.getElementById('locType').value = '';
	            document.getElementById('threshold').value = 7;
	            document.getElementById('statusFilter').value = 'ALL';
	            renderTable(true);
	        });
	
	        document.getElementById('threshold').addEventListener('change', () => renderTable());
	        document.getElementById('statusFilter').addEventListener('change', () => renderTable());
	        document.getElementById('btnSortExpAsc').addEventListener('click', () => renderTable({ sortExpAsc: true }));
	
	        renderTable(true);
	    });
	</script>
	
</body>
</html>