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
	    top: 48px;
	    right: 0;
	    min-width: 180px;
	    padding: 12px;
	    background-color: var(--card);
	    border: 1px solid var(--border);
	    border-radius: var(--radius);
	    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
	
	    /* 숨김 처리 */
	    display: none;
	    flex-direction: column;
	    align-items: center;
	    gap: 12px;
	
	    /* transition에서 opacity/visibility를 사용하려면 display:none 대신 아래 스타일 사용 */
	    /* opacity: 0;
	    visibility: hidden;
	    transition: opacity 0.2s ease, visibility 0.2s ease; */
	
	    z-index: 999;
	}
	
	.profile-popover.show {
	    display: flex; /* flex로 보임 처리 */
	    /* opacity: 1;
	    visibility: visible; */
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
			<a id="profile" href="javascript:void(0)" >
				<c:choose>
				<c:when test="${!empty sessionScope.sFid}">
					<img class="avatar" alt="profile" src="/file/thumnail/${sessionScope.sFid }?width=40&height=40"
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
			<label>프로필 사진</label>
		    <div style="position: relative; display: inline-block;">
		        <img id="profilePreview"
		            src=""
		            alt="프로필 사진"
		            style="width: 100px; height: 100px; object-fit: cover; border-radius: 50%; border: 1px solid #d9d9d9;">
		        <button type="button"
		            id="deleteProfileImgBtn"
		            style="position: absolute; top: 2px; right: 2px; background: #FF8C00; border: none; color: white; border-radius: 50%; width: 22px; height: 22px; font-weight: bold; cursor: pointer;">
		            ×
		        </button>
		    </div>
		    <br>
		    <input type="file" name="files"  class="form-control" id="profileImage" accept="image/*" style="margin:10px 0px; padding:6px 12px; border:1px solid #ccc; border-radius:4px; font-size:14px; ">
		    <input type="hidden" id="profileImageAction" name="profileImageAction" value="none">
		    <input type="hidden" id="deleteProfileImgFlag" name="deleteProfileImgFlag" value="false">
		
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
			    </ul>
			</li>
			<li>
				<a href="/outbound"><span>출고 관리</span></a>
				<ul class="submenu">
			        <li><a href="/outbound/main">대시보드</a></li>
			        <li><a href="/outbound/outboundManagement">출고조회</a></li>
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
	
	
	<script type="text/javascript">
		document.addEventListener("DOMContentLoaded", function(){
			var fileId = "${userProfileImg.fileId}";
			
			const existProfileImg = fileId && fileId !== '' && fileId !== 'null'; // true||false
			
			const profileImageAction = document.getElementById('profileImageAction'); // isnert, delete, update, none
			const deleteProfileImgFlag = document.getElementById('deleteProfileImgFlag'); //
			const profileImageInput = document.getElementById('profileImage'); //선택된 파일
			
			var profileUrl = existProfileImg ? '/file/' + fileId + '?type=0' : '/resources/images/default_profile_photo.png';
			
			document.getElementById('profilePreview').src = profileUrl;
			
			//파일 선택 시preview에 보여줌
			document.getElementById('profileImage').addEventListener('change', function(e) {
				const file = e.target.files[0];
				
				if (file) {
			        const reader = new FileReader();
			        reader.onload = function(evt) {
			            // 읽은 이미지 데이터를 profilePreview 이미지의 src에 설정
			            document.getElementById('profilePreview').src = evt.target.result;
			        }
			        reader.readAsDataURL(file);  // 파일을 DataURL 형식으로 읽기 (이미지 미리보기용)
			        profileImageAction.value = 'insert';
			        deleteProfileImgFlag.value = 'false';
			    } else {
			        // 파일선택 취소 시 "none" 처리
			        profileImageAction.value = 'none';
			    }
			});
			
			//이미지 삭제 버튼
			$('#deleteProfileImgBtn').on('click', function() {
			    // 프리뷰 이미지를 디폴트 이미지로 교체
			    $('#profilePreview').attr('src', '/resources/images/default_profile_photo.png');
			    // 삭제 의도를 서버에 전달할 수 있게 hidden input 값을 true로 설정
			    profileImageAction.value = 'delete';
			    deleteProfileImgFlag.value = 'true';
	
			    // 파일 선택된 것도 비워줌
			    profileImageInput.value = '';
			});
			
			document.querySelector('.custom-file-input').addEventListener('change', function(event) {
				const files = event.target.files;
				for (let i = 0; i < files.length; i++) {
					if (!files[i].type.startsWith('image/')) {
						alert('이미지 파일만 업로드 가능합니다.');
						document.getElementById('profilePreview').src = profileUrl;
						profileImageInput.value = '';  // 파일 입력값 비움
						return;
					}
				}					
	    	});
			
		});
	</script>


  <!-- 여기서부터 개별 페이지 내용 들어감 -->