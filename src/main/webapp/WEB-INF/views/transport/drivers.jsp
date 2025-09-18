<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>기사관리</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link href="${pageContext.request.contextPath}/resources/css/transport/common.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/driver.js"></script>
<style type="text/css">
.vehicle-empty {
	display:flex; 
	align-items:center; 
	justify-content:space-between;
  	padding:10px 12px; 
  	border:1px dashed #cbd5e1; 
  	border-radius:10px; 
  	background:#f8fafc; 
  	margin-bottom:10px;
}
.vehicle-empty-text { 
	color:#475569; 
}

.vehicle-actions { 
	margin-top:8px; 
	display:flex; 
	justify-content:flex-end; 
}

.btn.disabled {
	background-color: #e2e8f0;
    color: #94a3b8;
    border-color: #cbd5e1;
    cursor: not-allowed;
  	opacity: 0.6;
}

.grid-2 { 
	display: grid; 
	grid-template-columns: 1fr 1fr; 
	gap: 12px; 
}

.field { 
	display: flex; 
	flex-direction: column; 
	gap: 6px; 
}

.field input { 
	height: 38px; 
	border: 1px solid var(--border); 
	border-radius: 10px; 
	padding: 0 10px; 
	background: #f9fafb; 
	font-size: 0.9rem;
}

.field input[disabled] { 
	color: #4b5563; 
}

.section-title { 
	font-weight: 700; 
	margin: 10px 0 6px; 
}

.modal-body .field {
	margin-bottom: 0.5em;
}

</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	<section class="content">
		<div>
			<h3>기사관리</h3>
		</div>
		<%-- 검색/필터 --%>
		<div class="filterWrapper">
	        <form class="filters" aria-label="검색 및 필터">
	            <div class="field">
	                <select id="filterStatus" name="filter">
	                    <option value="전체">전체</option>
	                    <option value="대기">대기</option>
	                    <option value="예약">예약</option>
	                    <option value="운행중">운행중</option>
	                </select>
	            </div>
	            <div class="search">
	                <input id="filterText" type="text" name="searchKeyword" placeholder="이름/차량번호 검색 가능" />
	            </div>
	            <div class="actions">
	                <button class="btn btn-primary" id="btnSearch">검색</button>
	            </div>
	        </form>
		</div>
        <%-- 기사목록 --%>
		<div class="card">
			<c:choose>
				<c:when test="${empty driverList}">
					<div class="empty-result">검색된 기사가 없습니다.</div>
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
						<tbody id="driverTbody">
							<c:forEach var="driver" items="${driverList}">
								<tr class="driverInfo" data-driver-idx="${driver.empIdx}">
									<td>${driver.empName}</td>
									<td>${driver.empPhone}</td>
									<td>
										${not empty  driver.vehicleNumber ? driver.vehicleNumber : "미배정"}
									</td>
									<td>
										<c:choose>
											<c:when test="${driver.capacity eq 1000}">
												1.0t
											</c:when>
											<c:when test="${driver.capacity eq 1500}">
												1.5t
											</c:when>
										</c:choose>
									</td>
									<td>
										<c:choose>
											<c:when test="${driver.status eq '운행중'}">
												<span class="badge badge-normal">운행중</span>
											</c:when>
											<c:when test="${not empty driver.status && driver.status ne '운행중'}">
												<span class="badge badge-waiting">대기</span>
											</c:when>
											<c:otherwise>
												<span class="badge badge-urgent">예약</span>
											</c:otherwise>
										</c:choose>
									</td>
									<td>
										<c:choose>
											<c:when test="${driver.empStatus eq '재직'}">
												<span class="badge badge-confirmed">재직</span>
											</c:when>
											<c:when test="${driver.empStatus eq '휴직'}">
												<span class="badge badge-warning">휴직</span>
											</c:when>
											<c:otherwise>
												<span class="badge badge-urgent">퇴직</span>
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
			<jsp:param value="/transport/drivers" name="pageUrl"/>
		</jsp:include>
	</section>
	<%-- 기사 상세 + 차량 배정/변경 모달 --%>
	<jsp:include page="/WEB-INF/views/transport/modal/detail_driver.jsp"></jsp:include>
	</body>
</html>