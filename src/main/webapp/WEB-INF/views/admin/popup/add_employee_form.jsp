<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 추가</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
input {
	background-color: gray;
}

form {
    display: flex;
    flex-direction: column;
    gap: 10px;
}
label {
    font-weight: bold;
}
input[type="text"], input[type="email"], input[type="password"] {
    padding: 5px;
    width: 250px;
}
input[type="submit"] {
    padding: 8px;
    background: #486f4a;
    color: white;
    border: none;
    cursor: pointer;
}
input[type="submit"]:hover {
    background: #45a049;
}
</style>
</head>
<body>
<h2>직원 추가</h2>
<form action="/admin/employeeManagement/addEmployee" method="post" enctype="multipart/form-data">
	
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
	    <input type="file" name="files"  class="custom-file-input" id="profileImage" accept="image/*" style="margin-top: 10px;">
	    <input type="hidden" id="profileImageAction" name="profileImageAction" value="none">
	    <input type="hidden" id="deleteProfileImgFlag" name="deleteProfileImgFlag" value="false">
	
    <label>이름</label>
    <input type="text" name="empName" required>
    
    <label>성별</label>
	<div>
	    <label>
	        <input type="radio" name="empGender" value="남자" checked required>
	        남자
	    </label>
	    <label>
	        <input type="radio" name="empGender" value="여자">
	        여자
	    </label>
	</div>
    
    <label>연락처</label>
    <input type="text" name="empPhone" required>

    <label>이메일</label>
    <input type="email" name="empEmail" required>
	
    <label>부서</label>
    <input type="text" name="deptName">
    
    <label>팀</label>
    <input type="text" name="teamName">
    
    <label>직책</label>
    <input type="text" name="empPosition">

    <label>고용일</label>
    <input type="date" name="hireDate">

    <input type="submit" value="등록">
</form>

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
</body>
</html>