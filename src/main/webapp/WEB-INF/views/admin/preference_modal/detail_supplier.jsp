<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div id="supplierDetailModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="supplierDetailModalLabel" tabindex="-1">
    <div class="modal-card md">
        <form id="supplierDetailForm">
        	<sec:csrfInput/>
            <div class="modal-head">
                <h5 id="supplierDetailModalLabel">공급업체 상세정보</h5>
                <button type="button"
                        class="modal-close-btn"
                        aria-label="닫기"
                        onclick="ModalManager.closeModal(document.getElementById('supplierDetailModal'))">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="supplierIdx" name="supplierIdx">

                <div class="field">
                    <label class="form-label">업체명</label>
                    <input type="text" class="form-control" id="detailSupplierName" name="supplierName" required readonly>
                </div>
                <div class="field">
                    <label class="form-label">담당자</label>
                    <input type="text" class="form-control" id="detailSupplierManager" name="supplierManager" readonly>
                </div>
                <div class="field">
                    <label class="form-label">연락처</label>
                    <input type="text" class="form-control" id="detailSupplierManagerPhone" name="supplierManagerPhone" readonly>
                </div>
                <div class="field">
                    <label class="form-label">이메일</label>
                    <input type="text" class="form-control" id="detailSupplierManageremail1" name="supplierManagerPhone" readonly>
                    @
                    <select></select>
                </div>
                <div class="field">
                    <label class="form-label">우편번호</label>
                    <div style="display: flex; gap: 0.5rem; align-items: center;">
                        <input type="text"
                               class="form-control"
                               id="detailSupplierZipcode"
                               name="supplierZipcode"
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
                           id="detailSupplierAddress1"
                           name="supplierAddress1"
                           readonly
                           style="margin-bottom: 0.5rem;">
                    <input type="text"
                           class="form-control"
                           id="detailSupplierAddress2"
                           name="supplierAddress2"
                           readonly>
                </div>
                <div class="field">
                	<label class="form-label">상태</label>
                	<select id="detailSupplierStatus" name="status" class="form-control" disabled>
                    	<option value="활성">활성</option>
                    	<option value="비활성">비활성</option>
                    </select>
                </div>
            </div>
            <div class="modal-foot">
                <button type="button" 
                        class="btn btn-primary btn-delete"
                        >
                    삭제
                </button>
                <button type="button"
                        class="btn btn-secondary btn-cancel-edit"
                        style="display:none;"
                        onclick="setReadonlyMode();">
                    취소
                </button>
                <button type="button"
                        class="btn btn-primary btn-edit"
                        >
                    수정
                </button>
                <button type="submit"
                        class="btn btn-primary btn-save"
                        style="display:none;">
                    수정완료
                </button>
            </div>
        </form>
    </div>
</div>