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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/vehicle.js" defer></script>
<style type="text/css">
.container {
	max-width: 1264px;
	margin: 0 auto;
	padding: 0 16px;
}

header { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 12px; }

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
.filters .field { display: flex; flex-direction: column; gap: 6px; }
.filters .search { display: flex; flex-direction: column; gap: 6px; }
.search { width: 500px; }
.filters label { font-size: .85rem; color: var(--muted-foreground); }
.filters input, .filters select {
    height: 38px; padding: 0 10px; border: 1px solid var(--border); border-radius: 10px; background: #fff;
}
.filters .actions {
    display: flex; align-items: end; justify-content: center; gap: 8px;
}

.badge {
	display: inline-block;
	padding: 2px 8px;
	border-radius: 999px;
	font-size: .8rem;
	font-weight: 700
}

.badge.unassigned {
  background: #fef3c7; /* amber-100 */
  color: #92400e;      /* amber-900 */
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
	border: 1px solid var(--border);
	border-radius: 12px;
	overflow: hidden;
}

.modal-head {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 14px 16px;
	border-bottom: 1px solid var(--border);
}

.modal-body {
	padding: 14px 16px;
}

.modal-foot {
	display: flex;
	justify-content: flex-end;
	gap: 8px;
	padding: 12px 16px;
	border-top: 1px solid var(--border);
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

.seg-radio{
  display:inline-grid;
  grid-auto-flow:column;
  align-items:center;
  border:1px solid var(--border);
  border-radius:10px;
  height:38px;              /* 다른 input과 동일 높이 */
  overflow:hidden;
  background:#fff;
}

/* 실제 라디오는 숨기고 라벨을 버튼처럼 */
.seg-radio input{
  position:absolute;
  opacity:0;
  width:1px; height:1px;
  overflow:hidden;
  clip:rect(0 0 0 0);
}
.seg-radio label{
  display:inline-flex;
  align-items:center;
  justify-content:center;
  min-width:70px;           /* 버튼 넓이 */
  padding:0 14px;
  cursor:pointer;
  user-select:none;
  white-space:nowrap;
  border-right:1px solid var(--border);
  font-size:0.95rem;
}
.seg-radio label:last-of-type{ border-right:none; }

/* 선택 상태 */
.seg-radio input:checked + label{
  background: #9db2fb;          /* 버튼 선택 색상 */
  color: #fff;
  border-radius: 3rem;
}

/* hover */
.seg-radio label:hover{
  background: #f7f7f7;
  border-radius: 3rem;
}

/* 키보드 포커스 표시 */
.seg-radio input:focus-visible + label{
  outline:2px solid var(--ring, #2563eb);
  outline-offset:-2px;
}

/* 비활성화가 필요할 때 */
.seg-radio input:disabled + label{
  opacity:.5; cursor:not-allowed;
}

.form input, .form select {
	height: 38px;
	padding: 0 10px;
	border: 1px solid var(--border);
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
	<section class="container">
		<header>
	        <h1>차량 관리</h1>
	        <div style="display:flex; gap:8px">
	            <button class="btn secondary" id="openCreate">+ 차량 등록</button>
	            <button class="btn danger" id="bulkDelete">선택 삭제</button>
	        </div>
        </header>
		<div>
			<!-- 검색/필터 -->
	        <section class="filters" aria-label="검색 및 필터">
	            <div class="field">
	                <select id="filterStatus">
	                    <option value="전체">전체</option>
	                    <option value="미배정">미배정</option>
	                    <option value="대기">대기</option>
	                    <option value="운행중">운행중</option>
	                    <option value="사용불가">사용불가</option>
	                </select>
	            </div>
	            <div class="search">
	                <input id="filterText" type="text" placeholder="차량번호/적재량 검색 가능" />
	            </div>
	            <div class="actions">
	                <button class="btn secondary" id="btnReset">초기화</button>
	                <button class="btn" id="btnSearch">검색</button>
	            </div>
	        </section>
			<div>
				<h3>차량목록</h3>
				<table class="table" id="vehicleTable">
					<thead>
						<tr>
							<th><input type="checkbox" id="checkAll" /></th>
							<th>차량번호</th>
							<th>차종유형</th>
							<th>적재량</th>
							<th>제조사/모델명</th>
							<th>연식</th>
							<th>고정기사명</th>
							<th>상태</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="vehicle" items="${vehicleList}">
							<tr id="row-${vehicle.vehicleIdx}">
								<td><input type="checkbox"/></td>
								<td>${vehicle.vehicleNumber}</td>
								<td>${vehicle.vehicleType}</td>
								<td>
									<c:choose>
										<c:when test="${vehicle.capacity == 1000 }">
											1.0t
										</c:when>
										<c:otherwise>
											1.5t
										</c:otherwise>
									</c:choose>
								</td>
								<td>${vehicle.manufacturerModel}</td>
								<td>${vehicle.manufactureYear}</td>
								<td>
									<c:if test="${vehicle.driverName != null}">${vehicle.driverName}</c:if>
								</td>
								<td>
									<c:choose>
										<c:when test="${vehicle.status eq '미배정'}">
											<span class="badge unassigned">${vehicle.status}</span>
										</c:when>
										<c:when test="${vehicle.status eq '대기'}">
											<span class="badge wait">${vehicle.status}</span>
										</c:when>
										<c:when test="${vehicle.status eq '운행중'}">
											<span class="badge run">${vehicle.status}</span>
										</c:when>
										<c:otherwise>
											<span class="badge left">${vehicle.status}</span>
										</c:otherwise>
									</c:choose>
								
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		<!-- 등록 모달 -->
		<div class="modal" id="createModal" aria-hidden="true">
			<div class="modal-card" role="dialog" aria-modal="true"
				aria-labelledby="createTitle">
				<div class="modal-head">
					<strong id="createTitle">신규 차량 등록</strong>
				</div>
				<div class="modal-body">
					<form class="form" id="createForm" action="/transport/addVehicle" method="post">
						<div class="row">
							<div class="field">
								<label>차량번호*</label> 
								<input id="c_no" name="vehicleNumber" type="text" placeholder="123가4567 / 12가3456" required />
							</div>
							<div class="field">
								<label>차종유형*</label> <input id="c_type" name="vehicleType" type="text"
									placeholder="카고/윙바디/냉동탑 등" required />
							</div>
						</div>
						<div class="row">
							<div class="field">
								<label>적재량*</label>
							  	<div class="seg-radio" role="radiogroup" aria-label="적재량">
							    	<input id="cap-1"  type="radio" name="capacity" value="1000" required>
							    	<label for="cap-1">1t</label>
							
							    	<input id="cap-15" type="radio" name="capacity" value="1500">
							    	<label for="cap-15">1.5t</label>
							    </div>
							</div>
							<div class="field">
								<label>연식</label> 
								<input id="c_year" name="manufactureYear" type="number" placeholder="YYYY"/>
							</div>
						</div>
						<div class="row">
							<div class="field">
								<label>제조사/모델명</label> 
								<input id="c_model" name="manufacturerModel" placeholder="현대 포터 등" />
							</div>
							<div class="field">
								<label>고정기사명</label> <input id="c_driver" disabled/>
							</div>
						</div>
						<div class="help">* 차량번호는 중복 등록 불가</div>
					</form>
				</div>
				<div class="modal-foot">
					<button class="btn secondary" id="cancelCreate">취소</button>
					<button class="btn" id="saveCreate">등록</button>
				</div>
			</div>
		</div>

		<!-- 수정 모달 -->
		<div class="modal" id="editModal" aria-hidden="true">
			<div class="modal-card" role="dialog" aria-modal="true"
				aria-labelledby="editTitle">
				<div class="modal-head">
					<strong id="editTitle">차량 수정</strong>
					<button class="btn secondary" id="closeEdit">닫기</button>
				</div>
				<div class="modal-body">
					<form class="form" id="editForm" onsubmit="return false;">
						<input type="hidden" id="e_no" />
						<!-- 고정기사/상태만 수정 -->
						<div class="row">
							<div class="field">
								<label>고정기사명</label> <input id="e_driver" />
							</div>
							<div class="field">
								<label>상태</label> <select id="e_status">
									<option>대기</option>
									<option>운행중</option>
									<option>사용불가</option>
								</select>
							</div>
						</div>
						<div class="help">운행중인 차량은 고정기사명 수정 불가</div>
					</form>
				</div>
				<div class="modal-foot">
					<button class="btn secondary" id="cancelEdit">취소</button>
					<button class="btn" id="saveEdit">저장</button>
				</div>
			</div>
		</div>
	</section>
	<script>
		// ---- 더미 데이터 ----
		var vehicles = [ {
			no : '89바 1234',
			type : '카고',
			cap : '1.5t',
			model : '현대 포터',
			year : '2023',
			driver : '이정민',
			status : '대기'
		}, {
			no : '77나 4567',
			type : '윙바디',
			cap : '5t',
			model : '타타 대우',
			year : '2021',
			driver : '김도운',
			status : '운행중'
		}, {
			no : '55다 1111',
			type : '탑차',
			cap : '1.0t',
			model : '기아 봉고',
			year : '2022',
			driver : '',
			status : '대기'
		}, {
			no : '12라 2222',
			type : '카고',
			cap : '2.5t',
			model : '이스즈 엘프',
			year : '2020',
			driver : '',
			status : '사용불가'
		}, {
			no : '34마 3333',
			type : '냉동탑',
			cap : '1.5t',
			model : '현대 포터',
			year : '2024',
			driver : '박민수',
			status : '대기'
		} ];


		// ---- 전체 체크 ----
		document.getElementById('checkAll').addEventListener(
				'change',
				function(e) {
					var checked = e.target.checked;
					Array.prototype.forEach.call(document
							.querySelectorAll('.rowCheck'), function(c) {
						c.checked = checked;
					});
				});


		// ---- 수정 모달 ----
		var editModal = document.getElementById('editModal');
		function openEdit(no) {
			var v = vehicles.find(function(x) {
				return x.no === no;
			});
			if (!v)
				return;
			document.getElementById('e_no').value = v.no;
			document.getElementById('e_driver').value = v.driver || '';
			document.getElementById('e_status').value = v.status;

			// 운행중이면 고정기사명 입력 비활성화
			var driverInput = document.getElementById('e_driver');
			driverInput.disabled = (v.status === '운행중');

			editModal.classList.add('open');
		}
		document.getElementById('closeEdit').addEventListener('click',
				function() {
					editModal.classList.remove('open');
				});
		document.getElementById('cancelEdit').addEventListener('click',
				function() {
					editModal.classList.remove('open');
				});

		document.getElementById('saveEdit').addEventListener('click',
				function() {
					if (!confirm('저장하시겠습니까?'))
						return;
					var no = document.getElementById('e_no').value;
					var v = vehicles.find(function(x) {
						return x.no === no;
					});
					if (!v)
						return;

					var status = document.getElementById('e_status').value;
					var drv = document.getElementById('e_driver').value.trim();

					// 운행중이면 고정기사 수정 불가 (폼에서 disabled 처리하지만 안전망)
					if (v.status === '운행중' && drv !== (v.driver || '')) {
						alert('운행중인 차량은 고정기사명을 수정할 수 없습니다.');
						return;
					}

					v.status = status;
					if (v.status !== '운행중') {
						v.driver = drv; // 운행중이 아닐 때만 반영
					}

					editModal.classList.remove('open');
					applyFilter();
				});

		// ---- 삭제 ----
		document.getElementById('bulkDelete').addEventListener(
				'click',
				function() {
					var checked = Array.prototype.map.call(document
							.querySelectorAll('.rowCheck:checked'),
							function(c) {
								return c.getAttribute('data-no');
							});
					if (!checked.length) {
						alert('삭제할 차량을 선택하세요.');
						return;
					}
					if (!confirm('삭제하시겠습니까?'))
						return;

					// 삭제 = 상태를 '사용불가'로 변경
					vehicles.forEach(function(v) {
						if (checked.indexOf(v.no) !== -1) {
							v.status = '사용불가';
						}
					});
					applyFilter();
				});
	</script>
</body>
</html>