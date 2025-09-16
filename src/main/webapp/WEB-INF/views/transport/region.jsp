<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>운송관리대시보드</title>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="https://code.jquery.com/ui/1.12.1/jquery-ui.js" ></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/region.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/administrativeRegion.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/route.js" defer></script>
<script src="https://kit.fontawesome.com/a96e186b03.js" crossorigin="anonymous"></script>
<style type="text/css">
/* 컨테이너 */
.region-container {
	display:grid;
	grid-template-columns: 1fr 1fr 1fr;
	gap: 40px;
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
	font-size: 1rem;
	font-weight: var(--font-weight-medium);
	margin-bottom: 1rem;
	padding-left: 0.5rem;
	border-left: 4px solid var(--primary);
}

.region-card h3 {
	font-size: 0.95rem;
}


.region-card label {
	font-size: 0.9rem;
	font-weight: var(--font-weight-medium);
	margin-top: 0.5rem;
}

.region-card input,
.region-card select,
.region-card {
	width:100%; 
	padding:0.5rem; 
	margin-top:0.25rem; 
	margin-bottom:0.75rem;
	border:1px solid var(--border); 
	border-radius: var(--radius);
}

.region-card button:hover { 
	opacity:0.9; 
}

/* 테이블 */
.region-card table { 
	width:100%; 
	border-collapse: collapse; 
	margin-top:1rem; 
}

.region-card table th,
.region-card table td { 
	border:1px solid var(--border); 
	padding:0.5rem; 
	text-align:center; 
}

.region-card table th { background: var(--muted); }


/* 리스트 드래그 */
#franchiseList { 
	list-style:none; 
	padding:0; 
	margin:1rem; 
}
#franchiseList li {
	background: var(--accent);
	color: var(--foreground);
	padding:0.6rem 0.8rem;
}
#franchiseList li.dragging { 
	opacity:0.5; 
	background: var(--secondary); 
}

#franchiseTable {
	margin-bottom: 1rem;
}

.region-item {
	display: flex;
    align-items: center;
    justify-content: space-between;
    background: var(--card);
    padding: 6px 10px;
    margin-bottom: 8px;
}

#regionName {
	width: 94%;
    flex: 1;
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 6px 10px;
    font-size: 0.95rem;
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
}

.region-name:focus {
    border-color: var(--primary);
	box-shadow: 0 0 0 2px rgba(86, 95, 254, 0.2);
}

.region-actions {
    display: flex;
    gap: 6px;
    margin-left: 8px;
    margin-bottom: 9px;
}

.btn.edit:hover { 
	background: var(--primary); 
    color: var(--primary-foreground); 
} 

.btn.delete:hover {
	background: var(--destructive);
    color: var(--destructive-foreground);
}

#saveRouteBtn {
	display: none;
}

.dong-del {
	cursor: pointer; 
	color: #9ca3af;       
	transition: color 0.2s, transform 0.2s;
}

.dong-del:hover {
	color: #dc2626;         
	transform: scale(1.2);  
}

#mappingList, #franchiseTable {
	font-size: 0.9rem;
}
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
					<sec:csrfInput/>
					<label>구역 이름</label> 
					<input type="text" id="regionName" name="regionName" placeholder="예: 1구역">
					<button type="submit" class="btn">구역 추가</button>
				</form>
				<h3>구역 목록</h3>
				<div id="regionList">
					<c:choose>
						<c:when test="${empty regionList}">
							<div>등록된 구역이 없습니다.</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="region" items="${regionList}">
								<div class="region-item" >
									<input class="region-name" value="${region.commonCodeName}"/>
								  	<div class="region-actions">
								    	<button type="button" class="btn edit" onclick="editRegion('${region.commonCodeIdx}', '${region.commonCodeName}')">
								    		<i class="fa-solid fa-pen"></i>
								    	</button>
								    	<button type="button" class="btn delete" onclick="deleteRegion('${region.commonCodeIdx}')">
								    		<i class="fa-solid fa-trash"></i>
								    	</button>
								  	</div>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			<!-- 2. 행정구역 매핑 -->
			<div class="region-card">
				<h2>구역 범위 등록</h2>
				<label>구역 선택</label> 
				<select id="regionSelect">
					<option value="" selected disabled>구역을 선택하세요</option>
					<c:forEach var="region" items="${regionList}">
						<option value="${region.commonCodeIdx}">${region.commonCodeName}</option>
					</c:forEach>
				</select> 
				
				<label>시/도</label>
				<select id="sidoSelect">
 					<option value="">-- 시/도 선택 --</option>
				</select> 
				
				<label>시군구</label> 
				<select id="sigunguSelect">
	 				<option value="">-- 시/도 선택 --</option>
				</select> 
				<label>동/리</label> 
				<select id="dongSelect">
 					<option value="">-- 시/도 선택 --</option>
				</select> 
				<button class="btn btn-primary" id="addMappingBtn">범위 추가</button>


				<h3>설정된 구역</h3>
				<table id="mappingList">
					<thead>
						<tr>
							<th>구역명</th>
							<th>시/도</th>
							<th>시군구</th>
							<th>동</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody id="mappingTable"></tbody>
				</table>
			</div>
			<!-- 3. 지점 순서 관리 -->
			<div class="region-card">
				<h2>지점 순서 관리</h2>
				<label>구역 선택</label> 
				<select id="routeRegionSelect">
					<option value="" selected disabled>구역을 선택하세요</option>
					<c:forEach var="region" items="${regionList}">
						<option value="${region.commonCodeName}" data-idx="${region.commonCodeIdx} }">${region.commonCodeName}</option>
					</c:forEach>
				</select>
				<table id="franchiseTable">
					<thead>
						<tr>
							<th>지점명</th>
							<th>순서</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
				<button class="btn btn-primary" id="saveRouteBtn" >순서 저장</button>
			</div>
		</div>
	</section>
</body>
</html>