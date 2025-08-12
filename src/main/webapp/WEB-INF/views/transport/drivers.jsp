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

/* 모달 기본: 숨김 */
.modal {
    position: fixed;
    inset: 0;
    display: none;              /* ← 이게 핵심 */
    align-items: center;
    justify-content: center;
    background: rgba(0,0,0,.45);
    z-index: 1000;
}

/* 모달 열림 상태 */
.modal.open {
    display: flex;
}

/* 모달 카드 기본 스타일 (필요 시) */
.modal-card, .sub-card {
    background: #fff;
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    width: min(900px, 96vw);    /* sub-card는 760px 등으로 조절 가능 */
    overflow: hidden;
}

.modal-head, .modal-foot {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    padding: 12px 16px;
    border-bottom: 1px solid #e5e7eb;
}
.modal-foot { border-bottom: 0; border-top: 1px solid #e5e7eb; }
.modal-body { padding: 14px 16px; }
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	<section class="container">
		<h1>기사관리</h1>
		<div>
			<section class="filters" aria-label="검색 및 필터">
				<div class="field">
					<select id="filterStatus">
						<option value="">전체</option>
						<option value="대기">대기</option>
						<option value="운행중">운행중</option>
					</select>
				</div>
				<div class="search">
					<input id="filterName" type="text" placeholder="이름/차량번호/적재량 검색 가능" />
				</div>
				<div class="actions">
					<button class="btn secondary" id="resetBtn">초기화</button>
					<button class="btn" id="searchBtn">검색</button>
				</div>
			</section>
			<div>
				<h3>기사목록</h3>
				<table class="table" id="driverTable">
                    <thead>
                        <tr>
                            <th>이름</th>
                            <th>연락처</th>
                            <th>면허만료일</th>
                            <th>배정 차량</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- JS 렌더링 -->
                    </tbody>
                </table>
			</div>
		</div>
	</section>
	<!-- 기사 상세 + 차량 배정/변경 모달 -->
        <div class="modal" id="driverModal" aria-hidden="true">
            <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="driverTitle">
                <div class="modal-head">
                    <strong id="driverTitle">기사 정보</strong>
                    <button class="btn secondary" id="closeDriverModal">닫기</button>
                </div>
                <div class="modal-body">
                    <div class="section-title">기사 정보 (읽기 전용)</div>
                    <div class="grid-2" style="margin-bottom:12px">
                        <div class="field">
                            <label>이름</label>
                            <input id="v_name" disabled />
                        </div>
                        <div class="field">
                            <label>연락처</label>
                            <input id="v_phone" disabled />
                        </div>
                        <div class="field">
                            <label>면허만료일</label>
                            <input id="v_license" disabled />
                        </div>
                        <div class="field">
                            <label>상태</label>
                            <input id="v_status" disabled />
                        </div>
                    </div>

                    <div class="section-title">차량</div>
                    <div id="vehicleArea">
                        <!-- JS: 배정된 차량 정보 or 배정 버튼 -->
                    </div>
                </div>
                <div class="modal-foot">
                    <button class="btn outline" id="vehicleAssignBtn" style="display:none">차량 배정</button>
                    <button class="btn" id="vehicleChangeBtn" style="display:none">차량 변경</button>
                </div>
            </div>
        </div>

        <!-- 차량 선택 모달(서브) -->
        <div class="modal" id="vehicleModal" aria-hidden="true">
            <div class="sub-card" role="dialog" aria-modal="true" aria-labelledby="vehicleTitle">
                <div class="modal-head">
                    <strong id="vehicleTitle">차량 선택</strong>
                    <button class="btn secondary" id="closeVehicleModal">닫기</button>
                </div>
                <div class="modal-body">
                    <div class="toolbar">
                        <input id="qCarNo" type="text" placeholder="차량번호 검색 (예: 89바)" />
                        <select id="qCap">
                            <option value="">전체 적재량</option>
                            <option>1.0t</option>
                            <option>1.5t</option>
                            <option>2.5t</option>
                            <option>5t</option>
                        </select>
                        <button class="btn" id="qSearch">검색</button>
                        <button class="btn secondary" id="qReset">초기화</button>
                    </div>
                    <div class="card" style="border:none; box-shadow:none">
                        <table id="vehicleTable">
                            <thead>
                                <tr>
                                    <th style="width:48px"></th>
                                    <th>차량번호</th>
                                    <th>적재량</th>
                                    <th>차종</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- JS 렌더링 -->
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-foot">
                    <button class="btn" id="confirmAssign">배정</button>
                </div>
            </div>
        </div>
<script>
    // ---- 더미 데이터 ----
    const drivers = [
        { id: 1, name: '김배송', phone: '010-1111-1111', license: '2026-12-31', status: '대기', car: null },
        { id: 2, name: '이배송', phone: '010-2222-2222', license: '2025-10-31', status: '운행중', car: { no: '89바 1234', cap: '1.5t', type: '카고' } },
        { id: 3, name: '최배송', phone: '010-3333-3333', license: '2027-01-15', status: '대기', car: null }
    ];

    const vehicles = [
        { no: '89바 1234', cap: '1.5t', type: '카고', status: '가용' },
        { no: '77나 4567', cap: '5t', type: '윙바디', status: '가용' },
        { no: '55다 1111', cap: '1.0t', type: '탑차', status: '가용' },
        { no: '12라 2222', cap: '2.5t', type: '카고', status: '정비중' },
        { no: '34마 3333', cap: '1.5t', type: '냉동탑', status: '가용' }
    ];

    // ---- 목록 렌더 ----
    const tbody = document.querySelector('#driverTable tbody');
    function renderTable() {
        tbody.innerHTML = '';
        drivers.forEach(function(d) {
            const tr = document.createElement('tr');
            tr.innerHTML =
                '<td>' + d.name + '</td>' +
                '<td>' + d.phone + '</td>' +
                '<td>' + d.license + '</td>' +
                '<td>' + (d.car ? (d.car.no + ' (' + d.car.cap + ')') : '<span class="muted">미배정</span>') + '</td>' +
                '<td>' + (d.status === '운행중' ? '<span class="badge run">운행중</span>' : '<span class="badge wait">대기</span>') + '</td>';
            tr.addEventListener('click', function() { openDriver(d.id); });
            tbody.appendChild(tr);
        });
    }
    renderTable();

    // ---- 기사 모달 ----
    const driverModal = document.getElementById('driverModal');
    const closeDriverModal = document.getElementById('closeDriverModal');
    const vehicleArea = document.getElementById('vehicleArea');
    const vehicleAssignBtn = document.getElementById('vehicleAssignBtn');
    const vehicleChangeBtn = document.getElementById('vehicleChangeBtn');
    let currentDriverId = null;

    function openDriver(id) {
        const d = drivers.find(function(x){ return x.id === id; });
        if (!d) return;
        currentDriverId = id;

        // 기사 정보 (읽기 전용)
        document.getElementById('v_name').value = d.name;
        document.getElementById('v_phone').value = d.phone;
        document.getElementById('v_license').value = d.license;
        document.getElementById('v_status').value = d.status;

        // 차량 영역
        if (d.car) {
            vehicleArea.innerHTML =
                '<div class="vehicle-box">' +
                    '<div class="vehicle-meta">' +
                        '<div><strong>' + d.car.no + '</strong></div>' +
                        '<small>적재량 ' + d.car.cap + ' · 차종 ' + d.car.type + '</small>' +
                    '</div>' +
                    '<div>' +
                        '<button class="btn outline" id="openChange">차량 변경</button>' +
                    '</div>' +
                '</div>';
            vehicleAssignBtn.style.display = 'none';
            vehicleChangeBtn.style.display = 'none';
            // 버튼 핸들러
            vehicleArea.querySelector('#openChange').addEventListener('click', openVehiclePicker);
        } else {
            vehicleArea.innerHTML =
                '<div class="vehicle-box" style="border-style: dashed;">' +
                    '<div class="vehicle-meta">' +
                        '<div><strong>배정된 차량이 없습니다</strong></div>' +
                        '<small>아래 버튼을 눌러 차량을 배정하세요.</small>' +
                    '</div>' +
                    '<div>' +
                        '<button class="btn" id="openAssign">차량 배정</button>' +
                    '</div>' +
                '</div>';
            vehicleAssignBtn.style.display = 'none';
            vehicleChangeBtn.style.display = 'none';
            // 버튼 핸들러
            vehicleArea.querySelector('#openAssign').addEventListener('click', openVehiclePicker);
        }

        driverModal.classList.add('open');
    }

    closeDriverModal.addEventListener('click', function(){ driverModal.classList.remove('open'); });

    // ---- 차량 선택 모달 ----
    const vehicleModal = document.getElementById('vehicleModal');
    const closeVehicleModal = document.getElementById('closeVehicleModal');
    const vTbody = document.querySelector('#vehicleTable tbody');
    const qCarNo = document.getElementById('qCarNo');
    const qCap = document.getElementById('qCap');
    const qSearch = document.getElementById('qSearch');
    const qReset = document.getElementById('qReset');
    let vehicleRows = vehicles.slice();
    let selectedVehicleNo = null;

    function openVehiclePicker() {
        selectedVehicleNo = null;
        qCarNo.value = '';
        qCap.value = '';
        vehicleRows = vehicles.slice();
        renderVehicleTable();
        vehicleModal.classList.add('open');
    }

    function renderVehicleTable() {
        vTbody.innerHTML = '';
        vehicleRows.forEach(function(v) {
            const tr = document.createElement('tr');
            tr.innerHTML =
                '<td><input class="radio" type="radio" name="pickVehicle" value="' + v.no + '" ' + (v.status !== '가용' ? 'disabled' : '') + '></td>' +
                '<td>' + v.no + '</td>' +
                '<td>' + v.cap + '</td>' +
                '<td>' + v.type + '</td>' +
                '<td>' + v.status + '</td>';
            const radio = tr.querySelector('input[type="radio"]');
            if (v.status === '가용') {
                radio.addEventListener('change', function(e){ selectedVehicleNo = e.target.value; });
            }
            vTbody.appendChild(tr);
        });
    }

    qSearch.addEventListener('click', function() {
        const term = qCarNo.value.trim();
        const cap = qCap.value;
        vehicleRows = vehicles.filter(function(v){
            if (term && v.no.indexOf(term) === -1) return false;
            if (cap && v.cap !== cap) return false;
            return true;
        });
        renderVehicleTable();
    });

    qReset.addEventListener('click', function() {
        qCarNo.value = '';
        qCap.value = '';
        vehicleRows = vehicles.slice();
        renderVehicleTable();
    });

    closeVehicleModal.addEventListener('click', function(){ vehicleModal.classList.remove('open'); });

    // 배정 확정
    document.getElementById('confirmAssign').addEventListener('click', function() {
        if (!selectedVehicleNo) {
            alert('배정할 차량을 선택하세요.');
            return;
        }
        const d = drivers.find(function(x){ return x.id === currentDriverId; });
        const v = vehicles.find(function(x){ return x.no === selectedVehicleNo; });
        if (!d || !v) return;

        // (선택) 여기에서 필요 시 적재량 규칙 검증 로직을 넣으세요.
        // 예: 주문 총량 <= v.cap 여부 검사

        d.car = { no: v.no, cap: v.cap, type: v.type };
        vehicleModal.classList.remove('open');
        openDriver(d.id); // 모달 내용 갱신
        renderTable();    // 목록 갱신
    });
</script>

</body>
</html>