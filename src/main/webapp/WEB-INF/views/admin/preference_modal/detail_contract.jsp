<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<div class="modal fade" id="contractDetailModal" tabindex="-1" aria-labelledby="contractDetailLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-sm modal-dialog-centered">
        <form id="contractDetailForm" class="modal-content" style="background-color:#f5f1e9; color:#212529;">
            <div class="modal-header" style="background-color:#007bff; color:#ffffff;">
                <h5 class="modal-title" id="contractDetailLabel">공급계약 상세보기</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                    <span aria-hidden="true" style="color:#fff;">&times;</span>
                </button>
            </div>
            <div class="modal-body">
				<div class="row">
			    <!-- 왼쪽 : 상품 사진 영역 -->
				    <div class="col-md-4 d-flex align-items-start justify-content-center">
				    	<img id="contractDetailProductImagePreview" src="" alt="상품 이미지" class="img-thumbnail" style="max-width: 180px; height: auto;">
				    </div>
			    
			    <!-- 오른쪽 : 주요 계약 정보 세로 배치 -->
			    	<div class="col-md-8">
				    	<div class="form-group">
				    		<label class="font-weight-bold">공급업체</label>
				        	<input type="text" id="detailSupplier" class="form-control mb-2" readonly>
			    		</div>
		      			<div class="form-group">
					        <label class="font-weight-bold">상품</label>
					        <input type="text" id="detailProduct" class="form-control mb-2" readonly>
			      		</div>
			      		<div class="form-group">
					        <label class="font-weight-bold">계약 단가</label>
					        <input type="text" id="detailContractPrice" class="form-control mb-2" readonly>
			      		</div>
			      		<div class="form-group">
					        <label class="font-weight-bold">시작일</label>
					        <input type="date" id="detailContractStart" class="form-control mb-2" readonly>
			      		</div>
		      			<div class="form-group">
					        <label class="font-weight-bold">종료일</label>
					        <input type="date" id="detailContractEnd" class="form-control mb-2" readonly>
			      		</div>
			    	</div>
		  		</div>
                <div class="form-group mb-3">
                    <label for="detailMinOrderQuantity" class="form-label">최소 주문 수량</label>
                    <input type="number" id="detailMinOrderQuantity" name="minOrderQuantity" class="form-control" readonly>
                </div>
                <div class="form-group mb-3">
                    <label for="detailMaxOrderQuantity" class="form-label">최대 주문 수량</label>
                    <input type="number" id="detailMaxOrderQuantity" name="maxOrderQuantity" class="form-control" readonly>
                </div>
                <div class="form-group mb-3">
				    <label for="detailStatus" class="form-label">상태</label>
				    <select id="detailStatus" name="status" class="form-control" disabled>
				        <option value="활성">활성</option>
				        <option value="비활성">비활성</option>
				        <option value="대기">대기</option>
				        <!-- 필요한 상태 값을 추가하세요 -->
				    </select>
				</div>
                <div class="form-group mb-3">
                    <label for="contractdetailNote" class="form-label">비고</label>
                    <textarea id="contractDetailNote" name="note" class="form-control" rows="3" readonly></textarea>
                </div>
            </div>
            <div class="modal-footer" style="background-color:#f1f3f5;">
                <!-- 기본 버튼들 -->
                <button type="button" class="btn btn-primary" id="btnEditContractDetail">수정</button>
                <button type="button" class="btn btn-danger" id="btnDeleteContractDetail">삭제</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>

                <!-- 수정 모드 버튼 (초기엔 숨김) -->
                <button type="button" class="btn btn-success d-none" id="btnSaveContractDetail">저장</button>
                <button type="button" class="btn btn-secondary d-none" id="btnCancelEditDetail">취소</button>
            </div>
        </form>
    </div>
</div>