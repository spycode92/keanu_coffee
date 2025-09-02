<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자페이지 - 직원관리</title>
<style type="text/css">
/* 검색/필터 바 */
.filters {
	width: 70em;
   
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 12px;
    display: grid;
    grid-template-columns: 180px 1fr max-content;
    gap: 10px;
    align-items: center; /* 세로 중앙 */
}
/* 고정폭 제거 → 그리드가 폭을 관리하도록 */
.filters .field{ display:flex; gap:6px; margin-right: 1.5em;}
.filters select{ width:100%; height:38px; }
.filters .search{ display:flex; }
.filters input{ width:100%; height:38px; }

.filters input, .filters select{
  padding:0 10px; border:1px solid var(--border); border-radius:10px; background:#fff;
}

/* 버튼은 오른쪽 끝 */
.filters .actions{
	display:flex; 
	width: 100%;
	justify-content:center; 
	align-items:center;
}
.filters .actions .btn{ 
	height:38px; 
	width: 10em;
	display: flex;
	justify-content: center;
}

/* 반응형: 좁아지면 세로 스택 */
@media (max-width: 900px){
  .filters{ grid-template-columns: 1fr; }
  .filters .actions{ justify-content: stretch; }
  .filters .actions .btn{ width:100%; }
}
/* 페이징(.pager: 앞서 만든 공용 클래스가 있다면 그대로 사용) */
.pager{
  	display:flex;
  	align-items:center;
  	justify-content:center;
  	margin-top:24px; /* 기존 30px에서 약간 컴팩트 */
}
.pager > div{
  	display:flex;
  	align-items:center;
  	flex-wrap:wrap;
  	gap:8px;
}
.pager > div a,
.pager > div input[type="button"],
.pager > div strong{
	display:inline-flex;
  	align-items:center;
  	justify-content:center;
  	min-width:36px;
  	height:36px;
  	padding:0 12px;
  	border:1px solid #cbd5e1;
  	border-radius:8px;
  	background:#fff;
  	color:#0f172a;
  	text-decoration:none;
  	font-size:.95rem;
  	line-height:1;
  	transition:background .12s ease, border-color .12s ease, color .12s ease, box-shadow .12s ease;
}
.pager > div a:hover,
.pager > div input[type="button"]:not([disabled]):hover{ background:#f8fafc; border-color:#94a3b8; }
.pager > div input[disabled]{ opacity:.45; pointer-events:none; cursor:not-allowed; }
.pager > div strong{
  background:#2563eb; border-color:#2563eb; color:#fff; cursor:default;
}

/* 반응형 */
@media (max-width: 900px){
  .filters{ grid-template-columns: 1fr; }
  .filters .actions .btn{ width:100%; }
}
@media (max-width: 640px){
  .pager > div a,
  .pager > div input[type="button"],
  .pager > div strong{
    min-width:32px; height:32px; padding:0 10px; font-size:.9rem;
}
   </style>
<!-- 기본 양식 -->
<sec:csrfMetaTags/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/resources/js/admin/employee_management.js"></script>
</head>

<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
<jsp:include page="/WEB-INF/views/admin/employee_modal/add_employee.jsp"></jsp:include> 
<jsp:include page="/WEB-INF/views/admin/employee_modal/detail_employee.jsp"></jsp:include> 
<jsp:include page="/WEB-INF/views/admin/employee_modal/modify_employee.jsp"></jsp:include> 
<section class="content">
	<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
		<h4>직원 관리</h4>
		<input type="button" value="직원추가" id="addEmployee" class="btn btn-primary" data-target="#addEmployeeModal">
	</div>
		<form class="filters" aria-label="검색 및 필터">
			<div class="field">
				<select id="filterStatus" name="searchType">
					<option <c:if test="${searchType eq '이름' }">selected</c:if>> 이름</option>
					<option <c:if test="${searchType eq '사번' }">selected</c:if>>사번</option>
				</select>
			</div>
			<div class="search">
				<input class="filterText" placeholder="텍스트 입력" name="searchKeyword" >
			</div>
			<div class="actions">
				<input type="submit" value="검색" class="btn btn-sm btn-primary">
			</div>
		</form>
    	<div class="table-responsive mt-3" >
		
			<table class="table table-striped table-bordered" >
				<tr>
					<c:if test="${param.orderKey eq e.emp_name }"></c:if>
					<th data-key="e.emp_name" onclick="allineTable(this)">
						이름
						<c:choose>
							<c:when test="${param.orderKey eq 'e.emp_name'}">
								<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
								<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
							</c:when>
							 <c:otherwise>
								↕
							 </c:otherwise>
						</c:choose>
					</th>
					<th >성별</th>
					<th data-key="e.emp_no" onclick="allineTable(this)">
						사번
						<c:choose>
							<c:when test="${param.orderKey eq 'e.emp_no'}">
								<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
								<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
							</c:when>
							 <c:otherwise>
								↕
							 </c:otherwise>
						</c:choose>
					</th>
					<th data-key="c.common_code_name" onclick="allineTable(this)">
						부서
						<c:choose>
							<c:when test="${param.orderKey eq 'c.common_code_name'}">
								<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
								<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
							</c:when>
							 <c:otherwise>
								↕
							 </c:otherwise>
						</c:choose>
					</th>
					<th data-key="t.team_name" onclick="allineTable(this)">
						팀명
						<c:choose>
							<c:when test="${param.orderKey eq 't.team_name'}">
								<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
								<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
							</c:when>
							 <c:otherwise>
								↕
							 </c:otherwise>
						</c:choose>
					</th>
					<th data-key="r.role_name" onclick="allineTable(this)">
					직급
						<c:choose>
							<c:when test="${param.orderKey eq 'r.role_name'}">
								<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
								<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
							</c:when>
							 <c:otherwise>
								↕
							 </c:otherwise>
						</c:choose>
					</th>
					<th>번호</th>
					<th>이메일</th>
					<th data-key="e.hire_date" onclick="allineTable(this)">
						입사일
						<c:choose>
							<c:when test="${param.orderKey eq 'e.hire_date'}">
								<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
								<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
							</c:when>
							 <c:otherwise>
								↕
							 </c:otherwise>
						</c:choose>
					</th>
					<th data-key="e.emp_status" onclick="allineTable(this)">
					상태
						<c:choose>
							<c:when test="${param.orderKey eq 'e.emp_status'}">
								<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
								<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
							</c:when>
							 <c:otherwise>
								↕
							 </c:otherwise>
						</c:choose>
					</th>
				</tr>
				<c:forEach var="employee" items="${employeeList }">
					<tr class="employee-row" data-emp-idx="${employee.empIdx}">
						<td>${employee.empName }</td>
						<td>${employee.empGender }</td>
						<td>${employee.empNo }</td>
						<td>
							${empty employee.commonCode.commonCodeName ?
								 '미배정' : employee.commonCode.commonCodeName }
						</td>
						<td>
							${empty employee.team.teamName ?
								'미배정' : employee.team.teamName }
						</td>
						<td>
							${empty employee.role.roleName ?
								'미배정' : employee.role.roleName }
						</td>
						<td>${employee.empPhone }</td>
						<td>${employee.empEmail }</td>
						<td>${employee.hireDate }</td>
						<td>${employee.empStatus }</td>
					</tr>
				</c:forEach>
				</table>

 				<div class="pager">
					<div>
						<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
							<input type="button" value="이전" 
								onclick="location.href='/admin/employeeManagement?pageNum=${pageInfo.pageNum - 1}&filter=${param.filter}&searchType=${param.searchType }&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod${param.orderMethod}'" 
								<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
							
							<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
								<c:choose>
									<c:when test="${i eq pageInfo.pageNum}">
										<strong>${i}</strong>
									</c:when>
									<c:otherwise>
										<a href="/admin/employeeManagement?pageNum=${i}&filter=${param.filter}&searchType=${param.searchType }&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod${param.orderMethod}">${i}</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							
							<input type="button" value="다음" 
								onclick="location.href='/admin/employeeManagement?pageNum=${pageInfo.pageNum + 1}&filter=${param.filter}&searchType=${param.searchType }&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod${param.orderMethod}'" 
							<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
						</c:if>
					</div>
				</div>
				
						
		</div>

	</section>
	
</div>

</body>
</html>