<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style type="text/css">
	.profile-wrapper {
		position: relative; /* popover 기준점 */
	}
	
	.avatar {
		width: 40px;
		height: 40px;
		object-fit: cover;
		border-radius: 50%;
		border: 1px solid #d9d9d9;
		cursor: pointer;
	}
	
	.profile-popover {
		position: absolute;
		top: 48px; /* 아바타 아래 */
		right: 0;
		min-width: 180px;
		padding: 12px;
		background-color: var(--card);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
		display: none;
		z-index: 999; /* 상단 UI보다 위 */
		
		/* 가운데 정렬 + 세로 배치 추가 */
		display: flex;
		flex-direction: column; 
		align-items: center;
		gap: 12px; /* 이름과 버튼 간격 */
		
		opacity: 0;                 /* 처음에는 보이지 않음 */
		visibility: hidden;
		transition: opacity 0.2s ease, visibility 0.2s ease;
		z-index: 999;
	}
	
	.profile-popover.show {
		opacity: 1;
		visibility: visible;
	}
	
	.profile-popover .top-user {
		font-size: 1rem;
		font-weight: 600;
		text-align: center;
	}
	
	.darkmode-wrapper {
		display: flex;
		align-items: center; /* 세로 가운데 맞춤 */
		gap: 8px; /* 라벨과 버튼 간격 */
	}
	
	.darkmode-label {
		font-size: 0.9rem;
		color: var(--foreground);
	}
	
	.id-check-wrapper {
	    display: flex;
	    gap: 8px; /* 입력창과 버튼 사이 간격 */
	    align-items: center;
	}
	
	.id-check-wrapper .form-control {
	    flex: 1; /* 입력창이 남는 공간 전부 차지 */
	}
	
	.id-check-wrapper .btn {
	    white-space: nowrap; /* 버튼 글자가 줄바꿈 되지 않게 */
	    height: 38px; /* input 높이와 맞춰주기 */
	}
</style>
<nav class="top-nav">
	
	<button id="sidebar-toggle" class="sidebar-toggle">&#9776;</button>
	<span class="site-title">물류관리 ERP</span>
  
	<div class="top-nav-actions" style="margin-left:auto; display:flex; align-items:center; gap:16px;">
		<div class="profile-wrapper">
			<a id="profile" href="javascript:void(0)" onclick="profile()">
				<c:choose>
				<c:when test="${!empty sessionScope.sFid}">
					<img class="avatar" alt="profile" src="/file/${sessionScope.sFid }?type=0"
						style="width: 40px; height: 40px; object-fit: cover; border-radius: 50%; border: 1px solid #d9d9d9;">
				</c:when>
				<c:otherwise>
					<img class="avatar" alt="profile" src="/resources/images/default_profile_photo.png"
						style="width: 40px; height: 40px; object-fit: cover; border-radius: 50%; border: 1px solid #d9d9d9;">
				</c:otherwise>
				</c:choose>
			</a>
			<div id="employeeInfo" class="profile-popover" role="menu" aria-hidden="true" >
				<span class="top-user">${sessionScope.sName }</span>
				<span class="changeInfo"><a href="javascript:void(0)" id="open-info-modal">정보변경</a></span>
				<span class="logout" ><a href="/logout" onclick="return confirm('정말 로그아웃하시겠습니까?');">로그아웃</a></span>
				<div class="darkmode-wrapper" style="color: #e0e5e6;">
					<span class="darkmode-label">다크모드 :</span>
					<button id="dark-mode-toggle" class="toggle-switch" aria-label="다크모드" style="text-align: right;"></button><br>	
				</div>				
			</div>
		</div>
	</div>
</nav>
<!-- 정보변경 모달창 -->
<div id="change-info-modal" class="settings-modal">
	<div class="settings-content">
		<div class="settings-header">
			<h2>정보 변경</h2>
			<button id="close-info-modal" class="settings-close">&times;</button>
		</div>
		
		<form action="/user/updateInfo" method="post">
			<!-- ID -->
			<div class="id-check-wrapper">
			    <input class="form-control" type="text" id="empId" name="empId" value="${sessionScope.sId}">
			    <button type="button" class="btn btn-secondary" id="check-id-btn">중복확인</button>
			</div>
			<small id="id-check-result" style="font-size: 0.85rem; color: gray;"></small>
			
			<!-- 비밀번호 -->
			<label class="form-label" for="empPassword">새 비밀번호</label>
			<input class="form-control" type="password" id="empPassword" name="empPassword">
			
			<!-- 휴대폰 번호 -->
			<label class="form-label" for="empPhone">휴대폰 번호</label>
			<input class="form-control" type="text" id="empPhone" name="empPhone"
			       value="${sessionScope.sPhone}">
			
			<!-- 이메일 -->
			<label class="form-label" for="empEmail">이메일</label>
			<input class="form-control" type="email" id="empEmail" name="empEmail"
			       value="${sessionScope.sEmail}">
			
			<div style="margin-top: 1rem; text-align: right;">
				<button type="submit" class="btn btn-primary">저장</button>
				<button type="button" id="cancel-info-modal" class="btn btn-secondary">취소</button>
			</div>
		</form>
	</div>
</div>
	<script>
		//정보변경 모달창 띄우기
		document.addEventListener("DOMContentLoaded", () => {
		    const openBtn = document.getElementById('open-info-modal');     // 정보변경 버튼
		    const closeBtn = document.getElementById('close-info-modal');   // X 닫기 버튼
		    const cancelBtn = document.getElementById('cancel-info-modal'); // 취소 버튼
		    const modal = document.getElementById('change-info-modal');     // 모달 자체
	
		    function openModal() {
		        modal.classList.add('open');    // 공통 CSS에서 .open 시 표시
		    }
	
		    function closeModal() {
		        modal.classList.remove('open'); // 닫기
		    }
	
		    // 열기 이벤트
		    openBtn?.addEventListener('click', openModal);
	
		    // 닫기 이벤트 (X 버튼, 취소 버튼)
		    closeBtn?.addEventListener('click', closeModal);
		    cancelBtn?.addEventListener('click', closeModal);
	
		    // 배경 클릭 시 닫기
		    modal?.addEventListener('click', (e) => {
		        if (e.target === modal) {
		            closeModal();
		        }
		    });
		});
		function profile() {
			const popover = document.getElementById('employeeInfo');
			popover.classList.toggle('show');
		}
	</script>

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
						<li><a href="/admin/dash">통계</a></li>
						<li><a href="/admin/workingLog">작업관리</a></li>
						<li><a href="/admin/preference">시스템설정</a></li>
					</ul>
				</li>
			</c:if>
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