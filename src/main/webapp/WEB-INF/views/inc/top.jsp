<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav class="top-nav">
	<jsp:include page="/WEB-INF/views/inc/change_info.jsp"></jsp:include> 
	<button id="sidebar-toggle" class="sidebar-toggle">&#9776;</button>
	<span class="site-title">물류관리 ERP</span>
  
	<div class="top-nav-actions" style="margin-left:auto; display:flex; align-items:center; gap:16px;">
		<div class="profile-wrapper">
			<a id="profile" href="javascript:void(0)" >
				${empNo }${empName }
			</a>
			<div id="employeeInfo" class="profile-popover" role="menu" aria-hidden="true" >
				<span class="top-user">${sessionScope.sName }</span>
				<span class="changeInfo"><button type="button" class="btn btn-link" data-modal-target="change-info-modal"> 정보 변경</button></span>
				<span class="logout" ><button type="button" class="btn btn-secondary" data-action="logout">로그아웃</button></span>
				<div class="darkmode-wrapper" style="color: #e0e5e6;">
					<span class="darkmode-label">다크모드 :</span>
					<button id="dark-mode-toggle" class="toggle-switch" aria-label="다크모드" style="text-align: right;"></button><br>	
				</div>				
			</div>
		</div>
	</div>
</nav>

	

<div class="dashboard-layout">
  <!-- 사이드바 -->
	<aside id="sidebar" class="sidebar">
		<ul>
		
				<li>
					<a href="/admin"><span>관리자페이지</span></a>
	<!-- 				<a href=""><span>물류부서관리</span></a> -->
					<ul class="submenu">
						<li><a href="/admin/employeeManage">사원관리</a></li>
						<li><a href="/admin/dash">통계</a></li>
						<li><a href="/admin/workingLog">작업관리</a></li>
						<li><a href="/admin/preference/dept">조직관리</a></li>
						<li><a href="/admin/preference/supplyCompany">공급업체관리</a></li>
						<li><a href="/admin/preference/product">상품관리</a></li>
						<li><a href="/admin/preference/supplyContract">공급계약</a></li>
					</ul>
				</li>
		
			<li>
				<a href="/inbound/main"><span>입고 관리</span></a>
				<ul class="submenu">
			        <li><a href="/inbound/main">대시보드</a></li>
			        <li><a href="/inbound/management">입고조회</a></li>
			        <li><a href="/inbound/inboundDetail">입고조회 > 상세</a></li>
			        <li><a href="/inbound/inboundInspection">입고조회 > 검수</a></li>
			        <li><a href="/inbound/inboundConfirm">입고조회 > 확정</a></li>
			        <li><a href="/inbound/inboundRegister">입고요청</a></li>
			    </ul>
			</li>
			<li>
				<a href="/outbound"><span>출고 관리</span></a>
				<ul class="submenu">
			        <li><a href="/outbound/main">대시보드</a></li>
			        <li><a href="/outbound/outboundManagement">출고조회</a></li>
			        <li><a href="/outbound/outboundDetail">출고조회 > 상세</a></li>
			        <li><a href="/outbound/outboundInspection">출고조회 > 검수</a></li>
			        <li><a href="/outbound/outboundConfirm">출고조회 > 확정</a></li>
			        <li><a href="/outbound/outboundRegister">출고요청</a></li>
			        <li><a href="/outbound/outboundPicking">출고피킹</a></li>
			    </ul>
			</li>
			<li>
				<a href="/inventory"><span>재고 현황</span></a>
			    <ul class="submenu">
			        <li><a href="/inventory/stockCheck">재고 조회/검수</a></li>
			        <li><a href="/inventory/productHistory">제품 위치 기록</a></li>
              <li><a href="/inventory/updateInventory">재고 업데이트</a></li>
              <li><a href="/inventory/updateWarehouse">창고 업데이트</a></li>
              <li><a href="/inventory/moveInventory">재고를 옮기다</a></li>
              <li><a href="/inventory/updatedInventory">업데이트된 재고 테이블</a></li>
              <li><a href="/inventory/inventoryToMove">이동할 재고</a></li>

              <li><a href="/inventory/qrScanner">QR 스캐너</a></li>
              <li><a href="/inventory/locationType">로케이션 지정</a></li>
              <li><a href="/inventory/stockCheck">재고 조회/검수</a></li>
			  </ul>



			</li>
			<li>
				<a href="/transport"><span>운송관리</span></a>
				<ul class="submenu">
					<li><a href="/transport/drivers">기사관리</a></li>
					<li><a href="/transport/vehicle">차량관리</a></li>
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