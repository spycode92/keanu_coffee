<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로케이션생성</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style type="text/css">
		section {
		width: 1200px;
		margin: 0 auto;
	}
	form {
	
	}
	form > table{
/*  		border: 1px solid #fff;  */
 		padding: 50px; 
/* 		margin: 50px auto; */
		padding-left: 50px;
		width: 600px;
	
	}
	.radio-group {
	font-size: 12px;
	  display: flex;
	  gap: 20px; /* adds spacing between options */
	  align-items: center;
	  width: 100%;
	}

.radio-group label {
  display: flex;
  align-items: center;
/*   gap: 5px; /* spacing between label text and radio input */ */
}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	<section>
	<h4>로케이션생성</h4>
	
	
	<form class="card" method="post" enctype="multipart/form-data" id="writeForm">
		<sec:csrfInput/>	
	  <table>
	  	<tr>
	  		<td colspan="2">
				<h3 class="card-header">로케이션 생성</h3>
	  		</td>
	  	</tr>
	    <tr>
	      <td><label  class="form-label" for="racks">랙 수</label></td>
	      <td><input class="form-control" type="number" id="racks" name="racks" min="0" value="${warehouseInfo.rackCount}" required></td>
	    </tr>
	    <tr>
	      <td><label  class="form-label" for="bays">베이 수</label></td>
	      <td><input class="form-control" type="number" id="bays" name="bays" min="0" value="${warehouseInfo.bayCount}" required></td>
	    </tr>
	    <tr>
	      <td><label class="form-label" for="levels">레벨 수</label></td>
	      <td><input class="form-control" type="number" id="levels" name="levels" value="${warehouseInfo.levelCount}" min="0" required></td>
	    </tr>
	    <tr>
	      <td><label class="form-label" for="positions">레벨당 칸수</label></td>
	      <td><input class="form-control" type="number" id="positions" name="positions" value="${warehouseInfo.positionCount}" min="0" required></td>
	    </tr>
	    <tr>
	    	<td colspan="2">
				<h3 class="card-header">레벨의 크기</h3>
			<td>
		</tr>
	    <tr>  
	      <td><label class="form-label" for="width">가로길이(cm)</label></td>
	      <td><input class="form-control" type="number" id="width" name="width"  min="0" required></td>
	     </tr> 
	     <tr>
	      <td><label class="form-label" for="depth">세로길이(cm)</label></td>
	      <td><input class="form-control" type="number" id="depth" name="depth" min="0" required></td>
	   </tr> 
	   <tr>  
	      <td><label class="form-label" for="height">높이(cm)</label></td>
	      <td><input class="form-control" type="number" id="height" name="height"  min="0" required></td>
	    </tr>
<!-- 	    <tr> -->
<!-- 	      <td><label  class="form-label" for="reason">업데이트 사유</label></td> -->
<!-- 	      <td><textarea class="form-control" id="reason" name="reason" rows="4" cols="40" ></textarea></td> -->
<!-- 	    </tr> -->
	    <tr>
	    	<td>위치 유형</td>
	    	<td>
	    		<div class="radio-group">
		    		<label for="locationType">
			    	파레트존
			     	 <input  type="radio" name="locationType" value="1"  required>
			    	</label>
			    	<label for="locationType">
			    	피킹존
			     	 <input  type="radio" name="locationType" value="2" required>
			    	</label>
		    	</div>
	     	 </td>
	    </tr>
	    <tr>
	      <td colspan="2" style="text-align: center;"><br>
	        <button class="btn btn-primary" id="btnSubmit" >생성</button>
<!-- 	        <button class="btn btn-primary"  type="submit" formaction="/inventoryAction/edit-warehouse">수정</button> -->
	      </td>
	    </tr>
	  </table>
	</form>
	<script type="text/javascript">
		// 파일 전송을 위한 enctype="multipart/form-data" 지정 시 CSRF 토큰 전송 과정에서 인식이 불가능한 문제에 대한 해결책2)
		// AJAX 요청을 통해 POST 방식으로 요청 전송 시 CSRF 토큰값을 헤더에 포함시켜 전송하기
		$("#btnSubmit").on("click", function() {
			let form = $("#writeForm")[0]; // 폼 객체 가져오기
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
					location.href = "/inventory/updateWarehouse";
				},
				error: function(xhr, status, error) {
					console.log(error);
					alert("등록 실패!");
				}
			});
		});
	</script>
	
	  
	  
	  
