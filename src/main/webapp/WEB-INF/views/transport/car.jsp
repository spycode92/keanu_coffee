<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운송관리대시보드</title>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style type="text/css">
.container {
	max-width:1264px; 
	margin:0 auto; 
	padding:0 16px;
}

 /* 검색/필터 바 */
.filters {
	background:var(--card); 
	border:1px solid var(--border); 
	border-radius:12px; 
	padding:12px; 
	display:grid; 
	grid-template-columns:repeat(3, minmax(200px, 1fr)); 
	gap:10px;
}
.filters .field {
	display:flex; 
	flex-direction:column; 
	gap:6px
}
.filters .search {
	display:flex; 
	flex-direction:column; 
	gap:6px
}

.search {
	width: 500px;
}

.filters label {
	font-size:.85rem; 
	color:var(--muted)
}

.filters input,.filters select {
	height:38px; 
	padding:0 10px; 
	border:1px solid var(--border); 
	border-radius:10px; 
	background:#fff
}
 
.filters .actions {
	display:flex; 
	align-items:end;
	justify-content: center;
	gap:8px
}

.badge {
	display:inline-block; 
	padding:2px 8px; 
	border-radius:999px; 
	font-size:.8rem; 
	font-weight:700
}

.badge.wait { /* 대기 */
	background:#e5e7eb; 
	color:#111827
}     

.badge.run { /* 운행중 */
	background:#dbeafe; 
	color:#1e40af
}      

.badge.left { /* 퇴사 */
	background:#fee2e2; 
	color:#991b1b
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
<section class="container">
	<h1>차량관리</h1>
	<div>
		<section class="filters" aria-label="검색 및 필터">
	    		<div class="field">
	        		<select id="filterStatus">
	          			<option value="">전체</option>
	          			<option value="대기">대기</option>
	          			<option value="운행중">운행중</option>
	        		</select>
	      		</div>
		        <div class="search">
		        	<input id="filterName" type="text" placeholder="차량번호/적재량 검색 가능" />
		        </div>
		        <div class="actions">
		        	<button class="btn secondary" id="resetBtn">초기화</button>
		        	<button class="btn" id="searchBtn">검색</button>
		        </div>
    	</section>
		<div>
			<h3>차량목록</h3>
			<table class="table">
				<thead>
					<tr>
						<th></th>
						<th>이름</th>
						<th>연락처</th>
						<th>면허만료일</th>
						<th>차량번호</th>
						<th>적재량</th>
						<th>상태</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><input type="checkbox"/></td>
						<td>김배송</td>
						<td>010-0000-0000</td>
						<td>2026-12-31</td>
						<td>89바 1234</td>
						<td>1.5t</td>
						<td><span class="badge run">운행중</span></td>
					</tr>
					<tr>
						<td><input type="checkbox"/></td>
						<td>김배송</td>
						<td>010-0000-0000</td>
						<td>2026-12-31</td>
						<td>89바 1234</td>
						<td>1.5t</td>
						<td><span class="badge wait">대기중</span></td>
					</tr>
					<tr>
						<td><input type="checkbox"/></td>
						<td>김배송</td>
						<td>010-0000-0000</td>
						<td>2026-12-31</td>
						<td>89바 1234</td>
						<td>1.5t</td>
						<td><span class="badge run">운행중</span></td>
					</tr>
					<tr>
						<td><input type="checkbox"/></td>
						<td>김배송</td>
						<td>010-0000-0000</td>
						<td>2026-12-31</td>
						<td>89바 1234</td>
						<td>1.5t</td>
						<td><span class="badge left">퇴사</span></td>
					</tr>
				</tbody>
			</table>
		</div>
	
	</div>
		
</section>

</body>
</html>