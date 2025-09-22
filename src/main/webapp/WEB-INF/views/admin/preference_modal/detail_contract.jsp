<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- 공급계약 상세 모달 -->
<div id="contractDetailModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="contractDetailLabel" tabindex="-1">
    <div class="modal-card md">
        <form id="contractDetailForm" class="modal-content">
        	<sec:csrfInput/>
            <div class="modal-head">
                <h5 id="contractDetailLabel">공급계약 상세보기</h5>
                <button type="button"
                        class="modal-close-btn"
                        aria-label="닫기"
                        onclick="ModalManager.closeModal(document.getElementById('contractDetailModal'))">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <div style="display:flex; gap:1rem; margin-bottom:1rem;">
                    <!-- 왼쪽: 상품 이미지 -->
                    <div style="flex:1; text-align:center;">
                        <img id="contractDetailProductImagePreview"
                             src=""
                             alt="상품 이미지"
                             style="max-width:180px; border:1px solid #eee;">
                    </div>
                    <!-- 오른쪽: 주요 정보 -->
                    <div style="flex:2;">
                        <div class="field mb-2">
		                    <div style=" display:flex; gap:1rem; min-width:150px;">
		                        <button id="detailContractSupplierSearch" class="btn btn-primary searchSupplier" >공급업체검색</button>
		                        <button id="detailContractProductSearch" class="btn btn-primary searchProduct" >상품검색</button>
		                    </div>
		                        <select id="detailContractSupplierSelect" name="supplierIdx" class="form-select supplierSelectList" required disabled>
		                        </select>
		                        <select id="detailContractProductSelect" name="productIdx" class="form-select productSelectList"  required disabled>
		                        </select>
                        </div>
                        <div class="field mb-2">
                            <label class="form-label">계약 단가</label>
                            <input type="text" id="detailContractPrice" class="form-control" readonly>
                        </div>
                        <div class="field mb-2" style="display:flex; gap:1rem;">
                            <div style="flex:1;">
                                <label class="form-label">시작일</label>
                                <input type="date" id="detailContractStart" class="form-control" readonly>
                            </div>
                            <div style="flex:1;">
                                <label class="form-label">종료일</label>
                                <input type="date" id="detailContractEnd" class="form-control" readonly>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="field mb-2">
                    <label class="form-label">최소 주문 수량</label>
                    <input type="number" id="detailMinOrderQuantity" name="minOrderQuantity" class="form-control" readonly>
                </div>
                <div class="field mb-2">
                    <label class="form-label">최대 주문 수량</label>
                    <input type="number" id="detailMaxOrderQuantity" name="maxOrderQuantity" class="form-control" readonly>
                </div>
                <div class="field mb-2">
                    <label class="form-label">상태</label>
                    <select id="detailStatus" name="status" class="form-control" disabled>
                        <option value="활성">활성</option>
                        <option value="비활성">비활성</option>
                        <option value="취소">취소</option>
                    </select>
                </div>
                <div class="field">
                    <label class="form-label">비고</label>
                    <textarea id="contractDetailNote" name="note" class="form-control" rows="3" readonly></textarea>
                </div>
            </div>
            <div class="modal-foot">
                <button type="button" id="btnDeleteContractDetail" class="btn btn-primary btn-delete">삭제</button>
                <button type="button" id="btnCancelEditDetail" class="btn btn-cancel" style="display:none;">취소</button>
                <button type="button" id="btnEditContractDetail" class="btn btn-primary">수정</button>
                <button type="button" id="btnSaveContractDetail" class="btn btn-success" style="display:none;">수정완료</button>
            </div>
        </form>
    </div>
</div>