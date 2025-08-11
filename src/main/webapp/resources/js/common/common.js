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

// 설정 모달 관리
const SettingsModalManager = {
    init: function() {
        this.bindEvents();
    },
    
    bindEvents: function() {
        // 설정 모달 열기
        const settingsButton = document.getElementById('settings-button');
        if (settingsButton) {
            settingsButton.addEventListener('click', function() {
                const settingsModal = document.getElementById('settings-modal');
                if (settingsModal) {
                    settingsModal.classList.add('open');
                }
            });
        }
        
        // 설정 모달 닫기
        const settingsClose = document.getElementById('settings-close');
        const settingsCancel = document.getElementById('settings-cancel');
        
        if (settingsClose) {
            settingsClose.addEventListener('click', this.closeModal);
        }
        
        if (settingsCancel) {
            settingsCancel.addEventListener('click', this.closeModal);
        }
        
        // 설정 모달 외부 클릭시 닫기
        const settingsModal = document.getElementById('settings-modal');
        if (settingsModal) {
            settingsModal.addEventListener('click', function(e) {
                if (e.target === e.currentTarget) {
                    SettingsModalManager.closeModal();
                }
            });
        }
    },
    
    closeModal: function() {
        const settingsModal = document.getElementById('settings-modal');
        if (settingsModal) {
            settingsModal.classList.remove('open');
        }
    }
};

// 토글 스위치 관리
const ToggleSwitchManager = {
    init: function() {
        this.bindEvents();
    },
    
    bindEvents: function() {
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('toggle-switch') && e.target.id !== 'dark-mode-toggle') {
                e.target.classList.toggle('active');
            }
        });
    }
};

// 테이블 관리
const TableManager = {
    init: function() {
        this.bindEvents();
    },
    
    bindEvents: function() {
        // 전체 선택 체크박스
        document.addEventListener('change', function(e) {
            if (e.target.type === 'checkbox' && e.target.classList.contains('select-all')) {
                const table = e.target.closest('table');
                if (table) {
                    const checkboxes = table.querySelectorAll('tbody input[type="checkbox"]');
                    checkboxes.forEach(function(checkbox) {
                        checkbox.checked = e.target.checked;
                    });
                }
            }
        });
    }
};

// 검색 및 필터 관리
const SearchManager = {
    init: function() {
        this.bindEvents();
    },
    
    bindEvents: function() {
        // 검색 버튼 클릭
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('btn-search')) {
                e.preventDefault();
                SearchManager.performSearch();
            }
        });
        
        // 초기화 버튼 클릭
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('btn-reset')) {
                e.preventDefault();
                SearchManager.resetSearch();
            }
        });
        
        // Enter 키 검색
        document.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && e.target.classList.contains('search-input')) {
                e.preventDefault();
                SearchManager.performSearch();
            }
        });
    },
    
    performSearch: function() {
        // 검색 로직 구현
        console.log('검색 실행');
        // 실제 구현에서는 AJAX 요청이나 폼 제출 등을 처리
    },
    
    resetSearch: function() {
        // 검색 초기화 로직
        const searchInputs = document.querySelectorAll('.search-input');
        searchInputs.forEach(function(input) {
            input.value = '';
        });
        
        const selectInputs = document.querySelectorAll('.search-select');
        selectInputs.forEach(function(select) {
            select.selectedIndex = 0;
        });
        
        console.log('검색 초기화');
    }
};

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

// 페이지 초기화
document.addEventListener('DOMContentLoaded', function() {
    DarkModeManager.init();
    MobileMenuManager.init();
    SettingsModalManager.init();
    ToggleSwitchManager.init();
    TableManager.init();
    SearchManager.init();
    
	const toggleBtn = document.getElementById('sidebar-toggle');
	const sidebar = document.getElementById('sidebar');
	
	if (toggleBtn && sidebar) {
		toggleBtn.addEventListener('click', function() {
			if (window.innerWidth <= 800) {
				sidebar.classList.toggle('open'); // 모바일용
			} else {
				sidebar.classList.toggle('sidebar-collapsed'); // PC용
			}
		});
	}
	
	

    console.log('물류관리 ERP 시스템 초기화 완료');
});

// 전역 함수들
window.showNotification = NotificationManager.show.bind(NotificationManager);
window.showSuccess = NotificationManager.success.bind(NotificationManager);
window.showError = NotificationManager.error.bind(NotificationManager);
window.showWarning = NotificationManager.warning.bind(NotificationManager);

// AJAX 공통 함수
window.ajaxRequest = function(url, method = 'GET', data = null, successCallback = null, errorCallback = null) {
    const xhr = new XMLHttpRequest();
    xhr.open(method, url, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                try {
                    const response = JSON.parse(xhr.responseText);
                    if (successCallback) {
                        successCallback(response);
                    }
                } catch (e) {
                    if (successCallback) {
                        successCallback(xhr.responseText);
                    }
                }
            } else {
                if (errorCallback) {
                    errorCallback(xhr.status, xhr.statusText);
                } else {
                    showError('요청 처리 중 오류가 발생했습니다.');
                }
            }
        }
    };
    
    if (data) {
        xhr.send(JSON.stringify(data));
    } else {
        xhr.send();
    }
};