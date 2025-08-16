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



// 페이지 초기화
document.addEventListener('DOMContentLoaded', function() {
    DarkModeManager.init();
    MobileMenuManager.init();
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
