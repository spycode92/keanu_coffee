<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div id="addFranchiseModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="supplierModalLabel" tabindex="-1">
    <div class="modal-card md">
        <form id="addFranchiseForm">
        	<sec:csrfInput/>
            <div class="modal-head">
                <h5 id="addFranchiseLabel">지점 등록</h5>
                <button type="button"
                        class="modal-close-btn"
                        aria-label="닫기"
                        onclick="ModalManager.closeModal(document.getElementById('addFranchiseModal'))">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <label class="form-label">지점명</label>
                    <input type="text" class="form-control" id="addFranchiseName" name="franchiseName" required>
                </div>
                <div class="field">
                    <label class="form-label">점주</label>
                    <input type="text" class="form-control" id="addFranchiseManagerName" name="franchiseManagerName" required>
                </div>
                <div class="field">
                    <label class="form-label">연락처</label>
                    <input type="text" class="form-control" id="addFranchisePhone" name="franchisePhone" required>
                </div>
                <div class="field">
                    <label class="form-label">우편번호</label>
                    <div style="display: flex; gap: 0.5rem; align-items: center;">
                        <input type="text" class="form-control" id="addFranchiseZipcode" name="franchiseZipcode"
                        	placeholder="우편번호" readonly style="flex: 1; max-width: 150px;">
                        <button type="button" class="btn btn-primary" id="btnSearchAddress">우편번호 검색</button>
                    </div>
                </div>
                <div class="field">
                    <label class="form-label">주소</label>
                    <input type="text" class="form-control" id="addFranchiseAddress1" name="franchiseAddress1" 
                    	placeholder="기본 주소" readonly style="margin-bottom: 0.5rem;">
                    <input type="text" class="form-control" id="addFranchiseAddress2" name="franchiseAddress2" 
                    	placeholder="상세 주소" required>
                    <input type="hidden" id="addFranchiseBcode" name="administrativeRegion.bcode">
                    <input type="hidden" id="addFranchiseSido" name="administrativeRegion.sido">
                    <input type="hidden" id="addFranchiseSigungu" name="administrativeRegion.sigungu">
                    <input type="hidden" id="addFranchiseDong" name="administrativeRegion.dong">
                </div>
            </div>
            <div class="modal-foot">
                <button type="button"
                        class="btn btn-secondary"
                        onclick="ModalManager.closeModal(document.getElementById('addFranchiseModal'))">
                    취소
                </button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </form>
    </div>
</div>