<!-- 	  <form action="/update-structure" method="post"> -->
<!-- 	  <table> -->
<!-- 	    <tr> -->
<!-- 	      <td><label for="warehouse">Warehouse Name or ID</label></td> -->
<!-- 	      <td><input type="text" id="warehouse" name="warehouse" required></td> -->
<!-- 	    </tr> -->
<!-- 	    <tr> -->
<!-- 	      <td><label for="rack">Number of Racks</label></td> -->
<!-- 	      <td><input type="number" id="rack" name="rack" min="0" required></td> -->
<!-- 	    </tr> -->
<!-- 	    <tr> -->
<!-- 	      <td><label for="bay">Number of Bays per Rack</label></td> -->
<!-- 	      <td><input type="number" id="bay" name="bay" min="0" required></td> -->
<!-- 	    </tr> -->
<!-- 	    <tr> -->
<!-- 	      <td><label for="level">Number of Levels per Bay</label></td> -->
<!-- 	      <td><input type="number" id="level" name="level" min="0" required></td> -->
<!-- 	    </tr> -->
<!-- 	    <tr> -->
<!-- 	      <td><label for="boxes">Number of small boxes per level position</label></td> -->
<!-- 	      <td><input type="number" id="boxes" name="boxes" min="0" required></td> -->
<!-- 	    </tr> -->
<!-- 	    <tr> -->
<!-- 	      <td><label for="zone">Number of Picking Zones</label></td> -->
<!-- 	      <td><input type="number" id="zone" name="zone" min="0" required></td> -->
<!-- 	    </tr> -->
<!-- 	    <tr> -->
<!-- 	      <td><label for="reason">Reason for update</label></td> -->
<!-- 	      <td><textarea id="reason" name="reason" rows="4" cols="40" required></textarea></td> -->
<!-- 	    </tr> -->
<!-- 	    <tr> -->
<!-- 	      <td colspan="2" style="text-align: center;"> -->
<!-- 	        <button type="submit">Update Structure</button> -->
<!-- 	      </td> -->
<!-- 	    </tr> -->
<!-- 	  </table> -->
<!-- 	</form> -->
	  
	  
<!-- 	  <h2>특정 창고 위치 크기 업데이트</h2> -->
	  
<!-- 	  <form action="/update-structure" method="post"> -->
<!-- 	    <h3>update specific rack size</h3> -->
	    
<!-- 	    <label for="rack2">Rack: </label> -->
<!-- 	    <input id="rack2" type="text" maxlength="2"><br> -->
	    
<!-- 	    <label for="bay2">Updated Number of Bays in Rack</label> -->
<!-- 	    <input type="number" id="bay2" name="bay2" min="0" required> -->
<!-- 		<br><br> -->
		
<!-- 		<label> -->
<!-- 			pallet storage -->
<!-- 			<input id="palletStorage" type="radio" name="storageType"> -->
<!-- 			picking storage -->
<!-- 			<input id="pickingStorage" type="radio" name="storageType">  -->
<!-- 		</label> -->
<!-- 		<input type="submit">	     -->
<!-- 	   </form> -->
<!-- 	    <form action="/update-structure" method="post"> -->
<!-- 	    <h3>update specific bay size</h3> -->
<!-- 	    <label for="rack3">Rack: </label> -->
<!-- 	    <input id="rack3" type="text" maxlength="2"><br> -->
<!-- 	    <label for="bay3">Bay: </label> -->
<!-- 	    <input id="bay3" type="number" min="0" ><br> -->
	    
<!-- 	    <label for="level2">Updated Number of Levels in Bay</label> -->
<!-- 	    <input type="number" id="level2" name="level2" min="0" required> -->
<!-- 		<br><br> -->
<!-- 		<label> -->
<!-- 			pallet storage -->
<!-- 			<input id="palletStorage2" type="radio" name="storageType"> -->
<!-- 			picking storage -->
<!-- 			<input id="pickingStorage2" type="radio" name="storageType">  -->
<!-- 		</label> -->
<!-- 		<input type="submit">	     -->
<!-- 	   </form> -->
<!-- 	   <form action="/update-structure" method="post"> -->
<!-- 	    <h3>update specific level size</h3> -->
<!-- 	    <label for="rack4">Rack: </label> -->
<!-- 	    <input id="rack4" type="text" maxlength="2"><br> -->
<!-- 	    <label for="bay4">Bay: </label> -->
<!-- 	    <input id="bay4" type="number" min="0" ><br> -->
<!-- 	    <label for="level3">Level: </label> -->
<!-- 	    <input id="level3" type="text" min="0" ><br> -->
	    
<!-- 	    <label for="boxes">Updated Number of small boxes per level</label> -->
<!-- 	    <input type="number" id="boxes" name="level2" min="0" required> -->
<!-- 		<br><br> -->
		
