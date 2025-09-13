 <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>운송관리대시보드</title>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link
	href="${pageContext.request.contextPath}/resources/css/transport/common.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/resources/css/common/common.css"
	rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/transport/dispatch.js"></script>
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

.badge { 
	display: inline-block; 
	padding: 2px 8px; 
	border-radius: 999px; 
	font-size: .8rem; 
	font-weight: 700; 
}

.badge.run { /* 운행중 */
	background: #dcfce7; 
	color: #166534; 
}      

.badge.book { /* 예약 */
	background: #e0e7ff; 
	color: #3730a3; 
}   
  
.badge.done {  /* 완료 */
	background: #e5ffe9; 
	color: #047857; 
}    

.badge.cancel { /* 취소 */
	background: #fee2e2; 
	color: #991b1b; 
} 

.badge.loaded { /* 적재완료 */
	background: #cffafe; 
	color: #0e7490;     
}

.help, .hint { font-size: .83rem; color: var(--muted-foreground); }


button:disabled {
  background: linear-gradient(145deg, #e0e0e0, #c0c0c0);
  color: #999;
  border: 1px solid #bbb;
  cursor: not-allowed;
  opacity: 0.7;
  transform: none;   /* hover시 scale 효과 제거 */
}

.field { display: flex; flex-direction: column; gap: 6px; }
.field input { height: 38px; border: 1px solid var(--border); border-radius: 10px; padding: 0 10px; background: #f9fafb; }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
    <div class="content">
        <header>
            <h1>배차 관리</h1>
            <div style="display:flex; gap:8px">
                <button class="btn btn-primary" id="openRegister">+ 배차 등록</button>
                <button onclick="location.href='/transport/mypage/${pageContext.request.userPrincipal.name}'">기사마이페이지</button>
                <button class="btn btn-confirm" onclick="location.href='/transport/region'">구역관리</button>
            </div>
        </header>
        <!-- 검색/필터 -->
        <form class="filters" aria-label="검색 및 필터">
            <div class="field">
                <select id="filterStatus" name="filter">
                    <option value="전체">전체</option>
                    <option value="예약">예약</option>
                    <option value="적재완료">적재완료</option>
                    <option value="운행중">운행중</option>
                    <option value="완료">완료</option>
                    <option value="취소">취소</option>
                </select>
            </div>
            <div class="search">
                <input id="filterText" type="text" name="searchKeyword" placeholder="기사명 / 차량번호 / 구역명 검색" />
            </div>
            <div class="actions">
                <button class="btn btn-primary" id="btnSearch">검색</button>
            </div>
        </form>

        <!-- 배차 목록 -->
        <section style="margin-top:14px">
            <h3>배차목록</h3>
            <c:choose>
            	<c:when test="${empty dispatchList}">
            		<div class="empty-result">검색된 배차가 없습니다.</div>
            	</c:when>
            	<c:otherwise>
		            <table class="table" id="dispatchTable">
		                <thead>
		                    <tr>
		                        <th>배차일</th>
		                        <th>배차시간</th>
		                        <th>기사명</th>
		                        <th>차량번호</th>
		                        <th>차량용량</th>
		                        <th>구역</th>
		                        <th>상태</th>
		                    </tr>
		                </thead>
		                <tbody>
		                	<c:forEach var="dispatch" items="${dispatchList}">
		                		<tr data-dispatch-idx="${dispatch.dispatchIdx }" 
		                			data-vehicle-idx="${dispatch.vehicleIdx}" class="dispatchInfo">
		                			<td>
		                				<fmt:formatDate value="${dispatch.dispatchDate}" pattern="yyyy-MM-dd"/>
		                			</td>
		                			<td>${dispatch.startSlot}</td>
		                			<td>${dispatch.driverName}</td>
		                			<td>${dispatch.vehicleNumber}</td>
		                			<td>
	                					<c:choose>
											<c:when test="${dispatch.capacity == 1000 }">
												1.0t
											</c:when>
											<c:otherwise>
												1.5t
											</c:otherwise>
										</c:choose>
		                			</td>
		                			<td>${dispatch.regionName}</td>
		                			<td>
		                				<c:choose>
		                					<c:when test="${dispatch.status eq '완료'}">
		                						<span class="badge done">완료</span>
		                					</c:when>
		                					<c:when test="${dispatch.status eq '예약'}">
		                						<span class="badge book">예약</span>
		                					</c:when>
		                					<c:when test="${dispatch.status eq '적재완료'}">
		                						<span class="badge loaded">적재완료</span>
		                					</c:when>
		                					<c:when test="${dispatch.status eq '운행중'}">
		                						<span class="badge run">운행중</span>
		                					</c:when>
		                					<c:otherwise>
		                						<span class="badge cancel">취소</span>
		                					</c:otherwise>
		                				</c:choose>
		                			
		                			</td>
		                		</tr>
		                	</c:forEach>
		                </tbody>
		            </table>
            	</c:otherwise>
            </c:choose>
        </section>
		<jsp:include page="/WEB-INF/views/inc/pagination.jsp">
			<jsp:param value="/transport/dispatches" name="pageUrl"/>
		</jsp:include>
	</div>

    <!-- 등록 모달 -->
	<jsp:include page="/WEB-INF/views/transport/modal/add_dispatch.jsp"></jsp:include>

    <!-- 상세 모달(배차 클릭 시) -->
	<jsp:include page="/WEB-INF/views/transport/modal/detail_dispatch.jsp"></jsp:include>
</body>
</html>