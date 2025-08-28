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

.content {
	height: 630px;
}

/* 4) 버튼 */
.btn{
	height: 36px;
  	padding: 0 14px;
  	border: 1px solid var(--border);
  	border-radius: var(--radius);
  	background: var(--background);
  	color: var(--foreground);
  	font-weight: 600;
  	transition: background .12s, border-color .12s, box-shadow .12s, color .12s;
}
.btn:hover{ background: #f8fafc; border-color: #cbd5e1; }
.btn:focus-visible{ outline: 2px solid var(--ring); outline-offset: 2px; }

.btn-primary{
  	background: var(--primary);
  	color: var(--primary-foreground);
  	border-color: transparent;
}
.btn-primary:hover{ filter: brightness(0.95); }

.btn-secondary{
  	background: var(--secondary);
  	color: var(--secondary-foreground);
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

.form .modifyRow {
	display: grid;
	grid-template-columns: 1fr 1fr 1fr;
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


/* 고정기사 필드: 입력 + 버튼 가로 정렬 */
.form .field:has(#btnAssignDriver){
  display: grid;
  grid-template-columns: 1fr max-content; /* 입력 확장, 버튼은 내용폭 */
  grid-template-rows: auto 38px;          /* 라벨 / 컨트롤 행 */
  gap: 6px 8px;
}

/* 라벨은 상단 전체 폭 */
.form .field:has(#btnAssignDriver) > label{
  grid-column: 1 / -1;
}

/* 입력창 */
#driverName{
  grid-column: 1 / 2;
  height: 38px;
  padding: 0 10px;
  border: 1px solid var(--border);
  border-radius: 10px;
  background: var(--input-background);
  color: var(--foreground);
}
#driverName[readonly]{
  background: #f8fafc; /* 읽기 전용 톤 */
}

/* 기사배정 버튼 (기존 .btn 느낌으로) */
#btnAssignDriver{
  grid-column: 2 / 3;
  height: 38px;
  padding: 0 14px;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  background: var(--secondary);
  color: var(--secondary-foreground);
  font-weight: 600;
  white-space: nowrap;
  transition: background .12s, border-color .12s, box-shadow .12s, color .12s;
}
#btnAssignDriver:hover{
  background: var(--accent);
}
#btnAssignDriver:focus-visible{
  outline: 2px solid var(--ring);
  outline-offset: 2px;
}
#btnAssignDriver:disabled{
  opacity: .5;
  cursor: not-allowed;
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
		<div class="content">
			<!-- 검색/필터 -->
	        <form class="filters" aria-label="검색 및 필터">
	            <div class="field">
	                <select id="filterStatus" name="filter">
	                    <option value="전체">전체</option>
	                    <option value="미배정">미배정</option>
	                    <option value="대기">대기</option>
	                    <option value="운행중">운행중</option>
	                    <option value="사용불가">사용불가</option>
	                </select>
	            </div>
	            <div class="search">
	                <input id="filterText" type="text" name="searchKeyword" placeholder="차량번호 검색" />
	            </div>
	            <div class="actions">
	                <button class="btn" id="btnSearch">검색</button>
	            </div>
	        </form>
			<div>
				<h3>차량목록</h3>
				<c:choose>
					<c:when test="${empty vehicleList}">
						<div class="empty-result">검색된 차량이 없습니다.</div>
					</c:when>
					<c:otherwise>
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
									<tr class="rowLink" data-vehicle-id="${vehicle.vehicleIdx}" data-status="${vehicle.status}">
										<td><input type="checkbox" class="rowCheck"/></td>
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
		<!-- 등록 모달 -->
		<jsp:include page="/WEB-INF/views/transport/modal/add_vehicle.jsp"></jsp:include>
		<!-- 상세 모달 -->
		<jsp:include page="/WEB-INF/views/transport/modal/detail_vehicle.jsp"></jsp:include>
	</section>
</body>
</html>