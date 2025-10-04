<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div id="addEmployeeModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="addEmployeeModalLabel" tabindex="-1">
    <div class="modal-card sm">
        <form action="/admin/employeeManagement/addEmployee"
              method="post"
              enctype="multipart/form-data"
              id="addEmployeeForm"
              class="modal-form">
			<sec:csrfInput/>
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
				<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 1rem;">
				    <div class="field" >
				        <label class="form-label">이름</label>
				        <input type="text" id="addEmpName" name="empName" required class="form-control" placeholder="한글만입력가능합니다.">
				    </div>
				    <div class="field">
				        <label class="form-label">성별</label>
				        <div class="seg-radio">
				            <input type="radio" id="male" name="empGender" value="남자" checked>
				            <label for="male">남자</label>
				            <input type="radio" id="female" name="empGender" value="여자">
				            <label for="female">여자</label>
				        </div>
				    </div>
				</div>

                <!-- 이메일/연락처 -->
                <div style="display:flex; gap:2rem; margin-bottom:1rem;">
                    <div class="field" style="flex:1;">
                        <label class="form-label">이메일</label>
                        <input type="text" name="empEmail" required class="form-control">
                    </div>
                    <div class="field" style="flex:1;">
                        <label class="form-label">연락처</label>
                        <input type="text" name="empPhone" id="addEmpPhone" required class="form-control">
                    </div>
                </div>

                <!-- 부서/팀/직무 -->
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
                        <label class="form-label">직무</label>
                        <select name="roleIdx" class="form-control">
                        </select>
                    </div>
                </div>

                <!-- 고용일 -->
                <div class="field">
                    <label class="form-label">입사일</label>
                    <input type="date" name="hireDate" class="form-control">
                </div>
            </div>
            <div class="modal-foot">
                <button type="submit" class="btn btn-primary">등록</button>
                <button type="button"
                        id="cancelBtn"
                        class="btn btn-cancel"
                        onclick="ModalManager.closeModal(document.getElementById('addEmployeeModal'))">
                    취소
                </button>
            </div>
        </form>
    </div>
</div>
