<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자페이지 - 상품 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="/resources/css/common/common.css" rel="stylesheet" />
    <script src="/resources/js/common/common.js"></script>
    <script src="/resources/js/admin/system_preferences/product_manage.js"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp" />
    <jsp:include page="/WEB-INF/views/admin/preference_modal/add_product.jsp" />
    <jsp:include page="/WEB-INF/views/admin/preference_modal/detail_product.jsp" />

    <section class="content">
        <div class="container mt-4">
            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
            	<h4 class="mb-0">상품 관리</h4>
            	<button id="btnAddProduct" class="btn btn-primary">상품 추가</button> 
            </div>
			<div style="display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 1rem;">
		        <!-- 좌측: 카테고리 선택 -->
		        <div style="display: flex; align-items: center; gap: 0.5rem;">
		            <select id="upperCategorySelect" class="form-control" style="max-width: 160px;">
		                <option value="">대분류 선택</option>
		            </select>
		            <select id="lowerCategorySelect" class="form-control" style="max-width: 160px;" disabled>
		                <option value="">소분류 선택</option>
		            </select>
		        </div>
		
		        <!-- 우측: 검색 폼 -->
		        <form action="${pageContext.request.contextPath}/admin/systemPreference/products" method="get" 
		              style="display: flex; align-items: center; gap: 0.5rem;">
		            <select name="searchType" class="form-control" style="max-width: 120px;">
		                <option value="name" ${param.searchType == 'name' ? 'selected' : ''}>상품명</option>
		                <option value="code" ${param.searchType == 'code' ? 'selected' : ''}>상품코드</option>
		            </select>
		            <input type="text"
		                   name="searchKeyword"
		                   value=""
		                   placeholder="검색어 입력"
		                   class="form-control"
		                   style="max-width: 200px;">
		            <button type="submit" class="btn btn-secondary" style="width:90px;">검색</button>
		        </form>
		    </div>
		
		    <div class="table-responsive" style="max-height: 280px; overflow-y: auto;">
		        <table id="productTable" class="table mb-0">
		            <thead>
		                <tr>
		                    <th>상품명</th>
		                    <th>기능</th>
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