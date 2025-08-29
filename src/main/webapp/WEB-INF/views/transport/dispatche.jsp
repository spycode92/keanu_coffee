<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운송관리대시보드</title>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link
	href="${pageContext.request.contextPath}/resources/css/common/common.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style type="text/css">
.container {
    max-width: 1264px;
    margin: 0 auto;
    padding: 0 16px;
}

header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 12px;
}

/* 검색/필터 바 */
.filters {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 12px;
    display: grid;
    grid-template-columns: repeat(3, minmax(200px, 1fr));
    gap: 10px;
}
.filters .field { display: flex; flex-direction: column; gap: 6px; justify-content: center;
}
.filters .search { display: flex; flex-direction: column; gap: 6px; justify-content: center;
}
.search { width: 500px; }
.filters input, .filters select {
    height: 38px; padding: 0 10px; border: 1px solid var(--border); border-radius: 10px; background: #fff;
}
.filters .actions {
    display: flex; align-items: end; justify-content: center; gap: 8px;
}

.badge { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: .8rem; font-weight: 700; }
.badge.run { background: #dcfce7; color: #166534; }      /* 운행중 */
.badge.book { background: #e0e7ff; color: #3730a3; }     /* 예약 */
.badge.done { background: #e5ffe9; color: #047857; }     /* 완료 */
.badge.cancel { background: #fee2e2; color: #991b1b; }   /* 취소 */

/* 모달 */
.modal {
    position: fixed; inset: 0; display: none; align-items: center; justify-content: center;
    padding: 20px; background: rgba(0, 0, 0, .45); z-index: 1000;
}
.modal.open { display: flex; }
.modal-card {
    width: min(860px, 96vw); background: #fff; border: 1px solid var(--border);
    border-radius: 12px; overflow: hidden;
}
.modal-head {
    display: flex; justify-content: space-between; align-items: center;
    padding: 14px 16px; border-bottom: 1px solid var(--border);
}
.modal-body { padding: 14px 16px; }
.modal-foot {
    display: flex; justify-content: flex-end; gap: 8px; padding: 12px 16px; border-top: 1px solid var(--border);
}

.field { display: flex; flex-direction: column; gap: 6px; margin-bottom: 10px; }
.field input, .field select { height: 38px; padding: 0 10px; border: 1px solid var(--border); border-radius: 10px; }
.help, .hint { font-size: .83rem; color: var(--muted-foreground); }

@media (max-width: 1100px) {
    .filters { grid-template-columns: repeat(3, minmax(140px, 1fr)); }
}
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

    <div class="container">
        <header>
            <h1>배차 관리</h1>
            <div style="display:flex; gap:8px">
                <button class="btn secondary" id="openRegister">+ 배차 등록</button>
                <button onclick="location.href='/transport/mypage'">기사마이페이지</button>
                <button onclick="location.href='/transport/region'">구역관리</button>
            </div>
        </header>

        <!-- 검색/필터 -->
        <section class="filters" aria-label="검색 및 필터">
            <div class="field">
                <select id="filterStatus">
                    <option value="">전체</option>
                    <option value="예약">예약</option>
                    <option value="운행중">운행중</option>
                    <option value="완료">완료</option>
                    <option value="취소">취소</option>
                </select>
            </div>
            <div class="search">
                <input id="filterText" type="text" placeholder="기사명 / 차량번호 / 목적지 검색" />
            </div>
            <div class="actions">
                <button class="btn secondary" id="btnReset">초기화</button>
                <button class="btn" id="btnSearch">검색</button>
            </div>
        </section>

        <!-- 배차 목록 -->
        <section style="margin-top:14px">
            <h3>배차목록</h3>
            <table class="table" id="dispatchTable">
                <thead>
                    <tr>
                        <th>배차일</th>
                        <th>기사명</th>
                        <th>차량번호</th>
                        <th>요청중량</th>
                        <th>담당구역</th>
                        <th>예상도착시간</th>
                        <th>상태</th>
                    </tr>
                </thead>
                <tbody><!-- JS 렌더링 --></tbody>
            </table>
        </section>
    </div>

    <!-- 등록(대기/추가 필요만) 모달 -->
    <div class="modal" id="assignModal" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="assignTitle">
            <div class="modal-head">
                <strong id="assignTitle">배차 등록/수정</strong>
                <button class="btn secondary" id="closeAssign">닫기</button>
            </div>
            <div class="modal-body">
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                    <!-- 좌: 대기/추가 필요 리스트 -->
                    <div>
                        <table class="table" id="assignList">
                            <thead>
                                <tr>
                                    <th style="width:44px">선택</th>
                                    <th>배차일</th>
                                    <th>구역</th>
                                    <th>요청중량</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody><!-- JS 렌더링 --></tbody>
                        </table>
                        <div class="hint" style="margin-top:6px">상태가 <b>대기</b> 또는 <b>추가 필요</b>인 건만 표시됩니다.</div>
                    </div>
                    <!-- 우: 선택건 조치 -->
                    <div>
                        <div class="field">
                            <label>선택된 배차</label>
                            <input id="selAssignSummary" disabled />
                        </div>
                        <div class="field">
                            <label>기본 기사(1.0t 차량) 변경</label>
                            <select id="primaryDriverSelect"></select>
                            <div class="help">기본적으로 1.0t 기사 1명이 배정되어 있습니다(한도 0.8t). 필요 시 변경하세요.</div>
                        </div>

                        <div class="field" id="extraDriverBlock" style="display:none">
                            <label>추가 기사 배정 (추가 필요 상태에서만)</label>
                            <div style="display:flex; gap:8px">
                                <select id="extraDriverSelect"></select>
                                <button class="btn" id="btnAddDriver">기사 추가 등록</button>
                            </div>
                            <div class="help">총 가용 한도(각 기사 80%)가 요청중량 이상이면 상태가 자동으로 <b>대기</b>로 전환됩니다.</div>
                        </div>

                        <div class="field">
                            <label>요청중량 / 현재 가용 한도</label>
                            <input id="capacityInfo" disabled />
                        </div>

                        <div style="display:flex; gap:8px; margin-top:8px">
                            <button class="btn danger" id="btnCancelAssign" style="display:none">배차 취소</button>
                            <button class="btn" id="btnSaveAssign">저장</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-foot">
                <button class="btn secondary" id="closeAssign2">닫기</button>
            </div>
        </div>
    </div>

    <!-- 상세 모달(배차 클릭 시) -->
    <div class="modal" id="detailModal" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="detailTitle">
            <div class="modal-head">
                <strong id="detailTitle">배차 상세</strong>
                <button class="btn secondary" id="closeDetail">닫기</button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <label>기사(들)</label>
                    <input id="detailDrivers" disabled />
                </div>
                <div class="field">
                    <label>담당 구역</label>
                    <input id="detailRegion" disabled />
                </div>
                <div class="field">
                    <label>배송 상태</label>
                    <input id="detailStatus" disabled />
                </div>

                <div class="card" style="margin-top:10px">
                    <div class="card-header">주문서(품목)</div>
                    <table class="table" id="detailItems">
                        <thead>
                            <tr>
                                <th>지점</th>
                                <th>품목</th>
                                <th>수량</th>
                                <th>중량</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody><!-- JS 렌더링 --></tbody>
                    </table>
                </div>
            </div>
            <div class="modal-foot">
                <button class="btn secondary" id="closeDetail2">닫기</button>
            </div>
        </div>
    </div>

    <script>
        /* =========================
           더미 데이터
           ========================= */
        // 기사 풀(용량 capNum, 80%가 실적용 한도)
        var driverPool = [
            { id:101, name:'기본기사A(1.0t)', capNum:1.0 },
            { id:102, name:'김배송(1.5t)', capNum:1.5 },
            { id:103, name:'이배송(2.5t)', capNum:2.5 },
            { id:104, name:'최배송(1.0t)', capNum:1.0 }
        ];

        // 배차 목록(상태 다양)
        var dispatches = [
            {
                id: 9001, date:'2025-08-12', dest:'동래구', eta:'18:30',
                requestLoad: 1.0, status:'대기',
                assignedDriverIds:[101],                 // 기본 1.0t 기사 1명
                orderItems:[
                    { region:'동래구', name:'원두1', qty:10, w:'0.4t', wNum:0.4, status:'대기' },
                    { region:'동래구', name:'설탕',  qty:5,  w:'0.2t', wNum:0.2, status:'대기' }
                ]
            },
            {
                id: 9002, date:'2025-08-12', dest:'남구', eta:'19:00',
                requestLoad: 1.6, status:'추가 필요',
                assignedDriverIds:[101],                 // 기본 1.0t만 배정되어 부족 → 추가 필요
                orderItems:[
                    { region:'남구', name:'종이컵', qty:12, w:'0.6t', wNum:0.6, status:'대기' },
                    { region:'남구', name:'시럽',   qty:8,  w:'0.4t', wNum:0.4, status:'대기' },
                    { region:'남구', name:'빨대',   qty:10, w:'0.6t', wNum:0.6, status:'대기' }
                ]
            },
            {
                id: 9003, date:'2025-08-12', dest:'수영구', eta:'17:40',
                requestLoad: 1.2, status:'운행중',
                assignedDriverIds:[102],
                orderItems:[
                    { region:'수영구', name:'머그컵', qty:6, w:'0.5t', wNum:0.5, status:'진행' }
                ]
            },
            {
                id: 9004, date:'2025-08-12', dest:'해운대구', eta:'20:10',
                requestLoad: 0.8, status:'예약',
                assignedDriverIds:[104],
                orderItems:[
                    { region:'해운대구', name:'스틱커피', qty:20, w:'0.3t', wNum:0.3, status:'대기' },
                    { region:'해운대구', name:'믹스',     qty:10, w:'0.2t', wNum:0.2, status:'대기' }
                ]
            }
        ];

        /* =========================
           공용 유틸/렌더
           ========================= */
        var dispBody = document.querySelector('#dispatchTable tbody');

        function statusBadge(s) {
            if (s === '예약') return '<span class="badge book">예약</span>';
            if (s === '운행중') return '<span class="badge run">운행중</span>';
            if (s === '완료') return '<span class="badge done">완료</span>';
            return '<span class="badge cancel">취소</span>';
        }
        function driverById(id){ return driverPool.find(function(x){ return x.id === id; }); }
        function driverNames(ids){
            ids = ids || [];
            return ids.map(function(id){
                var d = driverById(id);
                return d ? d.name : '(알 수 없음)';
            });
        }
        // 차량번호 매핑이 아직 없으므로 빈 값(시스템 연동 시 교체)
        function firstPlate(ids){ return ''; }
        function formatTon(n){ return (typeof n === 'number' ? n.toFixed(1) : n) + 't'; }

        function renderDispatchTable(rows) {
            var list = rows || dispatches.slice();
            dispBody.innerHTML = '';
            list.forEach(function(d){
                var tr = document.createElement('tr');
                tr.innerHTML =
                    '<td>' + d.date + '</td>' +
                    '<td>' + driverNames(d.assignedDriverIds).join(', ') + '</td>' +
                    '<td>' + (firstPlate(d.assignedDriverIds) || '-') + '</td>' +
                    '<td>' + formatTon(d.requestLoad) + '</td>' +
                    '<td>' + d.dest + '</td>' +
                    '<td>' + (d.eta || '-') + '</td>' +
                    '<td>' + statusBadge(d.status) + '</td>';
                tr.addEventListener('click', function(){ openDetail(d.id); });
                dispBody.appendChild(tr);
            });
        }
        renderDispatchTable();

        // 검색/초기화
        document.getElementById('btnSearch').addEventListener('click', function(){
            var st = document.getElementById('filterStatus').value.trim();
            var q  = document.getElementById('filterText').value.trim();
            var rows = dispatches.filter(function(x){
                if (st && x.status !== st) return false;
                if (q) {
                    var hay = (driverNames(x.assignedDriverIds).join(' ') + ' ' + x.dest);
                    if (hay.indexOf(q) === -1) return false;
                }
                return true;
            });
            renderDispatchTable(rows);
        });
        document.getElementById('btnReset').addEventListener('click', function(){
            document.getElementById('filterStatus').value = '';
            document.getElementById('filterText').value = '';
            renderDispatchTable();
        });

        /* =========================
           상세 모달
           ========================= */
        var detailModal = document.getElementById('detailModal');
        document.getElementById('closeDetail').onclick = function(){ detailModal.classList.remove('open'); };
        document.getElementById('closeDetail2').onclick = function(){ detailModal.classList.remove('open'); };

        function openDetail(id){
            var d = dispatches.find(function(x){ return x.id === id; });
            if (!d) return;

            document.getElementById('detailDrivers').value = driverNames(d.assignedDriverIds).join(', ');
            document.getElementById('detailRegion').value  = d.dest || '-';
            document.getElementById('detailStatus').value  = d.status;

            var tb = document.querySelector('#detailItems tbody');
            tb.innerHTML = '';
            (d.orderItems || []).forEach(function(it){
                var tr = document.createElement('tr');
                tr.innerHTML =
                    '<td>' + it.region + '</td>' +
                    '<td>' + it.name + '</td>' +
                    '<td>' + it.qty  + '</td>' +
                    '<td>' + it.w    + '</td>' +
                    '<td>' + (it.status || '대기') + '</td>';
                tb.appendChild(tr);
            });

            detailModal.classList.add('open');
        }

        /* =========================
           등록/수정 모달 (대기/추가 필요만)
           ========================= */
        var assignModal = document.getElementById('assignModal');
        var selAssignId = null;

        document.getElementById('openRegister').addEventListener('click', function(){
            selAssignId = null;
            renderAssignList();
            fillPrimaryDriverSelect();
            fillExtraDriverSelect();
            resetAssignRight();
            assignModal.classList.add('open');
        });
        document.getElementById('closeAssign').onclick  = function(){ assignModal.classList.remove('open'); };
        document.getElementById('closeAssign2').onclick = function(){ assignModal.classList.remove('open'); };

        function renderAssignList(){
            var body = document.querySelector('#assignList tbody');
            body.innerHTML = '';
            var candidates = dispatches.filter(function(d){
                return d.status === '대기' || d.status === '추가 필요';
            });
            candidates.forEach(function(d){
                var tr = document.createElement('tr');
                tr.innerHTML =
                    '<td><input type="radio" name="pickAssign" value="' + d.id + '"></td>' +
                    '<td>' + d.date + '</td>' +
                    '<td>' + d.dest + '</td>' +
                    '<td>' + formatTon(d.requestLoad) + '</td>' +
                    '<td>' + d.status + '</td>';
                tr.querySelector('input').addEventListener('change', function(){
                    selAssignId = d.id;
                    bindAssignRight(d);
                });
                body.appendChild(tr);
            });
        }

        function fillPrimaryDriverSelect(){
            var sel = document.getElementById('primaryDriverSelect');
            sel.innerHTML = '';
            driverPool.forEach(function(d){
                var opt = document.createElement('option');
                opt.value = d.id;
                opt.textContent = d.name + ' (한도 ' + (d.capNum*0.8).toFixed(1) + 't)';
                sel.appendChild(opt);
            });
        }
        function fillExtraDriverSelect(){
            var sel = document.getElementById('extraDriverSelect');
            sel.innerHTML = '<option value="">추가 기사 선택</option>';
            driverPool.forEach(function(d){
                var opt = document.createElement('option');
                opt.value = d.id;
                opt.textContent = d.name + ' (한도 ' + (d.capNum*0.8).toFixed(1) + 't)';
                sel.appendChild(opt);
            });
        }
        function resetAssignRight(){
            document.getElementById('selAssignSummary').value = '';
            document.getElementById('capacityInfo').value     = '';
            document.getElementById('btnCancelAssign').style.display = 'none';
            document.getElementById('extraDriverBlock').style.display = 'none';
            document.getElementById('primaryDriverSelect').value = '';
        }
        function calcCapacity(ids){
            ids = ids || [];
            var sum = 0;
            ids.forEach(function(id){
                var d = driverById(id);
                if (d) sum += (d.capNum * 0.8);
            });
            return sum; // t
        }
        function bindAssignRight(d){
            document.getElementById('selAssignSummary').value = d.date + ' · ' + d.dest + ' · 요청 ' + formatTon(d.requestLoad);
            var cap = calcCapacity(d.assignedDriverIds);
            document.getElementById('capacityInfo').value = formatTon(d.requestLoad) + ' / 가용 ' + cap.toFixed(1) + 't';

            var firstId = d.assignedDriverIds.length ? d.assignedDriverIds[0] : '';
            document.getElementById('primaryDriverSelect').value = firstId;

            document.getElementById('btnCancelAssign').style.display = (d.status === '대기') ? 'inline-flex' : 'none';
            document.getElementById('extraDriverBlock').style.display = (d.status === '추가 필요') ? 'block' : 'none';
        }

        // 저장: 기본기사 변경
        document.getElementById('btnSaveAssign').addEventListener('click', function(){
            if (!selAssignId) { alert('좌측에서 배차를 선택하세요.'); return; }
            var d = dispatches.find(function(x){ return x.id === selAssignId; });
            if (!d) return;

            var pri = parseInt(document.getElementById('primaryDriverSelect').value, 10);
            if (!isNaN(pri)) {
                if (d.assignedDriverIds.length === 0) d.assignedDriverIds.push(pri);
                else d.assignedDriverIds[0] = pri;
            }

            var cap = calcCapacity(d.assignedDriverIds);
            d.status = (cap >= d.requestLoad) ? '대기' : '추가 필요';

            renderDispatchTable();
            bindAssignRight(d);
            alert('저장되었습니다.');
        });

        // 배차 취소 (대기 상태만)
        document.getElementById('btnCancelAssign').addEventListener('click', function(){
            if (!selAssignId) return;
            var d = dispatches.find(function(x){ return x.id === selAssignId; });
            if (!d) return;
            if (d.status !== '대기') { alert('대기 상태만 취소할 수 있습니다.'); return; }
            if (!confirm('이 배차를 취소하시겠습니까?')) return;

            d.status = '취소';
            renderDispatchTable();
            renderAssignList();
            resetAssignRight();
        });

        // 추가 기사 등록 (추가 필요 상태)
        document.getElementById('btnAddDriver').addEventListener('click', function(){
            if (!selAssignId) return;
            var d = dispatches.find(function(x){ return x.id === selAssignId; });
            if (!d) return;
            if (d.status !== '추가 필요') { alert('추가 필요 상태에서만 가능합니다.'); return; }

            var ex = parseInt(document.getElementById('extraDriverSelect').value, 10);
            if (isNaN(ex)) { alert('추가 기사를 선택하세요.'); return; }
            if (d.assignedDriverIds.indexOf(ex) !== -1) { alert('이미 배정된 기사입니다.'); return; }

            d.assignedDriverIds.push(ex);

            var cap = calcCapacity(d.assignedDriverIds);
            if (cap >= d.requestLoad) {
                d.status = '대기'; // 용량 충족 → 대기 전환
                alert('용량 충족: 상태가 대기로 변경되었습니다.');
            } else {
                alert('추가 배정 완료(아직 용량 부족).');
            }
            renderDispatchTable();
            bindAssignRight(d);
        });
    </script>

</body>
</html>