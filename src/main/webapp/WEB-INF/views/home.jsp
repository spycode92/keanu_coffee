<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
<title>Home</title>
<sec:csrfMetaTags/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

<style type="text/css">
	body {
	    min-height: 100vh;
	    margin: 0;
	    padding: 0;
	    /* 배경 설정 */
	    background-size: contain;
	    background-color:var(--background);
	    /* 가운데 정렬을 위한 flex 속성 */
	    display: flex;
	    justify-content: center;  /* 가로 중앙 */
	    align-items: center;      /* 세로 중앙 */
	}
	
	.login-form-container {
	    background: rgba(255,255,255,0.85);  /* 약간 투명한 흰색 배경 */
	    padding: 40px 30px;
	    border-radius: 12px;
	    box-shadow: 0 2px 16px rgba(0,0,0,0.12);
	    min-width: 300px;
	}
	.login-form-container h3 {
	    margin-top: 0;
	    text-align: center;
	}
	.login-form-container input[type="text"],
	.login-form-container input[type="password"] {
	    width: 100%;
	    margin-bottom: 10px;
	    padding: 8px;
	    border-radius: 6px;
	    border: 1px solid #bbb;
	    box-sizing: border-box;
	}
	.login-form-container input[type="submit"] {
	    width: 100%;
	    padding: 10px;
	    background: #2d77e4;
	    color: white;
	    border: none;
	    border-radius: 6px;
	    cursor: pointer;
	    font-weight: bold;
	    font-size: 1em;
	    margin-top: 10px;
	}
	.login-form-container input[type="submit"]:hover {
	    background: #2057a8;
	}
	.site-title {
	  width: 100%;
	  text-align: center;
	  font-size: 4rem;
	  font-weight: bold;
	  color: var(--foreground);
	  margin: 0;
	}
</style>
</head>
<body>
	<div class="container">
    <h3 class="stie-title">Keanu_Coffee</h3>
	    <div class="login-form-container">
	        <form action="/loginForSecurity" method="post">
	        	<sec:csrfInput/>
	            <input type="text" placeholder="사번을입력하세요" name="empNo" autocomplete="off"><br>
	            <input type="password" placeholder="초기비밀번호:1234" name="empPassword" autocomplete="off">
	            <input type="submit" value="로그인">
	        </form>
	    </div>
	    
	    <button id="loginTransportBtn">운송관리자</button>
	    <button id="logindriverBtn">기사</button>
	    <button id="loginOutboundBtn">출고관리자</button>
	    <button id="loginOutboundPersonBtn">출고사원</button>
	    <button id="logininboundBtn">입고관리자</button>
	    <button id="logininboundPersonBtn">입고사원</button>
	    <button id="logininventoryBtn">재고관리자</button>
	    <button id="logininventoryPersonBtn">재고관리자</button>
	</div>
	<script type="text/javascript">
	const { token, header } = getCsrf();
	$("#loginTransportBtn").on("click", function() {
		$.ajax({
		    url: "/loginForSecurity",
		    type: "POST",
		    data: {
		        empNo: "kimgs",
		        empPassword: "1234"
		    },
		    beforeSend: (xhr) => {
		        xhr.setRequestHeader(header, token);
		    },
		    success: () => {
		        location.href = "/transport/main"; // 로그인 성공 후 이동
		    },
		    error: (xhr) => {
		        console.error("로그인 실패", xhr.responseText);
		    }
		});
	})
	
	$("#logindriverBtn").on("click", function() {
		$.ajax({
		    url: "/loginForSecurity",
		    type: "POST",
		    data: {
		        empNo: "54320747",
		        empPassword: "1234"
		    },
		    beforeSend: (xhr) => {
		        xhr.setRequestHeader(header, token);
		    },
		    success: () => {
		        location.href = "/transport/mypage/54320747"; // 로그인 성공 후 이동
		    },
		    error: (xhr) => {
		        console.error("로그인 실패", xhr.responseText);
		    }
		});
	})
	$("#loginOutboundBtn").on("click", function() {
		$.ajax({
		    url: "/loginForSecurity",
		    type: "POST",
		    data: {
		        empNo: "90110826",
		        empPassword: "1234"
		    },
		    beforeSend: (xhr) => {
		        xhr.setRequestHeader(header, token);
		    },
		    success: () => {
		        location.href = "/outbound/main"; // 로그인 성공 후 이동
		    },
		    error: (xhr) => {
		        console.error("로그인 실패", xhr.responseText);
		    }
		});
	})
	$("#loginOutboundPersonBtn").on("click", function() {
		$.ajax({
		    url: "/loginForSecurity",
		    type: "POST",
		    data: {
		        empNo: "gompange",
		        empPassword: "1234"
		    },
		    beforeSend: (xhr) => {
		        xhr.setRequestHeader(header, token);
		    },
		    success: () => {
		        location.href = "/outbound/outboundManagement/"; // 로그인 성공 후 이동
		    },
		    error: (xhr) => {
		        console.error("로그인 실패", xhr.responseText);
		    }
		});
	})
	$("#logininboundBtn").on("click", function() {
		$.ajax({
		    url: "/loginForSecurity",
		    type: "POST",
		    data: {
		        empNo: "19900826",
		        empPassword: "1234"
		    },
		    beforeSend: (xhr) => {
		        xhr.setRequestHeader(header, token);
		    },
		    success: () => {
		        location.href = "/inbound/main"; // 로그인 성공 후 이동
		    },
		    error: (xhr) => {
		        console.error("로그인 실패", xhr.responseText);
		    }
		});
	})
	$("#logininboundPersonBtn").on("click", function() {
		$.ajax({
		    url: "/loginForSecurity",
		    type: "POST",
		    data: {
		        empNo: "33330827",
		        empPassword: "1234"
		    },
		    beforeSend: (xhr) => {
		        xhr.setRequestHeader(header, token);
		    },
		    success: () => {
		        location.href = "/inbound/management"; // 로그인 성공 후 이동
		    },
		    error: (xhr) => {
		        console.error("로그인 실패", xhr.responseText);
		    }
		});
	})
	$("#logininventoryBtn").on("click", function() {
		$.ajax({
		    url: "/loginForSecurity",
		    type: "POST",
		    data: {
		        empNo: "54320827",
		        empPassword: "1234"
		    },
		    beforeSend: (xhr) => {
		        xhr.setRequestHeader(header, token);
		    },
		    success: () => {
		        location.href = "/inventory/main"; // 로그인 성공 후 이동
		    },
		    error: (xhr) => {
		        console.error("로그인 실패", xhr.responseText);
		    }
		});
	})
	$("#logininventoryPersonBtn").on("click", function() {
		$.ajax({
		    url: "/loginForSecurity",
		    type: "POST",
		    data: {
		        empNo: "54322746",
		        empPassword: "1234"
		    },
		    beforeSend: (xhr) => {
		        xhr.setRequestHeader(header, token);
		    },
		    success: () => {
		        location.href = "/inventory/inventoryToMove"; // 로그인 성공 후 이동
		    },
		    error: (xhr) => {
		        console.error("로그인 실패", xhr.responseText);
		    }
		});
	})
	
	</script>
</body>
</html>