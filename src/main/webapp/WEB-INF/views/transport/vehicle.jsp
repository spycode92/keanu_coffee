<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>차량관리</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/transport/common.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/common/sortUtils.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/vehicle.js" defer></script>
<style type="text/css">
header { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 12px; }

.badge.unassigned {
	background: #e5e7eb;
	color: #111827;
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
	<section class="content">
		<header>
	        <h3>차량 관리</h3>
	        <div style="display:flex; gap:8px">
	        	<sec:authorize access="isAuthenticated()">
	        		<sec:authorize access="hasAnyAuthority('TRANSPORT_WRITE')">
			            <button class="btn btn-primary" id="openCreate">+ 차량 등록</button>
			            <button class="btn btn-cancel" id="bulkDelete">선택 삭제</button>
	        		</sec:authorize>
	        	</sec:authorize>
	        </div>
        </header>
		<%-- 검색/필터 --%>
		<div class="filterWrapper">
	        <form class="filters" aria-label="검색 및 필터">
	            <div class="field">
	                <select id="filterStatus" name="searchType">
	                    <option <c:if test="${param.searchType eq '전체' }">selected</c:if>>전체</option>
	                    <option <c:if test="${param.searchType eq '미배정' }">selected</c:if>>미배정</option>
	                    <option <c:if test="${param.searchType eq '대기' }">selected</c:if>>대기</option>
	                    <option <c:if test="${param.searchType eq '운행중' }">selected</c:if>>운행중</option>
	                    <option <c:if test="${param.searchType eq '사용불가' }">selected</c:if>>사용불가</option>
	                </select>
	            </div>
	            <div class="search">
	                <input id="filterText" type="text" name="searchKeyword" placeholder="차량번호 검색" />
	            </div>
	            <div class="actions">
	                <button class="btn btn-primary" id="btnSearch">검색</button>
	            </div>
	        </form>
		</div>
        <%-- 차량 목록 --%>
		<div class="card">
			<c:choose>
				<c:when test="${empty vehicleList}">
					<div class="empty-result">검색된 차량이 없습니다.</div>
				</c:when>
				<c:otherwise>
					<table class="table" id="vehicleTable">
						<thead>
							<tr>
								<th><input type="checkbox" id="checkAll" /></th>
								<th data-key="v.vehicle_number" onclick="allineTable(this)">
	                        		차량번호
	                        		<c:choose>
										<c:when test="${param.orderKey eq 'v.vehicle_number'}">
											<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
											<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
										</c:when>
										 <c:otherwise>
											↕
										 </c:otherwise>
									</c:choose>
	                        	</th>
								<th data-key="v.vehicle_type" onclick="allineTable(this)">
	                        		차종유형
	                        		<c:choose>
										<c:when test="${param.orderKey eq 'v.vehicle_type'}">
											<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
											<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
										</c:when>
										 <c:otherwise>
											↕
										 </c:otherwise>
									</c:choose>
	                        	</th>
								<th data-key="v.capacity" onclick="allineTable(this)">
	                        		적재량
	                        		<c:choose>
										<c:when test="${param.orderKey eq 'v.capacity'}">
											<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
											<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
										</c:when>
										 <c:otherwise>
											↕
										 </c:otherwise>
									</c:choose>
	                        	</th>
								<th>제조사/모델명</th>
								<th data-key="v.manufacture_year" onclick="allineTable(this)">
	                        		연식
	                        		<c:choose>
										<c:when test="${param.orderKey eq 'v.manufacture_year'}">
											<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
											<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
										</c:when>
										 <c:otherwise>
											↕
										 </c:otherwise>
									</c:choose>
	                        	</th>
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
												<span class="badge badge-waiting">${vehicle.status}</span>
											</c:when>
											<c:when test="${vehicle.status eq '운행중'}">
												<span class="badge badge-normal">${vehicle.status}</span>
											</c:when>
											<c:otherwise>
												<span class="badge badge-urgent">${vehicle.status}</span>
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
		<jsp:include page="/WEB-INF/views/inc/pagination.jsp">
			<jsp:param value="/transport/vehicle" name="pageUrl"/>
		</jsp:include>
		<%-- 등록 모달 --%>
		<jsp:include page="/WEB-INF/views/transport/modal/add_vehicle.jsp"></jsp:include>
		<%-- 상세 모달 --%>
		<jsp:include page="/WEB-INF/views/transport/modal/detail_vehicle.jsp"></jsp:include>
	</section>
</body>
</html>