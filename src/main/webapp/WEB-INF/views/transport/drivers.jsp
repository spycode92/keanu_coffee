<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>운송관리대시보드</title>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link
	href="${pageContext.request.contextPath}/resources/css/transport/common.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/resources/css/common/common.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/transport/driver.js"></script>
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
.btn { display: inline-flex; align-items: center; gap: .5rem; padding: .55rem .85rem; border-radius: 10px; border: 1px solid var(--border); background: var(--primary); color: #fff; cursor: pointer; }
.btn.secondary { 
	background: #eef2ff; 
	color: #3949ab; 
	border-color: #c7d2fe; }
.btn.disabled {
	background-color: #e2e8f0;
    color: #94a3b8;
    border-color: #cbd5e1;
    cursor: not-allowed;
  	opacity: 0.6;
}

.grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.field { display: flex; flex-direction: column; gap: 6px; }
.field input { height: 38px; border: 1px solid var(--border); border-radius: 10px; padding: 0 10px; background: #f9fafb; }
.field input[disabled] { color: #4b5563; }
.section-title { font-weight: 700; margin: 10px 0 6px; }

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
												<c:otherwise></c:otherwise>
											</c:choose>
										</td>
										<td>
											<c:choose>
												<c:when test="${driver.status eq '운행중'}">
													운행중
												</c:when>
												<c:when test="${not empty driver.status && driver.status ne '운행중'}">
													대기
												</c:when>
												<c:otherwise></c:otherwise>
											</c:choose>
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
	<jsp:include page="/WEB-INF/views/transport/modal/detail_driver.jsp"></jsp:include>
	</body>
</html>