<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div id="employeeDetailModal" class="modal" >
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
            <p><strong>이름:</strong> <span id="empNameDetail"></span></p>
            <p><strong>사번:</strong> <span id="empNoDetail"></span></p>
            <p><strong>성별:</strong> <span id="empGenderDetail"></span></p>
            <p><strong>부서:</strong> <span id="empDeptDetail"></span></p>
            <p><strong>팀:</strong> <span id="empteamDetail"></span></p>
            <p><strong>직무:</strong> <span id="empRoleDetail"></span></p>
            <p><strong>번호:</strong> <span id="empPhoneDetail"></span></p>
            <p><strong>이메일:</strong> <span id="empEmailDetail"></span></p>
            <p><strong>입사일:</strong> <span id="empHireDateDetail"></span></p>
        </div>
        <div class="modal-foot">
            <button type="button"
                    class="btn btn-update"
                    id="DetailmodifyBtn" >
                수정
            </button>
            <button type="button"
                    class="btn btn-primary"
                    onclick="ModalManager.closeModal(document.getElementById('employeeDetailModal'))">
                닫기
            </button>
        </div>
    </div>
</div>