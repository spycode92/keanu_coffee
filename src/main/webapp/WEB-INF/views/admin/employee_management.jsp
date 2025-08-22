<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<style type="text/css">
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

body {
color : black;
}

</style>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/admin/employee_management.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
<jsp:include page="/WEB-INF/views/admin/employee_modal/add_employee.jsp"></jsp:include> 
<section class="content">
	<div style="display: flex; align-items: center; gap: 8px; width: 35%">
		<form action="/admin/employeeManagement">
			<select name="searchType">
				<option <c:if test="${searchType eq '이름' }">selected</c:if>> 이름</option>
				<option <c:if test="${searchType eq '사번' }">selected</c:if>>사번</option>
				<option <c:if test="${searchType eq '아이디' }">selected</c:if>>아이디</option>
			</select>
			<input class="form-control" placeholder="텍스트 입력" name="searchKeyword">
			<input type="submit" value="검색" class="btn btn-sm btn-primary">
		</form>
	</div>
    <div class="table-responsive mt-3" >
		
		<table class="table table-striped table-bordered" style="color:green;">
			<tr>
				<th data-key="emp_name" onclick="allineTable(this)">이름↕</th>
				<th >성별</th>
				<th data-key="emp_no" onclick="allineTable(this)">사번↕</th>
				<th>아이디</th>
				<th data-key="department_name" onclick="allineTable(this)">부서명↕</th>
				<th data-key="role_name" onclick="allineTable(this)">직급↕</th>
				<th>번호</th>
				<th>이메일</th>
				<th>입사일↕</th>
			</tr>
			<c:forEach var="employee" items="${employeeList }">
				<tr>
					<td>${employee.empName }</td>
					<td>${employee.empGender }</td>
					<td>${employee.empNo }</td>
					<td>${employee.empId }</td>
					<td>${employee.departmentName }</td>
					<td>${employee.roleName }</td>
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
	<!-- 모달 -->
<div class="modal fade" id="employeeModal" tabindex="-1" role="dialog" aria-labelledby="employeeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="employeeModalLabel">직원 정보</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" style="background-color: gray;">
          <p><b>이름:</b> <span id="empName"></span></p>
          <p><b>사번:</b> <span id="empNo"></span></p>
          <p><b>아이디:</b> <span id="empId"></span></p>
          <p><b>부서:</b> <span id="empDept"></span></p>
          <p><b>직급:</b> <span id="empRank"></span></p>
          <p><b>번호:</b> <span id="empPhone"></span></p>
          <p><b>이메일:</b> <span id="empEmail"></span></p>
          <p><b>입사일:</b> <span id="empHireDate"></span></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="text-align: left;">비밀번호초기화</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">수정</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">삭제</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
	
</section>
	
	</div>

</body>
</html>