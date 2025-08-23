<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 공급계약 등록 모달 -->
<div id="contractAddModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="contractAddLabel" tabindex="-1">
    <div class="modal-card md">
        <form id="contractAddForm" class="modal-content">
            <div class="modal-head" >
                <h5 id="contractAddLabel">공급계약 등록</h5>
                <button type="button"
                        class="modal-close-btn"
                        aria-label="닫기"
                        onclick="ModalManager.closeModal(document.getElementById('contractAddModal'))">
                    &times;
                </button>
            </div>
            <div class="modal-body" >
                <div class="field" >
                    <div style="flex:1; min-width:150px;">
                        <label class="form-label">공급업체</label>
                        <select id="supplierSelect" name="supplierIdx" class="form-select" required>
                            <option value="">선택하세요</option>
                        </select>
                    </div>
                    <div style="flex:1; min-width:150px;">
                        <label class="form-label">상품</label>
                        <select id="productSelect" name="productIdx" class="form-select" required>
                            <option value="">선택하세요</option>
                        </select>
                    </div>
                </div>
                <div class="field mb-3">
                    <label class="form-label">계약 단가</label>
                    <input type="number" id="contractPrice" name="contractPrice" class="form-control" min="0" required>
                </div>
                <div class="field mb-3" style="display:flex; gap:1rem;">
                    <div style="flex:1">
                        <label class="form-label">시작일</label>
                        <input type="date" id="contractStart" name="contractStart" class="form-control" required>
                    </div>
                    <div style="flex:1">
                        <label class="form-label">종료일</label>
                        <input type="date" id="contractEnd" name="contractEnd" class="form-control" required>
                    </div>
                </div>
                <div class="field mb-3">
                    <label class="form-label">최소 주문 수량</label>
                    <input type="number" id="minOrderQuantity" name="minOrderQuantity" class="form-control" min="0">
                </div>
                <div class="field mb-3">
                    <label class="form-label">최대 주문 수량</label>
                    <input type="number" id="maxOrderQuantity" name="maxOrderQuantity" class="form-control" min="0">
                </div>
                <div class="field mb-3">
                    <label class="form-label">상태</label>
                    <select id="statusSelect" name="status" class="form-select" required>
                        <option value="1">활성</option>
                        <option value="2">비활성</option>
                        <option value="3">대기</option>
                    </select>
                </div>
                <div class="field mb-3">
                    <label class="form-label">비고</label>
                    <textarea id="addContractnote" name="note" class="form-control" rows="3"></textarea>
                </div>
            </div>
            <div class="modal-foot" >
                <button type="button"
                        id="btnSaveContract"
                        class="btn btn-primary">
                    등록
                </button>
                <button type="button"
                        class="btn btn-secondary"
                        onclick="ModalManager.closeModal(document.getElementById('contractAddModal'))">
                    취소
                </button>
            </div>
        </form>
    </div>
</div>