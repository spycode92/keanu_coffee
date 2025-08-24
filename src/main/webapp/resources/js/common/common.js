/**
 * 물류관리 ERP 시스템 공통 JavaScript
 */
console.log('common.js 로드됨');
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
		 console.log('ProfileManager: 요소 모두 찾음, 이벤트 바인딩 시도');
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
    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
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
    data,
    dataType: 'json',
    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
    beforeSend(xhr) {
      if (token && header) xhr.setRequestHeader(header, token);
    }
  }).promise();
}


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
                // 실제 로그아웃 요청 전송
                window.location.href = '/logout';
            }
        });
    });

	// 정보변경 버튼 클릭 처리
	document.querySelectorAll('[data-modal-target]').forEach(btn => {
	    btn.addEventListener('click', () => {
	        const modalId = btn.getAttribute('data-modal-target');
	        ModalManager.openModalById(modalId);
			loadCurrentUserInfo();
	    });
	});
	
	// 정보변경 버튼 클릭시 최신 정보 불러오기 
	function loadCurrentUserInfo() {
	    return ajaxGet('/admin/employeeManagement/getOneEmployeeInfo')
	        .then(function(data) {
	            if (data) {
//					console.log(data)
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
	    const modal = document.getElementById('change-info-modal');
	    if (!modal || !data) return;
	
	    // 프로필 이미지 업데이트
	    const profileImg = modal.querySelector('#topProfilePreview');
	    if (profileImg) {
	        if (data.fileIdx || data.file_idx) {
	            // file_idx가 있으면 해당 파일로 이미지 설정
	            const fileId = data.fileIdx || data.file_idx;
	            profileImg.src = `/file/thumbnail/${fileId}?width=80&height=80`;
	        } else {
	            // file_idx가 없으면 기본 이미지
	            profileImg.src = '/resources/images/default_profile_photo.png';
	        }
	    }
	
	    // input 필드들 업데이트
	    const empIdInput = modal.querySelector('#empId');
	    const phoneInput = modal.querySelector('#empPhone');
	    const emailInput = modal.querySelector('#empEmail');
	    
	    if (empIdInput && data.empId) empIdInput.value = data.empId;
	    if (phoneInput && data.empPhone) phoneInput.value = data.empPhone;
	    if (emailInput && data.empEmail) emailInput.value = data.empEmail || ''; // null인 경우 빈 문자열
		    
	    console.log('모달 정보 업데이트 완료:', data);
	}
});
