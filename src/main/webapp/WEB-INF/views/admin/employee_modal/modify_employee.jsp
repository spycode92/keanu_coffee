<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div id="modifyEmployeeModal" class="modal" >
    <div class="modal-card sm">
        <form action="/admin/employeeManagement/updateEmployee"
              method="post"
              enctype="multipart/form-data"
              id="modifyEmployeeForm"
              class="modal-form">
            <sec:csrfInput/>
            <div class="modal-head">
                <h5 id="modifyEmployeeModalLabel">직원 정보수정</h5>
                <button type="button"
                        class="modal-close-btn"
                        aria-label="닫기"
                        onclick="ModalManager.closeModal(document.getElementById('addEmployeeModal'))">
                    &times;
                </button>
            </div>
            <div class="modal-body">
		        <input type="hidden" id="modifyEmpIdx" name="empIdx" value="">
			    <!-- 오른쪽: 이름/성별 -->
			    <div style="flex:1; display:flex; flex-direction: column; gap:1rem;">
			        <div class="field">
			            <label class="form-label">사번</label>
			            <input type="text" name="empNo" required class="form-control" readonly>
			        </div>
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
                        <select name="departmentIdx" class="form-control">
                        </select>
                    </div>
                    <div class="field">
                        <label class="form-label">팀</label>
                        <select name="teamIdx" class="form-control">
                        </select>
                    </div>
                    <div class="field">
                        <label class="form-label">직책</label>
                        <select name="roleIdx" class="form-control">
                        </select>
                    </div>
                </div>

                <!-- 고용일 -->
                <div class="field">
                    <label class="form-label">고용일</label>
                    <input type="date" name="hireDate" class="form-control">
                </div>
                <!-- 상태 -->
                <div class="field">
                    <label class="form-label">상태</label>
                    <select name="empStatus" class="form-control">
                    	<option value="재직">재직</option>
                    	<option value="휴직">휴직</option>
                    	<option value="퇴직">퇴직</option>
                    </select>
                </div>
            </div>
            <div class="modal-foot">
            	<div style="margin-right:auto;">
                <button type="button" class="btn btn-primary" id="resetPw">pw초기화</button>
                </div>
                <div>
                <button type="submit" class="btn btn-primary">저장</button>
                <button type="button"
                        class="btn btn-secondary"
                        onclick="ModalManager.closeModal(document.getElementById('modifyEmployeeModal'))">
                    취소
                </button>
            	</div>
            </div>
        </form>
    </div>
</div>
