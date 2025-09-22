/**
 * 물류관리 ERP 시스템 공통 JavaScript
 */

//console.log('common.js 로드됨');
// 다크모드 관리
const DarkModeManager = {
    isDarkMode: localStorage.getItem('darkMode') === 'true' || 
                (!localStorage.getItem('darkMode') && window.matchMedia('(prefers-color-scheme: dark)').matches),
    
    init: function() {
        this.updateDarkMode();
        this.bindEvents();
    },
    
    updateDarkMode: function() {
        const toggle = document.getElementById('dark-mode-toggle');
        if (this.isDarkMode) {
            document.documentElement.classList.add('dark');
            if (toggle) toggle.classList.add('active');
        } else {
            document.documentElement.classList.remove('dark');
            if (toggle) toggle.classList.remove('active');
        }
        localStorage.setItem('darkMode', this.isDarkMode);
    },
    
    toggle: function() {
        this.isDarkMode = !this.isDarkMode;
        this.updateDarkMode();
    },
    
    bindEvents: function() {
        const self = this;
        document.addEventListener('click', function(e) {
            if (e.target.id === 'dark-mode-toggle') {
                self.toggle();
            }
        });
    }
};

// 모바일 메뉴 관리
const MobileMenuManager = {
    init: function() {
        this.bindEvents();
    },
    
    bindEvents: function() {
        // 모바일 메뉴 열기
        const mobileMenuButton = document.getElementById('mobile-menu-button');
        if (mobileMenuButton) {
            mobileMenuButton.addEventListener('click', function() {
                const mobileMenu = document.getElementById('mobile-menu');
                if (mobileMenu) {
                    mobileMenu.classList.add('open');
                }
            });
        }
        
        // 모바일 메뉴 닫기
        const mobileMenuClose = document.getElementById('mobile-menu-close');
        if (mobileMenuClose) {
            mobileMenuClose.addEventListener('click', function() {
                const mobileMenu = document.getElementById('mobile-menu');
                if (mobileMenu) {
                    mobileMenu.classList.remove('open');
                }
            });
        }
        
        // 모바일 메뉴 외부 클릭시 닫기
        const mobileMenu = document.getElementById('mobile-menu');
        if (mobileMenu) {
            mobileMenu.addEventListener('click', function(e) {
                if (e.target === e.currentTarget) {
                    mobileMenu.classList.remove('open');
                }
            });
        }
    }
};

// 상단 프로필이미지 클릭(정보변경, 로그아웃, 다크모드 토글)팝오버
const ProfileManager = {
    init: function() {
        this.profileBtn = document.getElementById('profile');
        this.popover = document.getElementById('employeeInfo');
        if (!this.profileBtn || !this.popover) {
	        console.warn('Profile elements not found in DOM at init');
	        return;
    	}
        this.bindEvents();
    },
    bindEvents: function() {
        this.profileBtn.addEventListener('click', (e) => {
            e.preventDefault();
			e.stopPropagation(); // 전파차단
            this.togglePopover(); // 여기서 this는 ProfileManager 객체
        });

        // 바깥 클릭 시 팝오버 닫기
        document.addEventListener('click', (e) => {
            if (this.popover.classList.contains('show') &&
                !this.popover.contains(e.target) &&
                e.target !== this.profileBtn) {
                this.closePopover();
            }
        });
    },
    togglePopover: function() {
        const isShown = this.popover.classList.toggle('show');
        this.popover.setAttribute('aria-hidden', !isShown);
		console.log('Popover show 상태:', isShown); // show가 토글되는지도 찍어보자
    },
    closePopover: function() {
        this.popover.classList.remove('show');
        this.popover.setAttribute('aria-hidden', 'true');
    }
};



