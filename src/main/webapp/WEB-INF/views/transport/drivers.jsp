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
	href="${pageContext.request.contextPath}/resources/css/transport/common.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/resources/css/common/common.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style type="text/css">

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

/* 모달 공통 */
.modal { position: fixed; inset: 0; display: none; align-items: center; justify-content: center; padding: 20px; background: rgba(0,0,0,.45); z-index: 100; }
.modal.open { display: flex; }
.modal-card { width: min(900px, 96vw); background: #fff; border: 1px solid var(--border); border-radius: 12px; overflow: hidden; }
.modal-head { display: flex; justify-content: space-between; align-items: center; padding: 14px 16px; border-bottom: 1px solid var(--border); }
.modal-body { padding: 14px 16px; }
.modal-foot { display: flex; justify-content: flex-end; gap: 8px; padding: 12px 16px; border-top: 1px solid var(--border); }
.btn { display: inline-flex; align-items: center; gap: .5rem; padding: .55rem .85rem; border-radius: 10px; border: 1px solid var(--border); background: var(--primary); color: #fff; cursor: pointer; }
.btn.secondary { background: #eef2ff; color: #3949ab; border-color: #c7d2fe; }
.btn.outline { background: #fff; color: #111; }
.btn.danger { background: #ef4444; border-color: #ef4444; }

.grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.field { display: flex; flex-direction: column; gap: 6px; }
.field input { height: 38px; border: 1px solid var(--border); border-radius: 10px; padding: 0 10px; background: #f9fafb; }
.field input[disabled] { color: #4b5563; }
.section-title { font-weight: 700; margin: 10px 0 6px; }

 /* 차량 카드 / 비어있을 때 */
 .vehicle-box { border: 1px dashed #cdd3ff; border-radius: 12px; padding: 12px; background: #fafbff; display: flex; justify-content: space-between; gap: 12px; align-items: center; }
 .vehicle-meta { display: grid; gap: 4px; }
 .vehicle-meta small { color: var(--muted); }

 /* 차량 선택 모달(서브) */
 .sub-card { width: min(760px, 96vw); background: #fff; border: 1px solid var(--border); border-radius: 12px; overflow: hidden; }
 .toolbar { display: flex; gap: 8px; margin-bottom: 10px; }
 .toolbar input, .toolbar select { height: 36px; border: 1px solid var(--border); border-radius: 10px; padding: 0 10px; }
 .radio { width: 18px; height: 18px; }

</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	<div class="container">
		<h1>기사관리</h1>
		<div class="content">
			<!-- 검색/필터 -->
	        <form class="filters" aria-label="검색 및 필터">
	            <div class="field">
	                <select id="filterStatus" name="filter">
	                    <option value="전체">전체</option>
	                    <option value="대기">대기</option>
	                    <option value="운행중">운행중</option>
	                </select>
	            </div>
	            <div class="search">
	                <input id="filterText" type="text" name="searchKeyword" placeholder="이름/차량번호 검색 가능" />
	            </div>
	            <div class="actions">
	                <button class="btn" id="btnSearch">검색</button>
	            </div>
	        </form>
			<div>
				<h3>기사목록</h3>
				<c:choose>
					<c:when test="${empty driverList}">
						<div class="empty-result">검색된 차량이 없습니다.</div>
					</c:when>
					<c:otherwise>
						<table class="table" id="driverTable">
					    	<thead>
		                        <tr>
		                            <th>이름</th>
		                            <th>연락처</th>
		                            <th>차량번호</th>
		                            <th>적재량</th>
		                            <th>운송상태</th>
		                            <th>상태</th>
		                        </tr>
		                    </thead>
							<tbody>
								<c:forEach var="driver" items="${driverList}">
									<tr>
										<td>${driver.empName}</td>
										<td>${driver.empPhone}</td>
										<td>
											${driver.vehicleNumber ? driver.vehicleNumber : "미배정"}
										</td>
										<td>
											${driver.capacity == 1000 ? "1.0t" : "1.5t"}
										</td>
										<td>
											${driver.status eq "운행중" ? "운행중" : "대기"}
										</td>
										<td>${driver.empStatus}</td>
									</tr>
								
								</c:forEach>
							</tbody>
						</table>
					
					</c:otherwise>
				</c:choose> 
			</div>
		</div>
		<div class="pager">
			<div>
				<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
					<input type="button" value="이전" 
						onclick="location.href='/transport/vehicle?pageNum=${pageInfo.pageNum - 1}&filter=${param.filter}&searchKeyword=${param.searchKeyword}'" 
						<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
					<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
						<c:choose>
							<c:when test="${i eq pageInfo.pageNum}">
								<strong>${i}</strong>
							</c:when>
							<c:otherwise>
								<a href="/transport/vehicle?pageNum=${i}&filter=${param.filter}&searchKeyword=${param.searchKeyword}">${i}</a>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<input type="button" value="다음" 
						onclick="location.href='/transport/vehicle?pageNum=${pageInfo.pageNum + 1}&filter=${param.filter}&searchKeyword=${param.searchKeyword}'" 
					<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
				</c:if>
			</div>
		</div>
	</div>
	<!-- 기사 상세 + 차량 배정/변경 모달 -->
        <div class="modal" id="driverModal" aria-hidden="true">
            <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="driverTitle">
                <div class="modal-head">
                    <strong id="driverTitle">기사 정보</strong>
                    <button class="btn secondary" id="closeDriverModal">닫기</button>
                </div>
                <div class="modal-body">
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

        d.car = { no: v.no, cap: v.cap, type: v.type };
        vehicleModal.classList.remove('open');
        openDriver(d.id); // 모달 내용 갱신
        renderTable();    // 목록 갱신
    });
</script>

</body>
</html>