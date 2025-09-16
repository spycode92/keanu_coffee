<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수주확인서</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/transport/common.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/dispatch.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/deliveryConfirmation.js"></script>

</head>
<body>
	<div>
        <div>
            <div>
                <strong id="detailTitle">수주확인서</strong>
            </div>
            <div class="modal-body">
            <table>
            	<colgroup>
            		<col width="20%">
            		<col width="80%">
            	</colgroup>
            	<tr>
            		<th>수주확인서번호</th>
            		<td>1</td>
            	</tr>
            	<tr>
            		<th>출고주문번호</th>
            		<td>2</td>
            	</tr>
            </table>
                <div class="field">
                    <label>담당 기사 정보</label>
                    <input id="detailDriver" disabled />
                </div>

                <div class="card" style="margin-top:10px" id="summary">
                    <div class="card-header">주문서(품목)</div>
                    <table class="table" id="summaryInfo">
                        <thead>
                            <tr>
                                <th>배차일</th>
                                <th>배차시간</th>
                                <th>구역명</th>
                                <th>총적재량</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody><!-- JS 렌더링 --></tbody>
                    </table>
                </div>
                <div class="card" style="margin-top:10px" id="detail">
                    <table class="table" id="detailItems">
                        <thead>
                            <tr>
                                <th>지점</th>
                                <th>품목</th>
                                <th>반품수량/출고수량</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody><!-- JS 렌더링 --></tbody>
                    </table>
                </div>
            </div>
            <div>
            </div>
        </div>
    </div>
</body>
</html>