<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>상품 관리</title>
    <style type="text/css">
    /* 검색/필터 바 */
	.pfilters {
		width: 100%;
	    border: 1px solid var(--border);
	    border-radius: 12px;
	    padding: 12px;
	    display: grid;
	    grid-template-columns: 180px 180px 1fr max-content;
	    gap: 10px;
	    align-items: center; /* 세로 중앙 */
	}
	/* 고정폭 제거 → 그리드가 폭을 관리하도록 */
	.pfilters .field{ display:flex; gap:6px; margin-right: 1.5em;}
	.pfilters select{ width:100%; height:38px; }
	.pfilters .search{ display:flex; }
	.pfilters input{ width:100%; height:38px; }
	
	.pfilters input, .pfilters select{
	  padding:0 10px; border:1px solid var(--border); border-radius:10px; background:#fff;
	}
	
	/* 버튼은 오른쪽 끝 */
	.pfilters .actions{
		display:flex; 
		width: 100%;
		justify-content:center; 
		align-items:center;
	}
	.pfilters .actions .btn{ 
		height:38px; 
		width: 10em;
		display: flex;
		justify-content: center;
	}
	
	/* 반응형: 좁아지면 세로 스택 */
	@media (max-width: 900px){
	  .pfilters{ grid-template-columns: 1fr; }
	  .pfilters .actions{ justify-content: stretch; }
	  .pfilters .actions .btn{ width:100%; }
	}
    </style>
   	<sec:csrfMetaTags/>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
        <div class="container">
			<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
			    <h3 class="mb-0">상품 관리</h3>
			    <button id="btnAddProduct" class="btn btn-primary">상품 추가</button>
			</div>
			<div style="display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 1rem;">
		    	<form class="pfilters" aria-label="검색 및 필터">
		    		<div class="field">
			    		<select class="categories" name="filterCategoryIdx" class="form-control" ></select>
		            </div>
		            <div class="field">
		                <select id="filterStatus" name="searchType">
		                    <option value="">상태</option>
		                    <option value="활성">활성</option>
		                    <option value="비활성">비활성</option>
		                    <option value="삭제">삭제</option>
		                </select>
		            </div>
		            <div class="search">
		                <input id="filterText" type="text" name="searchKeyword" placeholder="상품명" />
		            </div>
		            <div class="actions">
		                <button class="btn btn-primary" id="btnSearch">검색</button>
		            </div>
		        </form>    
		    </div>
			<div class="card">
			    <div class="table-responsive" >
			        <table id="productTable" class="table mb-0">
			            <thead>
			                <tr>
			                    <th>상품번호</th>
			                    <th>카테고리</th>
			                    <th>상품명</th>
			                    <th>상태</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<c:forEach items="${productList }" var="product">
								<tr class="productIdx" data-productidx="${product.productIdx}">
									<td>${product.productIdx }</td>
									<td>${product.commonCode.commonCodeName }</td>
									<td>${product.productName }</td>
									<td>
										<span class="badge
											${product.status eq '활성'   ? 'badge-confirmed' :
											  product.status eq '비활성' ? 'badge-warning'   :
											                              'badge-urgent'}">
											${product.status}
										</span>
									</td>
								</tr>		            	
			            	</c:forEach>
			            </tbody>
			        </table>
			    </div>
			</div>
		    <!-- 페이징 -->
		    <div class="pager">
				<div>
					<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
						<input type="button" value="이전" 
							onclick="location.href='/admin/systemPreference/product?pageNum=${pageInfo.pageNum - 1}&filter=${param.searchType}&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod=${param.orderMethod}&filterCategoryIdx=${param.filterCategoryIdx}'" 
							<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
						<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
							<c:choose>
								<c:when test="${i eq pageInfo.pageNum}">
									<strong>${i}</strong>
								</c:when>
								<c:otherwise>
									<a href="/admin/systemPreference/product?pageNum=${i}&filter=${param.searchType}&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod=${param.orderMethod}&filterCategoryIdx=${param.filterCategoryIdx}">${i}</a>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<input type="button" value="다음" 
							onclick="location.href='/admin/systemPreference/product?pageNum=${pageInfo.pageNum + 1}&filter=${param.searchType}&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod=${param.orderMethod}&filterCategoryIdx=${param.filterCategoryIdx}'" 
						<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
					</c:if>
				</div>
			</div>
            
            
		</div>		
    </section>
</body>
</html>