<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="franchiseDetailModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="franchiseDetailModalLabel" tabindex="-1">
    <div class="modal-card md">
        <form id="franchiseDetailForm">
            <div class="modal-head">
                <h5 id="franchiseDetailModalLabel">지점 상세정보</h5>
                <button type="button"
                        class="modal-close-btn"
                        aria-label="닫기"
                        onclick="ModalManager.closeModal(document.getElementById('franchiseDetailModal'))">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="franchiseDetailIdx" name="franchiseIdx">

                <div class="field">
                    <label class="form-label">지점명</label>
                    <input type="text" class="form-control" id="detailFranchiseName" name="franchiseName" required readonly>
                </div>
                <div class="field">
                    <label class="form-label">점주</label>
                    <input type="text" class="form-control" id="detailFranchiseManager" name="franchiseManagerName" readonly>
                </div>
                <div class="field">
                    <label class="form-label">연락처</label>
                    <input type="text" class="form-control" id="detailFranchisePhone" name="franchisePhone" readonly>
                </div>
                <div class="field">
                    <label class="form-label">우편번호</label>
                    <div style="display: flex; gap: 0.5rem; align-items: center;">
                        <input type="text"
                               class="form-control"
                               id="detailFranchiseZipcode"
                               name="franchiseZipcode"
                               readonly
                               style="flex: 1; max-width: 150px;">
                        <button type="button"
                                class="btn btn-secondary"
                                id="btnDetailSearchAddress"
                                disabled>
                            우편번호 검색
                        </button>
                    </div>
                </div>
                <div class="field">
                    <label class="form-label">주소</label>
                    <input type="text"
                           class="form-control"
                           id="detailFranchiseAddress1"
                           name="franchiseAddress1"
                           readonly
                           style="margin-bottom: 0.5rem;">
                    <input type="text"
                           class="form-control"
                           id="detailFranchiseAddress2"
                           name="franchiseAddress2"
                           readonly>
                    <input type="hidden" id="detailFranchiseBcode" name="administrativeRegion.bcode">
                    <input type="hidden" id="detailFranchiseSido" name="administrativeRegion.sido">
                    <input type="hidden" id="detailFranchiseSigungu" name="administrativeRegion.sigungu">
                    <input type="hidden" id="detailFranchiseDong" name="administrativeRegion.dong">
                </div>
                <div class="field">
                	<label class="form-label">상태</label>
                	<select id="detailFranchiseStatus" name="status" class="form-control" disabled>
                    	<option value="운영">운영</option>
                    	<option value="휴점">휴점</option>
                    	<option value="폐점">폐점</option>
                    </select>
                </div>
            </div>
            <div class="modal-foot">
                <button type="button" class="btn btn-secondary btn-cancel-edit" style="display:none;">취소</button>
                <button type="button" class="btn btn-primary btn-edit">수정</button>
                <button type="submit" class="btn btn-primary btn-save" style="display:none;">저장</button>
            </div>
        </form>
    </div>
</div>