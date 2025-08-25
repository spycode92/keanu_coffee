<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자페이지 - 직원관리</title>

<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/admin/employee_management.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
<jsp:include page="/WEB-INF/views/admin/employee_modal/add_employee.jsp"></jsp:include> 
<jsp:include page="/WEB-INF/views/admin/employee_modal/detail_employee.jsp"></jsp:include> 
<section class="content">
	<h4>직원 관리</h4>
	<div style="display: flex; align-items: center; gap: 8px; width: 35%">
		<div style="display: flex; align-items: center; gap: 8px; width: 35%;">
 			<form action="/admin/employeeManagement" style="display: flex; align-items: center; gap: 8px; width: 100%;">
 				<select name="searchType">
					<option <c:if test="${searchType eq '이름' }">selected</c:if>> 이름</option>
					<option <c:if test="${searchType eq '사번' }">selected</c:if>>사번</option>
					<option <c:if test="${searchType eq '아이디' }">selected</c:if>>아이디</option>
				</select>
				<input class="form-control" placeholder="텍스트 입력" name="searchKeyword" style="width:200px;">
				<input type="submit" value="검색" class="btn btn-sm btn-primary">
			</form>
		</div>
	</div>
    <div class="table-responsive mt-3" >
		
		<table class="table table-striped table-bordered" >
			<tr>
				<th data-key="e.emp_name" onclick="allineTable(this)">이름↕</th>
				<th >성별</th>
				<th data-key="e.emp_no" onclick="allineTable(this)">사번↕</th>
				<th data-key="c.common_code_name" onclick="allineTable(this)">부서명↕</th>
				<th data-key="t.team_name" onclick="allineTable(this)">팀명↕</th>
				<th data-key="r.role_name" onclick="allineTable(this)">직급↕</th>
				<th>번호</th>
				<th>이메일</th>
				<th data-key="e.hire_date" onclick="allineTable(this)">입사일↕</th>
			</tr>
			<c:forEach var="employee" items="${employeeList }">
				<tr class="employee-row" data-emp-idx="${employee.empIdx}">
					<td>${employee.empName }</td>
					<td>${employee.empGender }</td>
					<td>${employee.empNo }</td>
					<td>${employee.commonCode.commonCodeName }</td>
					<td>${employee.team.teamName }</td>
					<td>${employee.role.roleName }</td>
					<td>${employee.empPhone }</td>
					<td>${employee.empEmail }</td>
					<td>${employee.hireDate }</td>
				</tr>
			</c:forEach>
			
			<tr>
				<td colspan="9" style="text-align: center; ">
					<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
						<input type="button" value="이전" 
							onclick="location.href='/admin/employeeManagement?pageNum=${pageInfo.pageNum - 1}&filter=${param.filter}&searchType=${param.searchType }&searchKeyword=${param.searchKeyword}'" 
							<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
						
						<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
							<c:choose>
								<c:when test="${i eq pageInfo.pageNum}">
									<strong>${i}</strong>
								</c:when>
								<c:otherwise>
									<a href="/admin/employeeManagement?pageNum=${i}&filter=${param.filter}&searchType=${param.searchType }&searchKeyword=${param.searchKeyword}">${i}</a>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						
						<input type="button" value="다음" 
							onclick="location.href='/admin/employeeManagement?pageNum=${pageInfo.pageNum + 1}&filter=${param.filter}&searchType=${param.searchType }&searchKeyword=${param.searchKeyword}'" 
						<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
					</c:if>
				
					<div style="text-align: right;">
						<input type="button" value="직원추가" id="addEmployee" class="btn btn-primary" data-target="#addEmployeeModal">
					</div>
				</td>
			</tr>
			
					
		</table>
	</div>

</section>
	
	</div>

</body>
</html>