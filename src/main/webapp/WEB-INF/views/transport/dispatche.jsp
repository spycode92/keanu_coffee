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
	background: var(- -card);
	border: 1px solid var(- -border);
	border-radius: 12px;
	padding: 12px;
	display: grid;
	grid-template-columns: repeat(3, minmax(200px, 1fr));
	gap: 10px;
}

.filters .field {
	display: flex;
	flex-direction: column;
	gap: 6px
}

.filters .search {
	display: flex;
	flex-direction: column;
	gap: 6px
}

.search {
	width: 500px;
}

.filters label {
	font-size: .85rem;
	color: var(- -muted)
}

.filters input, .filters select {
	height: 38px;
	padding: 0 10px;
	border: 1px solid var(- -border);
	border-radius: 10px;
	background: #fff
}

.filters .actions {
	display: flex;
	align-items: end;
	justify-content: center;
	gap: 8px
}

.badge {
	display: inline-block;
	padding: 2px 8px;
	border-radius: 999px;
	font-size: .8rem;
	font-weight: 700
}

.badge.wait { /* 대기 */
	background: #e5e7eb;
	color: #111827
}

.badge.run { /* 운행중 */
	background: #dbeafe;
	color: #1e40af
}

.badge.left { /* 퇴사 */
	background: #fee2e2;
	color: #991b1b
}

/* 모달 */
.modal {
	position: fixed;
	inset: 0;
	display: none;
	align-items: center;
	justify-content: center;
	padding: 20px;
	background: rgba(0, 0, 0, .45);
	z-index: 1000;
}

.modal.open {
	display: flex;
}

.modal-card {
	width: min(860px, 96vw);
	background: #fff;
	border: 1px solid var(- -border);
	border-radius: 12px;
	overflow: hidden;
}

.modal-head {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 14px 16px;
	border-bottom: 1px solid var(- -border);
}

.modal-body {
	padding: 14px 16px;
}

.modal-foot {
	display: flex;
	justify-content: flex-end;
	gap: 8px;
	padding: 12px 16px;
	border-top: 1px solid var(- -border);
}

.form .row {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 10px;
}

.form .field {
	display: flex;
	flex-direction: column;
	gap: 6px;
	margin-bottom: 10px;
}

.form input, .form select {
	height: 38px;
	padding: 0 10px;
	border: 1px solid var(- -border);
	border-radius: 10px;
}

.help {
	font-size: .83rem;
	color: var(- -muted);
}

