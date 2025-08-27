
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
	
	            $.ajax({
	                url: '/admin/systemPreference/dept/addDepartment',
	                method: 'POST',
	                contentType: 'application/json',
	                data: JSON.stringify({ departmentName: deptName }),
	                dataType: 'json',
	                success: function(dept) {
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
	                },
	                error: function() {
	                    Swal.fire({
	                        icon: 'error',
	                        title: '실패',
	                        text: '부서 추가에 실패했습니다.',
	                        confirmButtonText: '확인'
	                    });
	                }
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
	
	            $.ajax({
	                url: '/admin/systemPreference/dept/addTeam',
	                method: 'POST',
	                contentType: 'application/json',
	                data: JSON.stringify({ teamName: teamName, departmentIdx: selectedDeptIdx }),
	                dataType: 'json',
	                success: function(team) {
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
	                },
	                error: function() {
	                    Swal.fire({
	                        icon: 'error',
	                        title: '실패',
	                        text: '팀 추가에 실패했습니다.',
	                        confirmButtonText: '확인'
	                    });
	                }
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
	
	            $.ajax({
	                url: '/admin/systemPreference/dept/addRole',
	                method: 'POST',
	                contentType: 'application/json',
	                data: JSON.stringify({ roleName: roleName, departmentIdx: selectedDeptIdx }),
	                dataType: 'json',
	                success: function(role) {
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
	                },
	                error: function() {
	                    Swal.fire({
	                        icon: 'error',
	                        title: '실패',
	                        text: '직책 추가에 실패했습니다.',
	                        confirmButtonText: '확인'
	                    });
	                }
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
		        $.ajax({
		            url: '/admin/systemPreference/dept/removeDepartment',
		            method: 'DELETE',
		            contentType: 'application/json',
		            data: JSON.stringify({ departmentIdx: departmentIdx }),
		            success: function() {
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
		            },
		            error: function() {
		                Swal.fire({
						    icon: 'error',
						    title: '실패',
						    text: '부서 삭제에 실패했습니다.',
						    confirmButtonText: '확인'
						});
		            }
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
	            $.ajax({
	                url: '/admin/systemPreference/dept/removeTeam',
	                method: 'DELETE',
	                contentType: 'application/json',
	                data: JSON.stringify({ teamIdx: teamIdx }),
	                success: function() {
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
	                },
	                error: function() {
	                    Swal.fire({
	                        icon: 'error',
	                        title: '실패',
	                        text: '팀 삭제에 실패했습니다.',
	                        confirmButtonText: '확인'
	                    });
	                }
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
	            let roleIdx = $btn.closest('li').data('roleidx');
	
	            $.ajax({
	                url: '/admin/systemPreference/dept/removeRole',
	                method: 'DELETE',
	                data: JSON.stringify({ roleIdx: roleIdx }),
	                contentType: 'application/json',
	                success: () => {
	                    $btn.closest('li').remove();  // 삭제 성공 시 UI에서 해당 li 제거
	                    Swal.fire({
	                        icon: 'success',
	                        title: '성공!',
	                        text: '직책 삭제가 완료되었습니다.',
	                        confirmButtonText: '확인'
	                    });
	                },
	                error: () => {
	                    Swal.fire({
	                        icon: 'error',
	                        title: '실패',
	                        text: '직책 삭제에 실패했습니다.',
	                        confirmButtonText: '확인'
	                    });
	                }
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
	
	            $.ajax({
	                url: '/admin/systemPreference/dept/modifyDepartment',
	                method: 'PUT',
	                contentType: 'application/json',
	                data: JSON.stringify({ departmentIdx: deptIdx, departmentName: newName }),
	                success: function() {
	                    $li.find('.department-name').text(newName);
	                    Swal.fire({
	                        icon: 'success',
	                        title: '성공!',
	                        text: '부서 수정이 완료되었습니다.',
	                        confirmButtonText: '확인'
	                    });
	                },
	                error: function() {
	                    Swal.fire({
	                        icon: 'error',
	                        title: '실패',
	                        text: '부서 수정에 실패했습니다.',
	                        confirmButtonText: '확인'
	                    });
	                }
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
	
	            $.ajax({
	                url: '/admin/systemPreference/dept/modifyTeam',
	                method: 'PUT',
	                contentType: 'application/json',
	                data: JSON.stringify({ teamIdx: teamIdx, teamName: newName }),
	                success: function() {
	                    $li.find('span').text(newName);
	                    Swal.fire({
	                        icon: 'success',
	                        title: '성공!',
	                        text: '팀 수정이 완료되었습니다.',
	                        confirmButtonText: '확인'
	                    });
	                },
	                error: function() {
	                    Swal.fire({
	                        icon: 'error',
	                        title: '실패',
	                        text: '팀 수정에 실패했습니다.',
	                        confirmButtonText: '확인'
	                    });
	                }
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
		console.log(",ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")
		console.log(roleIdx);
		console.log(",ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")
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
	
	            $.ajax({
	                url: '/admin/systemPreference/dept/modifyRole',
	                method: 'PUT',
	                contentType: 'application/json',
	                data: JSON.stringify({roleIdx:roleIdx,roleName:newName }),
	                success: function() {
	                    $li.find('span').text(newName);
	                    Swal.fire({
	                        icon: 'success',
	                        title: '성공!',
	                        text: '직책 수정이 완료되었습니다.',
	                        confirmButtonText: '확인'
	                    });
	                },
	                error: function() {
	                    Swal.fire({
	                        icon: 'error',
	                        title: '실패',
	                        text: '직책 수정에 실패했습니다.',
	                        confirmButtonText: '확인'
	                    });
	                }
	            });
	        }
	    });
	});
	

	
	//부서 선택시 팀,역할 목록 불러오기
    function loadTeamsAndRoles(departmentIdx) {
	    $('#teamList').empty();
	    $('#roleList').empty();
	    if (!departmentIdx) return;
	    $.ajax({
	        url: '/admin/systemPreference/dept/getTeamsAndRoles',
	        method: 'GET',
	        data: { departmentIdx: departmentIdx },
	        dataType: 'json',
	        success: function(data) {
				console.log("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")
				console.log(data);
				console.log("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")
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
	        }
	    });
	}


});
