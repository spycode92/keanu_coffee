<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!-- Form Modal -->
<div class="modal open" id="formModal">
    <div class="modal-card modal-form md">
        <div class="modal-head">
            <h3>회원 등록</h3>
            <button onclick="closeModal('formModal')">✕</button>
        </div>
        <div class="modal-body">
            <form class="form">
                <div class="row">
                    <div class="field">
                        <label>이름</label>
                        <input type="text" class="form-control">
                    </div>
                    <div class="field">
                        <label>이메일</label>
                        <input type="email" class="form-control">
                    </div>
                </div>
                <div class="modifyRow">
                    <div class="field">
                        <label>나이</label>
                        <input type="number" class="form-control">
                    </div>
                    <div class="field">
                        <label>성별</label>
                        <div class="seg-radio">
                            <label><input type="radio" name="gender">남</label>
                            <label><input type="radio" name="gender">여</label>
                        </div>
                    </div>
                    <div class="field">
                        <label>직업</label>
                        <input type="text" class="form-control">
                    </div>
                </div>
            </form>
        </div>
        <div class="modal-foot">
            <button class="btn btn-secondary" onclick="closeModal('formModal')">취소</button>
            <button class="btn btn-primary">저장</button>
        </div>
    </div>
</div>