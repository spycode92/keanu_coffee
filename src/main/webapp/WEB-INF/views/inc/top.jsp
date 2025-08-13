<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="top-nav">

  <button id="sidebar-toggle" class="sidebar-toggle">&#9776;</button>
  <span class="site-title">물류관리 ERP</span>
  <div class="top-nav-actions" style="margin-left:auto; display:flex; align-items:center; gap:16px;">

	<c:if test="${EmployeePosition eq 'admin'}">
    	<input type="button" value="관리자페이지" id="adminPage">
	</c:if>
    <span class="top-user">홍길동 사원</span>
	<button id="dark-mode-toggle" class="toggle-switch"></button>	
  </div>
</nav>

<div class="dashboard-layout">
  <!-- 사이드바 -->
	<aside id="sidebar" class="sidebar">
		<ul>
			<li>
<!-- 				<a href="/dashboard"><span>대시보드</span></a> -->
				<a href=""><span>대시보드</span></a>
				<ul class="submenu">
					<li><a href="/dashsub1">대시보드하위메뉴1</a></li>
					<li><a href="/dashsub2">대시보드하위메뉴2</a></li>
					<li><a href="/dashsub3">대시보드하위메뉴3</a></li>
					<li><a href="/dashsub4">대시보드하위메뉴4</a></li>
				</ul>
			</li>
			<li>
				<a href="/inbound/main"><span>입고 관리</span></a>
			</li>
			<li>
				<a href="/outbound"><span>출고 관리</span></a>
			</li>
			<li>
				<a href="/inventory"><span>재고 현황</span></a>
			    <ul class="submenu">
			        <li><a href="/inventory/stockCheck">재고 조회/검수</a></li>
			    </ul>
			</li>
			<li>
				<a href="/settings"><span>시스템 설정</span></a>
			</li>
			<li>
				<a href="/guide"><span>가이드페이지</span></a>
				
			</li>
      
    </ul>
  </aside>
  <!-- 여기서부터 개별 페이지 내용 들어감 -->