const ModalManager = {
	init: function() {
		this.bindEvents();
		this.bindEscKey();
	},

	bindEvents: function() {
	  	this.modals = document.querySelectorAll('.modal');
	  	this.modals.forEach(modal => {
			modal.addEventListener('click', e => {
			  if (e.target === modal) this.closeModal(modal);
			});
			const closeBtn = modal.querySelector('.modal-close-btn');
			if (closeBtn) closeBtn.addEventListener('click', () => this.closeModal(modal));
	  	});
	},
	
	bindEscKey: function() {
		document.addEventListener('keydown', e => {
			if (e.key === 'Escape' || e.key === 'Esc') {
			  const topModal = this.getTopModal();
			  if (topModal) this.closeModal(topModal);
			}
	  	});
	},
	
	getTopModal: function() {
		const opened = Array.from(document.querySelectorAll('.modal.open'));
		return opened.length ? opened[opened.length - 1] : null;
	},
	
	// 요소 참조로 열기
	openModal: function(modal) {
		if (!(modal instanceof HTMLElement)) return;
	  	modal.classList.add('open');
		document.body.classList.add('modal-open');
	},
	
	// ID로 열기 호출 시 openModal을 사용
	openModalById: function(id) {
		const modal = document.getElementById(id);
		this.openModal(modal);
	},
	
	closeModal: function(modal) {
		modal.classList.remove('open');
		if (!document.querySelector('.modal.open')) {
		document.body.classList.remove('modal-open');
		}
	},
	
	closeModalById: function(id) {
		const modal = document.getElementById(id);
		this.closeModal(modal);
	}
};


// Csrf토큰 가져오기
function getCsrf() {
  const tokenMeta  = document.querySelector('meta[name="_csrf"]');
  const headerMeta = document.querySelector('meta[name="_csrf_header"]');
  return {
    token:  tokenMeta  ? tokenMeta.content  : null,
    header: headerMeta ? headerMeta.content : null
  };
}

/*
 * GET 요청용 AJAX 헬퍼
 * @param {string} url   요청 URL
 * @param {Object} params 쿼리 파라미터 객체
 * @returns {Promise<any>}
 */
function ajaxGet(url, params = {}) {
  const { token, header } = getCsrf();
  return $.ajax({
    url,
    method: 'GET',
    data: params,
    dataType: 'json',
//    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
    contentType: 'application/json; charset=UTF-8', 
    beforeSend(xhr) {
      if (token && header) xhr.setRequestHeader(header, token);
    }
  }).promise();
}

/*
 * POST 요청용 AJAX 헬퍼
 * @param {string} url   요청 URL
 * @param {Object} data  전송할 폼 데이터 객체
 * @returns {Promise<any>}
 */
function ajaxPost(url, data = {}) {
  const { token, header } = getCsrf();
  return $.ajax({
    url,
    method: 'POST',
    data: JSON.stringify(data),
    dataType: 'json',
//    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
    contentType: 'application/json; charset=UTF-8', 
    beforeSend(xhr) {
      if (token && header) xhr.setRequestHeader(header, token);
    }
  }).promise();
}

//파일전송용 ajax함수
// ajaxPostWithFile('/admin/sys', '#formId').then().catch()
function ajaxPostWithFile(url, formId, additionalFiles = null) {
	const { token, header } = getCsrf();
  
	// 지정된 폼으로 FormData 생성
	const form = document.querySelector(formId);
	const formData = new FormData(form);  // ⭐ 여기서 폼 지정!

	// 추가 파일이 있으면 추가
	if (additionalFiles) {
		if (additionalFiles instanceof FileList) {
			for (let i = 0; i < additionalFiles.length; i++) {
				formData.append("files", additionalFiles[i]);
			}
		} else {
			formData.append("file", additionalFiles);
		}
	}
 
	return $.ajax({
		url,
		method: 'POST',
		data: formData,
		contentType: false,
		processData: false,
		  	beforeSend(xhr) {
		    	if (token && header) xhr.setRequestHeader(header, token);
			}
	}).promise();
}

