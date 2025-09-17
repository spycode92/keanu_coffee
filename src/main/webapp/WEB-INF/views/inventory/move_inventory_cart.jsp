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

<!-- FontAwesome CDN for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
<section class="content">
    <form class="card d-flex" action="/inventory/moveInventory" method="post"  id="moveTolocationForm" style="gap: 1.5rem; max-width: 500px; margin: auto;">
        <sec:csrfInput/>

        <div>
		    <!-- 제목 영역: 테이블 위 -->
		    <div class="d-flex justify-content-between align-items-center mb-3">
		        <h1 class="card-title">재고 이동</h1>
		        <a href="/inventory/moveInventory" class="nav-item">
		            <i class="fa-solid fa-backward"></i>
		        </a>
		    </div>
		
		    <!-- 테이블 영역 -->
		    <div class="form field mb-3" id="cartList">
		        <table class="table table-bordered mb-4">
		            <thead>
		                <tr class="bg-muted-foreground">
		                    <th class="text-center">lot번호</th>
		                    <th class="text-left">상품이름</th>
		                    <th class="text-right">수량</th>
		                </tr>
		            </thead>
		            <tbody>
		                <c:forEach var="inventory" items="${inventoryList}">
		                    <tr data-lotNumber="${inventory['lotNumber']}" data-maxQuantity="${inventory['quantity']}"> 
		                        <td class="text-center">${inventory['lotNumber']}</td>
		                        <td class="text-left">${inventory['productName']}</td>
		                        <td class="text-right">${inventory['quantity']}</td>
		                    </tr>
		                </c:forEach>
		            </tbody>
		        </table>
		    </div>
		
		    <!-- 이미지 + 폼 입력 영역 flex 컨테이너 -->
		    <div class="d-flex gap-4 align-items-start">
		        <!-- 상품 이미지 프리뷰 영역 -->
		        <div class="flex-shrink-0" style="min-width: 150px; border: 1px solid var(--border); border-radius: var(--radius); padding: 1rem; display: flex; justify-content: center; align-items: center;">
		            <img id="productPreview" src="${defaultProductImageUrl}" alt="상품 이미지" style="max-width: 100%; height: auto; border-radius: var(--radius);">
		        </div>
		
		        <!-- 폼 입력 영역 -->
		        <div class="flex-grow-1">
		            <div class="form field mb-3">
		                <label class="form-label" for="mi_lotNumber">상품 lot번호</label>
		                <input class="form-control" id="mi_lotNumber" type="text" name="lotNumber" readonly>
		            </div>
		            <div class="form field mb-3">
		                <label class="form-label" for="mi_locationName">로케이션 이름</label>
		                <input class="form-control" id="mi_locationName" type="text" name="locationName">
		            </div>
		            <div class="form field mb-3">
		                <label class="form-label" for="mi_quantity">상품 갯수</label>
		                <input class="form-control" id="mi_quantity" type="number" name="quantity" min="1" required readonly>
		            </div>
		            
		            <div class="text-right">
		                <button class="btn btn-primary" type="button" id="mi_moveToLocation">카트에담기</button>
		            </div>
		        </div>
		    </div>
		</div>
    </form>
</section>
<script src="${pageContext.request.contextPath}/resources/js/inventory/move_cartinventory.js"></script>
</body>
</html>
