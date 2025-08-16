
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
        let deptName = prompt("새 부서 이름을 입력하세요:");
        if (deptName) {
	        $.ajax({
	            url: '/admin/systemPreference/addDepartment',
	            method: 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify({ departmentName: deptName.trim() }),
	            dataType: 'json',
	            success: function(dept) {
	                // 서버에서 반환한 새 부서 정보로 리스트에 추가
	                $('#departmentList').append(
	                    `<li class="list-group-item d-flex justify-content-between align-items-center department-item" style="color: black;" data-departmentidx="${dept.idx}">
	                        <span class="department-name">${dept.departmentName}</span>
	                        <button type="button" class="btn btn-sm btn-danger btn-delete-department">−</button>
	                    </li>`
	                );
	            },
	            error: function() {
	                alert('부서 추가에 실패했습니다.');
	            }
	        });
	    }
    });

    // 팀 추가
    $('#btnAddTeam').click(function () {
	    if (!selectedDeptIdx) {
	        alert("부서를 먼저 선택하세요.");
	        return;
	    }
	    let teamName = prompt("새 팀 이름을 입력하세요:");
	    if (teamName) {
	        $.ajax({
	            url: '/admin/systemPreference/addTeam',
	            method: 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify({ teamName: teamName.trim(), departmentIdx: selectedDeptIdx }),
	            dataType: 'json',
	            success: function(team) {
					$('#teamList').find('li.text-muted').remove();
					
	                $('#teamList').append(
	                    `<li class="list-group-item d-flex justify-content-between align-items-center team-item" style="color: black;" data-teamidx="${team.idx}">
	                        <span>${team.teamName}</span>
	                        <button type="button" class="btn btn-sm btn-danger btn-delete-team">−</button>
	                    </li>`
	                );
	            },
	            error: function() {
	                alert('팀 추가에 실패했습니다.');
	            }
	        });
	    }
	});

    // 직책 추가
    $('#btnAddRole').click(function () {
	    if (!selectedDeptIdx) {
	        alert("부서를 먼저 선택하세요.");
	        return;
	    }
	    let roleName = prompt("새 직책 이름을 입력하세요:");
	    if (roleName && roleName.trim() !== '') {
	        $.ajax({
	            url: '/admin/systemPreference/addRole',
	            method: 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify({ roleName: roleName.trim(), departmentIdx: selectedDeptIdx }),
	            dataType: 'json',
	            success: function(role) {
	                // 존재하지 않습니다 문구 삭제
	                $('#roleList').find('li.text-muted').remove();
	
	                $('#roleList').append(
	                    `<li class="list-group-item d-flex justify-content-between align-items-center role-item" style="color: black;" data-roleidx="${role.idx}">
	                        <span>${role.roleName}</span>
	                        <button type="button" class="btn btn-sm btn-danger btn-delete-role">−</button>
	                    </li>`
	                );
	            },
	            error: function() {
	                alert('직책 추가에 실패했습니다.');
	            }
	        });
	    } else {
	        alert('유효한 직책 이름을 입력하세요.');
	    }
	});

	// 부서 삭제
    $(document).on('click', '.btn-delete-department', function (e) {
	    e.stopPropagation();
	    if (confirm("정말 이 부서를 삭제하시겠습니까? 관련 팀, 직책, 직원 정보가 변경됩니다.")) {
	        let deptIdx = $(this).closest('li').data('departmentidx');
	        let $targetLi = $(this).closest('li');
	        $.ajax({
	            url: '/admin/systemPreference/removeDepartment',
	            method: 'DELETE',
	            contentType: 'application/json',
	            data: JSON.stringify({ idx: deptIdx }),
	            success: function() {
	                $targetLi.remove();
	                alert("부서가 삭제되었습니다.");
	                // 관련 UI 초기화 추가
	                $('#teamList').empty();
	                $('#roleList').empty();
	                $('#btnAddTeam').prop('disabled', true);
	                $('#btnAddRole').prop('disabled', true);
	            },
	            error: function() {
	                alert("부서 삭제에 실패했습니다.");
	            }
	        });
	    }
	});

    // 팀 삭제
    $(document).on('click', '.btn-delete-team', function (e) {
	    e.stopPropagation();
	    if (confirm("정말 이 팀을 삭제하시겠습니까?")) {
	        let teamIdx = $(this).closest('li').data('teamidx');
	        let $targetLi = $(this).closest('li');
	        $.ajax({
	            url: '/admin/systemPreference/removeTeam',
	            method: 'DELETE',
	            contentType: 'application/json',
	            data: JSON.stringify({ idx: teamIdx }),
	            success: function() {
	                $targetLi.remove(); // UI에서 제거
	                alert('팀이 삭제되었습니다.');
	                // 필요하다면 직책 리스트도 비우기 및 버튼 비활성화 처리
	                $('#positionList').empty();
	                $('#btnAddPosition').prop('disabled', true);
	            },
	            error: function() {
	                alert('팀 삭제에 실패했습니다.');
	            }
	        });
	    }
	});
	
	//직책 삭제
	$(document).on('click', '.btn-delete-role', function (e) {
	    e.stopPropagation();
	    if (confirm("정말 이 직책을 삭제하시겠습니까?")) {
	        let roleIdx = $(this).closest('li').data('roleidx');
	
	        $.ajax({
	            url: '/admin/systemPreference/removeRole',  // 서버 삭제 API 주소
	            method: 'DELETE',
	            data: JSON.stringify({ idx: roleIdx }),
	            contentType: 'application/json',
	            success: () => {
	                // 삭제 성공 시 UI에서 해당 li 제거
	                $(this).closest('li').remove();
	                alert('직책이 삭제되었습니다.');
	            },
	            error: () => {
	                alert('직책 삭제에 실패했습니다.');
	            }
	        });
	    }
	});
	
	//부서 선택시 팀,역할 목록 불러오기
    function loadTeamsAndRoles(departmentIdx) {
	    $('#teamList').empty();
	    $('#roleList').empty();
	    if (!departmentIdx) return;
	    $.ajax({
	        url: '/admin/systemPreference/getTeamsAndRoles',
	        method: 'GET',
	        data: { departmentIdx: departmentIdx },
	        dataType: 'json',
	        success: function(data) {
	            // 팀 목록 표시
	            if (Array.isArray(data.teams) && data.teams.length > 0) {
	                data.teams.forEach(function(team) {
	                    $('#teamList').append(
	                        `<li class="list-group-item d-flex justify-content-between align-items-center team-item" style="color: black;" data-teamidx="${team.idx}">
	                            <span>${team.teamName}</span>
	                            <button type="button" class="btn btn-sm btn-danger btn-delete-team">−</button>
	                        </li>`
	                    );
	                });
	            } else {
	                $('#teamList').append(`<li class="list-group-item text-muted" style="color: black;">팀이 존재하지 않습니다.</li>`);
	            }
	            // 직책(roles) 표시
	            if (Array.isArray(data.roles) && data.roles.length > 0) {
	                data.roles.forEach(function(role) {
	                    $('#roleList').append(
	                        `<li class="list-group-item d-flex justify-content-between align-items-center role-item" style="color: black;" data-roleidx="${role.idx}">
	                            <span>${role.roleName}</span>
	                            <button type="button" class="btn btn-sm btn-danger btn-delete-role">−</button>
	                        </li>`
	                    );
	                });
	            } else {
	                $('#roleList').append(`<li class="list-group-item text-muted" style="color: black;">직책이 존재하지 않습니다.</li>`);
	            }
	        }
	    });
	}


});
