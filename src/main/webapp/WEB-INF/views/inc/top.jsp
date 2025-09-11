<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
	#alarm-wrapper {
		position: relative;
		display: inline-block;
	}
	
	#alarm-image {
		width: 25px;
		height: 25px;
		vertical-align: bottom;
	}
	
	/* 알람 아이콘 뱃지 */
	#alarm-badge {
		position: absolute;
		/* 우측 하단 고정 */
		bottom: 0;
		right: 0;
		width: 8px;
		height: 8px;
		background-color: red;
		border-radius: 50%; /* 원형 */
		display: none; /* 처음 로딩 시 숨김 */
	}
	
	#noti:hover {
	    transform: translateY(-2px);
	    transition: background-color 0.3s ease, transform 0.3s ease;
	}
	#noti:active {
	    transform: translateY(0);
	    transition: background-color 0.1s ease, transform 0.1s ease;
	}
	
	/* 					notification button */
	#notification-box {
		display: none;
		position: absolute;
		width: 300px;
		border-radius: 20px;
		box-shadow: 0 3.2px 16.2px rgba(0, 0, 0, 0.3);
		margin-top: 200px;
		right: 20px;
		background-color: #fff;
		padding: 20px;
	}
	
	#notification-box > ul > li:nth-child(odd) {
		background-color: #d9d9d9;
	}
	#notification-box > h3 {
		padding: 5px;
		border-bottom: #333 solid 2px;
	}
	#notification-box > ul > span {
		float: right;
		margin-left: auto;
	}
	#notification-box > ul > li {
		margin-top: 5px;
	}
	#small-menu {
		display:none;
	}
	
	/* notification */
	#notification-box {
	    position: absolute;
	    top: 100%; 
	    right: 240px;  
	    margin-top: 0.5em; 
	    width: 420px;
	    max-height: 300px;
	    overflow-y: auto;
	    border: 1px solid #ccc;
	    border-radius: 8px;
	    background: white;
	    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
	    display: none;
	    z-index: 100;
	    padding-top: 0;
	}
	
	#notification-list {
	    list-style: none;
	    margin: 0;
	    padding: 0;
	    position: relative;
	}
	
	#notification-list li {
	    padding: 10px;
	    cursor: pointer;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    border-bottom: 1px solid #eee;
	    transition: background 0.2s;
	}
	
	#notification-list li:hover {
	    background: #f9f9f9;
	}
	
	#notification-list li .dot {
	    font-size: 14px;
	}
	
	#notification-header {
		display: flex; 
		justify-content: space-between; 
		align-items: center;
		border-bottom: 1px solid #ddd;
		position: sticky;
		top: 0;
		background: white;
		width: 370px;
		z-index: 999;
	}
	
	#notification-header a {
		color: black;
	}
	
	.no-notification {
	    padding: 10px;
	    color: #888;
	    text-align: center;
	}
	
	#notification-box #notification-list li {
	    padding: 10px;
	    cursor: pointer;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    border-bottom: 1px solid #eee;
	    transition: background 0.2s;
	    background-color: white;
	    white-space: nowrap;       
	  	overflow: hidden;          /* 넘치는 텍스트 감춤 */
	  	text-overflow: ellipsis; 
	}
	
	#notification-list li:hover {
	    background: #f9f9f9;
	}
	
	#notification-box h3 {
	    position: sticky;
	    top: -20px;
	    background: white;
		padding: 10px;
	    margin: 0;
	    font-size: 1.2em;
	    z-index: 10;
	}
	
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
	
	#notification-header  div {
		display: flex;
		gap: 20px;
		cursor: pointer;
		color: black;
	}
	
	
	.noti-message {
	  flex: 1;
	  white-space: nowrap;
	  overflow: hidden;
	  text-overflow: ellipsis;
	  color: #333;
	}
</style>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/common/web_socket.js"></script>
<c:if test="${not empty accessDeniedMessage }">
	<script type="text/javascript">
		Swal.fire({
		    icon: 'error',
		    title: '경고',
		    text: "${accessDeniedMessage}",
		    confirmButtonText: '확인'
		});
	</script>
	<% session.removeAttribute("accessDeniedMessage");%>
