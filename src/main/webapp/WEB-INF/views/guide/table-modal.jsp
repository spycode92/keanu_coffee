<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!-- Table Modal -->
<div class="modal open" id="tableModal">
    <div class="modal-card modal-table lg">
        <div class="modal-head">
            <h3>결제 내역</h3>
            <button onclick="closeModal('tableModal')">✕</button>
        </div>
        <div class="modal-body">
            <table class="table">
                <thead>
                    <tr>
                        <th>날짜</th>
                        <th>금액</th>
                        <th>상태</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>2025-08-01</td>
                        <td>10,000원</td>
                        <td><span class="badge badge-confirmed">완료</span></td>
                    </tr>
                    <tr>
                        <td>2025-08-10</td>
                        <td>5,000원</td>
                        <td><span class="badge badge-pending">대기</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="modal-foot">
            <button class="btn btn-secondary" onclick="closeModal('tableModal')">닫기</button>
        </div>
    </div>
</div>