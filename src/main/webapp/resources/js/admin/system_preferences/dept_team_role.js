
$(function () {
	let firstDeptItem = $('#departmentList .department-item').first();
	if (firstDeptItem.length) {
        firstDeptItem.trigger('click');  // 클릭 이벤트 강제 발생 → selectedDeptIdx 세팅, 팀 리스트 로드 등 실행
    }
	$('#btnAddRole').prop('disabled', false);
	$('#btnAddTeam').prop('disabled', false);
    let selectedDeptIdx = null;
    let selectedTeamIdx = null;

    // 부서 선택시 이벤트
    $(document).on('click', '.department-item', function () {
        $('.department-item').removeClass('active');
        $(this).addClass('active');
        selectedDeptIdx = $(this).data('departmentidx');
        loadTeamsAndRoles(selectedDeptIdx);
        $('#btnAddTeam').prop('disabled', false);
        $('#roleList').empty();
        $('#btnAddRole').prop('disabled', false);
		checkBox.hide();
    });

    // 부서 추가
	$('#btnAddDepartment').click(function () {
	    Swal.fire({
	        title: '새 부서 이름을 입력하세요',
	        input: 'text',
	        inputPlaceholder: '부서명',
	        showCancelButton: true,
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        inputValidator: (value) => {
	            if (!value.trim()) {
	                return '부서명을 입력해주세요.';
	            }
	            // 허용하는 문자: 한글, 영어, 숫자, _ , -
	            const validPattern = /^[\uAC00-\uD7A3a-zA-Z0-9_\- ]+$/;
	            if (!validPattern.test(value.trim())) {
	                return '가-힣 A-Z a-z 0-9, 특수문자는 _ 와 - 만 허용됩니다.';
	            }
	            return null; // 유효성 통과
	        }
	    }).then((result) => {
			if (result.isConfirmed) {
				const deptName = result.value.trim();
				ajaxPost(
					'/admin/systemPreference/dept/addDepartment',
					{ departmentName: deptName }          // JSON 바디
				)
	            .then(function (dept) {
                    $('#departmentList').append(
                        `<li class="list-group-item d-flex justify-content-between align-items-center department-item"  data-departmentidx="${dept.departmentIdx}">
                            <span class="department-name">${dept.departmentName}</span>
							<div>
								<button type="button" class="btn btn-sm btn-secondary btn-edit-department">✎</button>
	                            <button type="button" class="btn btn-sm btn-danger btn-delete-department">−</button>
                        	</div>
						</li>`
                    );
                    Swal.fire({
                        icon: 'success',
                        title: '성공!',
                        text: '부서 추가가 완료되었습니다.',
                        confirmButtonText: '확인'
                    });
                })
                .catch(function () {
                    Swal.fire({
                        icon: 'error',
                        title: '실패',
                        text: '부서 추가에 실패했습니다.',
                        confirmButtonText: '확인'
                    });
                });
	        }
	    });
	});

    // 팀 추가
	$('#btnAddTeam').click(function () {
	    if (!selectedDeptIdx) {
	        Swal.fire({
	            icon: 'error',
	            title: '선택 불가',
	            text: '부서를 먼저 선택해주세요.',
	            confirmButtonText: '확인'
	        });
	        return;
	    }
	
	    Swal.fire({
	        title: '새 팀 이름을 입력하세요',
	        input: 'text',
	        inputPlaceholder: '팀명',
	        showCancelButton: true,
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        inputValidator: (value) => {
	            if (!value.trim()) {
	                return '팀명을 입력해주세요.';
	            }
	            // 허용하는 문자: 가-힣, A-Z, a-z, 0-9, _ , -
	            const validPattern = /^[\uAC00-\uD7A3a-zA-Z0-9_\- ]+$/;
	            if (!validPattern.test(value.trim())) {
	                return '가-힣, A-Z, a-z, 0-9, 특수문자는 _ 와 - 만 허용됩니다.';
	            }
	            return null;
	        }
	    }).then((result) => {
	        if (result.isConfirmed) {
	            const teamName = result.value.trim();
	
	            ajaxPost(
					'/admin/systemPreference/dept/addTeam',
					{ teamName: teamName, departmentIdx: selectedDeptIdx }          // JSON 바디
				).then(function(team) {
                    $('#teamList').find('li.text-muted').remove();

                    $('#teamList').append(
                        `<li class="list-group-item d-flex justify-content-between align-items-center team-item"  data-teamidx="${team.teamIdx}">
                            <span>${team.teamName}</span>
							<div>
								<button type="button" class="btn btn-sm btn-secondary btn-edit-team">✎</button>
	                            <button type="button" class="btn btn-sm btn-danger btn-delete-team">−</button>
                        	</div>
                        </li>`
                    );

                    Swal.fire({
                        icon: 'success',
                        title: '성공!',
                        text: '팀 추가가 완료되었습니다.',
                        confirmButtonText: '확인'
                    });
                })
                .catch(function() {
                    Swal.fire({
                        icon: 'error',
                        title: '실패',
                        text: '팀 추가에 실패했습니다.',
                        confirmButtonText: '확인'
                    });
                });
	        }
	    });
	});

    // 직책 추가
	$('#btnAddRole').click(function () {
	    if (!selectedDeptIdx) {
	        Swal.fire({
	            icon: 'error',
	            title: '선택 불가',
	            text: '부서를 먼저 선택해주세요.',
	            confirmButtonText: '확인'
	        });
	        return;
	    }
	
	    Swal.fire({
	        title: '새 직책 이름을 입력하세요',
	        input: 'text',
	        inputPlaceholder: '직책명',
	        showCancelButton: true,
	        confirmButtonText: '확인',
	        cancelButtonText: '취소',
	        inputValidator: (value) => {
	            if (!value.trim()) {
	                return '직책명을 입력해주세요.';
	            }
	            // 허용하는 문자: 가-힣, A-Z, a-z, 0-9, _ , -
	            const validPattern = /^[\uAC00-\uD7A3a-zA-Z0-9_\- ]+$/;
	            if (!validPattern.test(value.trim())) {
	                return '가-힣, A-Z, a-z, 0-9, 특수문자는 _ 와 - 만 허용됩니다.';
	            }
	            return null;
	        }
	    }).then((result) => {
	        if (result.isConfirmed) {
	            const roleName = result.value.trim();
	
	            ajaxPost('/admin/systemPreference/dept/addRole',
					{ roleName: roleName, departmentIdx: selectedDeptIdx }
				).then(function(role) {
                    $('#roleList').find('li.text-muted').remove();
                    $('#roleList').append(
                        `<li class="list-group-item d-flex justify-content-between align-items-center role-item"  data-roleidx="${role.roleIdx}">
                            <span>${role.roleName}</span>
							<div>
								<button type="button" class="btn btn-sm btn-secondary btn-edit-role">✎</button>
	                            <button type="button" class="btn btn-sm btn-danger btn-delete-role">−</button>
                        	</div>
                        </li>`
                    );
                    Swal.fire({
                        icon: 'success',
                        title: '성공!',
                        text: '직책 추가가 완료되었습니다.',
                        confirmButtonText: '확인'
                    });
                })
				.catch(function() {
                    Swal.fire({
                        icon: 'error',
                        title: '실패',
                        text: '직책 추가에 실패했습니다.',
                        confirmButtonText: '확인'
                    });
                });
	        }
	    });
	});

	// 부서 삭제
    $(document).on('click', '.btn-delete-department', function (e) {
	    e.stopPropagation();
		Swal.fire({
	        title: "정말 이 부서를 삭제하시겠습니까?",
	        text: "관련 팀, 직책, 직원 정보가 변경됩니다.",
	        icon: "warning",
	        showCancelButton: true,
	        confirmButtonText: "확인",
	        cancelButtonText: "취소"
	    }).then((result) => {
		    if (result.isConfirmed) {
		        
				let departmentIdx = $(this).closest('li').data('departmentidx');
		        let $targetLi = $(this).closest('li');
				
		        ajaxPost(
					'/admin/systemPreference/dept/removeDepartment',
					{departmentIdx:departmentIdx}
				).then( function() {
	                $targetLi.remove();

	                Swal.fire({
					    icon: 'success',  // 아이콘 종류: success, error, warning, info, question
					    title: '성공!',
					    text: '부서 삭제가 완료되었습니다.',
					    confirmButtonText: '확인'
					});
	                // 관련 UI 초기화 추가
	                $('#teamList').empty();
	                $('#roleList').empty();
	                $('#btnAddTeam').prop('disabled', true);
	                $('#btnAddRole').prop('disabled', true);
	            })
				.catch( function() {
	                Swal.fire({
					    icon: 'error',
					    title: '실패',
					    text: '부서 삭제에 실패했습니다.',
					    confirmButtonText: '확인'
					});
		        });
		    }
		});
	});

	// 팀 삭제
	$(document).on('click', '.btn-delete-team', function (e) {
	    e.stopPropagation();
	
	    Swal.fire({
	        title: '정말 이 팀을 삭제하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonText: '확인',
	        cancelButtonText: '취소'
	    }).then((result) => {
	        if (result.isConfirmed) {
	            let teamIdx = $(this).closest('li').data('teamidx');
	            let $targetLi = $(this).closest('li');
				ajaxPost(
					'/admin/systemPreference/dept/removeTeam',
					{ teamIdx: teamIdx }
				)
				.then(function() {
                    $targetLi.remove(); // UI에서 제거
                    Swal.fire({
                        icon: 'success',
                        title: '성공!',
                        text: '팀 삭제가 완료되었습니다.',
                        confirmButtonText: '확인'
                    });
                    // 필요하다면 직책 리스트도 비우기 및 버튼 비활성화 처리
                    $('#positionList').empty();
                    $('#btnAddPosition').prop('disabled', true);
                })
				.catch(function() {
                    Swal.fire({
                        icon: 'error',
                        title: '실패',
                        text: '팀 삭제에 실패했습니다.',
                        confirmButtonText: '확인'
                    });
	            });
	        }
	    });
	});
	
	// 직책 삭제
	$(document).on('click', '.btn-delete-role', function (e) {
	    e.stopPropagation();
	
	    let $btn = $(this);  // 클릭한 버튼 요소 저장
	
	    Swal.fire({
	        title: '정말 이 직책을 삭제하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonText: '확인',
	        cancelButtonText: '취소'
	    }).then((result) => {
	        if (result.isConfirmed) {
	            let roleidx = $btn.closest('li').data('roleidx');
	
	            ajaxPost(
					'/admin/systemPreference/dept/removeRole',
					{ roleIdx: roleidx }
				).then( () => {
                    $btn.closest('li').remove();  // 삭제 성공 시 UI에서 해당 li 제거
                    Swal.fire({
                        icon: 'success',
                        title: '성공!',
                        text: '직책 삭제가 완료되었습니다.',
                        confirmButtonText: '확인'
                    });
                })
	            .catch( () => {
                    Swal.fire({
                        icon: 'error',
                        title: '실패',
                        text: '직책 삭제에 실패했습니다.',
                        confirmButtonText: '확인'
                    });
	            });
	        }
	        // 취소 시 별도 처리 없음
	    });
	});
	
	// 부서 수정
	$(document).on('click', '.btn-edit-department', function(e) {
	    e.stopPropagation();
	    let $li = $(this).closest('li');
	    let currentName = $li.find('.department-name').text();
	    let deptIdx = $li.data('departmentidx');
	
	    Swal.fire({
	        title: '부서명을 수정하세요',
	        input: 'text',
	        inputValue: currentName,
	        showCancelButton: true,
	        confirmButtonText: '저장',
	        cancelButtonText: '취소',
	        inputValidator: (value) => {
	            if (!value.trim()) {
	                return '부서명을 입력해주세요.';
	            }
	            if (value.trim() === currentName) {
	                return '변경된 이름을 입력해주세요.';
	            }
	            const validPattern = /^[\uAC00-\uD7A3a-zA-Z0-9_\- ]+$/;
	            if (!validPattern.test(value.trim())) {
	                return '가-힣, A-Z, a-z, 0-9, 특수문자는 _ 와 - 만 허용됩니다.';
	            }
	            return null;
	        }
	    }).then((result) => {
	        if (result.isConfirmed) {
	            let newName = result.value.trim();
	
	            ajaxPost(
					'/admin/systemPreference/dept/modifyDepartment',
					{ departmentIdx: deptIdx, departmentName: newName }
				).then(function() {
                    $li.find('.department-name').text(newName);
                    Swal.fire({
                        icon: 'success',
                        title: '성공!',
                        text: '부서 수정이 완료되었습니다.',
                        confirmButtonText: '확인'
                    });
                })
				.catch(function() {
                    Swal.fire({
                        icon: 'error',
                        title: '실패',
                        text: '부서 수정에 실패했습니다.',
                        confirmButtonText: '확인'
                    });
	            });
	        }
	    });
	});
	
	// 팀 수정
	$(document).on('click', '.btn-edit-team', function(e) {
	    e.stopPropagation();
	    let $li = $(this).closest('li');
	    let currentName = $li.find('span').text();
	    let teamIdx = $li.data('teamidx');
	
	    Swal.fire({
	        title: '팀명을 수정하세요',
	        input: 'text',
	        inputValue: currentName,
	        showCancelButton: true,
	        confirmButtonText: '저장',
	        cancelButtonText: '취소',
	        inputValidator: (value) => {
	            if (!value.trim()) {
	                return '팀명을 입력해주세요.';
	            }
	            if (value.trim() === currentName) {
	                return '변경된 이름을 입력해주세요.';
	            }
	            const validPattern = /^[\uAC00-\uD7A3a-zA-Z0-9_\- ]+$/;
	            if (!validPattern.test(value.trim())) {
	                return '가-힣, A-Z, a-z, 0-9, 특수문자는 _ 와 - 만 허용됩니다.';
	            }
	            return null;
	        }
	    }).then((result) => {
	        if (result.isConfirmed) {
	            let newName = result.value.trim();
	
	            ajaxPost(
					'/admin/systemPreference/dept/modifyTeam',
					{ teamIdx: teamIdx, teamName: newName }
				).then(function() {
                    $li.find('span').text(newName);
                    Swal.fire({
                        icon: 'success',
                        title: '성공!',
                        text: '팀 수정이 완료되었습니다.',
                        confirmButtonText: '확인'
                    });
                })
				.catch( function() {
                    Swal.fire({
                        icon: 'error',
                        title: '실패',
                        text: '팀 수정에 실패했습니다.',
                        confirmButtonText: '확인'
                    });
	            });
	        }
	    });
	});
	
	// 직책 수정
	$(document).on('click', '.btn-edit-role', function(e) {
	    e.stopPropagation();
	    let $li = $(this).closest('li');
	    let currentName = $li.find('span').text();
//	    let roleIdx = 10;
	    let roleIdx = $li.data('roleidx');
	    Swal.fire({
	        title: '직책명을 수정하세요',
	        input: 'text',
	        inputValue: currentName,
	        showCancelButton: true,
	        confirmButtonText: '저장',
	        cancelButtonText: '취소',
	        inputValidator: (value) => {
	            if (!value.trim()) {
	                return '직책명을 입력해주세요.';
	            }
	            if (value.trim() === currentName) {
	                return '변경된 이름을 입력해주세요.';
	            }
	            const validPattern = /^[\uAC00-\uD7A3a-zA-Z0-9_\- ]+$/;
	            if (!validPattern.test(value.trim())) {
	                return '가-힣, A-Z, a-z, 0-9, 특수문자는 _ 와 - 만 허용됩니다.';
	            }
	            return null;
	        }
	    }).then((result) => {
	        if (result.isConfirmed) {
	            let newName = result.value.trim();
	
	            ajaxPost(
					'/admin/systemPreference/dept/modifyRole',
	                {roleIdx:roleIdx,roleName:newName }
				).then( function() {
                    $li.find('span').text(newName);
                    Swal.fire({
                        icon: 'success',
                        title: '성공!',
                        text: '직책 수정이 완료되었습니다.',
                        confirmButtonText: '확인'
                    });
                })
				.catch(function() {
                    Swal.fire({
                        icon: 'error',
                        title: '실패',
                        text: '직책 수정에 실패했습니다.',
                        confirmButtonText: '확인'
                    });
	            });
	        }
	    });
	});
	

	
	//부서 선택시 팀,역할 목록 불러오기
    function loadTeamsAndRoles(departmentIdx) {
	    $('#teamList').empty();
	    $('#roleList').empty();
	    if (!departmentIdx) return;
	   	ajaxGet(
			'/admin/systemPreference/dept/getTeamsAndRoles',
			{ departmentIdx: departmentIdx }
		).then(function(data) {
            // 팀 목록 표시
            if (Array.isArray(data.teams) && data.teams.length > 0) {
                data.teams.forEach(function(team) {
                    $('#teamList').append(
                        `<li class="list-group-item d-flex justify-content-between align-items-center team-item" data-teamidx="${team.teamIdx}">
                            <span>${team.teamName}</span>
							<div>
                                <button type="button" class="btn btn-sm btn-secondary btn-edit-team">✎</button> 
                            	<button type="button" class="btn btn-sm btn-danger btn-delete-team">−</button>
							</div>
                        </li>`
                    );
                });
            } else {
                $('#teamList').append(`<li class="list-group-item text-muted" >팀이 존재하지 않습니다.</li>`);
            }
            // 직책(roles) 표시
            if (Array.isArray(data.roles) && data.roles.length > 0) {
                data.roles.forEach(function(role) {
                    $('#roleList').append(
                        `<li class="list-group-item d-flex justify-content-between align-items-center role-item" data-roleidx="${role.roleIdx}">
                            <span>${role.roleName}</span>
							<div>
								<button type="button" class="btn btn-sm btn-secondary btn-edit-role">✎</button> 
                            	<button type="button" class="btn btn-sm btn-danger btn-delete-role">−</button>
							</div>
                        </li>`
                    );
                });
            } else {
                $('#roleList').append(`<li class="list-group-item text-muted" >직책이 존재하지 않습니다.</li>`);
            }
	    });
	}
	
	let selectedRoleIdx = null;
	let originalAuthorities = new Set(); // 초기 권한 상태
	let currentAuthorities = new Set();  // 현재 권한 상태
    // 직책 선택시 이벤트
    $(document).on('click', '.role-item', function () {
		//권한목록 보이기
		checkBox.show();
		$('#btnSaveAutho').hide();
        $('.role-item').removeClass('active');
        $(this).addClass('active');
        selectedRoleIdx = $(this).data('roleidx');
		
        loadRolesAutho(selectedRoleIdx);
		$('#btnSaveAutho').prop('disabled', true);
    });

	//직책이가진권한불러오기
	function loadRolesAutho(roleIdx) {
	    if(!roleIdx) return
		ajaxGet('/admin/systemPreference/dept/getAutho',{ roleIdx: roleIdx } )
	    	.then(function(data) {
				//체크박스상태초기화
				document.querySelectorAll('input[type="checkbox"]').forEach(function(cb) {
                	cb.checked = false;
				});
	            // 직책이 가진 권한 체크박스 표시
	            if (Array.isArray(data) && data.length > 0) {
					document.querySelectorAll('input[type="checkbox"]').forEach(function(cb) {
					    cb.checked = false;
					});
	                data.forEach(function(autho) {
						const checkbox = document.querySelector(`input[type="checkbox"][value="${autho.autho_idx}"]`);
	                   	if (checkbox) {
					        checkbox.checked = true;
					    };
	                });
	            } else {
	                Swal.fire({
		                title: '경고',
						html: '부여된 권한이 없습니다.',
            		});
	            }
				//원래 가지고있던 권한정보 저장
				saveOriginalState();
	        });
	}
	
	// 직책별 권한 상태 저장
	function saveOriginalState() {
	    originalAuthorities.clear();
	    currentAuthorities.clear();

		$(checkBox).filter(':checked').each(function(){
			const value = $(this).val();
			originalAuthorities.add(value);
			currentAuthorities.add(value);
		})
		console.log('직급의 초기 권한:', Array.from(originalAuthorities));
	}
	
	// 현재 체크박스 상태 저장
    function updateCurrentState() {
        currentAuthorities.clear();
        
        checkBox.filter(':checked').each(function() {
            currentAuthorities.add($(this).val());
        });
    }

	// Set 비교 함수
    function setsEqual(set1, set2) {
        if (set1.size !== set2.size) return false;
        for (let item of set1) {
            if (!set2.has(item)) return false;
        }
        return true;
    }

	// 직책 상태 변경사항 분석
    function getChangeDetails() {
        const addedAuthorities = [...currentAuthorities].filter(x => !originalAuthorities.has(x));
        const removedAuthorities = [...originalAuthorities].filter(x => !currentAuthorities.has(x));
        
        return {
            roleIdx: selectedRoleIdx,
            added: addedAuthorities,        // DB에 INSERT할 권한들
            removed: removedAuthorities,    // DB에서 DELETE할 권한들
            hasChanges: addedAuthorities.length > 0 || removedAuthorities.length > 0,
            currentAll: Array.from(currentAuthorities)  // 현재 전체 권한 목록
        };
    }

	// 저장 버튼 상태 업데이트
    function updateSaveButton() {
        const hasChanges = !setsEqual(originalAuthorities, currentAuthorities);
        const saveButton = $('#btnSaveAutho');
        
        if (hasChanges) {
            saveButton.show();
            saveButton.prop('disabled', false);
            saveButton.text('변경사항 저장');
            saveButton.removeClass('btn-secondary').addClass('btn-primary');
            
        } else {
            saveButton.prop('disabled', true);
            saveButton.text('변경사항 없음');
            saveButton.removeClass('btn-primary').addClass('btn-secondary');
            
            console.log('변경사항 없음');
        }
    }
	
	
	
	//직책의 권한리스트 변경이벤트
	$('#authoList').on('change','input[type="checkbox"]',function(){
		const checkbox = $(this);
        const value = checkbox.val();
        const isChecked = checkbox.is(':checked');

		console.log(`권한 ${value} 상태 변경: ${isChecked ? '체크됨' : '해제됨'}`);
		// 현재 상태 업데이트
        updateCurrentState();
        // 저장 버튼 상태 업데이트
        updateSaveButton();
	});
	
	
	//직책의 권한 변경 후 저장버튼
	$('#btnSaveAutho').on('click','',function(){
		const changes = getChangeDetails();
		
		if (!changes.hasChanges) {
            Swal.fire({
                title: '경고',
				html: '변경된 권한이없습니다.',
				icon: 'error'
            });
            return;
        }

		console.log('저장할 데이터:');
        console.log('선택된 직책 ID:', selectedRoleIdx);
        console.log('추가된 권한:', changes.added);
        console.log('제거된 권한:', changes.removed);
        console.log('현재 전체 권한:', Array.from(currentAuthorities));
		//DB저장 로직 함수 호출(roleIdx, 현재선택된권한모록)
		saveRoleAuthorities(changes);
	});
	
	//ROLE_AUTHO 테이블 저장함수
	function saveRoleAuthorities(changes) {
	    const saveData = {
	        roleIdx: changes.roleIdx,
	        addedAuthorities: changes.added,     // INSERT할 권한들
	        removedAuthorities: changes.removed  // DELETE할 권한들
    	};

		ajaxPost('/admin/systemPreference/dept/saveRoleAutho', saveData)
		.then(function(response) {
            console.log('서버 응답', response);
			Swal.fire({
                title: '성공',
				html: '권한이 변경되었습니다.',
				icon: 'success'
            });
			
			originalAuthorities = new Set(currentAuthorities);
            updateSaveButton();
		})
        .catch(function(error) {
//            Swal.fire({
//                title: '경고',
//				html: '권한 변경에 실패하였습니다.',
//				icon: 'error'
//            });
			console.error('Promise reject:', error);
            console.error('저장 실패:', error);
        });
	}
	// 수정버튼
	$('.btn-edit-autho').on('click','',function(){
		const authoIdx = $(this).data('authoidx');
		const authoName = $(this).data('authoname');
		console.log(authoIdx);
		Swal.fire({
	        title: '직책명을 수정하세요',
	        input: 'text',
	        inputValue: authoName,
	        showCancelButton: true,
	        confirmButtonText: '저장',
	        cancelButtonText: '취소',
	        inputValidator: (value) => {
	            if (!value.trim()) {
	                return '변경할 권한명을 입력해주세요.';
	            }
	            if (value.trim() === authoName) {
	                return '변경된 권한명을 입력해주세요.';
	            }
	            const validPattern = /^[\uAC00-\uD7A3a-zA-Z0-9 ]+$/;
	            if (!validPattern.test(value.trim())) {
	                return '가-힣, A-Z, a-z, 0-9만 허용됩니다.';
	            }
	            return null;
	        }
	    }).then((result) => {
	        if (result.isConfirmed) {
	            let newAuthoName = result.value.trim();
				ajaxPost(
					'/admin/systemPreference/dept/modifyAutho'
					, { authoIdx: authoIdx, authoName: newAuthoName}
				).then((data)=>{
					const  span = $(`li[data-authoidx="${authoIdx}"]`).find('span');
					span.html(newAuthoName);
					Swal.fire({
		                title: data.result,
						html: data.msg,
						icon: 'success'
		            });
				})
				.catch(() => {
					Swal.fire({
		                title: '실패',
						html: '잠시후 다시 시도하세요.',
						icon: 'error'
		            });	
				});
			}
		});
	});
	
	// 삭제버튼
	$('.btn-delete-autho').on('click','',function(){
		const authoIdx = $(this).data('authoidx');
		Swal.fire({
	        title: "권한삭제",
	        text: "권한을 삭제하시겠습니까?",
	        icon: "warning",
	        showCancelButton: true,
	        confirmButtonText: "확인",
	        cancelButtonText: "취소"
	    })
		.then((result) => {
		    if (result.isConfirmed) {
				ajaxPost(`/admin/systemPreference/dept/removeAutho/${authoIdx}`)
				.then((data)=>{
					Swal.fire({
			            title: data.result,
						html: data.msg,
						icon: 'success'
					}).then(()=>{
						window.location.reload();
					});
					
				}).catch(()=>{
					Swal.fire({
		                title: '실패',
						html: '잠시후 다시 시도하세요.',
						icon: 'error'
		            });	
				});
			};
		});
	});
	
	$('#btnAddAutho').on('click','',function(){
		Swal.fire({
        title: '새 권한 추가',
        html: `
            <input id="swal-authoCode" class="swal2-input" placeholder="권한 코드 (영문+숫자+_)">
            <input id="swal-authoName" class="swal2-input" placeholder="권한명 (한글+영문+숫자)">
        `,
        focusConfirm: false,
        showCancelButton: true,
        confirmButtonText: '추가',
        cancelButtonText: '취소',
        preConfirm: () => {
            const authoCode = document.getElementById('swal-authoCode').value.trim();
            const authoName = document.getElementById('swal-authoName').value.trim();

            // ① 기본 유효성 검사
            if (!authoCode || !authoName) {
                Swal.showValidationMessage('모든 필드를 입력해주세요');
                return false;
            }

            // ② 권한 코드 유효성 검사 (영어+숫자+특수문자+_)
            const codePattern = /^[a-zA-Z0-9_]+$/;
            if (!codePattern.test(authoCode)) {
                Swal.showValidationMessage('권한 코드는 영문, 숫자, _만 허용됩니다');
                return false;
            }

            // ③ 권한명 유효성 검사 (한글+영어+숫자)
            const namePattern = /^[\uAC00-\uD7A3a-zA-Z0-9]+$/;
            if (!namePattern.test(authoName)) {
                Swal.showValidationMessage('권한명은 한글, 영문, 숫자만 허용됩니다');
                return false;
            }

            // ④ 검증 통과 시 객체로 반환
            return {
                authoCode: authoCode,
                authoName: authoName
            };
        }})
		.then((result) => {
	        if (result.isConfirmed && result.value) {
	            const { authoCode, authoName } = result.value;
	            
	            console.log('입력된 권한 코드:', authoCode);
	            console.log('입력된 권한명:', authoName);
	            
	            // 여기서 AJAX 호출로 권한 추가
	            ajaxPost('/admin/systemPreference/dept/addAutho', 
					{authoCode: authoCode
	                , authoName: authoName }
				)
	            .then((response) => {
	                Swal.fire({
	                    icon: 'success',
	                    title: '성공!',
	                    text: '권한이 추가되었습니다.',
	                    confirmButtonText: '확인'
	                }).then(() => {
	                    
	                    window.location.reload();
	                });
	            })
	            .catch((error) => {
	                Swal.fire({
	                    icon: 'error',
	                    title: '실패',
	                    text: '권한 추가에 실패했습니다.',
	                    confirmButtonText: '확인'
	                });
	                console.error('권한 추가 실패:', error);
	            });
	        }
	    });
	});
	
	
	
	
	
	//체크박스객체 숨기기
	const checkBox = $('#authoList').find('input[type="checkbox"]');
	checkBox.hide();
	$('#btnSaveAutho').hide();
	console.log(selectedRoleIdx);
});
