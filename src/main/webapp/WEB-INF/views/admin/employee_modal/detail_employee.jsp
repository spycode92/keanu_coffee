<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="employeeDetailModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="employeeDetailModalLabel" tabindex="-1">
    <div class="modal-card sm">
        <div class="modal-head">
            <h5 id="employeeDetailModalLabel">직원 정보</h5>
            <button type="button"
                    class="modal-close-btn"
                    aria-label="닫기"
                    onclick="ModalManager.closeModal(document.getElementById('employeeDetailModal'))">
                &times;
            </button>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <label for="empNo"><strong>사번:</strong></label>
                <input type="text" id="empNo" name="empNo" class="form-control" readonly />
            </div>
            <div class="form-group">
                <label for="empNameDetail"><strong>이름:</strong></label>
                <input type="text" id="empName" name="empName" class="form-control" readonly />
            </div>
            <div class="form-group">
                <label for="empGender"><strong>성별:</strong></label>
                <input type="text" id="empGender" name="empId" class="form-control" readonly />
            </div>
            <div class="form-group">
                <label for="empDept"><strong>부서:</strong></label>
                <input type="text" id="empDeptName" name="departmentName" class="form-control" readonly />
                <input type="text" id="empDeptIdx" name="departmentIdx" class="form-control" readonly />
            </div>
            <div class="form-group">
                <label for="empteam"><strong>팀:</strong></label>
                <input type="text" id="teamName" name="departmentName" class="form-control" readonly />
                <input type="text" id="empTeamIdx" name="teamIdx" class="form-control" readonly />
            </div>
            <div class="form-group">
                <label for="empRole"><strong>직급:</strong></label>
                <input type="text" id="empRoleName" name="roleName" class="form-control" readonly />
                <input type="text" id="empRoleIdx" name="roleIdx" class="form-control" readonly />
            </div>
            <div class="form-group">
                <label for="empPhone"><strong>번호:</strong></label>
                <input type="text" id="empPhone" name="empPhone" class="form-control" readonly />
            </div>
            <div class="form-group">
                <label for="empEmail"><strong>이메일:</strong></label>
                <input type="email" id="empEmail" name="empEmail" class="form-control" readonly />
            </div>
            <div class="form-group">
                <label for="empHireDate"><strong>입사일:</strong></label>
                <input type="date" id="empHireDate" name="empHireDate" class="form-control" readonly />
            </div>
        </div>
        <div class="modal-foot">
            <button type="button"
                    class="btn btn-secondary"
                    onclick="resetPassword('${employee.empId}');">
                비밀번호 초기화
            </button>
            <button type="button"
                    class="btn btn-update"
                    onclick="editEmployee('${employee.empNo}');">
                수정
            </button>
            <button type="button"
                    class="btn btn-cancel"
                    onclick="deleteEmployee('${employee.empNo}');">
                삭제
            </button>
            <button type="button"
                    class="btn btn-confirm"
                    onclick="ModalManager.closeModal(document.getElementById('employeeDetailModal'))">
                확인
            </button>
        </div>
    </div>
</div>