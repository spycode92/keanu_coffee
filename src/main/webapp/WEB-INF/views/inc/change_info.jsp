<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 정보변경 모달창 -->
<div id="change-info-modal" class="modal">
    <div class="modal-card sm">
        <div class="modal-head">
            <h2>정보 변경</h2>
            <button type="button" class="modal-close-btn" data-modal-close>&times;</button>
        </div>
        
        <div class="modal-body modal-form">
            <form id="changeInfoForm" action="/admin/employeeManagement/modifyEmployeeInfo" method="post" enctype="multipart/form-data">
                <!-- 프로필 사진 -->
                <div class="field">
                    <label>프로필 사진</label>
                    
                    <input type="hidden" name="fileIdx" value=${sessionScope.sFIdx }>
                    <input type="hidden" name="empIdx" value=${sessionScope.sIdx }>
                    <div style="display: flex; justify-content: center; margin-bottom: 10px;">
                        <div style="position: relative;">
                            <img id="topProfilePreview" 
                            src=""
                            alt="프로필 사진"
                            style="width: 80px; height: 80px; object-fit: cover; border-radius: 50%; border: 1px solid #d9d9d9;">
                            
                            <!-- 삭제 버튼 (편집 모드에서만) -->
                            <button type="button" 
                                    id="deleteTopProfileImgBtn" 
                                    class="edit-only"
                                    name="files"
                                    style="position: absolute; top: -5px; right: -5px; background: #FF8C00; border: none; color: white; border-radius: 50%; width: 22px; height: 22px; font-weight: bold; cursor: pointer; display: none;">
                                ×
                            </button>
                        </div>
                    </div>
                    
                    <!-- 파일 입력 (편집 모드에서만) -->
                    <div class="edit-only" style="display: none;">
                        <input type="file" name="files" class="form-control" id="topPprofileImage" accept="image/*">
                        <input type="hidden" id="deleteTopProfileImgFlag" name="deleteTopProfileImgFlag" value="false">
                    </div>
                </div>

                <!-- 사원 ID -->
                <div class="field">
                    <label for="empId">사원 ID</label>
                    <input class="form-control" type="text" id="empId" name="empId" value="${sessionScope.sId}" disabled>
                </div>

                <!-- 휴대폰 번호 -->
                <div class="field">
				    <label for="empPhone">휴대폰 번호</label>
				    <input class="form-control" type="text" id="empPhone" name="empPhone" value="${sessionScope.sPhone}" 
				           readonly maxlength="13" placeholder="010-1234-5678">
				</div>

                <!-- 이메일 -->
                <div class="field">
                    <label for="empEmail">이메일</label>
                    <input class="form-control" type="email" id="empEmail" name="empEmail" value="${sessionScope.sEmail}" readonly>
                </div>

                <!-- 비밀번호 (편집 모드에서만) -->
                <div class="field edit-only" style="display: none;">
                    <label for="empPassword1">새 비밀번호</label>
                    <input class="form-control" type="password" id="empPassword1">
                    <div id="passwordStrengthMsg"></div>
                    <label for="empPassword2">새 비밀번호 확인</label>
                    <input class="form-control" type="password" id="empPassword2" name="empPassword">
                    <div id="passwordMatchMsg"></div>
                </div>
            </form>
        </div>
        
        <div class="modal-foot">
            <div class="view-only">
                <button type="button" class="btn btn-update">수정</button>
            </div>
            <div class="edit-only" style="display: none;">
                <button type="submit" form="changeInfoForm" class="btn btn-primary">저장</button>
                <button type="button" class="btn btn-secondary" data-modal-close>취소</button>
            </div>
        </div>
    </div>

    <script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function() {
        const modal         = document.getElementById('change-info-modal');
        const updateBtn     = modal.querySelector('.btn-update');
        const editOnlyEls   = modal.querySelectorAll('.edit-only');
        const viewOnlyEls   = modal.querySelectorAll('.view-only');
        const cancelBtn     = modal.querySelector('button[data-modal-close].btn-secondary');

        const form          = modal.querySelector('#changeInfoForm');
     	// 비밀번호 강도 메시지 div
        const passwordStrengthMsg = modal.querySelector('#passwordStrengthMsg');
        const passwordMatchMsg = modal.querySelector('#passwordMatchMsg');
        
        
        // Form inputs
        const fileInput     = modal.querySelector('#topPprofileImage');
        const preview       = modal.querySelector('#topProfilePreview');
        const deleteBtn     = modal.querySelector('#deleteTopProfileImgBtn');
        const deleteFlag    = modal.querySelector('#deleteTopProfileImgFlag');
        const empIdInput    = modal.querySelector('#empId');
        const phoneInput    = modal.querySelector('#empPhone');
        const emailInput    = modal.querySelector('#empEmail');
        const pwd1          = modal.querySelector('#empPassword1');
        const pwd2          = modal.querySelector('#empPassword2');

        let originalData = {};

        function captureOriginalData() {
            originalData = {
                imageSrc: preview.src,
                empId: empIdInput.value,
                empPhone: phoneInput.value,
                empEmail: emailInput.value
            };
        }

        function restoreOriginalData() {
            preview.src = originalData.imageSrc;
            empIdInput.value = originalData.empId;
            phoneInput.value = originalData.empPhone;
            emailInput.value = originalData.empEmail;
            
            fileInput.value = '';
            deleteFlag.value = 'false';
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
            
            // readonly 스타일 변경 (선택사항)
            const readonlyInputs = [empIdInput, phoneInput, emailInput];
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

        // 파일 선택 시 프리뷰 업데이트
        fileInput.addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                };
                reader.readAsDataURL(file);
                deleteFlag.value = 'none';
            }
        });

        // 프로필 사진 삭제
        deleteBtn.addEventListener('click', function() {
            fileInput.value = '';
            preview.src = '/resources/images/default_profile_photo.png';
            deleteFlag.value = 'true';
        });

        // 모달 열 때 초기 상태 저장
        document.querySelectorAll('[data-modal-target="change-info-modal"]').forEach(btn => {
            btn.addEventListener('click', function() {
                captureOriginalData();
                switchMode(false);
            });
        });

        // 수정/취소 토글
        updateBtn.addEventListener('click', function() {
            const editing = updateBtn.textContent === '수정';
            if (editing) {
                switchMode(true);
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
    </script>
</div>