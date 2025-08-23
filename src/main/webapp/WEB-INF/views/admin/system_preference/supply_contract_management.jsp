<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자페이지 - 공급계약 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="/resources/css/common/common.css" rel="stylesheet" />
    <script src="/resources/js/common/common.js"></script>
    <script src="/resources/js/admin/system_preferences/supply_contract.js"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp" />
    <jsp:include page="/WEB-INF/views/admin/preference_modal/add_contract.jsp" />
    <jsp:include page="/WEB-INF/views/admin/preference_modal/detail_contract.jsp" />

    <section class="content">
        <div class="container mt-4">
            <div class="flex-between mb-3">
                <h4 class="mb-0">공급계약 관리</h4>
                <button id="btnAddContract" class="btn btn-primary">공급계약 추가</button>
            </div>

            <div class="table-responsive" style="max-height:300px; overflow-y:auto;">
                <table id="contractTable" class="table contract-table mb-0">
                    <thead>
                        <tr>
                            <th>공급업체</th>
                            <th>상품명</th>
                            <th>계약단가</th>
                            <th>계약기간</th>
                            <th>상태</th>
                            <th>상세보기</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- JS 렌더링 -->
                    </tbody>
                </table>
            </div>
        </div>
    </section>
</body>
</html>