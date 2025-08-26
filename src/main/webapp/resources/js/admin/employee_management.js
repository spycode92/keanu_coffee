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
function groupDataByKey(flatData, groupKey,groupIdx, ...valueKeys) {
    //flatData를 직렬화할수 있게 저장할 result객체생성
	const result = {};

    flatData.forEach(item => {
        const groupName = item[groupKey];
		const groupIdxValue = item[groupIdx];
        
        if (!result[groupIdxValue]) { //result{}에 [groupName]으로 된 배열이 없다면
            
			result[groupIdxValue] = { // result[groupName] 정의
 				common_code_idx: groupIdxValue,
				common_code_name: groupName	
			};
			
            //Set 초기화
            valueKeys.forEach(key => { // valueKeys수만큼 result[groupName][Key] 생성
                result[groupIdxValue][key] = new Set();
            });
        }
        
        // 각 valueKey에 해당하는 값들을 Set에 추가
        valueKeys.forEach(key => {
            result[groupIdxValue][key].add(item[key]);
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
    orgData = groupDataByKey(rawData, "common_code_name","common_code_idx"
		, "team_name", "team_idx", "role_name", "role_idx");
	console.log(orgData);
    // 기존 선택값 초기화
    document.querySelector('select[name="departmentIdx"]').value = "";
    document.querySelector('select[name="teamIdx"]').innerHTML = '<option value="">없음</option>';
    document.querySelector('select[name="roleIdx"]').innerHTML = '<option value="">없음</option>';
}

//부서 옵션 채우기
function populateDepartments() {
	const deptSel = document.querySelector('select[name="departmentIdx"]');
	deptSel.innerHTML = '<option value="">없음</option>';
	Object.keys(orgData).forEach(dept => {
		const opt = document.createElement('option');
		opt.value = orgData[dept].common_code_idx; 
		opt.textContent = orgData[dept].common_code_name; 
		deptSel.appendChild(opt);
	});
}
// 5) 부서 선택 시 팀·직책 동시 채우기
function onDeptChange() {
	const dept = document.querySelector('select[name="departmentIdx"]').value;
	const teamSel = document.querySelector('select[name="teamIdx"]');
	const roleSel = document.querySelector('select[name="roleIdx"]');
	teamSel.innerHTML = '<option value="">없음</option>';
	roleSel.innerHTML = '<option value="">없음</option>';
	
	//부서 idx로 부서 찾기
//	const deptName = Object.keys(orgData).find(dept => 
//        orgData[dept].common_code_idx == selectedDeptIdx
//    );
	
	if (!dept || !orgData[dept]) return;
	
	orgData[dept].team_name.forEach((team, index) => {
		const o = document.createElement('option');
		o.value = orgData[dept].team_idx[index];  
		o.textContent = team;
		teamSel.appendChild(o);
	});
	
	orgData[dept].role_name.forEach((role, index) => {
		const o = document.createElement('option');
	    o.value = orgData[dept].role_idx[index]; 
		o.textContent = role;
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
		const modal = document.getElementById('addEmployeeModal');
		modal.querySelectorAll('input').forEach(input => input.value = '');
    	modal.querySelectorAll('select').forEach(select => select.value = '');
    	modal.querySelectorAll('textarea').forEach(textarea => textarea.value = '');
		

		ModalManager.openModal(modal);
		//부서,팀,직책 정보 함수
		loadOrgData();
    });
	// 부서 선택시 부서내의 팀, 직책 불러오기함수 호출
	document.querySelector('select[name="departmentIdx"]').addEventListener('change', onDeptChange);
	
	const inputName = document.getElementById('addEmpName');
	const inputPhone = document.getElementById('addEmpPhone');
	
	//이름 한글만 입력가능
	inputName.addEventListener('blur', (e) => {
		// 한글만 허용하는 정규식
		const hangulPattern = /^[가-힣]*$/;
		let value = e.target.value;
		value = value.replace(/[^가-힣]/g, '');
		e.target.value = value;
	});
	
	//핸드폰번호 숫자만입력, 010-1111-1111형식
	inputPhone.addEventListener('input', (e) => {
		 // 1. 숫자만 남기기
	    let value = e.target.value.replace(/\D/g, '');
	    // 2. 최대 11자리(010 + 8자리)로 자르기
	    if (value.length > 11) {
	        value = value.slice(0, 11);
	    }
	    // 3. 자동 하이픈 삽입 (010-1111-1111 형식)
	    //    3-4-4 기준으로 그룹 나누기
	    const part1 = value.slice(0, 3);
	    const part2 = value.length > 3 ? value.slice(3, 7) : '';
	    const part3 = value.length > 7 ? value.slice(7) : '';
	
	    let formatted = part1;
	    if (part2) {
	        formatted += '-' + part2;
	    }
	    if (part3) {
	        formatted += '-' + part3;
	    }
	
	    e.target.value = formatted;
	});
	
	// 상세정보 모달 열기
	document.querySelectorAll('.employee-row').forEach(row => {
	    row.addEventListener('click', async () => { 
	        const empIdx = row.dataset.empIdx;
	        
	        // 1. 데이터 가져오기
	        const data = await getEmpData(empIdx);
	        if (!data) {
	            console.error('직원 정보 로드 실패');
	            return;
	        }
	        
	        // 2. 모달의 input 요소에 값 채우기
	        document.getElementById('empNo').value        = data.empNo   || '';
	        document.getElementById('empName').value      = data.empName || '';
	        document.getElementById('empGender').value    = data.empId   || '';
	        document.getElementById('empDeptName').value      = data.departmentName || '';
	        document.getElementById('empDeptIdx').value      = data.departmentName || '';
	        document.getElementById('empPhone').value     = data.phoneNumber    || '';
	        document.getElementById('empEmail').value     = data.email          || '';
	        document.getElementById('empHireDate').value  = data.hireDate       || '';
	        
	        // 3. 모달 열기
	        const detailModal = document.getElementById('employeeDetailModal');
	        ModalManager.openModal(detailModal);
	    });
	});
	
	//상세정보 직원 정보 불러오기
	function getEmpData(empIdx){
		return ajaxGet("/admin/employeeManagement/getOneEmployeeInfoByIdx"
			, params = {empIdx : empIdx})
			
			.then(function(data) {
				return data;
			})
			.catch(function(err) {
				console.error('사용자 정보 로드 중 오류:', err);
	            return null;
			});
	}
});
