// 알림 메시지 관리
const NotificationManager = {
    show: function(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.innerHTML = `
            <span>${message}</span>
            <button class="notification-close" onclick="this.parentElement.remove()">&times;</button>
        `;
        
        // 알림 컨테이너가 없으면 생성
        let container = document.getElementById('notification-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'notification-container';
            container.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                max-width: 400px;
            `;
            document.body.appendChild(container);
        }
        
        container.appendChild(notification);
        
        // 자동 제거 (5초 후)
        setTimeout(function() {
            if (notification.parentElement) {
                notification.remove();
            }
        }, 5000);
    },
    
    success: function(message) {
        this.show(message, 'success');
    },
    
    error: function(message) {
        this.show(message, 'error');
    },
    
    warning: function(message) {
        this.show(message, 'warning');
    }
};

// 전역 함수들
window.showNotification = NotificationManager.show.bind(NotificationManager);
window.showSuccess = NotificationManager.success.bind(NotificationManager);
window.showError = NotificationManager.error.bind(NotificationManager);
window.showWarning = NotificationManager.warning.bind(NotificationManager);



// 페이지 초기화(DOMContentLoaded)
document.addEventListener('DOMContentLoaded', function() {
	
    DarkModeManager.init();
    MobileMenuManager.init();
	ProfileManager.init();
	ModalManager.init();
    //사이드바토글
	const toggleBtn = document.getElementById('sidebar-toggle');
	const sidebar = document.getElementById('sidebar');
	
	//사이드바 토글
	if (toggleBtn && sidebar) {
		toggleBtn.addEventListener('click', function() {
			if (window.innerWidth <= 800) {
				sidebar.classList.toggle('open'); // 모바일용
			} else {
				sidebar.classList.toggle('sidebar-collapsed'); // PC용
			}
		});
		
		// 모바일 화면 사이드바 바깥 클릭시 사이드바닫힘
		document.addEventListener('click', function(e) {
	        if (
	            sidebar.classList.contains('open') &&
	            !sidebar.contains(e.target) &&
	            e.target !== toggleBtn
	        ) {
	            sidebar.classList.remove('open');
	        }
	    });
	}
	
    // 로그아웃 버튼 클릭 처리
    document.querySelectorAll('[data-action="logout"]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            if (confirm('정말 로그아웃하시겠습니까?')) {
				ajaxPost('/logoutForSecurity').then(()=>{
					window.location.href = '/?t=' + Date.now();
				})
				.catch((error) => {
	                console.error('로그아웃 실패:', error);
	                // 실패해도 페이지 이동 (세션 만료 등의 경우)
	                window.location.href = '/';
	            });
            }
        });
    });

	// 정보변경 버튼 클릭 처리
	document.querySelectorAll('[data-modal-target]').forEach(btn => {
	    btn.addEventListener('click', async () => {
			try { 
		        const modalId = btn.getAttribute('data-modal-target');
		        ModalManager.openModalById(modalId);
				
				$('#changeInfoForm')[0].reset();
				$('#passwordStrengthMsg').empty();
				$('#passwordMatchMsg').empty();
				
				await loadCurrentUserInfo();
	            captureOriginalData();
	            switchMode(false);
			} catch (error) { 
            	console.error('정보 불러오기 또는 초기화 중 오류:', error);
        	}
	    });
	});
	
	// 정보변경 버튼 클릭시 최신 정보 불러오기 
	function loadCurrentUserInfo() {
	    return ajaxGet('/admin/employeeManagement/getOneEmployeeInfo')
        	.then(function(data) {
	            if (data) {
	                updateUserInfoModal(data);
	                return data;
	            } else {
	                console.error('사용자 정보를 받아오지 못했습니다.');
	                return null;
	            }
	        })
	        .catch(function(err) {
	            console.error('사용자 정보 로드 중 오류:', err);
	            return null;
	        });
	}
	
	// 모달 필드 업데이트 함수 (실제 데이터 구조에 맞춤)
	function updateUserInfoModal(data) {
	    if (!modal || !data) return;
		    	    
	    if (empNoInput && data.empNo) empNoInput.value = data.empNo;
	    if (empNameInput && data.empName) empNameInput.value = data.empName;
	    if (empDepartmentInput && data.commonCode) empDepartmentInput.value = data.commonCode.commonCodeName;
	    if (empTeamInput && data.team) empTeamInput.value = data.team.teamName;
	    if (empRoleInput && data.role) empRoleInput.value = data.role.roleName;

	    if (phoneInput && data.empPhone) phoneInput.value = data.empPhone;
	    if (emailInput && data.empEmail) emailInput.value = data.empEmail || ''; // null인 경우 빈 문자열
	    if (hireDateInput && data.hireDate) {
			const date = new Date(data.hireDate);
		    // 날짜가 유효하면 로케일 포맷으로 표시
		    hireDateInput.value = isNaN(date.getTime()) ? '' : date.toLocaleDateString();		
		}
	    console.log('모달 정보 업데이트 완료:', data);
	}
	
	const modal = document.getElementById('change-info-modal');
	const updateBtn     = modal.querySelector('.btn-update');
	const editOnlyEls   = modal.querySelectorAll('.edit-only');
    const viewOnlyEls   = modal.querySelectorAll('.view-only');
    const cancelBtn     = modal.querySelector('button[data-modal-close].btn-cancel');

    const form          = modal.querySelector('#changeInfoForm');
 	// 비밀번호 강도 메시지 div
    const passwordStrengthMsg = modal.querySelector('#passwordStrengthMsg');
    const passwordMatchMsg = modal.querySelector('#passwordMatchMsg');
	// input 필드들 업데이트
    const empNoInput = modal.querySelector('#top_empNo');
	const empNameInput = modal.querySelector('#top_empName')
	const empDepartmentInput = modal.querySelector('#top_departmentName')
    const empTeamInput = modal.querySelector('#top_teamName');
    const empRoleInput = modal.querySelector('#top_roleName');
    const phoneInput = modal.querySelector('#top_empPhone');
    const emailInput = modal.querySelector('#top_empEmail');
    const hireDateInput = modal.querySelector('#top_hireDate');
    const pwd1          = modal.querySelector('#empPassword1');
    const pwd2          = modal.querySelector('#empPassword2');

	let originalData = {};
	
	function captureOriginalData() {
        originalData = {
            empNo: empNoInput.value,
            empName: empNameInput.value,
            empDepartment: empDepartmentInput.value,
            empTeam: empTeamInput.value,
            empRole: empRoleInput.value,
            empPhone: phoneInput.value,
            empEmail: emailInput.value
        };
    }

    function restoreOriginalData() {
    	empNoInput.value = originalData.empNo;
    	empNameInput.value = originalData.empName;
    	empDepartmentInput.value = originalData.empDepartment;
    	empTeamInput.value = originalData.empTeam;
    	empRoleInput.value = originalData.empRole;
        phoneInput.value = originalData.empPhone;
        emailInput.value = originalData.empEmail;
        
        pwd1.value = '';
        pwd2.value = '';
    }

    function switchMode(editing) {
        // readonly 상태 변경
        phoneInput.readOnly = !editing;
        emailInput.readOnly = !editing;
        
        // 편집 전용 요소들 표시/숨김
        editOnlyEls.forEach(el => el.style.display = editing ? '' : 'none');
        viewOnlyEls.forEach(el => el.style.display = editing ? 'none' : '');
        
        updateBtn.textContent = editing ? '취소' : '수정';
        
        // readonly 스타일 변경 
        const readonlyInputs = [ phoneInput, emailInput];
        readonlyInputs.forEach(input => {
            if (editing) {
                input.style.cursor = 'text';
            } else {
                input.style.cursor = 'default';
            }
        });
    }
    
 	// 휴대폰 번호 실시간 포맷팅 (수정된 버전)
    phoneInput.addEventListener('input', function(e) {
        if (phoneInput.readOnly) return;
        
        let value = e.target.value.replace(/[^0-9]/g, '');
        
        if (value.length > 11) {
            value = value.slice(0, 11);
        }
        
        // 실시간 하이픈 추가
        if (value.length <= 3) {
            e.target.value = value;
        } else if (value.length <= 7) {
            e.target.value = value.slice(0, 3) + '-' + value.slice(3);
        } else {
            e.target.value = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7);
        }
    });
 	
    // 휴대폰 번호 키 입력 제한 (숫자와 백스페이스, 델리트만 허용)
    phoneInput.addEventListener('keydown', function(e) {
        if (phoneInput.readOnly) return;
        
        // 숫자, 백스페이스, 델리트, 탭, 화살표 키만 허용
        const allowedKeys = [
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
            'Backspace', 'Delete', 'Tab', 'ArrowLeft', 'ArrowRight'
        ];
        
        if (!allowedKeys.includes(e.key)) {
            e.preventDefault();
        }
    });
    
 	// 비밀번호 강도 실시간 검사
    pwd1.addEventListener('input', function() {
        const password = pwd1.value;
        
        if (password.length === 0) {
            passwordStrengthMsg.innerHTML = '';
            return;
        }
        
        // 조건 체크
        let count = 0;
        if (password.length >= 8) count++;
        if (/[a-z]/.test(password)) count++;
        if (/[A-Z]/.test(password)) count++;
        if (/[0-9]/.test(password)) count++;
        if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) count++;
        
        let message = '';
        if (count < 2) {
            message = '<div style="color: #dc3545; font-size: 0.9rem;">비밀번호 조건: 8자 이상, 대문자, 소문자, 숫자, 특수문자 중 3가지 이상</div>';
        } else if (count === 2) {
            message = '<div style="color: #dc3545; font-weight: bold; font-size: 0.9rem;">위험</div>';
        } else if (count === 3) {
            message = '<div style="color: #ffc107; font-weight: bold; font-size: 0.9rem;">보통</div>';
        } else if (count >= 4) {
            message = '<div style="color: #28a745; font-weight: bold; font-size: 0.9rem;">안전</div>';
        }
        
        passwordStrengthMsg.innerHTML = message;
        checkPasswordMatch(); // 비밀번호 확인도 함께 체크
    });

    // 비밀번호 확인 실시간 검사
    pwd2.addEventListener('input', checkPasswordMatch);

    function checkPasswordMatch() {
        const password1 = pwd1.value;
        const password2 = pwd2.value;
        
        if (password2.length === 0) {
            passwordMatchMsg.innerHTML = '';
            return;
        }
        
        if (password1 === password2) {
            passwordMatchMsg.innerHTML = '<div style="color: #28a745; font-size: 0.9rem;">✓ 비밀번호가 일치합니다</div>';
        } else {
            passwordMatchMsg.innerHTML = '<div style="color: #dc3545; font-size: 0.9rem;">✗ 비밀번호가 일치하지 않습니다</div>';
        }
    }

    // 폼 제출 전 유효성 검사
    form.addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
            return false;
        }
    });

    function validateForm() {
        // 휴대폰 번호 검사
        const phone = phoneInput.value.trim();
        if (!phone) {
            alert('휴대폰 번호를 입력해주세요.');
            phoneInput.focus();
            return false;
        }
        
        // 010-XXXX-XXXX 형식 검사
        if (!/^010-\d{4}-\d{4}$/.test(phone)) {
            alert('휴대폰 번호는 010-XXXX-XXXX 형식으로 입력해주세요.');
            phoneInput.focus();
            return false;
        }

        // 이메일 검사 (선택사항)
        const email = emailInput.value.trim();
        if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            alert('올바른 이메일 형식을 입력해주세요.');
            emailInput.focus();
            return false;
        }

        // 비밀번호 검사 (입력한 경우만)
        if (pwd1.value || pwd2.value) {
            if (pwd1.value !== pwd2.value) {
                alert('비밀번호가 일치하지 않습니다.');
                pwd1.focus();
                return false;
            }
            
            if (pwd1.value.length < 8) {
                alert('비밀번호는 8자 이상 입력해주세요.');
                pwd1.focus();
                return false;
            }
            
            // 복잡성 검사: 대소문자, 숫자, 특수문자 중 3종류 이상
            let complexityCount = 0;
            if (/[a-z]/.test(pwd1.value)) complexityCount++; // 소문자
            if (/[A-Z]/.test(pwd1.value)) complexityCount++; // 대문자
            if (/[0-9]/.test(pwd1.value)) complexityCount++; // 숫자
            if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(pwd1.value)) complexityCount++; // 특수문자
            
            if (complexityCount < 3) {
                alert('비밀번호는 대문자, 소문자, 숫자, 특수문자 중 3종류 이상 포함해야 합니다.');
                pwd1.focus();
                return false;
            }
        }

        return true;
    }
 
    // 수정/취소 토글
    updateBtn.addEventListener('click', function() {
        const editing = updateBtn.textContent === '수정';
        if (editing) {
            switchMode(true);
			$('#passwordStrengthMsg').empty();
			$('#passwordMatchMsg').empty();
        } else {
			restoreOriginalData();
            switchMode(false);
        }
    });

    // 취소 버튼 클릭
    cancelBtn.addEventListener('click', function() {
        restoreOriginalData();
        switchMode(false);
    });

    // 초기 상태 설정
    switchMode(false);

});
