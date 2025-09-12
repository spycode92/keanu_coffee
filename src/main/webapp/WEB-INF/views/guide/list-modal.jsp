<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!-- List Modal -->
<div class="modal open" id="listModal">
    <div class="modal-card modal-list sm">
        <div class="modal-head">
            <h3>옵션 선택</h3>
            <button onclick="closeModal('listModal')">✕</button>
        </div>
        <div class="modal-body">
            <ul>
                <li>옵션 1</li>
                <li>옵션 2</li>
                <li>옵션 3</li>
                <li>옵션 4</li>
            </ul>
        </div>
        <div class="modal-foot">
            <button class="btn btn-secondary" onclick="closeModal('listModal')">취소</button>
        </div>
    </div>
</div>
