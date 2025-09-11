<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림</title>
<sec:csrfMetaTags/>
<style type="text/css">
	.read-status {
	    font-size: 12px;
	    color: #888;
	    margin-left: 10px;
	}
	.no-notification {
	    text-align: center;
	    color: #999;
	    padding: 10px;
	}
	
	.circle {
	    display: inline-block;
	    width: 10px;
	    height: 10px;
	    border-radius: 50%;
	    margin-left: 5px;
	}
	.circle.read {
	    background-color: #ccc; 
	}
	.circle.unread {
	    background-color: red;
	}
	.noti-message {
	  flex: 1;
	  white-space: nowrap;
	  overflow: hidden;
	  text-overflow: ellipsis;
	  color: #333;
	}
</style>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
</head>
<body>
<!-- 기본양식 -->
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 

<section class="content">
	<table class="table" style="color:green;">
		<tr>
			<th style="width:15%;">시간</th>
			<th>알림 메세지</th>
		</tr>
		<c:forEach var="alarm" items="${alarmList }">
			<tr>
				<td>${alarm.createdAt }</td>
				<td>
					<span class="noti-message">
						${alarm.empAlarmMessage }
					</span>
					<c:if test="${alarm.empAlarmReadStatus == 1}">
						<span class="circle unread"></span>
					</c:if>
					<c:if test="${alarm.empAlarmReadStatus == 0}">
						<span class="circle read"></span>
					</c:if>
					<button onclick="link()" <c:if test="${empty alarm.empAlarmLink }">disabled</c:if>>
						이동
					</button>
					
				</td>
			</tr>
		</c:forEach>
	</table>
</section>

</div>
</body>
</html>