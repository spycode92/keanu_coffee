<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- 정보변경 모달창 -->
<div id="change-info-modal" class="modal">
    <div class="modal-card sm">
        <div class="modal-head">
            <h2>정보 변경</h2>
            <button type="button" class="modal-close-btn" data-modal-close>&times;</button>
        </div>
        
        <div class="modal-body modal-form">
            <form id="changeInfoForm" action="/admin/employeeManagement/modifyEmployeeInfo" method="post" >
                 <sec:csrfInput/>
                <input type="hidden" name="empIdx" value="<sec:authentication property="principal.empIdx"/>">
                <!-- 사원 ID -->
                <div class="field">
                    <label for="top_empNo">사번</label>
                    <input class="form-control" type="text" id="top_empNo" name="empNo" value="" disabled>
                </div>
                <!-- 이름 -->
                <div class="field">
                    <label for="top_empName">이름</label>
                    <input class="form-control" type="text" id="top_empName" name="empName" value="" disabled>
                </div>
                <!-- 이름 -->
                <div class="field">
                    <label for="top_departmentName">부서</label>
                    <input class="form-control" type="text" id="top_departmentName" name="departmentName" value="" disabled>
                </div>
                <!-- 이름 -->
                <div class="field">
                    <label for="top_teamName">팀</label>
                    <input class="form-control" type="text" id="top_teamName" name="teamName" value="" disabled>
                </div>
                <!-- 이름 -->
                <div class="field">
                    <label for="top_roleName">직책</label>
                    <input class="form-control" type="text" id="top_roleName" name="roleName" value="" disabled>
                </div>
				
                <!-- 휴대폰 번호 -->
                <div class="field">
				    <label for="top_empPhone">휴대폰 번호</label>
				    <input class="form-control" type="text" id="top_empPhone" name="empPhone" value="" 
				           readonly maxlength="13" >
				</div>

                <!-- 이메일 -->
                <div class="field">
                    <label for="top_empEmail">이메일</label>
                    <input class="form-control" type="email" id="top_empEmail" name="empEmail" value="" readonly>
                </div>
                
                <!-- 입사일 -->
                <div class="field">
                    <label for="top_hireDate">입사일</label>
                    <input class="form-control" type="text" id="top_hireDate" name="hireDate" value="" disabled>
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
                <button type="button" class="btn btn-cancel" data-modal-close style="display: none;">취소</button>
            </div>
        </div>
    </div>

    
</div>