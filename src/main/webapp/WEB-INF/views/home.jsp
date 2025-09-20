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
	    
	    <button id="logininboundBtn">입고관리자</button>
	    <button id="logininboundPersonBtn">입고사원</button>
	    <button id="loginOutboundBtn">출고관리자</button>
	    <button id="loginOutboundPersonBtn">출고사원</button>
	    <br>
	    <button id="logininventoryBtn">재고관리자</button>
	    <button id="logininventoryPersonBtn">재고사원</button>
	    <button id="loginTransportBtn">운송관리자</button>
	    <button id="logindriverBtn">기사</button>
	</div>
	<script type="text/javascript">
	const { token, header } = getCsrf();
	
	function getCsrf() {
		const tokenMeta  = document.querySelector('meta[name="_csrf"]');
		const headerMeta = document.querySelector('meta[name="_csrf_header"]');
		return {
			token:  tokenMeta  ? tokenMeta.content  : null,
			header: headerMeta ? headerMeta.content : null
		};
	}
	
	// 로그인 버튼 함수
	function login(empNo, redirectUrl) {
	    $.ajax({
	        url: "/loginForSecurity",
	        type: "POST",
	        data: {
	            empNo: empNo,
	            empPassword: 1234
	        },
	        beforeSend: (xhr) => {
	            xhr.setRequestHeader(header, token);
	        }
	        ,
	        success: () => {
	            location.href = redirectUrl;
	        },
	        error: (xhr) => {
	            console.error("로그인 실패", xhr.responseText);
	        }
	    });
	}
	
	// 로그인버튼별 값 지정
	$("#logininboundBtn").on("click", () => login("2301180002", "/inbound/main"));
	$("#logininboundPersonBtn").on("click", () => login("2301180020", "/inbound/management"));
	
	$("#loginOutboundBtn").on("click", () => login("2301180003", "/outbound/main"));
	$("#loginOutboundPersonBtn").on("click", () => login("2301180021", "/outbound/outboundManagement/"));
	
	$("#logininventoryBtn").on("click", () => login("2301180009", "/inventory/main"));
	$("#logininventoryPersonBtn").on("click", () => login("2301180023", "/inventory/moveInventory"));
	
	$("#loginTransportBtn").on("click", () => login("2509200001", "/transport/main"));
	$("#logindriverBtn").on("click", () => login("2301180014", "/transport/mypage/54320747"));
	
	// 다크모드 관리
	const DarkModeManager = {
	    isDarkMode: localStorage.getItem('darkMode') === 'true' || 
	                (!localStorage.getItem('darkMode') && window.matchMedia('(prefers-color-scheme: dark)').matches),
	    
	    init: function() {
	        this.updateDarkMode();
	        this.bindEvents();
	    },
	    
	    updateDarkMode: function() {
	        const toggle = document.getElementById('dark-mode-toggle');
	        if (this.isDarkMode) {
	            document.documentElement.classList.add('dark');
	            if (toggle) toggle.classList.add('active');
	        } else {
	            document.documentElement.classList.remove('dark');
	            if (toggle) toggle.classList.remove('active');
	        }
	        localStorage.setItem('darkMode', this.isDarkMode);
	    },
	    
	    toggle: function() {
	        this.isDarkMode = !this.isDarkMode;
	        this.updateDarkMode();
	    },
	    
	    bindEvents: function() {
	        const self = this;
	        document.addEventListener('click', function(e) {
	            if (e.target.id === 'dark-mode-toggle') {
	                self.toggle();
	            }
	        });
	    }
	};
	
	document.addEventListener('DOMContentLoaded', function() {
		
	    DarkModeManager.init();
	})
	</script>
</body>
</html>