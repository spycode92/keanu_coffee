<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<link rel="icon" href="resources/images/keanu_favicon.ico">

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
	<br>
</section>









<script>
const pageName = "main";

function subscribePage() {
	// top.jsp - function subscribeRoom(roomId, callback) {} 함수 호출하여 채팅방 구독 요청
	// => 콜백함수로 전달할 익명함수 정의 시 익명함수 파라미터에 메세지를 전달받을 파라미터 선언
	//    (callback(JSON.parse(outputMsg.body)); 형태로 콜백함수 호출이 일어남)
	subscribeRoom(pageName, function(message) {
		// 전달받은 채팅메세지를 채팅 메세지 영역에 추가
	});
}
// ====================================
// 채팅메세지 전송 요청을 수행할 함수
function requestSendMessage() {
	let messageContent = "ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ";
	
	// top.jsp - sendMessage() 함수(function sendMessage(roomId, messageContent) {}) 호출하여 메세지 전송 요청
	sendMessage(pageName, messageContent);
	
}
	
// ==============================================
// 페이지 로딩 완료 시 현재 기본 채팅방 구독 요청
$(function() {
	subscribePage();
	requestSendMessage();
});
</script>
</div>
</body>
</html>