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
<!-- 기본양식 -->
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 


<section class="content">
  <h1>메인페이지</h1>
</section>









<script>
$("#adminPage").click(function(){
  location.href="/admin/main";
});
</script>
</div>
</body>
</html>