//파라미터값받아오기
function getUrlParameter(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

// 정렬버튼 클릭 함수
function allineTable(thElement) {
	// 지금 누른 orderKey 받아오기	
    const key = thElement.getAttribute('data-key');
	
	//현재 orderKey, orderMethod 
	let currentOrderMethod = getUrlParameter('orderMethod') || 'asc';
    let currentOrderKey = getUrlParameter('orderKey');
	// 새 orderMethod
    let newOrderMethod = 'asc';
    // 지금 누른 오더키가 원래의 오더키 일때 
	if (currentOrderKey === key) {
		// 새 오더메서드 방법 변경
        newOrderMethod = (currentOrderMethod === 'asc') ? 'desc' : 'asc';
    }
	//현재 검색 타입, 검색어 존재하면 유지 없으면 널스트링
	const searchType = getUrlParameter('searchType') || '';
    const searchKeyword = getUrlParameter('searchKeyword') || '';
	
	//요청할 url 조합
	let url = `${window.location.pathname}?orderKey=${key}&orderMethod=${newOrderMethod}`;
    	if(searchType) url += `&searchType=${encodeURIComponent(searchType)}`;
    	if(searchKeyword) url += `&searchKeyword=${encodeURIComponent(searchKeyword)}`;
	
	// 이동요청
	window.location.href = url;
}

// DOM 로드후 
document.addEventListener("DOMContentLoaded", function() {
    const modal = document.getElementById('addEmployeeModal');
    const btnOpen = document.getElementById('addEmployee');  // 직원추가 버튼 id="addEmployee" 있어야 함
    const btnClose = document.getElementById('closeModalBtn');
    const btnCancel = document.getElementById('cancelBtn');

    btnOpen.addEventListener('click', () => {
        modal.classList.add('open');
        modal.setAttribute('aria-hidden', 'false');
    });

    function closeModal() {
        modal.classList.remove('open');
        modal.setAttribute('aria-hidden', 'true');
    }

    btnClose.addEventListener('click', closeModal);
    btnCancel.addEventListener('click', closeModal);

    window.addEventListener('click', (event) => {
        if (event.target === modal) {
            closeModal();
        }
    });


    // === 기존 프로필 이미지 JS 유지 ===
    var fileId = "${userProfileImg.fileId}";
    const existProfileImg = fileId && fileId !== '' && fileId !== 'null';
    const profileImageAction = document.getElementById('profileImageAction');
    const deleteProfileImgFlag = document.getElementById('deleteProfileImgFlag');
    const profileImageInput = document.getElementById('profileImage');
    var profileUrl = existProfileImg ? '/file/' + fileId + '?type=0' : '/resources/images/default_profile_photo.png';
    document.getElementById('profilePreview').src = profileUrl;

    profileImageInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(evt) {
                document.getElementById('profilePreview').src = evt.target.result;
            }
            reader.readAsDataURL(file);
            profileImageAction.value = 'insert';
            deleteProfileImgFlag.value = 'false';
        } else {
            profileImageAction.value = 'none';
        }
    });

    document.getElementById('deleteProfileImgBtn').addEventListener('click', function() {
        document.getElementById('profilePreview').src = '/resources/images/default_profile_photo.png';
        profileImageAction.value = 'delete';
        deleteProfileImgFlag.value = 'true';
        profileImageInput.value = '';
    });

    profileImageInput.addEventListener('change', function(event) {
        const files = event.target.files;
        for (let i = 0; i < files.length; i++) {
            if (!files[i].type.startsWith('image/')) {
                alert('이미지 파일만 업로드 가능합니다.');
                document.getElementById('profilePreview').src = profileUrl;
                profileImageInput.value = '';
                return;
            }
        }
    });
});


























