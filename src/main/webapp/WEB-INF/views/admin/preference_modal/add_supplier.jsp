<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!-- 공급업체 등록 모달 -->
<div class="modal fade supplier-modal" id="supplierModal" tabindex="-1" aria-labelledby="supplierModalLabel" aria-hidden="true">
	<div class="modal-dialog">
	    <form id="supplierForm">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="supplierModalLabel">공급업체 등록</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	            </div>
	            <div class="modal-body">
	                <div class="form-group">
	                    <label for="supplierName">업체명</label>
	                    <input type="text" class="form-control" id="supplierName" name="supplierName" required>
	                </div>
	                <div class="form-group">
	                    <label for="supplierManager">담당자</label>
	                    <input type="text" class="form-control" id="supplierManager" name="supplierManager" required>
	                </div>
	                <div class="form-group">
	                    <label for="supplierManagerPhone">연락처</label>
	                    <input type="text" class="form-control" id="supplierManagerPhone" name="supplierManagerPhone" required>
					</div>
					<div class="form-group">
		    			<label for="supplierZipcode" class="mb-1"><b>우편번호</b></label>
		    			<div class="d-flex">
							<input type="text" class="form-control mr-2" id="supplierZipcode" name="supplierZipcode" placeholder="Zipcode" readonly style="max-width:150px;">
					        <button type="button" class="btn btn-primary" id="btnSearchAddress">우편번호 확인</button>
					    </div>
					</div>
					<div class="form-group mb-1">
					    <label for="supplierAddress" class="mb-1"><b>주소</b></label>
					    <input type="text" class="form-control mb-2" id="supplierAddress1" name="supplierAddress1" placeholder="Address1" readonly >
					    <input type="text" class="form-control" id="supplierAddress2" name="supplierAddress2" placeholder="Address2" required>
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