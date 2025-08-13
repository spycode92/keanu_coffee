<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="top-nav">

  <button id="sidebar-toggle" class="sidebar-toggle">&#9776;</button>
  <span class="site-title">물류관리 ERP</span>
  <div class="top-nav-actions" style="margin-left:auto; display:flex; align-items:center; gap:16px;">
    <span class="top-user">${sessionScope.sName }</span>
	<button id="dark-mode-toggle" class="toggle-switch"></button>	
  </div>
</nav>

<div class="dashboard-layout">
  <!-- 사이드바 -->
	<aside id="sidebar" class="sidebar">
		<ul>
			<c:if test="${sessionScope.sId eq 'admin'}">
				<li>
					<a href="/admin"><span>관리자페이지</span></a>
	<!-- 				<a href=""><span>물류부서관리</span></a> -->
					<ul class="submenu">
						<li><a href="/admin/employeeManagement">사원관리</a></li>
						<li><a href="/admin/accessManagement">권한관리</a></li>
						<li><a href="/admin/statistic">통계</a></li>
					</ul>
				</li>
			</c:if>
			<li>
				<a href="/inbound/main"><span>입고 관리</span></a>
			</li>
			<li>
				<a href="/outbound"><span>출고 관리</span></a>
			</li>
			<li>
				<a href="/inventory"><span>재고 현황</span></a>
			    <ul class="submenu">
			        <li><a href="/inventory/locationType">로케이션 지정</a></li>
			        <li><a href="/inventory/stockCheck">재고 조회/검수</a></li>
			    </ul>
			</li>
			<li>
				<a href="/transport"><span>운송관리</span></a>
				<ul class="submenu">
					<li><a href="/transport/drivers">기사관리</a></li>
					<li><a href="/transport/car">차량관리</a></li>
					<li><a href="/transport/dispatches">배차관리</a></li>
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