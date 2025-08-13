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

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
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
	
	<table class="table" style="color:green;">
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
	<script type="text/javascript">
		$("#addEmployee").click(function(){
			window.open(
			"/admin/employeeManagement/addEmployeeForm", // 매핑 주소
	        "addEmployeePopup",  // 팝업 이름
	        "width=500,height=500,top=100,left=100"  // 크기와 위치
	        );
		});


	$(document).ready(function(){
	    // 헤더 제외, 데이터 있는 tr에 클릭 이벤트
	    $(".table tr").not(":first").click(function(){
	        let tds = $(this).find("td");
	
	        // td 순서대로 값 가져와서 모달에 넣기
	        $("#empName").text(tds.eq(0).text());
	        $("#empNo").text(tds.eq(1).text());
	        $("#empId").text(tds.eq(2).text());
	        $("#empDept").text(tds.eq(3).text());
	        $("#empRank").text(tds.eq(4).text());
	        $("#empPhone").text(tds.eq(5).text());
	        $("#empEmail").text(tds.eq(6).text());
	        $("#empHireDate").text(tds.eq(7).text());
	
	        // 모달 띄우기
	        $("#employeeModal").modal("show");
	    });
	});
	</script>
	</div>

</body>
</html>