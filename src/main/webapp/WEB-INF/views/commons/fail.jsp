<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<script type="text/javascript">
		// 서버로부터 전달받은 "msg" 속성값을 자바스크립트 alert() 함수를 통해 출력(오류메세지 출력)
		alert("${msg}");
		// 이전페이지로 돌아가기
		history.back();
	</script>
</body>
</html>