@media ( max-width : 1100px) {
	.filters {
		grid-template-columns: repeat(3, minmax(140px, 1fr));
	}
	.form .row {
		grid-template-columns: 1fr;
	}
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
            </div>
        </header>

        <!-- 검색/필터 -->
        <section class="filters" aria-label="검색 및 필터">
            <div class="field">
                <label>상태</label>
                <select id="filterStatus">
                    <option value="">전체</option>
                    <option value="예약">예약</option>
                    <option value="운행중">운행중</option>
                    <option value="완료">완료</option>
                    <option value="취소">취소</option>
                </select>
            </div>
            <div class="search">
                <label>검색</label>
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
                        <th>적재량</th>
                        <th>담당구역</th>
                        <th>예상도착시간</th>
                        <th>상태</th>
                    </tr>
                </thead>
                <tbody><!-- JS 렌더링 --></tbody>
            </table>
        </section>
    </div>

    <!-- 1단계: 배차 등록 모달 -->
    <div class="modal" id="registerStep1" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="regStep1Title">
            <div class="modal-head">
                <strong id="regStep1Title">배차 등록 (1단계)</strong>
                <button class="btn secondary" id="closeStep1">닫기</button>
            </div>
            <div class="modal-body">
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                    <div>
                        <div class="list">
                            <table class="table" id="regionTableStep1">
                                <thead>
                                    <tr>
                                        <th style="width:44px">선택</th>
                                        <th>구역명</th>
                                        <th>적재량</th>
                                        <th>상태</th>
                                    </tr>
                                </thead>
                                <tbody><!-- JS 렌더링 --></tbody>
                            </table>
                        </div>
                        <div class="hint" style="margin-top:8px">상태가 <b>대기</b>인 요청만 선택 가능합니다.</div>
                    </div>
                    <div>
                        <div class="field">
                            <label>운송 시작</label>
                            <div class="radio-group">
                                <label><input type="radio" name="startAt" value="08:00"> 오전 8시</label>
                                <label><input type="radio" name="startAt" value="13:00"> 오후 1시</label>
                            </div>
                        </div>
                        <div class="field">
                            <label>기사 선택 (한도: 보유 차량 용량의 80%)</label>
                            <select id="driverSelectStep1"></select>
                        </div>
                        <div class="field">
                            <label>선택된 총 적재량</label>
                            <input id="sumLoadStep1" disabled />
                        </div>
                        <div class="hint" id="driverHintStep1">기사는 선택된 적재량을 자신의 80% 한도 내에서만 배정할 수 있습니다.</div>
                    </div>
                </div>
            </div>
            <div class="modal-foot">
                <button class="btn" id="goStep2" disabled>다음 (품목 선택)</button>
            </div>
        </div>
    </div>

    <!-- 2단계: 기사 관점 품목 선택 모달 -->
    <div class="modal" id="registerStep2" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="regStep2Title">
            <div class="modal-head">
                <strong id="regStep2Title">배차 등록 (2단계) - 품목 선택</strong>
                <button class="btn secondary" id="closeStep2">닫기</button>
            </div>
            <div class="modal-body">
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                    <div>
                        <div class="list">
                            <table class="table" id="itemTableStep2">
                                <thead>
                                    <tr>
                                        <th style="width:44px"></th>
                                        <th>구역</th>
                                        <th>품목</th>
                                        <th>수량</th>
                                        <th>중량</th>
                                    </tr>
                                </thead>
                                <tbody><!-- JS 렌더링 --></tbody>
                            </table>
                        </div>
                        <div class="hint" id="capHint" style="margin-top:6px">남은 선택 가능 중량: 0.0t</div>
                    </div>
                    <div>
                        <div class="field">
                            <label>선택된 기사</label>
                            <input id="pickedDriverName" disabled />
                        </div>
                        <div class="field">
                            <label>기사 차량 용량 / 한도(80%)</label>
                            <input id="pickedDriverCaps" disabled />
                        </div>
                        <div class="field">
                            <label>1단계에서 선택한 총 적재량</label>
                            <input id="pickedSumLoad" disabled />
                        </div>
                        <div class="field">
                            <label>현재 선택 품목 총량</label>
                            <input id="pickedItemLoad" disabled />
                        </div>
                        <div class="hint">품목 선택 총량이 기사 한도(80%)를 초과할 수 없습니다.</div>
                    </div>
                </div>
            </div>
            <div class="modal-foot">
                <button class="btn" id="startDispatch" disabled>운행 시작</button>
            </div>
        </div>
    </div>

    <script>
        /* ---------------- 더미 데이터 ---------------- */
        // 기사: 각 기사에 "보유 차량 용량(capNum)"을 매핑 (예: 1.5t → capNum: 1.5)
        var drivers = [
            { id:1, name:'이정민', capNum:1.5 },   // 80% = 1.2t
            { id:2, name:'김배송', capNum:5.0 },   // 80% = 4.0t
            { id:3, name:'최배송', capNum:1.0 }    // 80% = 0.8t
        ];
        // 구역별 요청(대기만 선택 가능)
        var regions = [
            { id:101, name:'동래구', load:'1.2t', loadNum:1.2, status:'대기' },
            { id:102, name:'남구',   load:'0.8t', loadNum:0.8, status:'대기' },
            { id:103, name:'수영구', load:'1.0t', loadNum:1.0, status:'할당됨' }
        ];
        // 품목(주문서 유사) - 구역과 연결
        var items = [
            { id:201, region:'동래구', name:'원두1', qty:10, wNum:0.6, w:'0.6t' },
            { id:202, region:'동래구', name:'설탕',  qty:5,  wNum:0.2, w:'0.2t' },
            { id:203, region:'남구',   name:'종이컵', qty:8, wNum:0.3, w:'0.3t' },
            { id:204, region:'수영구', name:'머그컵', qty:6, wNum:0.5, w:'0.5t' }
        ];
        // 배차 목록(초기 값)
        var dispatches = [
            { date:'2025-08-12', driver:'김배송', vehicle:'89바 1234', load:'1.2t', dest:'동래구', eta:'18:30', status:'운행중' }
        ];

        /* ---------------- 목록 렌더링/검색 ---------------- */
        var dispBody = document.querySelector('#dispatchTable tbody');

        function statusBadge(s) {
            if (s === '예약') return '<span class="badge book">예약</span>';
            if (s === '운행중') return '<span class="badge run">운행중</span>';
            if (s === '완료') return '<span class="badge done">완료</span>';
            return '<span class="badge cancel">취소</span>';
        }

        function renderDispatchTable(rows) {
            var list = rows || dispatches.slice();
            dispBody.innerHTML = '';
            list.forEach(function(d){
                var tr = document.createElement('tr');
                tr.innerHTML =
                    '<td>' + d.date + '</td>' +
                    '<td>' + d.driver + '</td>' +
                    '<td>' + (d.vehicle || '-') + '</td>' +
                    '<td>' + d.load + '</td>' +
                    '<td>' + d.dest + '</td>' +
                    '<td>' + d.eta + '</td>' +
                    '<td>' + statusBadge(d.status) + '</td>';
                dispBody.appendChild(tr);
            });
        }
        renderDispatchTable();

        document.getElementById('btnSearch').addEventListener('click', function(){
            var st = document.getElementById('filterStatus').value.trim();
            var q  = document.getElementById('filterText').value.trim();
            var rows = dispatches.filter(function(x){
                if (st && x.status !== st) return false;
                if (q) {
                    var hay = (x.driver + ' ' + (x.vehicle||'') + ' ' + x.dest);
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

        /* ---------------- 모달 유틸 ---------------- */
        function openModal(el) { el.classList.add('open'); }
        function closeModal(el) { el.classList.remove('open'); }

        /* ---------------- 1단계 상태/요소 ---------------- */
        var btnOpenRegister = document.getElementById('openRegister');
        var step1Modal = document.getElementById('registerStep1');
        var step2Modal = document.getElementById('registerStep2');

        var selRegionIds = [];     // 체크된 구역 id 배열
        var selSumLoad = 0;        // 선택된 구역 총 적재량
        var pickedDriverId = '';   // 선택된 기사 id
        var pickedStartAt = '';    // '08:00' | '13:00'

        var regionBody1 = document.querySelector('#regionTableStep1 tbody');
        var driverSelect1 = document.getElementById('driverSelectStep1');
        var sumLoadInput = document.getElementById('sumLoadStep1');
        var goStep2Btn = document.getElementById('goStep2');

        function renderRegionsStep1() {
            regionBody1.innerHTML = '';
            regions.forEach(function(r){
                var disabled = (r.status !== '대기');
                var tr = document.createElement('tr');
                tr.innerHTML =
                    '<td><input type="checkbox" class="regCheck1" data-id="' + r.id + '" ' + (disabled ? 'disabled' : '') + '></td>' +
                    '<td>' + r.name + '</td>' +
                    '<td>' + r.load + '</td>' +
                    '<td>' + r.status + '</td>';
                regionBody1.appendChild(tr);
            });
            Array.prototype.forEach.call(document.querySelectorAll('.regCheck1'), function(c){
                c.addEventListener('change', function(e){
                    var id = parseInt(e.target.getAttribute('data-id'), 10);
                    if (e.target.checked) {
                        if (selRegionIds.indexOf(id) === -1) selRegionIds.push(id);
                    } else {
                        selRegionIds = selRegionIds.filter(function(x){ return x !== id; });
                    }
                    recalcSumLoad();
                    validateStep1();
                });
            });
        }

        function recalcSumLoad() {
            var sum = 0;
            selRegionIds.forEach(function(id){
                var r = regions.find(function(x){ return x.id === id; });
                if (r) sum += r.loadNum;
            });
            selSumLoad = sum;
            sumLoadInput.value = selSumLoad.toFixed(1) + 't';
        }

        function fillDriverSelect() {
            driverSelect1.innerHTML = '<option value="">기사 선택</option>';
            drivers.forEach(function(d){
                var limit = d.capNum * 0.8;
                var label = d.name + ' (한도 ' + limit.toFixed(1) + 't)';
                var opt = document.createElement('option');
                opt.value = d.id;
                opt.textContent = label;
                driverSelect1.appendChild(opt);
            });
        }

        function validateStep1() {
            // 운송시간
            var radios = document.getElementsByName('startAt');
            pickedStartAt = '';
            for (var i=0;i<radios.length;i++){ if (radios[i].checked) { pickedStartAt = radios[i].value; break; } }
            // 기사
            pickedDriverId = driverSelect1.value;

            // 기사 한도 체크
            var ok = false;
            if (pickedDriverId && pickedStartAt && selSumLoad > 0) {
                var drv = drivers.find(function(x){ return (x.id + '') === (pickedDriverId + ''); });
                if (drv) {
                    var limit = drv.capNum * 0.8;
                    ok = (selSumLoad <= limit);
                    var hint = document.getElementById('driverHintStep1');
                    if (!ok) {
                        hint.textContent = '선택된 적재량이 기사 한도(' + limit.toFixed(1) + 't)를 초과했습니다. 구역을 줄이거나 다른 기사를 선택하세요.';
                    } else {
                        hint.textContent = '기사는 선택된 적재량을 자신의 80% 한도 내에서만 배정할 수 있습니다.';
                    }
                }
            }
            goStep2Btn.disabled = !ok;
        }

        Array.prototype.forEach.call(document.getElementsByName('startAt'), function(r){
            r.addEventListener('change', validateStep1);
        });
        driverSelect1.addEventListener('change', validateStep1);

        /* ---------------- 2단계 상태/요소 ---------------- */
        var selItemIds = [];            // 체크된 품목 id 배열
        var pickedDriverObj = null;     // 선택 기사
        var driverLimit = 0;            // 기사 한도 = capNum * 0.8
        var currentItemSum = 0;         // 현재 선택 품목 총중량

        var itemBody2 = document.querySelector('#itemTableStep2 tbody');
        var capHint = document.getElementById('capHint');
        var pickedDriverName = document.getElementById('pickedDriverName');
        var pickedDriverCaps = document.getElementById('pickedDriverCaps');
        var pickedSumLoad = document.getElementById('pickedSumLoad');
        var pickedItemLoad = document.getElementById('pickedItemLoad');
        var startBtn = document.getElementById('startDispatch');

        function renderItemsForPickedDriver() {
            // 1단계에서 선택한 구역만 표시
            var regionNames = selRegionIds.map(function(id){
                var r = regions.find(function(x){ return x.id === id; });
                return r ? r.name : '';
            });

            itemBody2.innerHTML = '';
            items.forEach(function(it){
                if (regionNames.indexOf(it.region) === -1) return;
                var tr = document.createElement('tr');
                tr.innerHTML =
                    '<td><input type="checkbox" class="itemCheck2" data-id="' + it.id + '"></td>' +
                    '<td>' + it.region + '</td>' +
                    '<td>' + it.name + '</td>' +
                    '<td>' + it.qty + '</td>' +
                    '<td>' + it.w + '</td>';
                itemBody2.appendChild(tr);
            });

            selItemIds = [];
            currentItemSum = 0;
            updateCapUI();

            Array.prototype.forEach.call(document.querySelectorAll('.itemCheck2'), function(c){
                c.addEventListener('change', function(e){
                    var id = parseInt(e.target.getAttribute('data-id'), 10);
                    var it = items.find(function(x){ return x.id === id; });
                    if (!it) return;

                    if (e.target.checked) {
                        var nextSum = currentItemSum + it.wNum;
                        if (nextSum > driverLimit) {
                            alert('기사 한도(' + driverLimit.toFixed(1) + 't)를 초과할 수 없습니다.');
                            e.target.checked = false;
                            return;
                        }
                        selItemIds.push(id);
                        currentItemSum = nextSum;
                    } else {
                        selItemIds = selItemIds.filter(function(x){ return x !== id; });
                        currentItemSum = Math.max(0, currentItemSum - it.wNum);
                    }
                    updateCapUI();
                });
            });
        }

        function updateCapUI() {
            var remain = Math.max(0, driverLimit - currentItemSum);
            capHint.textContent = '남은 선택 가능 중량: ' + remain.toFixed(1) + 't';
            pickedItemLoad.value = currentItemSum.toFixed(1) + 't';
            startBtn.disabled = (selItemIds.length === 0);
        }

        /* ---------------- 흐름 제어 ---------------- */
        // 등록 버튼 → 1단계 열기
        btnOpenRegister.addEventListener('click', function(){
            selRegionIds = [];
            selSumLoad = 0;
            pickedDriverId = '';
            pickedStartAt = '';
            document.getElementById('sumLoadStep1').value = '0.0t';
            Array.prototype.forEach.call(document.getElementsByName('startAt'), function(r){ r.checked = false; });

            renderRegionsStep1();
            fillDriverSelect();
            validateStep1();
            openModal(step1Modal);
        });

        // 1단계 닫기
        document.getElementById('closeStep1').addEventListener('click', function(){ closeModal(step1Modal); });

        // 1단계 → 2단계
        document.getElementById('goStep2').addEventListener('click', function(){
            pickedDriverObj = drivers.find(function(x){ return (x.id + '') === (pickedDriverId + ''); });
            driverLimit = pickedDriverObj ? (pickedDriverObj.capNum * 0.8) : 0;

            pickedDriverName.value = pickedDriverObj ? pickedDriverObj.name : '';
            pickedDriverCaps.value = (pickedDriverObj ? pickedDriverObj.capNum.toFixed(1) : '0.0') + 't / ' + driverLimit.toFixed(1) + 't';
            pickedSumLoad.value = selSumLoad.toFixed(1) + 't';
            pickedItemLoad.value = '0.0t';

            renderItemsForPickedDriver();

            closeModal(step1Modal);
            openModal(step2Modal);
        });

        // 2단계 닫기
        document.getElementById('closeStep2').addEventListener('click', function(){ closeModal(step2Modal); });

        // 운행 시작 → 목록에 추가(데모)
        document.getElementById('startDispatch').addEventListener('click', function(){
            if (!selItemIds.length) { alert('품목을 선택하세요.'); return; }

            // 선택된 구역명을 목적지(담당구역)로 표시
            var destNames = selRegionIds.map(function(id){
                var r = regions.find(function(x){ return x.id === id; });
                return r ? r.name : '';
            }).filter(function(x){ return !!x; });
            var dest = destNames.join(', ');

            // 오늘 날짜
            var td = new Date();
            var y = td.getFullYear();
            var m = (td.getMonth()+1 + '').padStart(2,'0');
            var d = (td.getDate() + '').padStart(2,'0');

            // ETA: 간단 규칙(예시)
            var eta = (pickedStartAt === '08:00') ? '12:00' : '18:00';

            // 목록에 추가
            dispatches.push({
                date: y + '-' + m + '-' + d,
                driver: pickedDriverObj ? pickedDriverObj.name : '',
                vehicle: '',                       // 실제 시스템에서는 기사-차량 매핑으로 채우세요
                load: currentItemSum.toFixed(1) + 't',
                dest: dest || '-',
                eta: eta,
                status: '예약'
            });

            alert('운행을 시작합니다.\n선택 기사: ' + (pickedDriverObj ? pickedDriverObj.name : '') +
                  '\n선택 품목 총량: ' + currentItemSum.toFixed(1) + 't' +
                  '\n운송 시작: ' + pickedStartAt);
            closeModal(step2Modal);
            renderDispatchTable(); // 목록 갱신
        });
    </script>

</body>
</html>