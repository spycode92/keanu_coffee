<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="employeeDetailModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="employeeDetailModalLabel" tabindex="-1">
    <div class="modal-card lg">
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
            <p><strong>이름:</strong> <span id="empName"></span></p>
            <p><strong>사번:</strong> <span id="empNo"></span></p>
            <p><strong>아이디:</strong> <span id="empId"></span></p>
            <p><strong>부서:</strong> <span id="empDept"></span></p>
            <p><strong>직급:</strong> <span id="empRank"></span></p>
            <p><strong>번호:</strong> <span id="empPhone"></span></p>
            <p><strong>이메일:</strong> <span id="empEmail"></span></p>
            <p><strong>입사일:</strong> <span id="empHireDate"></span></p>
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
                취소
            </button>
            <button type="button"
                    class="btn btn-confirm"
                    onclick="ModalManager.closeModal(document.getElementById('employeeDetailModal'))">
                확인
            </button>
        </div>
    </div>
</div>