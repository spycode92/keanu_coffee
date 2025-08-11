<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<div id="footer-area" style="padding:30px 0; background: #faf8fc; border-top:1px solid #ddd; position: relative;
	z-index: 1000; margin-top: 300px;">
    <div style="display:flex; align-items:center; justify-content: center; gap:40px;">
        <!-- Logo -->
        <img src="${pageContext.request.contextPath}/resources/images/logo4-2.png" alt="회사 로고" style="height:60px;">

        <!-- Company Info -->
        <div>
            <strong>회사정보</strong><br>
            (주)클리시 | 대표: 홍길동<br>
            사업자등록번호: 123-45-67890<br>
            주소: 서울특별시 강남구 테헤란로 123<br>
            이메일: info@clish.com
        </div>

        <!-- Customer Center -->
        <div>
            <strong>고객센터</strong><br>
            전화: 1588-1234<br>
            운영시간: 평일 09:00~18:00<br>
            <a href="/customer/FAQ">FAQ 바로가기</a>
        </div>

        <!-- Footer Links -->
        <div>
            <a href="/customer/announcements">공지사항</a> |
            <a href="/customer/termsOfService">이용약관</a> |
            <a href="/customer/privacyPolicy">개인정보방침</a>
        </div>
    </div>
</div>
































