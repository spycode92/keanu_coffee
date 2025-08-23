<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="addEmployeeModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="addEmployeeModalLabel" tabindex="-1">
    <div class="modal-card sm">
        <form action="/admin/employeeManagement/addEmployee"
              method="post"
              enctype="multipart/form-data"
              id="addEmployeeForm"
              class="modal-form">
            <div class="modal-head">
                <h5 id="addEmployeeModalLabel">직원 추가</h5>
                <button type="button"
                        class="modal-close-btn"
                        aria-label="닫기"
                        onclick="ModalManager.closeModal(document.getElementById('addEmployeeModal'))">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <!-- 프로필 + 파일 입력 + 이름/성별 -->
				<div style="display: flex; gap: 2rem; margin-bottom: 1rem;">
				    <!-- 왼쪽: 프로필 & 파일 입력 -->
				    <div style="display: flex; flex-direction: column; align-items: center; gap: 0.5rem;">
				        <div style="position: relative; width:100px; height:100px;">
				            <img id="profilePreview"
				                 src="/resources/images/default_profile_photo.png"
				                 alt="프로필 사진"
				                 style="width:100%; height:100%; object-fit:cover; border-radius:50%; border:1px solid #d9d9d9;">
				            <button type="button"
				                    id="deleteProfileBtn"
				                    class="btn btn-destructive btn-sm"
				                    style="position:absolute; top:-8px; right:-8px; width:24px; height:24px; padding:0; border-radius:50%; display:flex; align-items:center; justify-content:center;">
				                ×
				            </button>
				        </div>
				        <input type="file"
				               name="files"
				               id="profileImage"
				               accept="image/*"
				               class="form-control"
				               style="width:100px; padding:.25rem .5rem;">
				    </div>
				
				    <!-- 오른쪽: 이름/성별 -->
				    <div style="flex:1; display:flex; flex-direction: column; gap:1rem;">
				        <div class="field">
				            <label class="form-label">이름</label>
				            <input type="text" name="empName" required class="form-control">
				        </div>
				        <div class="field">
				            <label class="form-label">성별</label>
				            <div class="seg-radio" style="display:flex; gap:1rem;">
				                <label><input type="radio" name="empGender" value="남자" checked required> 남자</label>
				                <label><input type="radio" name="empGender" value="여자"> 여자</label>
				            </div>
				        </div>
				    </div>
				</div>

                <!-- 이메일/연락처 -->
                <div style="display:flex; gap:2rem; margin-bottom:1rem;">
                    <div class="field" style="flex:1;">
                        <label class="form-label">이메일</label>
                        <input type="email" name="empEmail" required class="form-control">
                    </div>
                    <div class="field" style="flex:1;">
                        <label class="form-label">연락처</label>
                        <input type="text" name="empPhone" required class="form-control">
                    </div>
                </div>

                <!-- 부서/팀/직책 -->
                <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:1rem; margin-bottom:1rem;">
                    <div class="field">
                        <label class="form-label">부서</label>
                        <select name="deptName" class="form-control">
                            <option value="">없음</option>
                            <option value="개발부">개발부</option>
                            <option value="마케팅부">마케팅부</option>
                            <option value="영업부">영업부</option>
                        </select>
                    </div>
                    <div class="field">
                        <label class="form-label">팀</label>
                        <select name="teamName" class="form-control">
                            <option value="">없음</option>
                            <option value="프론트엔드팀">프론트엔드팀</option>
                            <option value="백엔드팀">백엔드팀</option>
                            <option value="기획팀">기획팀</option>
                        </select>
                    </div>
                    <div class="field">
                        <label class="form-label">직책</label>
                        <select name="empPosition" class="form-control">
                            <option value="">없음</option>
                            <option value="사원">사원</option>
                            <option value="주임">주임</option>
                            <option value="대리">대리</option>
                            <option value="과장">과장</option>
                        </select>
                    </div>
                </div>

                <!-- 고용일 -->
                <div class="field">
                    <label class="form-label">고용일</label>
                    <input type="date" name="hireDate" class="form-control">
                </div>
            </div>
            <div class="modal-foot">
                <button type="submit" class="btn btn-primary">등록</button>
                <button type="button"
                        id="cancelBtn"
                        class="btn btn-secondary"
                        onclick="ModalManager.closeModal(document.getElementById('addEmployeeModal'))">
                    취소
                </button>
            </div>
        </form>
    </div>
</div>