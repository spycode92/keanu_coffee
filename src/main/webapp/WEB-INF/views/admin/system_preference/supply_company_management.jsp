<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자페이지 - 공급 업체 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="/resources/css/common/common.css" rel="stylesheet" />
    <script src="/resources/js/common/common.js"></script>
    <script src="/resources/js/admin/system_preferences/supplier_manage.js"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp" />
    <jsp:include page="/WEB-INF/views/admin/preference_modal/add_supplier.jsp" />
    <jsp:include page="/WEB-INF/views/admin/preference_modal/detail_supplier.jsp" />

    <section class="content">
        <div class="container">
            <h4 class="mb-3"><i class="fas fa-truck"></i> 공급업체 관리</h4>

            <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
                <button id="btnAddSupplier" class="btn btn-primary btn-sm">+ 공급업체 추가</button>
                <div style="display: flex; gap: 1rem;">
                    <label><input type="radio" name="supplierStatus" value="ALL" checked> 전체</label>
                    <label><input type="radio" name="supplierStatus" value="HAS_CONTRACT"> 계약중</label>
                    <label><input type="radio" name="supplierStatus" value="NO_CONTRACT"> 미계약</label>
                </div>
            </div>

            <div class="table-responsive">
                <table id="supplierTable" class="table">
                    <thead>
                        <tr>
                            <th>업체 번호</th>
                            <th>공급업체명</th>
                            <th>계약 상태</th>
                            <th>상세보기</th>
                            <th>삭제</th>
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