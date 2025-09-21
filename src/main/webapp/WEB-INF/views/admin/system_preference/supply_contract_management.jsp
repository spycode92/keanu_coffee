<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>공급계약 관리</title>
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
    <script src="/resources/js/admin/system_preferences/supply_contract.js"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    

</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp" />
    <jsp:include page="/WEB-INF/views/admin/preference_modal/add_contract.jsp" />
    <jsp:include page="/WEB-INF/views/admin/preference_modal/detail_contract.jsp" />

    <section class="content">
        <div class="container mt-4">
			<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                <h3 class="mb-0">공급계약 관리</h3>
                <button id="btnAddContract" class="btn btn-primary">공급계약 추가</button>
            </div>
			<div style="display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 1rem;">
		    	<form class="pfilters" aria-label="검색 및 필터">
		            <div class="field">
		                <select id="filterStatus" name="filterStatus" >
		                    <option value="">전체</option>
		                    <option value="활성" <c:if test="${filterStatus eq '활성' }">selected</c:if>>활성</option>
		                    <option value="비활성" <c:if test="${filterStatus eq '비활성' }">selected</c:if>>비활성</option>
		                    <option value="취소" <c:if test="${filterStatus eq '취소' }">selected</c:if>>취소</option>
		                    <option value="삭제" <c:if test="${filterStatus eq '삭제' }">selected</c:if>>삭제</option>
		                </select>
		            </div>
		    		<div class="field">
			    		<select name="searchType"  >
							<option value="s.supplier_name" <c:if test="${searchType eq 's.supplier_name' }">selected</c:if>>공급업체 </option>
							<option value="p.product_name" <c:if test="${searchType eq 'p.product_name' }">selected</c:if>>상품명</option>
			            </select>
		            </div>
		            <div class="search">
		                <input id="filterText" type="text" name="searchKeyword" placeholder="검색" />
		            </div>
		            <div class="actions">
		                <button class="btn btn-primary" id="btnSearch">검색</button>
		            </div>
		        </form>    
		    </div>
		    <div class="card">
	            <div class="table-responsive" >
	                <table id="contractTable" class="table contract-table mb-0">
	                    <thead>
	                        <tr>
	                            <th>공급업체</th>
	                            <th>상품명</th>
	                            <th>계약단가</th>
	                            <th>계약시작</th>
	                            <th>계약끝</th>
	                            <th>상태</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                        <c:forEach items="${supplyCotractList }" var="contract">
	                        	<tr data-contract-idx="${contract.supplyContractIdx}">
	                        		<td>${contract.supplier.supplierName }</td>
	                        		<td>${contract.product.productName }</td>
	                        		<td>${contract.contractPrice }</td>
	                        		<td>${contract.contractStart }</td>
	                        		<td>${contract.contractEnd }</td>
	                        		<td>              
		                        		<span class="badge
							                  ${contract.status eq '활성'   ? 'badge-confirmed' :
							                    contract.status eq '비활성' ? 'badge-warning'   :
							                                                'badge-urgent'}">
							                  ${contract.status}
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
							onclick="location.href='/admin/systemPreference/supplyContract?pageNum=${pageInfo.pageNum - 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod=${param.orderMethod}&filterStatus=${param.filterStatus}'" 
							<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
						<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
							<c:choose>
								<c:when test="${i eq pageInfo.pageNum}">
									<strong>${i}</strong>
								</c:when>
								<c:otherwise>
									<a href="/admin/systemPreference/supplyContract?pageNum=${i}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod=${param.orderMethod}&filterStatus=${param.filterStatus}">${i}</a>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<input type="button" value="다음" 
							onclick="location.href='/admin/systemPreference/supplyContract?pageNum=${pageInfo.pageNum + 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod=${param.orderMethod}&filterStatus=${param.filterStatus}'" 
						<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
					</c:if>
				</div>
			</div>
        </div>
    </section>
    
	<!-- 공급처검색 모달 -->
	<div id="searchSupplier" class="modal" aria-hidden="true" role="dialog" aria-labelledby="contractAddLabel" tabindex="-1">
	    <div class="modal-card sm">
			<div class="modal-head" >
	        	<h5 id="supplierSearchLabel">공급업체검색</h5>
	       	    <button type="button"
	                       class="modal-close-btn"
	                       aria-label="닫기"
	                       onclick="ModalManager.closeModal(document.getElementById('searchSupplier'))">
	                   &times;
	            </button>
	        </div>
	        <div class="modal-body" >
	            <div class="field" >
	                <div style=" display:flex; gap:1rem; min-width:150px;">
		                <input type="text" id="supplierSearch">
	                </div>
	            </div>
	            <div class="field">
	            	<table id="searchSupplierList">
	            	
	            	</table>
	            </div>
			</div>
	    </div>
	</div>
	<!-- 상품검색 모달 -->
	<div id="searchProduct" class="modal" aria-hidden="true" role="dialog" aria-labelledby="contractAddLabel" tabindex="-1">
	    <div class="modal-card sm">
			<div class="modal-head" >
	        	<h5 id="productSearchLabel">상품검색</h5>
	       	    <button type="button"
	                       class="modal-close-btn"
	                       aria-label="닫기"
	                       onclick="ModalManager.closeModal(document.getElementById('searchProduct'))">
	                   &times;
	            </button>
	        </div>
	        <div class="modal-body" >
	            <div class="field" >
	                <div style=" display:flex; gap:1rem; min-width:150px;">
		                <input type="text" id="productSearch">
	                </div>
	            </div>
	            <div class="field">
	            	<table id="searchProductList">
	            	
	            	</table>
	            </div>
			</div>
	    </div>
	</div>
</body>
</html>