<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style type="text/css">
		section {
		width: 1200px;
		margin: 0 auto;
	}
	form {
	
	}
	form > table{
 		border: 1px solid #fff; 
 		padding: 50px; 
/* 		margin: 50px auto; */
		padding-left: 50px;
		width: 600px;
	
	}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	<section>
	<h1>창고 위치 치수 변경</h1>
	
	<h2>기본 창고 구조 업데이트</h2>
			<form action="/update-structure" method="post">
  <table>
    <tr>
      <td><label  class="form-label" for="warehouse">창고 이름 또는 ID</label></td>
      <td><input  class="form-control" type="text" id="warehouse" name="warehouse" required></td>
    </tr>
    <tr>
      <td><label  class="form-label" for="rack">랙 수</label></td>
      <td><input class="form-control" type="number" id="rack" name="rack" min="0" required></td>
    </tr>
    <tr>
      <td><label  class="form-label" for="bay">랙당 베이 수</label></td>
      <td><input class="form-control" type="number" id="bay" name="bay" min="0" required></td>
    </tr>
    <tr>
      <td><label class="form-label" for="level">베이당 레벨 수</label></td>
      <td><input class="form-control" type="number" id="level" name="level" min="0" required></td>
    </tr>
    <tr>
      <td><label  class="form-label" for="boxes">레벨 위치당 소형 박스 수</label></td>
      <td><input class="form-control" type="number" id="boxes" name="boxes" min="0" required></td>
    </tr>
    <tr>
      <td><label  class="form-label" for="zone">피킹 존 수</label></td>
      <td><input class="form-control" type="number" id="zone" name="zone" min="0" required></td>
    </tr>
    <tr>
      <td><label  class="form-label" for="reason">업데이트 사유</label></td>
      <td><textarea class="form-control" id="reason" name="reason" rows="4" cols="40" required></textarea></td>
    </tr>
    <tr>
      <td colspan="2" style="text-align: center;"><br>
        <button class="btn btn-primary"  type="submit">구조 업데이트</button>
      </td>
    </tr>
  </table>
</form>
	
	  
	  
	  
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
	  
	  
	  <h2>특정 창고 위치 크기 업데이트</h2>
	  
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
	   <form action="/update-structure" method="post">
		  <h3>랙 크기 업데이트</h3>
		  <table>
		    <tr>
		      <td><label  class="form-label" for="rack2">랙 번호</label></td>
		      <td><input class="form-control" id="rack2" type="text" maxlength="2" required></td>
		    </tr>
		    <tr>
		      <td><label  class="form-label" for="bay2">업데이트된 베이 수</label></td>
		      <td><input class="form-control" type="number" id="bay2" name="bay2" min="0" required></td>
		    </tr>
		    <tr>
		      <td>저장 유형</td>
		      <td>
		        <label  class="form-label"><input  id="palletStorage" type="radio" name="storageType"> 팔레트 저장</label><br>
		        <label  class="form-label"><input id="pickingStorage" type="radio" name="storageType"> 피킹 저장</label>
		      </td>
		    </tr>
		    <tr>
		      <td colspan="2" style="text-align: center;"><br>
		        <input class="btn btn-primary"  type="submit" value="업데이트">
		      </td>
		    </tr>
		  </table>
		</form>
		<form action="/update-structure" method="post">
		  <h3>베이 크기 업데이트</h3>
		  <table>
		    <tr>
		      <td><label  class="form-label" for="rack3">랙 번호</label></td>
		      <td><input class="form-control" id="rack3" type="text" maxlength="2" required></td>
		    </tr>
		    <tr>
		      <td><label class="form-label" for="bay3">베이 번호</label></td>
		      <td><input class="form-control" id="bay3" type="number" min="0" required></td>
		    </tr>
		    <tr>
		      <td><label  class="form-label" for="level2">업데이트된 레벨 수</label></td>
		      <td><input class="form-control" type="number" id="level2" name="level2" min="0" required></td>
		    </tr>
		    <tr>
		      <td>저장 유형</td>
		      <td>
		        <label  class="form-label"><input id="palletStorage2" type="radio" name="storageType"> 팔레트 저장</label><br>
		        <label  class="form-label"><input id="pickingStorage2" type="radio" name="storageType"> 피킹 저장</label>
		      </td>
		    </tr>
		    <tr>
		      <td colspan="2" style="text-align: center;"><br>
		        <input class="btn btn-primary"  type="submit" value="업데이트">
		      </td>
		    </tr>
		  </table>
		</form>
		<form action="/update-structure" method="post">
		  <h3>레벨 크기 업데이트</h3>
		  <table>
		    <tr>
		      <td><label  class="form-label" for="rack4">랙 번호</label></td>
		      <td><input class="form-control" id="rack4" type="text" maxlength="2" required></td>
		    </tr>
		    <tr>
		      <td><label  class="form-label" for="bay4">베이 번호</label></td>
		      <td><input class="form-control" id="bay4" type="number" min="0" required></td>
		    </tr>
		    <tr>
		      <td><label  class="form-label" for="level3">레벨 번호</label></td>
		      <td><input class="form-control" id="level3" type="text" required></td>
		    </tr>
		    <tr>
		      <td><label  class="form-label" for="boxes">업데이트된 소형 박스 수</label></td>
		      <td><input class="form-control" type="number" id="boxes" name="boxes" min="0" required></td>
		    </tr>
		    <tr>
		      <td colspan="2" style="text-align: center;"><br>
		        <input class="btn btn-primary"  type="submit" value="업데이트">
		      </td>
		    </tr>
		  </table>
		</form>
	
	  
	</section>
</body>
</html>