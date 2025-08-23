/**
 * 물류관리 ERP 시스템 공통 JavaScript
 */

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

//정보변경 모달창
const InfoModalManager = {
    init: function() {
        this.modal = document.getElementById('change-info-modal');
        this.openBtn = document.getElementById('open-info-modal');
        this.closeBtn = document.getElementById('close-info-modal');
        this.cancelBtn = document.getElementById('cancel-info-modal');
        this.bindEvents();
    },
    bindEvents: function() {
        if (!this.modal) return;
		//?. 옵셔널 체인 구문버그 작동이상x
        // 열기
		if(this.openBtn){
	        this.openBtn.addEventListener('click', () => this.open());
		}
        // 닫기 (X, 취소)
		if(this.closeBtn){
	        this.closeBtn.addEventListener('click', () => this.close());
		}
		if(this.cancelBtn){
	        this.cancelBtn.addEventListener('click', () => this.close());
		}
        // 배경 클릭 시 닫기
        this.modal.addEventListener('click', (e) => {
            if (e.target === this.modal) this.close();
        });
    },
    open: function() {
        this.modal.classList.add('open');
    },
    close: function() {
        this.modal.classList.remove('open');
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
  }
};



// 페이지 초기화(DOMContentLoaded)
document.addEventListener('DOMContentLoaded', function() {
	
    DarkModeManager.init();
    MobileMenuManager.init();
	ProfileManager.init();
	InfoModalManager.init();
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
	
	

    console.log('물류관리 ERP 시스템 초기화 완료');
});
