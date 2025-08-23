<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 상품 추가 모달 -->
<div id="productAddModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="productAddModalLabel" tabindex="-1">
    <div class="modal-card lg">
        <form id="productAddForm" enctype="multipart/form-data">
            <div class="modal-head">
                <h5 id="productAddModalLabel">상품 추가</h5>
                <button type="button"
                        class="modal-close-btn"
                        aria-label="닫기"
                        onclick="ModalManager.closeModal(document.getElementById('productAddModal'))">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <label class="form-label">상품명</label>
                    <input type="text" id="productName" name="productName" class="form-control" required>
                </div>
                <div class="field" style="display:flex; align-items:center; gap:0.5rem;">
                    <label class="form-label" style="min-width:100px;">상위 카테고리</label>
                    <select id="upperCategorySelect_" name="parentCategoryIdx" class="form-control" required>
                        <option value="">선택하세요</option>
                    </select>
                    <button type="button"
                            id="btnAddCategory"
                            class="btn btn-secondary btn-sm"
                            onclick="ModalManager.openModal(document.getElementById('addCategoryModal'))">
                        추가
                    </button>
                    <button type="button"
                            id="btnCategoryManage"
                            class="btn btn-secondary btn-sm"
                            onclick="ModalManager.openModal(document.getElementById('categoryManageModal'))">
                        수정/삭제
                    </button>
                </div>
                <div class="field">
                    <label class="form-label">소분류 카테고리</label>
                    <select id="lowerCategorySelect_" name="categoryIdx" class="form-control" disabled required>
                        <option value="">상위 카테고리 먼저 선택</option>
                    </select>
                </div>
                <div class="field">
                    <label class="form-label">무게 (kg)</label>
                    <input type="number" id="productWeight" name="productWeight" class="form-control" step="0.01" min="0">
                </div>
                <div class="field" style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:1rem;">
                    <div>
                        <label class="form-label">가로 (cm)</label>
                        <input type="number" id="productWidth" name="productWidth" class="form-control" step="0.01" min="0">
                    </div>
                    <div>
                        <label class="form-label">세로 (cm)</label>
                        <input type="number" id="productLength" name="productLength" class="form-control" step="0.01" min="0">
                    </div>
                    <div>
                        <label class="form-label">높이 (cm)</label>
                        <input type="number" id="productHeight" name="productHeight" class="form-control" step="0.01" min="0">
                    </div>
                </div>
                <div class="field">
                    <label class="form-label">부피 (cm³)</label>
                    <input type="text" id="productVolume" name="productVolume" class="form-control" readonly>
                </div>
                <div class="field">
                    <label class="form-label">원산지</label>
                    <input type="text" id="productFrom" name="productFrom" class="form-control">
                </div>
                <div class="field">
                    <label class="form-label">설명</label>
                    <textarea id="note" name="note" class="form-control" rows="3"></textarea>
                </div>
                <div class="field">
                    <label class="form-label">상품 이미지</label>
                    <input type="file" id="productImage" name="files" accept="image/*" class="form-control">
                    <img id="productImagePreview"
                         src="#"
                         alt="이미지 미리보기"
                         style="display:none; margin-top:0.5rem; max-width:200px; max-height:200px;">
                </div>
            </div>
            <div class="modal-foot">
                <button type="button"
                        class="btn btn-secondary"
                        onclick="ModalManager.closeModal(document.getElementById('productAddModal'))">
                    취소
                </button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </form>
    </div>
</div>

<!-- 새 카테고리 추가 모달 -->
<div id="addCategoryModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="addCategoryModalLabel" tabindex="-1">
    <div class="modal-card sm">
        <form id="addCategoryForm">
            <div class="modal-head">
                <h5 id="addCategoryModalLabel">새 카테고리 추가</h5>
                <button type="button"
                        class="modal-close-btn"
                        aria-label="닫기"
                        onclick="ModalManager.closeModal(document.getElementById('addCategoryModal'))">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <label class="form-label">카테고리명</label>
                    <input type="text" id="newCategoryName" name="category_name" class="form-control" required>
                </div>
                <div class="field">
                    <label class="form-label">부모 카테고리</label>
                    <select id="parentCategorySelect" name="parent_category_idx" class="form-control">
                        <option value="">없음 (최상위)</option>
                    </select>
                </div>
            </div>
            <div class="modal-foot">
                <button type="button"
                        class="btn btn-secondary"
                        onclick="ModalManager.closeModal(document.getElementById('addCategoryModal'))">
                    취소
                </button>
                <button type="submit" class="btn btn-primary">추가</button>
            </div>
        </form>
    </div>
</div>

<!-- 카테고리 관리 모달 -->
<div id="categoryManageModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="categoryManageModalLabel" tabindex="-1">
    <div class="modal-card md">
        <div class="modal-head">
            <h5 id="categoryManageModalLabel">카테고리 관리</h5>
            <button type="button"
                    class="modal-close-btn"
                    aria-label="닫기"
                    onclick="ModalManager.closeModal(document.getElementById('categoryManageModal'))">
                &times;
            </button>
        </div>
        <div class="modal-body" style="max-height:400px; overflow-y:auto;">
            <ul id="categoryListInModal" style="list-style:none; padding:0; margin:0;"></ul>
        </div>
        <div class="modal-foot">
            <button type="button"
                    class="btn btn-secondary"
                    onclick="ModalManager.closeModal(document.getElementById('categoryManageModal'))">
                닫기
            </button>
        </div>
    </div>
</div>