<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 상품 상세/수정 모달 -->
<div id="productDetailModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="productDetailModalLabel" tabindex="-1">
    <div class="modal-card md">
        <form id="productDetailForm" enctype="multipart/form-data">
            <div class="modal-head">
                <h5 id="productDetailModalLabel">상품 상세/수정</h5>
                <button type="button"
                        class="modal-close-btn"
                        aria-label="닫기"
                        onclick="ModalManager.closeModal(document.getElementById('productDetailModal'))">
                    ×
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="productIdx" id="detailProductIdx">

                <div style="display: flex; gap: 1rem;">
                    <!-- 이미지 영역 -->
                    <div style="flex: 1; text-align: center;">
                        <img id="detailProductImagePreview"
                             src=""
                             alt="상품 이미지"
                             style="max-width:100%; border:1px solid #eee; margin-bottom:0.5rem;">
                        <a id="detailProductImageDownload"
                           href="#"
                           class="btn btn-secondary btn-sm mb-2"
                           download>
                            이미지 다운로드
                        </a>
                        <div class="field">
                            <label class="form-label">이미지 변경</label>
                            <input type="file"
                                   id="detailProductImage"
                                   name="files"
                                   accept="image/*"
                                   class="form-control .custom-file-input"
                                   disabled>
                        </div>
               	   </div>

	                    <!-- 상세정보 폼 -->
                    <div style="flex: 2;">
                        <div class="field mb-2">
                            <label class="form-label">상품명</label>
                            <input type="text"
                                   id="detailProductName"
                                   name="productName"
                                   class="form-control"
                                   disabled>
						</div>
	
	                    <div>
		                    <select name="categoryIdx" id="detailProductCategory" class="form-control categories" required>
		                        <option value="">선택하세요</option>
		                    </select>
	                	</div>
	
                       	<div class="field mb-2" style="display: grid; grid-template-columns: repeat(3,1fr); gap: 1rem;">

	                        <div class="field">
			                    <label class="form-label">박스 호수</label>
			                    <select id="detailProductVolume" name="productVolume" class="form-control" required>
			                    	<option value="3">3호</option>
			                    	<option value="4">4호</option>
			                    	<option value="5">5호</option>
			                    </select>
			                </div>
	
	                        <div class="field mb-2">
	                            <label class="form-label">무게 (kg)</label>
	                            <input type="number"
	                                   id="detailProductWeight"
	                                   name="productWeight"
	                                   class="form-control"
	                                   disabled>
	                        </div>
	
	                        <div class="field mb-2">
	                            <label class="form-label">원산지</label>
	                            <input type="text"
	                                   id="detailProductFrom"
	                                   name="productFrom"
	                                   class="form-control"
	                                   disabled>
	                        </div>
	
                   		</div>
                        <div class="field">
                            <label class="form-label">설명</label>
                            <textarea id="detailNote"
                                      name="note"
                                      class="form-control"
                                      rows="3"
                                      disabled></textarea>
                        </div>
                        <div class="field">
                            <label class="form-label" >상태</label>
                            <select id="detailProductStatus" name="status" class="form-control" required>
		                    	<option value="활성">활성</option>
		                    	<option value="비활성">비활성</option>
		                    	<option value="삭제">삭제</option>
		                    </select>
                        </div>
                	</div>
            	</div>
           	</div>
            <div class="modal-foot">
                <button type="button"
                        class="btn btn-secondary btn-cancel-edit"
                        style="display: none;">
                    취소
                </button>
                <button type="button"
                        class="btn btn-primary btn-edit">
                    수정
                </button>
                <button type="button"
                        class="btn btn-primary btn-save"
                        style="display: none;">
                    저장
                </button>
            </div>
       	</form>
   	</div>
</div>