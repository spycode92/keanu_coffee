<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고 이동</title>
<sec:csrfMetaTags/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/inventory/move_inventory.js"></script>

<!-- FontAwesome CDN for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
<section class="content">
    <form class="card d-flex" action="/inventory/moveInventory" method="post"  id="moveToCartForm" style="gap: 1.5rem; max-width: 500px; margin: auto;">
        <sec:csrfInput/>
        
        <!-- 상품 이미지 프리뷰 영역: 가로 공간 약 35% -->
        <div style="flex: 0 0 35%; min-width: 150px; display: flex; justify-content: center; align-items: center; border: 1px solid var(--border); border-radius: var(--radius); padding: 1rem;">
            <img id="productPreview" src="${defaultProductImageUrl}" alt="상품 이미지" style="max-width: 100%; height: auto; border-radius: var(--radius);">
        </div>
        
        <!-- 폼 입력 영역: 가로 공간 약 65% -->
        <div style="flex: 1;">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1 class="card-title">재고 이동</h1>
                <a href="/inventory/moveInventory/cart">
	                <i class="fa-solid fa-cart-shopping"></i>
                </a>
            </div>

            <div class="form field mb-3">
                <label class="form-label" for="mi_lotNumber">상품 lot번호</label>
                <input class="form-control" id="mi_lotNumber" type="text" name="lotNumber">
            </div>

            <div class="form field mb-3">
                <label class="form-label" for="mi_locationName">상품의 로케이션</label>
                <input class="form-control" id="mi_locationName" type="text" name="locationName">
            </div>

            <div class="form field mb-3">
                <label class="form-label" for="mi_quantity">상품 갯수</label>
                <input class="form-control" id="mi_quantity" type="number" name="quantity" min="1" required readonly>
            </div>
            
            <div style="text-align: right;">
                <button class="btn btn-primary" type="button" id="mi_addCart" onclick="javascript:void(0)">이동</button>
            </div>
        </div>
    </form>
</section>

</body>
</html>
