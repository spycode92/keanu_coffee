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
                    <div style=" display:flex; gap:1rem; min-width:150px;">
                        <button class="btn btn-primary searchSupplier" >공급업체검색</button>
                        <select id="addContractSupplierSelect" name="supplierIdx" class="form-select supplierSelectList" required>
                        </select>
                        <button class="btn btn-primary searchProduct" >상품검색</button>
                        <select id="addContractProductSelect" name="productIdx" class="form-select productSelectList"  required>
                            <option value="">선택하세요</option>
                        </select>
                    </div>
                </div>
                <div class="field mb-3">
                    <label class="form-label">계약 단가(원)</label>
                    <input type="number" id="contractPrice" name="contractPrice" class="form-control" min="0" max="2147483647" required>
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
                    <label class="form-label">최소 주문 수량(BOX)</label>
                    <input type="number" id="minOrderQuantity" name="minOrderQuantity" class="form-control" min="0" max="2147483647" required>
                </div>
                <div class="field mb-3">
                    <label class="form-label">최대 주문 수량(BOX)</label>
                    <input type="number" id="maxOrderQuantity" name="maxOrderQuantity" class="form-control" min="0" max="2147483647" required>
                </div>
                <div class="field mb-3">
                    <label class="form-label">상태</label>
                    <select id="statusSelect" name="status" class="form-select" required>
                        <option value="활성">활성</option>
                        <option value="비활성">비활성</option>
                        <option value="취소">취소</option>
                        <option value="삭제">삭제</option>
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

<!-- 공급처검색 모달 -->
<div id="searchSupplier" class="modal" aria-hidden="true" role="dialog" aria-labelledby="contractAddLabel" tabindex="-1">
    <div class="modal-card sm">
		<div class="modal-head" >
        	<h5 id="supplierSearchLabel">공급업체검색</h5>
       	    <button type="button"
                       class="modal-close-btn"
                       aria-label="닫기"
                       onclick="ModalManager.closeModal(document.getElementById('searchSupplier'))">
                   &times;
            </button>
        </div>
        <div class="modal-body" >
            <div class="field" >
                <div style=" display:flex; gap:1rem; min-width:150px;">
	                <input type="text" id="supplierSearch">
                </div>
            </div>
            <div class="field">
            	<table id="searchSupplierList">
            	
            	</table>
            </div>
		</div>
    </div>
</div>
<!-- 상품검색 모달 -->
<div id="searchProduct" class="modal" aria-hidden="true" role="dialog" aria-labelledby="contractAddLabel" tabindex="-1">
    <div class="modal-card sm">
		<div class="modal-head" >
        	<h5 id="productSearchLabel">상품검색</h5>
       	    <button type="button"
                       class="modal-close-btn"
                       aria-label="닫기"
                       onclick="ModalManager.closeModal(document.getElementById('searchProduct'))">
                   &times;
            </button>
        </div>
        <div class="modal-body" >
            <div class="field" >
                <div style=" display:flex; gap:1rem; min-width:150px;">
	                <input type="text" id="productSearch">
                </div>
            </div>
            <div class="field">
            	<table id="searchProductList">
            	
            	</table>
            </div>
		</div>
    </div>
</div>