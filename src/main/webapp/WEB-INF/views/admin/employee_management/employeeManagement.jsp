<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" >
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	</header>
	<h1>
		직원관리 메인페이지
	</h1>
	<input type="button" value="직원추가" id="addEmployee">
	
	<footer>
<%-- 		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>  --%>
	</footer>
	<script type="text/javascript">
		$("#addEmployee").click(function(){
			window.open(
			"/admin/employeeManagement/addEmployeeForm", // 매핑 주소
	        "addEmployeePopup",  // 팝업 이름
	        "width=500,height=500,top=100,left=100"  // 크기와 위치
	        );
		});
	</script>

</body>
</html>