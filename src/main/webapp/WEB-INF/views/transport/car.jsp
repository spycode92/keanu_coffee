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

header { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 12px; }

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
	<section class="container">
		<header>
	        <h1>차량 관리</h1>
	        <div style="display:flex; gap:8px">
	            <button class="btn secondary" id="openCreate">+ 차량 등록</button>
	            <button class="btn danger" id="bulkDelete">선택 삭제</button>
	        </div>
        </header>
		<div>
			<section class="filters" aria-label="검색 및 필터">
				<div class="field">
					<select id="filterStatus">
						<option value="">전체</option>
						<option value="대기">대기</option>
						<option value="운행중">운행중</option>
						<option value="사용불가">사용불가</option>
					</select>
				</div>
				<div class="search">
					<input id="filterName" type="text" placeholder="차량번호/적재량 검색 가능" />
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
					<form class="form" id="createForm" onsubmit="return false;">
						<div class="row">
							<div class="field">
								<label>차량번호*</label> <input id="c_no" required />
							</div>
							<div class="field">
								<label>차종유형*</label> <input id="c_type"
									placeholder="카고/윙바디/냉동탑 등" required />
							</div>
						</div>
						<div class="row">
							<div class="field">
								<label>적재량*</label> <input id="c_cap"
									placeholder="1.0t / 1.5t / 5t" required />
							</div>
							<div class="field">
								<label>연식</label> <input id="c_year" placeholder="YYYY" />
							</div>
						</div>
						<div class="row">
							<div class="field">
								<label>제조사/모델명</label> <input id="c_model" placeholder="현대 포터 등" />
							</div>
							<div class="field">
								<label>고정기사명</label> <input id="c_driver" placeholder="예: 이정민" />
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

		// ---- 렌더링 ----
		var vBody = document.querySelector('#vehicleTable tbody');

		function badge(status) {
			if (status === '운행중')
				return '<span class="badge run">운행중</span>';
			if (status === '사용불가')
				return '<span class="badge block">사용불가</span>';
			return '<span class="badge wait">대기</span>';
		}

		function renderTable(list) {
			vBody.innerHTML = '';
			list
					.forEach(function(v) {
						var tr = document.createElement('tr');
						tr.innerHTML = '<td><input type="checkbox" class="rowCheck" data-no="' + v.no + '"></td>'
								+ '<td class="rowLink" data-no="' + v.no + '">'
								+ v.no
								+ '</td>'
								+ '<td>'
								+ v.type
								+ '</td>'
								+ '<td>'
								+ v.cap
								+ '</td>'
								+ '<td>'
								+ (v.model || '')
								+ '</td>'
								+ '<td>'
								+ (v.year || '')
								+ '</td>'
								+ '<td>'
								+ (v.driver || '<span class="muted">미지정</span>')
								+ '</td>' + '<td>' + badge(v.status) + '</td>';
						vBody.appendChild(tr);
					});

			// 행 클릭 → 수정 모달
			Array.prototype.forEach.call(document.querySelectorAll('.rowLink'),
					function(el) {
						el.addEventListener('click', function(e) {
							var no = e.currentTarget.getAttribute('data-no');
							openEdit(no);
						});
					});

			// 전체 체크 초기화
			document.getElementById('checkAll').checked = false;
		}

		// 초기 렌더
		renderTable(vehicles);

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

		// ---- 등록 모달 ----
		var createModal = document.getElementById('createModal');
		document.getElementById('openCreate').addEventListener('click',
				function() {
					document.getElementById('c_no').value = '';
					document.getElementById('c_type').value = '';
					document.getElementById('c_cap').value = '';
					document.getElementById('c_year').value = '';
					document.getElementById('c_model').value = '';
					document.getElementById('c_driver').value = '';
					createModal.classList.add('open');
				});
		document.getElementById('cancelCreate').addEventListener('click',
				function() {
					createModal.classList.remove('open');
				});

		document
				.getElementById('saveCreate')
				.addEventListener(
						'click',
						function() {
							var no = document.getElementById('c_no').value
									.trim();
							var type = document.getElementById('c_type').value
									.trim();
							var cap = document.getElementById('c_cap').value
									.trim();
							var year = document.getElementById('c_year').value
									.trim();
							var model = document.getElementById('c_model').value
									.trim();
							var driver = document.getElementById('c_driver').value
									.trim();

							if (!no || !type || !cap) {
								alert('차량번호/차종유형/적재량은 필수입니다.');
								return;
							}
							var dup = vehicles.some(function(v) {
								return v.no === no;
							});
							if (dup) {
								alert('이미 등록된 차량번호입니다.');
								return;
							}

							vehicles.push({
								no : no,
								type : type,
								cap : cap,
								model : model,
								year : year,
								driver : driver,
								status : '대기'
							});
							createModal.classList.remove('open');
							applyFilter();
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