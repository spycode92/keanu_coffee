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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/transport/vehicle.js"
	defer></script>
<style type="text/css">
/* 컨테이너 */
.region-container {
display:grid;
grid-template-columns: 1fr 1fr 1fr;
gap:20px;
}


.region-card {
background: var(--card);
color: var(--card-foreground);
border: 1px solid var(--border);
border-radius: var(--radius);
padding: 1.25rem;
box-shadow:0 2px 8px rgba(0,0,0,0.08);
}


.region-card h2 {
font-size: 1.1rem;
font-weight: var(--font-weight-medium);
margin-bottom: 1rem;
padding-left: 0.5rem;
border-left: 4px solid var(--primary);
}


.region-card label {
font-size: 0.9rem;
font-weight: var(--font-weight-medium);
margin-top: 0.5rem;
}


.region-card input,
.region-card select,
.region-card button {
width:100%; padding:0.5rem; margin-top:0.25rem; margin-bottom:0.75rem;
border:1px solid var(--border); border-radius: var(--radius);
}


.region-card button {
background: var(--primary);
color: var(--primary-foreground);
font-weight: var(--font-weight-medium);
cursor: pointer;
}
.region-card button:hover { opacity:0.9; }


/* 테이블 */
.region-card table { width:100%; border-collapse: collapse; margin-top:1rem; }
.region-card table th,
.region-card table td { border:1px solid var(--border); padding:0.5rem; text-align:center; }
.region-card table th { background: var(--muted); }


/* 리스트 드래그 */
#franchiseList { list-style:none; padding:0; margin:1rem 0; }
#franchiseList li {
background: var(--accent);
color: var(--foreground);
padding:0.6rem 0.8rem;
#franchiseList li.dragging { opacity:0.5; background: var(--secondary); }
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	<section class="content">
		<c:if test="${not empty msg}">
			<script type="text/javascript">
				alert("${msg}");
			</script>
		</c:if>
		<header>
			<h1>구역 관리</h1>
		</header>
		<div class="region-container">

			<!-- 1. 구역 추가 -->
			<div class="region-card">
				<h2>구역 추가</h2>
				<form action="/transport/region/add"  method="POST" id="regionForm">
					<label>구역 이름</label> 
					<input type="text" id="regionName" name="regionName" placeholder="예: 1구역">
					<button type="submit">구역 추가</button>
				</form>
				<h3>구역 목록</h3>
				<ul id="regionList">
					<c:choose>
						<c:when test="${empty regionList}">
							<div>등록된 구역이 없습니다.</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="region" items="${regionList}">
								<li>${region.commonCodeName}</li>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</ul>
			</div>

			<!-- 2. 행정구역 매핑 -->
			<div class="region-card">
				<h2>bcode 매핑 등록</h2>
				<label>구역 선택</label> <select id="regionSelect"></select> <label>시/도</label>
				<select id="sidoSelect"></select> <label>시군구</label> <select
					id="sigunguSelect"></select> <label>동/리</label> <select
					id="dongSelect"></select> <label>bcode</label> <input type="text"
					id="bcode" readonly>


				<button id="addMappingBtn">매핑 추가</button>


				<h3>등록된 매핑</h3>
				<table>
					<thead>
						<tr>
							<th>구역명</th>
							<th>시/도</th>
							<th>시군구</th>
							<th>동</th>
							<th>bcode</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody id="mappingTable"></tbody>
				</table>
			</div>
			<!-- 3. 지점 순서 관리 -->
			<div class="region-card">
				<h2>지점 순서 관리</h2>
				<label>구역 선택</label> <select id="routeRegionSelect"></select>
				<ul id="franchiseList"></ul>
				<button id="saveRouteBtn" disabled>순서 저장</button>
			</div>
		</div>
	</section>
</body>
</html>