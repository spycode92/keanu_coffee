<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<sec:csrfMetaTags/>
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
  <h3>🔐 보유 권한 목록</h3>
	<ul>
    <c:forEach var="authority" items="${pageContext.request.userPrincipal.authorities}">
        <li><strong>${authority.authority}</strong></li>
    </c:forEach>
	</ul>
</section>









<script>
$("#adminPage").click(function(){
  location.href="/admin/main";
});
</script>
</div>
</body>
</html>