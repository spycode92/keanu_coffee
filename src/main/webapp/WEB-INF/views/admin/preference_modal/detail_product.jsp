<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!-- 상품 상세/수정 Modal -->
<div class="modal fade product-modal" id="productDetailModal" tabindex="-1" aria-labelledby="productDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form id="productDetailForm" enctype="multipart/form-data">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="productDetailModalLabel">상품 상세/수정</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <!-- 왼쪽: 상품 이미지 및 다운로드 -->
                        <div class="col-md-4 text-center d-flex flex-column align-items-center justify-content-start">
                            <img
                                id="detailProductImagePreview"
                                src="/file/thumnail/0"
                                alt="상품 이미지"
                                width="200"
                                height="200"
                                style="border: 1px solid #eee; margin-bottom:10px;"
                            >
                            <a
                                id="detailProductImageDownload"
                                href="#"
                                class="btn btn-outline-secondary btn-sm"
                                download
                                style="margin-bottom: 10px;"
                            >이미지 다운로드</a>
                            <label for="detailProductImage" class="form-label mt-2">이미지 변경</label>
                            <input type="file" class="form-control-file" id="detailProductImage" name="files" accept="image/*" disabled />
                        </div>
                        <!-- 오른쪽: 상세정보 폼 -->
                        <div class="col-md-8">
                            <input type="hidden" name="productIdx" />

                            <div class="form-group">
                                <label for="detailProductName">상품명</label>
                                <input type="text" class="form-control" id="detailProductName" name="productName" required disabled>
                            </div>

                            <div class="form-row">
							    <div class="form-group col-md-6">
							        <label for="detailUpperCategorySelect">대분류</label>
							        <select id="detailUpperCategorySelect" name="parentCategoryIdx" class="form-control" disabled required>
							            <option value="">대분류 선택</option>
							            <!-- JS로 옵션 동적 생성 -->
							        </select>
							    </div>
							
							    <div class="form-group col-md-6">
							        <label for="detailLowerCategorySelect">소분류</label>
							        <select id="detailLowerCategorySelect" name="categoryIdx" class="form-control" disabled required>
							            <option value="">소분류 선택</option>
							            <!-- JS로 옵션 동적 생성 -->
							        </select>
							    </div>
							</div>

                            <div class="form-row">
                                <div class="form-group col-md-4">
                                    <label for="detailProductWidth">가로 (cm)</label>
                                    <input type="number" class="form-control" id="detailProductWidth" name="productWidth" step="0.01" min="0" disabled>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="detailProductLength">세로 (cm)</label>
                                    <input type="number" class="form-control" id="detailProductLength" name="productLength" step="0.01" min="0" disabled>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="detailProductHeight">높이 (cm)</label>
                                    <input type="number" class="form-control" id="detailProductHeight" name="productHeight" step="0.01" min="0" disabled>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="detailProductVolume">부피 (cm³)</label>
                                    <input type="number" class="form-control" id="detailProductVolume" name="productVolume" step="0.01" min="0" readonly >
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="detailProductWeight">무게 (kg)</label>
                                    <input type="number" class="form-control" id="detailProductWeight" name="productWeight" step="0.01" min="0" disabled>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="detailProductFrom">원산지</label>
                                <input type="text" class="form-control" id="detailProductFrom" name="productFrom" disabled>
                            </div>

                            <div class="form-group">
                                <label for="detailNote">설명</label>
                                <textarea class="form-control" id="detailNote" name="note" rows="3" disabled></textarea>
                            </div>
                        </div>
                    </div><!-- row 끝 -->
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnDeleteProduct" class="btn btn-danger me-auto" >삭제</button>
                    <button type="button" class="btn btn-secondary btn-cancel-edit" style="display:none;">취소</button>
                    <button type="button" class="btn btn-primary btn-edit">수정</button>
                    <button type="button" class="btn btn-primary btn-save" style="display:none;">저장</button>
                </div>
            </div>
        </form>
    </div>
</div>