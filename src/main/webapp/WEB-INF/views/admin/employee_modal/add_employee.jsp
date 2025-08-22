<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 직원 추가용 모달 -->
<div id="addEmployeeModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="addEmployeeModalLabel" tabindex="-1">
    <div class="modal-card">
        <form action="/admin/employeeManagement/addEmployee" method="post" enctype="multipart/form-data" id="addEmployeeForm" class="modal-form" >
            <div class="modal-head">
                <h5 id="addEmployeeModalLabel">직원 추가</h5>
                <button type="button" id="closeModalBtn" aria-label="닫기" style="font-size: 24px; background:none; border:none; cursor:pointer;">&times;</button>
            </div>
            <div class="modal-body">
			    <!-- 상단: 프로필사진 + 이름/성별 -->
			    <div style="display: flex; gap: 20px; margin-bottom: 15px;">
			        <!-- 프로필사진 (왼쪽) -->
			        <div>
			            <img id="profilePreview" src="/resources/images/default_profile_photo.png" alt="프로필 사진"
			                style="width: 100px; height: 100px; object-fit: cover; border-radius: 50%; border: 1px solid #d9d9d9;">
			            <input type="file" name="files" id="profileImage" accept="image/*" style="margin-top: 10px;">
			            <button type="button" id="deleteProfileImgBtn" style="display: block; margin-top: 5px;">×</button>
			            <input type="hidden" id="profileImageAction" name="profileImageAction" value="none">
			            <input type="hidden" id="deleteProfileImgFlag" name="deleteProfileImgFlag" value="false">
			        </div>
			        
			        <!-- 이름/성별 (오른쪽, 세로배치) -->
			        <div style="flex: 1;">
			            <div class="field" style="margin-bottom: 15px;">
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
			        </div>
			    </div>
			
			    <!-- 이메일/연락처 (세로배치) -->
			    <div style="display: flex; gap: 15px; margin-bottom: 15px;">
			        <div class="field" style="flex: 1;">
			            <label>이메일</label>
			            <input type="email" name="empEmail" required>
			        </div>
			        <div class="field" style="flex: 1;">
			            <label>연락처</label>
			            <input type="text" name="empPhone" required>
			        </div>
			    </div>
			
			    <!-- 부서/팀/직책 (가로 일렬 3개, 셀렉트박스) -->
			    <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px; margin-bottom: 15px;">
			        <div class="field">
			            <label>부서</label>
			            <select name="deptName">
			                <option value="">없음</option>
			                <option value="개발부">개발부</option>
			                <option value="마케팅부">마케팅부</option>
			                <option value="영업부">영업부</option>
			            </select>
			        </div>
			        <div class="field">
			            <label>팀</label>
			            <select name="teamName">
			                <option value="">없음</option>
			                <option value="프론트엔드팀">프론트엔드팀</option>
			                <option value="백엔드팀">백엔드팀</option>
			                <option value="기획팀">기획팀</option>
			            </select>
			        </div>
			        <div class="field">
			            <label>직책</label>
			            <select name="empPosition">
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
			        <label>고용일</label>
			        <input type="date" name="hireDate">
			    </div>
			</div>
            <div class="modal-foot">
                <input type="submit" value="등록" style="cursor: pointer; padding: 6px 12px; background-color: #007bff; color: #fff; border: none; border-radius: 4px;">
                <button type="button" id="cancelBtn" style="cursor: pointer; padding: 6px 12px; background-color: #6c757d; color: #fff; border:none; border-radius: 4px;">취소</button>
            </div>
        </form>
    </div>
</div>