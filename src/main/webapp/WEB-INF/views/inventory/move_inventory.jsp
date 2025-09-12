<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style>
	section {
		width: 1200px;
		margin: 0 auto;
	}
	form {
		margin-top: 50px;
	
	}
	table {
/* 		border: 1px solid #fff; */
		padding: 50px;
		width: 500px;
	
	}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	<section>
		
		
<!-- 		<form action="/inventory/updateInventory" method="post"> -->
<!-- 			<p>직원 ID: John</p> -->
<!-- 			<input type="text" name="employee_id" value="John" hidden><br> -->
<!-- 			<label for="inventoryId">재고 ID</label> -->
<!-- 			<input id="inventoryID" type="text" name="inventoryId"><br> -->
			
<!-- 			<label for="qtyMoving">이동할 양</label> -->
<!-- 			<input id="qtyMoving" type="number" name="qtyMoving" min="0"><br> -->
			
			
<!-- 			<select> -->
<!-- 				<option value="">목적지</option> -->
<!-- 				<option> -->
<%-- 			 <c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				 팔레트 보관</option> -->
<!-- 				<option > -->
<%-- 			<c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				저장 선택</option> -->
<!-- 				<option > -->
<%-- 			<c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				포장 구역</option> -->
<!-- 				<option > -->
<%-- 			<c:if test="${param. eq '최신'}">selected</c:if> value="최신"> --%> 
<!-- 				쓰레기통</option> -->
<!-- 			</select> -->
<!-- 			<input type="submit"> -->
<!-- 		</form> -->
			<form class="card" action="/inventory/moveInventory" method="post" enctype="multipart/form-data" id="form">
				<sec:csrfInput/>
				<h1 class="card-header">재고를 옮기다</h1>
			  <table>
			    <tr>
			      <td class="form-label">직원 ID:</td>
			      <td>
			        <sec:authentication property="principal.name" />
			        <input type="text" name="employee_id" value="principal.name" hidden>
			      </td>
			    </tr>
			    <tr>
			      <td><label class="form-label" for="inventoryId">재고 ID</label></td>
			      <td><input class="form-control" id="inventoryID" type="text" name="inventoryId" required></td>
			    </tr>
			    <tr>
			      <td><label class="form-label"  for="qtyMoving">이동할 양</label></td>
			      <td><input class="form-control" id="qtyMoving" type="number" name="qtyMoving" min="0" required></td>
			    </tr>
			    <tr>
			      <td><label class="form-label"  for="moveType">이동 유형</label></td>
			      <td>
			      	<label>
				      픽업
				      <input class="form-control" id="moveType" type="radio" name="moveType" value="pickUp" required>
			     	 </label>
			      	 <label>
				      배치하다
				      <input class="form-control"  type="radio" name="moveType" value="putDown" required>
			       </label>
				  </td>
			    </tr>
			    <tr>
			      <td><label class="form-label"  for="destinationType">목적지</label></td>
			      <td>
			        <select class="form-control" id="destinationType" name="destinationType" required>
			          <option value="">목적지를 선택하세요</option>
			          <option value="팔레트 보관">팔레트 죤</option>
			          <option value="저장 선택">피킹 죤</option>
<!-- 			          <option value="포장 구역">포장 구역</option> -->
			        </select>
			      </td>
			    </tr>
			 
			    <tr>
			      <td><label class="form-label" for="destinationName">목적지 이름(아이템을 배치하는 경우)</label></td>
			      <td><input class="form-control" id="destinationName" type="text" name="destinationName" ></td>
			    </tr>
			    
			    <tr>
			      <td colspan="2" style="text-align: center;"><br>
			        <button class="btn btn-primary"  type="submit" id="btnSubmit">업데이트</button>
			      </td>
			    </tr>
			</table>
		</form>

	</section>
	<script type="text/javascript">
		// 파일 전송을 위한 enctype="multipart/form-data" 지정 시 CSRF 토큰 전송 과정에서 인식이 불가능한 문제에 대한 해결책2)
		// AJAX 요청을 통해 POST 방식으로 요청 전송 시 CSRF 토큰값을 헤더에 포함시켜 전송하기
		$("#btnSubmit").on("click", function() {
			let form = $("#form")[0]; // 폼 객체 가져오기
			let formData = new FormData(form); // 해당 폼을 전송 가능한 FormData 객체 형태로 생성
			
			// CSRF 토큰 가져오기
// 			const csrfToken = $("input[name='_csrf']").val();
			const csrfToken = "${_csrf.token}";
// 			console.log("csrfToken : " + csrfToken);
			
			$.ajax({
				url: "/inventoryAction/create-warehouse",
				type: "POST",
				data: formData,
				dataType: "json", // 응답데이터 형식을 JSON 으로 지정
				processData: false, // 전송되는 데이터를 별도의 처리없이 그대로 전송
				contentType: false, // multipart/form-data 형식 설정
				// CSRF 토큰값을 헤더에 포함시키는 방법
				// 1) headers 속성 활용
// 				headers: {
// 					"X-CSRF-TOKEN": csrfToken
// 				},
				// 2) beforeSend 속성 활용 => 함수를 가질 수 있으므로 부가적인 처리도 가능
				beforeSend: function(xhr) {
					xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
				},
				success: function(response) {
					console.log(response);
					alert("등록 완료!");
					location.href = "/inventory/moveInventory";
				},
				error: function(xhr, status, error) {
					console.log(error);
					alert("등록 실패!");
				}
			});
		});
	</script>
</body>
</html>