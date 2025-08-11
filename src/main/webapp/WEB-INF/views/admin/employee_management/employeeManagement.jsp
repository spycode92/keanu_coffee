<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
<section class="content">
	<div style="display: flex; align-items: center; gap: 8px; width: 35%">
		<select>
			<option>이름</option>
			<option>사번</option>
			<option>아이디</option>
		</select>
		<input class="form-control" placeholder="텍스트 입력">
		<input type="button" value="검색" class="btn btn-sm btn-primary">
	</div>
	
	<table class="table">
		<tr>
			<th>이름↕</th>
			<th>사번↕</th>
			<th>아이디</th>
			<th>부서명↕</th>
			<th>직급↕</th>
			<th>번호</th>
			<th>이메일</th>
			<th>입사일↕</th>
		</tr>
		<tr>
			<td>김갑수</td>
			<td>2010302029</td>
			<td>2010302029</td>
			<td>입고</td>
			<td>관리자</td>
			<td>010-3333-3333</td>
			<td>kimgs@gmail.com</td>
			<td>2022-03-13</td>
		</tr>
		<tr>
			<td>김갑수</td>
			<td>2010302029</td>
			<td>2010302029</td>
			<td>입고</td>
			<td>관리자</td>
			<td>010-3333-3333</td>
			<td>kimgs@gmail.com</td>
			<td>2022-03-13</td>
		</tr>
		<tr>
			<td>김갑수</td>
			<td>2010302029</td>
			<td>2010302029</td>
			<td>입고</td>
			<td>관리자</td>
			<td>010-3333-3333</td>
			<td>kimgs@gmail.com</td>
			<td>2022-03-13</td>
		</tr>
		<tr>
			<td>김갑수</td>
			<td>2010302029</td>
			<td>2010302029</td>
			<td>입고</td>
			<td>관리자</td>
			<td>010-3333-3333</td>
			<td>kimgs@gmail.com</td>
			<td>2022-03-13</td>
		</tr>
		<tr>
			<td>김갑수</td>
			<td>2010302029</td>
			<td>2010302029</td>
			<td>입고</td>
			<td>관리자</td>
			<td>010-3333-3333</td>
			<td>kimgs@gmail.com</td>
			<td>2022-03-13</td>
		</tr>
		<tr>
			<td>김갑수</td>
			<td>2010302029</td>
			<td>2010302029</td>
			<td>입고</td>
			<td>관리자</td>
			<td>010-3333-3333</td>
			<td>kimgs@gmail.com</td>
			<td>2022-03-13</td>
		</tr>
		<tr>
			<td colspan="7" style="text-align: center; ">
				이전 1 2 3 4 ..다음
			</td>
			<td>
				<div style="text-align: right;">
					<input type="button" value="직원추가" id="addEmployee" class="btn btn-primary">
				</div>
			</td>
		</tr>
		
				
	</table>
	
</section>
	<script type="text/javascript">
		$("#addEmployee").click(function(){
			window.open(
			"/admin/employeeManagement/addEmployeeForm", // 매핑 주소
	        "addEmployeePopup",  // 팝업 이름
	        "width=500,height=500,top=100,left=100"  // 크기와 위치
	        );
		});
	</script>
	</div>

</body>
</html>