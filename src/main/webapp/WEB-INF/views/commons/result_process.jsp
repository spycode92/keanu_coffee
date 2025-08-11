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
		
		// 서버로부터 전송된 "targetURL" 속성값 존재 여부 판별하여
		// 1) 비어있을 경우 이전페이지로 돌아가기
		// 2) 비어있지 않을 경우 targetURL 속성에 지정된 페이지로 이동
		if("${targetURL}" === "") {
			// 이전페이지로 돌아가기
			history.back();
		} else {
			// targetURL 속성에 지정된 페이지로 이동
			location.href = "${targetURL}";
		}
	</script>
</body>
</html>
