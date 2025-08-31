<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div id="supplierModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="supplierModalLabel" tabindex="-1">
    <div class="modal-card md">
        <form id="supplierForm">
        	<sec:csrfInput/>
            <div class="modal-head">
                <h5 id="supplierModalLabel">공급업체 등록</h5>
                <button type="button"
                        class="modal-close-btn"
                        aria-label="닫기"
                        onclick="ModalManager.closeModal(document.getElementById('supplierModal'))">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <label class="form-label">업체명</label>
                    <input type="text" class="form-control" id="supplierName" name="supplierName" required>
                </div>
                <div class="field">
                    <label class="form-label">담당자</label>
                    <input type="text" class="form-control" id="supplierManager" name="supplierManager" required>
                </div>
                <div class="field">
                    <label class="form-label">연락처</label>
                    <input type="text" class="form-control" id="supplierManagerPhone" name="supplierManagerPhone" required>
                </div>
                <div class="field">
                    <label class="form-label">우편번호</label>
                    <div style="display: flex; gap: 0.5rem; align-items: center;">
                        <input type="text"
                               class="form-control"
                               id="supplierZipcode"
                               name="supplierZipcode"
                               placeholder="우편번호"
                               readonly
                               style="flex: 1; max-width: 150px;">
                        <button type="button"
                                class="btn btn-secondary"
                                id="btnSearchAddress">
                            우편번호 검색
                        </button>
                    </div>
                </div>
                <div class="field">
                    <label class="form-label">주소</label>
                    <input type="text"
                           class="form-control"
                           id="supplierAddress1"
                           name="supplierAddress1"
                           placeholder="기본 주소"
                           readonly
                           style="margin-bottom: 0.5rem;">
                    <input type="text"
                           class="form-control"
                           id="supplierAddress2"
                           name="supplierAddress2"
                           placeholder="상세 주소"
                           required>
                </div>
            </div>
            <div class="modal-foot">
                <button type="button"
                        class="btn btn-secondary"
                        onclick="ModalManager.closeModal(document.getElementById('supplierModal'))">
                    취소
                </button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </form>
    </div>
</div>