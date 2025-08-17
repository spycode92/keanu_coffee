<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>

<div class="modal fade supplier-modal" id="supplierDetailModal" tabindex="-1" aria-labelledby="supplierDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form id="supplierDetailForm">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="supplierDetailModalLabel">공급업체 상세정보</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="supplierIdx" name="supplierIdx">
                    <div class="form-group">
                        <label for="detailSupplierName">업체명</label>
                        <input type="text" class="form-control" id="detailSupplierName" name="supplierName" required>
                    </div>
                    <div class="form-group">
                        <label for="detailSupplierManager">담당자</label>
                        <input type="text" class="form-control" id="detailSupplierManager" name="supplierManager">
                    </div>
                    <div class="form-group">
                        <label for="detailSupplierManagerPhone">연락처</label>
                        <input type="text" class="form-control" id="detailSupplierManagerPhone" name="supplierManagerPhone">
                    </div>
                    <div class="form-group">
                        <label for="detailSupplierZipcode">우편번호</label>
                        <div class="d-flex">
                            <input type="text" class="form-control mr-2" id="detailSupplierZipcode" name="supplierZipcode" readonly style="max-width:150px;">
                            <button type="button" class="btn btn-primary" id="btnDetailSearchAddress">우편번호 검색</button>
                        </div>
                    </div>
                    <div class="form-group mb-1">
                        <label for="detailSupplierAddress1">주소</label>
                        <input type="text" class="form-control mb-2" id="detailSupplierAddress1" name="supplierAddress1" readonly>
                        <input type="text" class="form-control" id="detailSupplierAddress2" name="supplierAddress2">
                    </div>
                </div>
                <div class="modal-footer">
				    <button type="button" class="btn btn-secondary btn-cancel-edit" style="display:none;">취소</button>
				    <button type="button" class="btn btn-primary btn-edit">수정</button>
				    <button type="submit" class="btn btn-primary btn-save" style="display:none;">수정완료</button>
				</div>
            </div>
        </form>
    </div>
</div>