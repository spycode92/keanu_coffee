<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 직원 추가용 모달 -->
<div class="modal fade" id="addEmployeeModal" tabindex="-1" role="dialog" aria-labelledby="addEmployeeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <form action="/admin/employeeManagement/addEmployee" method="post" enctype="multipart/form-data" id="addEmployeeForm">
                <div class="modal-header">
                    <h5 class="modal-title" id="addEmployeeModalLabel">직원 추가</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label>프로필 사진</label>
                    <div style="position: relative; display: inline-block;">
                        <img id="profilePreview"
                             src=""
                             alt="프로필 사진"
                             style="width: 100px; height: 100px; object-fit: cover; border-radius: 50%; border: 1px solid #d9d9d9;">
                        <button type="button"
                                id="deleteProfileImgBtn"
                                style="position: absolute; top: 2px; right: 2px; background: #FF8C00; border: none; color: white; border-radius: 50%; width: 22px; height: 22px; font-weight: bold; cursor: pointer;">
                            ×
                        </button>
                    </div>
                    <br>
                    <input type="file" name="files" class="custom-file-input" id="profileImage" accept="image/*" style="margin-top: 10px;">
                    <input type="hidden" id="profileImageAction" name="profileImageAction" value="none">
                    <input type="hidden" id="deleteProfileImgFlag" name="deleteProfileImgFlag" value="false">

                    <label>이름</label>
                    <input type="text" name="empName" required>

                    <label>성별</label>
                    <div>
                        <label>
                            <input type="radio" name="empGender" value="남자" checked required>
                            남자
                        </label>
                        <label>
                            <input type="radio" name="empGender" value="여자">
                            여자
                        </label>
                    </div>

                    <label>연락처</label>
                    <input type="text" name="empPhone" required>

                    <label>이메일</label>
                    <input type="email" name="empEmail" required>

                    <label>부서</label>
                    <input type="text" name="deptName">

                    <label>팀</label>
                    <input type="text" name="teamName">

                    <label>직책</label>
                    <input type="text" name="empPosition">

                    <label>고용일</label>
                    <input type="date" name="hireDate">
                </div>
                <div class="modal-footer">
                    <input type="submit" value="등록" class="btn btn-primary">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function() {
        var fileId = "${userProfileImg.fileId}";
        const existProfileImg = fileId && fileId != '' && fileId != 'null';
        const profileImageAction = document.getElementById('profileImageAction');
        const deleteProfileImgFlag = document.getElementById('deleteProfileImgFlag');
        const profileImageInput = document.getElementById('profileImage');
        var profileUrl = existProfileImg ? '/file/' + fileId + '?type=0' : '/resources/images/default_profile_photo.png';
        document.getElementById('profilePreview').src = profileUrl;

        document.getElementById('profileImage').addEventListener('change', function(e) {
            const file = e.target.files[0];

            if (file) {
                const reader = new FileReader();
                reader.onload = function(evt) {
                    document.getElementById('profilePreview').src = evt.target.result;
                }
                reader.readAsDataURL(file);
                profileImageAction.value = 'insert';
                deleteProfileImgFlag.value = 'false';
            } else {
                profileImageAction.value = 'none';
            }
        });

        $('#deleteProfileImgBtn').on('click', function() {
            $('#profilePreview').attr('src', '/resources/images/default_profile_photo.png');
            profileImageAction.value = 'delete';
            deleteProfileImgFlag.value = 'true';
            profileImageInput.value = '';
        });

        document.querySelector('.custom-file-input').addEventListener('change', function(event) {
            const files = event.target.files;
            for (let i = 0; i < files.length; i++) {
                if (!files[i].type.startsWith('image/')) {
                    alert('이미지 파일만 업로드 가능합니다.');
                    document.getElementById('profilePreview').src = profileUrl;
                    profileImageInput.value = '';
                    return;
                }
            }
        });
    });
</script>