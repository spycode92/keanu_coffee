<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<div class="modal fade product-modal" id="productAddModal" tabindex="-1" aria-labelledby="productAddModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form id="productAddForm" enctype="multipart/form-data">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="productAddModalLabel">상품 추가</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- 상품명 -->
                    <div class="form-group">
                        <label for="productName">상품명</label>
                        <input type="text" class="form-control" id="productName" name="productName" required>
                    </div>

                    <!-- 상위 카테고리 선택 -->
                    <div class="form-group">
                        <label for="upperCategorySelect">상위 카테고리</label>
        		        <button id="btnAddCategory" class="btn btn-sm btn-primary ml-auto" style="text-align:right;">추가</button>
						<button type="button" class="btn btn-sm btn-primary editBtn ml-2" id="btnCategoryManage" >수정/삭제</button>                        
						<select id="upperCategorySelect" class="form-control" name="parentCategoryIdx" required>
                            <option value="">상위 카테고리 선택</option>
                            <!--옵션목록 -->
                        </select>
                    </div>

                    <!-- 하위 카테고리 선택 -->
                    <div class="form-group">
                        <label for="lowerCategorySelect">하위 카테고리</label>
                        <select id="lowerCategorySelect" name="categoryIdx" class="form-control" required>
                            <option value="">먼저 상위 카테고리를 선택하세요</option>
                            <!-- 옵션목록 -->
                        </select>
                    </div>

                    <!-- 상품 무게 -->
                    <div class="form-group">
                        <label for="productWeight">무게 (kg)</label>
                        <input type="number" class="form-control" id="productWeight" name="productWeight" step="0.01" min="0">
                    </div>

                    <!-- 가로, 세로, 높이 -->
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label for="productWidth">가로 (cm)</label>
                            <input type="number" class="form-control" id="productWidth" name="productWidth" step="0.01" min="0">
                        </div>
                        <div class="form-group col-md-4">
                            <label for="productLength">세로 (cm)</label>
                            <input type="number" class="form-control" id="productLength" name="productLength" step="0.01" min="0">
                        </div>
                        <div class="form-group col-md-4">
                            <label for="productHeight">높이 (cm)</label>
                            <input type="number" class="form-control" id="productHeight" name="productHeight" step="0.01" min="0">
                        </div>
                    </div>

                    <!-- 부피 -->
                    <div class="form-group">
                        <label for="productVolume">부피 (cm³)</label>
                        <input type="number" class="form-control" id="productVolume" name="productVolume" step="0.01" min="0" readonly>
                    </div>

                    <!-- 원산지 -->
                    <div class="form-group">
                        <label for="productFrom">원산지</label>
                        <input type="text" class="form-control" id="productFrom" name="productFrom">
                    </div>

                    <!-- 상품 설명 -->
                    <div class="form-group">
                        <label for="note">설명</label>
                        <textarea class="form-control" id="note" name="note" rows="3"></textarea>
                    </div>

                    <!-- 상품 이미지 첨부 -->
                    <div class="form-group">
                        <label for="productImage">상품 이미지</label>
                        <input type="file" class="form-control-file" id="productImage" name="files" accept="image/*" />
                        <small class="form-text text-muted">이미지를 첨부하세요. 썸네일로 생성됩니다.</small>
                        <img id="productImagePreview" src="#" alt="이미지 미리보기" style="display:none; margin-top:10px; max-width: 200px; height: 200px;" />
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-custom-cancel" data-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-primary">등록</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- 새 카테고리 추가용 작은 모달 -->
<div class="modal fade product-modal" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form id="addCategoryForm">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addCategoryModalLabel">새 카테고리 추가</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="newCategoryName">카테고리명</label>
                        <input type="text" class="form-control" id="newCategoryName" name="category_name" required>
                    </div>
                    <div class="form-group">
                        <label for="parentCategorySelect">부모 카테고리</label>
                        <select class="form-control" id="parentCategorySelect" name="parent_category_idx">
                            <option value="">없음 (최상위 카테고리)</option>
                            <c:forEach var="cat" items="${categoryList}">
                                <option value="${cat.idx}">${cat.category_name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-custom-cancel" data-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-primary">추가</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- 카테고리 관리 모달 -->
<div class="modal fade product-modal" id="categoryManageModal" tabindex="-1" aria-labelledby="categoryManageModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-md">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="categoryManageModalLabel">카테고리 관리</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!-- 카테고리 리스트와 추가/수정 영역 -->
                <div id="categoryManagePanel">
                    <div >
					    <div class="card-body" style="max-height:400px; overflow-y:auto;">
					        <ul id="categoryListInModal" class="list-unstyled mb-0" ></ul>
					    </div>
					</div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>