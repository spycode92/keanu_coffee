<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 직원 추가용 모달 -->
<div id="addEmployeeModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="addEmployeeModalLabel" tabindex="-1">
    <div class="modal-card">
        <form action="/admin/employeeManagement/addEmployee" method="post" enctype="multipart/form-data" id="addEmployeeForm" class="form">
            <div class="modal-head">
                <h5 id="addEmployeeModalLabel">직원 추가</h5>
                <button type="button" id="closeModalBtn" aria-label="닫기" style="font-size: 24px; background:none; border:none; cursor:pointer;">&times;</button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <label>프로필 사진</label>
                    <div style="position: relative; display: inline-block;">
                        <img id="profilePreview" src="" alt="프로필 사진"
                            style="width: 100px; height: 100px; object-fit: cover; border-radius: 50%; border: 1px solid #d9d9d9;">
                        <button type="button" id="deleteProfileImgBtn"
                            style="position: absolute; top: 2px; right: 2px; background: #FF8C00; border: none; color: white; border-radius: 50%; width: 22px; height: 22px; font-weight: bold; cursor: pointer;">×
                        </button>
                    </div>
                    <input type="file" name="files" id="profileImage" accept="image/*" style="margin-top: 10px;">
                    <input type="hidden" id="profileImageAction" name="profileImageAction" value="none">
                    <input type="hidden" id="deleteProfileImgFlag" name="deleteProfileImgFlag" value="false">
                </div>
                <div class="row">
                    <div class="field">
                        <label>이름</label>
                        <input type="text" name="empName" required>
                    </div>
                    <div class="field">
                        <label>성별</label>
                        <div class="seg-radio">
                            <label><input type="radio" name="empGender" value="남자" checked required> 남자</label>
                            <label><input type="radio" name="empGender" value="여자"> 여자</label>
                        </div>
                    </div>
                    <div class="field">
                        <label>연락처</label>
                        <input type="text" name="empPhone" required>
                    </div>
                    <div class="field">
                        <label>이메일</label>
                        <input type="email" name="empEmail" required>
                    </div>
                    <div class="field">
                        <label>부서</label>
                        <input type="text" name="deptName">
                    </div>
                    <div class="field">
                        <label>팀</label>
                        <input type="text" name="teamName">
                    </div>
                    <div class="field">
                        <label>직책</label>
                        <input type="text" name="empPosition">
                    </div>
                    <div class="field">
                        <label>고용일</label>
                        <input type="date" name="hireDate">
                    </div>
                </div>
            </div>
            <div class="modal-foot">
                <input type="submit" value="등록" style="cursor: pointer; padding: 6px 12px; background-color: #007bff; color: #fff; border: none; border-radius: 4px;">
                <button type="button" id="cancelBtn" style="cursor: pointer; padding: 6px 12px; background-color: #6c757d; color: #fff; border:none; border-radius: 4px;">취소</button>
            </div>
        </form>
    </div>
</div>