</c:if>
<c:if test="${not empty msg}">
	<script type="text/javascript">
		Swal.fire({
	        icon: '${icon}',
	        title: '${title}',
	        text: '${msg}',
	        confirmButtonText: '확인'
	    });
	</script>
</c:if>
<nav class="top-nav">
	<jsp:include page="/WEB-INF/views/inc/change_info.jsp"></jsp:include> 
	<button id="sidebar-toggle" class="sidebar-toggle">&#9776;</button>
	<span class="site-title">물류관리 ERP </span>
	<div class="top-nav-actions" style="margin-left:auto; display:flex; align-items:center; gap:16px;">
		<div class="profile-wrapper">
			<a id="profile" href="javascript:void(0)" >
				<sec:authentication property="principal.username"/>
				<sec:authentication property="principal.empName"/>
			</a>
			<script type="text/javascript">
				const role = "${pageContext.request.userPrincipal.principal.role.roleName}";
			</script>
			<div id="employeeInfo" class="profile-popover" role="menu" aria-hidden="true" >
				<span class="changeInfo"><button type="button" class="btn btn-link" data-modal-target="change-info-modal"> 정보 변경</button></span>
				<span class="logout" >
					<button type="button" class="btn btn-secondary" data-action="logout">로그아웃</button>
				</span>
				<div class="darkmode-wrapper" style="color: #e0e5e6;">
					<span class="darkmode-label">다크모드 :</span>
					<button id="dark-mode-toggle" class="toggle-switch" aria-label="다크모드" style="text-align: right;"></button><br>	
				</div>				
			</div>
		</div>
		<div id="alarm-wrapper">
			<a id="noti" href="javascript:void(0)" onclick="notification()"><img src="/resources/images/alarm.png" id="alarm-image" /></a>
			<span id="alarm-badge"></span>
       		<div id="notification-box">
				<div id="notification-header">
					<h3>알림</h3>
					<div>
						<a href="/alarm">전체보기</a>
					</div>
				</div>
				<ul id="notification-list"></ul>
       		</div>			
		</div>			
	</div>
</nav>

	

<div class="dashboard-layout">
  <!-- 사이드바 -->
	<aside id="sidebar" class="sidebar">
		<ul>
			<sec:authorize access="hasAnyAuthority('ADMIN_MASTER', 'ADMIN_SYSTEM')">
			<li>
				<span>관리자페이지</span>
<!-- 				<a href=""><span>물류부서관리</span></a> -->
				<ul class="submenu">
					<li><a href="/admin/employeeManage">직원관리</a></li>
					<li><a href="/admin/preference/dept">조직관리</a></li>
					<li><a href="/admin/preference/supplyCompany">공급업체관리</a></li>
					<li><a href="/admin/preference/product">상품관리</a></li>
					<li><a href="/admin/preference/supplyContract">공급계약</a></li>
					<li><a href="/admin/preference/franchise">지점관리</a></li>
					<li><a href="/admin/sysNoti">시스템알림</a></li>
				</ul>
			</li>
			</sec:authorize>
			<sec:authorize access="hasAnyAuthority('INBOUND_READ', 'INBOUND_WRITE')">
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
			</sec:authorize>
			<sec:authorize access="hasAnyAuthority('OUTBOUND_READ', 'OUTBOUND_WRITE')">
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
			</sec:authorize>
			<sec:authorize access="hasAnyAuthority('INVENTORY_READ', 'INVENTORY_WRITE')">
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
			</sec:authorize>
			<sec:authorize access="hasAnyAuthority('TRANSPORT_READ', 'TRANSPORT_WRITE')">
			<li>
				<a href="/transport"><span>운송관리</span></a>
				<ul class="submenu">
					<li><a href="/transport/drivers">기사관리</a></li>
					<li><a href="/transport/vehicle">차량관리</a></li>
					<li><a href="/transport/dispatches">배차관리</a></li>
				</ul>
			</li>
			</sec:authorize>
			<sec:authorize access="isAuthenticated()">
				<li>
					<ul class="submenu">
						<li><a href="/admin/dash">통계</a></li>
						<li><a href="/admin/workingLog">작업관리</a></li>
					</ul>
				</li>
			</sec:authorize>
			<li>
				<a href="/guide"><span>가이드페이지</span></a>
				
			</li>
      
		</ul>
	</aside>

  <!-- 여기서부터 개별 페이지 내용 들어감 -->