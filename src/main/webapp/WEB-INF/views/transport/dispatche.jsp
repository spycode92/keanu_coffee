 <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>배차관리</title>
<link href="${pageContext.request.contextPath}/resources/css/transport/common.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2b14d97248052db181d2cfc125eaa368&libraries=services"></script>	
<script src="${pageContext.request.contextPath}/resources/js/transport/dispatch.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/kakao_map.js"></script>
<style type="text/css">
header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 12px;
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

#detailItems, #assignList, .driver-item {
	font-size: 0.91rem;
}

.assignListWrapper {
	height: 450px;
	overflow-y: scroll;
}

/* 스크롤바 전체 */
.assignListWrapper::-webkit-scrollbar {
  width: 8px; /* 스크롤바 너비 */
}

.assignListWrapper::-webkit-scrollbar-thumb {
  background: #d3d3d3; /* 연한 회색 (lightgray) */
  border-radius: 10px;
}

.assignListWrapper::-webkit-scrollbar-track {
  background: #f9f9f9; /* 트랙은 더 연한 색 */
  border-radius: 10px;
}

.removeDriverBtn {
	cursor: pointer;
}
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
    <div class="content">
        <header>
            <h3>배차 관리</h3>
            <div style="display:flex; gap:8px">
            	<sec:authorize access="isAuthenticated()">
            		<sec:authorize access="hasAnyAuthority('TRANSPORT_WRITE')">
		                <button class="btn btn-primary" id="openRegister">+ 배차 등록</button>
		                <button class="btn btn-confirm" onclick="location.href='/transport/region'">구역관리</button>
            		</sec:authorize>
            	</sec:authorize>
            </div>
        </header>
        <%-- 검색/필터 --%>
        <div class="filterWrapper">
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
        </div>
		<%-- 배차 목록 --%>
        <section class="card" style="margin-top:14px">
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
		                						<span class="badge badge-confirmed">완료</span>
		                					</c:when>
		                					<c:when test="${dispatch.status eq '예약'}">
		                						<span class="badge badge-waiting">예약</span>
		                					</c:when>
		                					<c:when test="${dispatch.status eq '적재완료'}">
		                						<span class="badge badge-pending">적재완료</span>
		                					</c:when>
		                					<c:when test="${dispatch.status eq '운행중'}">
		                						<span class="badge badge-normal">운행중</span>
		                					</c:when>
		                					<c:otherwise>
		                						<span class="badge badge-urgent">취소</span>
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
	<%-- 등록 모달 --%>
	<jsp:include page="/WEB-INF/views/transport/modal/add_dispatch.jsp"></jsp:include>
	<%-- 상세 모달(배차 클릭 시) --%>
	<jsp:include page="/WEB-INF/views/transport/modal/detail_dispatch.jsp"></jsp:include>
</body>
</html>