<!-- 		<input type="submit">	     -->
<!-- 	   </form> -->
<!-- 	   <form class="card" action="/update-structure" method="post"> -->
<!-- 		  <h3 class="card-header">랙 크기 업데이트</h3> -->
<!-- 		  <table> -->
<!-- 		    <tr> -->
<!-- 		      <td><label  class="form-label" for="rack2">랙 번호</label></td> -->
<!-- 		      <td><input class="form-control" id="rack2" type="text" maxlength="2" required></td> -->
<!-- 		    </tr> -->
<!-- 		    <tr> -->
<!-- 		      <td><label  class="form-label" for="bay2">업데이트된 베이 수</label></td> -->
<!-- 		      <td><input class="form-control" type="number" id="bay2" name="bay2" min="0" required></td> -->
<!-- 		    </tr> -->
<!-- 		    <tr> -->
<!-- 		      <td>저장 유형</td> -->
<!-- 		      <td> -->
<!-- 		        <label  class="form-label"><input  id="palletStorage" type="radio" name="storageType"> 팔레트 저장</label><br> -->
<!-- 		        <label  class="form-label"><input id="pickingStorage" type="radio" name="storageType"> 피킹 저장</label> -->
<!-- 		      </td> -->
<!-- 		    </tr> -->
<!-- 		    <tr> -->
<!-- 		      <td colspan="2" style="text-align: center;"><br> -->
<!-- 		        <input class="btn btn-primary"  type="submit" value="업데이트"> -->
<!-- 		      </td> -->
<!-- 		    </tr> -->
<!-- 		  </table> -->
<!-- 		</form> -->
<!-- 		<form class="card" action="/update-structure" method="post"> -->
<!-- 		  <h3 class="card-header">베이 크기 업데이트</h3> -->
<!-- 		  <table> -->
<!-- 		    <tr> -->
<!-- 		      <td><label  class="form-label" for="rack3">랙 번호</label></td> -->
<!-- 		      <td><input class="form-control" id="rack3" type="text" maxlength="2" required></td> -->
<!-- 		    </tr> -->
<!-- 		    <tr> -->
<!-- 		      <td><label class="form-label" for="bay3">베이 번호</label></td> -->
<!-- 		      <td><input class="form-control" id="bay3" type="number" min="0" required></td> -->
<!-- 		    </tr> -->
<!-- 		    <tr> -->
<!-- 		      <td><label  class="form-label" for="level2">업데이트된 레벨 수</label></td> -->
<!-- 		      <td><input class="form-control" type="number" id="level2" name="level2" min="0" required></td> -->
<!-- 		    </tr> -->
<!-- 		    <tr> -->
<!-- 		      <td>저장 유형</td> -->
<!-- 		      <td> -->
<!-- 		        <label  class="form-label"><input id="palletStorage2" type="radio" name="storageType"> 팔레트 저장</label><br> -->
<!-- 		        <label  class="form-label"><input id="pickingStorage2" type="radio" name="storageType"> 피킹 저장</label> -->
<!-- 		      </td> -->
<!-- 		    </tr> -->
<!-- 		    <tr> -->
<!-- 		      <td colspan="2" style="text-align: center;"><br> -->
<!-- 		        <input class="btn btn-primary"  type="submit" value="업데이트"> -->
<!-- 		      </td> -->
<!-- 		    </tr> -->
<!-- 		  </table> -->
<!-- 		</form> -->
<!-- 		<form class="card" action="/update-structure" method="post"> -->
<!-- 		  <h3 class="card-header">레벨 크기 업데이트</h3> -->
<!-- 		  <table> -->
<!-- 		    <tr> -->
<!-- 		      <td><label  class="form-label" for="rack4">랙 번호</label></td> -->
<!-- 		      <td><input class="form-control" id="rack4" type="text" maxlength="2" required></td> -->
<!-- 		    </tr> -->
<!-- 		    <tr> -->
<!-- 		      <td><label  class="form-label" for="bay4">베이 번호</label></td> -->
<!-- 		      <td><input class="form-control" id="bay4" type="number" min="0" required></td> -->
<!-- 		    </tr> -->
<!-- 		    <tr> -->
<!-- 		      <td><label  class="form-label" for="level3">레벨 번호</label></td> -->
<!-- 		      <td><input class="form-control" id="level3" type="text" required></td> -->
<!-- 		    </tr> -->
<!-- 		    <tr> -->
<!-- 		      <td><label  class="form-label" for="boxes">업데이트된 소형 박스 수</label></td> -->
<!-- 		      <td><input class="form-control" type="number" id="boxes" name="boxes" min="0" required></td> -->
<!-- 		    </tr> -->
<!-- 		    <tr> -->
<!-- 		      <td colspan="2" style="text-align: center;"><br> -->
<!-- 		        <input class="btn btn-primary"  type="submit" value="업데이트"> -->
<!-- 		      </td> -->
<!-- 		    </tr> -->
<!-- 		  </table> -->
<!-- 		</form> -->
	
	  
<!-- 	</section> -->
</body>
</html>