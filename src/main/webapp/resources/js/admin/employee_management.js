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

let orgData;
let structuredOrgData; 
// 범용 함수: 플랫한 데이터를 그룹별로 묶어서 배열로 변환
function groupDataByKey(flatData, groupKey, ...valueKeys) {
    const result = {};

    flatData.forEach(item => {
        const group = item[groupKey];
        
        if (!result[group]) {
            result[group] = {};
            // valueKeys 만큼 Set 초기화
            valueKeys.forEach(key => {
                result[group][key] = new Set();
            });
        }
        
        // 각 valueKey에 해당하는 값들을 Set에 추가
        valueKeys.forEach(key => {
            result[group][key].add(item[key]);
        });
    });

    // Set을 Array로 변환
    Object.keys(result).forEach(group => {
        valueKeys.forEach(key => {
            result[group][key] = Array.from(result[group][key]);
        });
    });

    return result;
}

// 드롭다운 초기화
function processOrgData(rawData) {
    // 원본 flatData를 부서별로 그룹화
    orgData = groupDataByKey(rawData, "common_code_name", "team_name", "role_name");
	console.log(orgData);
    // 기존 선택값 초기화
    document.querySelector('select[name="deptName"]').value = "";
    document.querySelector('select[name="teamName"]').innerHTML = '<option value="">없음</option>';
    document.querySelector('select[name="roleName"]').innerHTML = '<option value="">없음</option>';
}

//부서 옵션 채우기
function populateDepartments() {
	const deptSel = document.querySelector('select[name="deptName"]');
	deptSel.innerHTML = '<option value="">없음</option>';
	Object.keys(orgData).forEach(dept => {
		const opt = document.createElement('option');
		opt.value = dept; 
		opt.textContent = dept;
		deptSel.appendChild(opt);
	});
}
// 5) 부서 선택 시 팀·직책 동시 채우기
function onDeptChange() {
  const dept = document.querySelector('select[name="deptName"]').value;
  const teamSel = document.querySelector('select[name="teamName"]');
  const roleSel = document.querySelector('select[name="roleName"]');
  teamSel.innerHTML = '<option value="">없음</option>';
  roleSel.innerHTML = '<option value="">없음</option>';
  if (!dept || !orgData[dept]) return;

  orgData[dept].team_name.forEach(team => {
    const o = document.createElement('option');
    o.value = team; o.textContent = team;
    teamSel.appendChild(o);
  });
  orgData[dept].role_name.forEach(role => {
    const o = document.createElement('option');
    o.value = role; o.textContent = role;
    roleSel.appendChild(o);
  });
}

//부서,팀,직책정보 함수
function loadOrgData() {
    ajaxGet('/admin/employeeManagement/getOrgData')
		.then(data => {
			console.log(data);
			processOrgData(data);
       		populateDepartments();
		})
		.catch(err => {
			console.error('부서정보 로딩 오류', err);
			Swal.fire('부서정보 불러오기 실패', '', 'error');
		});
}      


// DOM 로드후 
document.addEventListener("DOMContentLoaded", function() {
    const btnOpen = document.getElementById('addEmployee');  // 직원추가 버튼 id="addEmployee" 있어야 함
	
	//직원추가버튼클릭시 직원추가모달 열기
    btnOpen.addEventListener('click', () => {
		 ModalManager.openModal(document.getElementById('addEmployeeModal'));
		//부서,팀,직책 정보 함수
		loadOrgData();
    });
	// 부서 선택시 부서내의 팀, 직책 불러오기함수 호출
	document.querySelector('select[name="deptName"]').addEventListener('change', onDeptChange);

	 // 상세정보 모달 열기
    document.querySelectorAll('.employee-row').forEach(row => {
        row.addEventListener('click', () => {
            const empIdx = row.dataset.empIdx;
            // TODO: empIdx로 데이터 로딩 로직은 나중에 구현

            // 모달 열기
            const detailModal = document.getElementById('employeeDetailModal');
            ModalManager.openModal(detailModal);
        });
    });
});

/* 직원추가 모달 사용 */
document.addEventListener("DOMContentLoaded", function() {
    // 직원 추가 모달 전용 요소
    const profileInput = document.getElementById("addProfileImage");
    const profilePreview = document.getElementById("addProfilePreview");
    const deleteBtn = document.getElementById("deleteAddProfileBtn");
    const defaultSrc = "/resources/images/default_profile_photo.png";

    // 요소가 없으면 종료
    if (!profileInput || !profilePreview || !deleteBtn) return;

    // 이미지 선택 시 미리보기
    profileInput.addEventListener("change", function(event) {
        const file = event.target.files[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onload = function(e) {
            profilePreview.src = e.target.result;
        };
        reader.readAsDataURL(file);
    });

    // x버튼 클릭 시 프로필 이미지 초기화
    deleteBtn.addEventListener("click", function() {
        profileInput.value = "";
        profilePreview.src = defaultSrc;
    });
});

























