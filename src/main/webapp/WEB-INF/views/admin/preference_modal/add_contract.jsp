<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!-- 공급계약 등록 모달 -->
<div class="modal fade" id="contractAddModal" tabindex="-1" aria-labelledby="contractAddLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-sm modal-dialog-centered">
        <form id="contractAddForm" class="modal-content" style="background-color:#f5f1e9; color:#212529;">
        	<div class="modal-header" style="background-color:#007bff; color:#ffffff;">
                <h5 class="modal-title" id="contractAddLabel">공급계약 등록</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">
	
			   
			    <div class="form-group flex-fill m-0" style="flex-wrap: wrap; display: flex;">
			    <!-- 공급업체 선택 -->
			        <label for="supplierSelect" class="form-label">공급업체</label>
			        <select id="supplierSelect" name="supplierIdx" class="form-select" required>
			            <option value="">선택하세요</option>
			            <!-- 공급업체 옵션 -->
			        </select>
			         <!-- 상품 선택 -->
			        <label for="productSelect" class="form-label">상품</label>
			        <select id="productSelect" name="productIdx" class="form-select" required>
			            <option value="">선택하세요</option>
			            <!-- 상품 옵션-->
			        </select>
			    
			
			   
			    </div>


                <!-- 계약 단가 -->
                <div class="form-group mb-3">
                    <label for="contractPrice" class="form-label">계약 단가</label>
                    <input type="number" id="contractPrice" name="contractPrice" class="form-control" min="0" required>
                </div>
                <!-- 계약 기간 -->
                <div class="form-group mb-3 d-flex gap-2">
                    <div style="flex:1">
                        <label for="contractStart" class="form-label">시작일</label>
                        <input type="date" id="contractStart" name="contractStart" class="form-control" required>
                    </div>
                    <div style="flex:1">
                        <label for="contractEnd" class="form-label">종료일</label>
                        <input type="date" id="contractEnd" name="contractEnd" class="form-control" required>
                    </div>
                </div>
                <!-- 최소 주문 수량 -->
                <div class="form-group mb-3">
                    <label for="minOrderQuantity" class="form-label">최소 주문 수량</label>
                    <input type="number" id="minOrderQuantity" name="minOrderQuantity" class="form-control" min="0">
                </div>
                <!-- 최대 주문 수량 -->
                <div class="form-group mb-3">
                    <label for="maxOrderQuantity" class="form-label">최대 주문 수량</label>
                    <input type="number" id="maxOrderQuantity" name="maxOrderQuantity" class="form-control" min="0">
                </div>
                <!-- 상태 -->
                <div class="form-group mb-3">
                    <label for="statusSelect" class="form-label">상태</label>
                    <select id="statusSelect" name="status" class="form-select" required>
                        <option value="1" selected>활성</option>
                        <option value="2">비활성</option>
                        <option value="3">대기</option>
                    </select>
                </div>
                <!-- 메모/비고 -->
                <div class="form-group mb-3">
                    <label for="addContractnote" class="form-label">비고</label>
                    <textarea id="addContractnote" name="note" class="form-control" rows="3"></textarea>
                </div>
            </div>
            <div class="modal-footer" style="background-color:#f1f3f5;">
                <button type="button" class="btn btn-primary" id="btnSaveContract">등록</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
            </div>
        </form>
    </div>
</div>