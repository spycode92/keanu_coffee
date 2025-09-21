<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>공급 업체 관리</title>
    <sec:csrfMetaTags/>
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
			<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
	            <h3 class="mb-0">공급업체 관리</h3>
				<button id="btnAddSupplier" class="btn btn-primary">공급업체 추가</button>
			</div>
			<div style="display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 1rem;">
			
	  	        <form class="filters" aria-label="검색 및 필터">
		            <div class="field">
		                <select id="filterStatus" name="searchType">
		                    <option value="">전체</option>
		                    <option value="활성">활성</option>
		                    <option value="비활성">비활성</option>
		                    <option value="삭제">삭제</option>
		                </select>
		            </div>
		            <div class="search">
		                <input id="filterText" type="text" name="searchKeyword" placeholder="업체명" />
		            </div>
		            <div class="actions">
		                <button class="btn btn-primary" id="btnSearch">검색</button>
		            </div>
		        </form>
	        </div>
			<div class="card">	
	            <div class="table-responsive">
	                <table id="supplierTable" class="table">
	                    <thead>
	                        <tr>
	                            <th>업체 번호</th>
	                            <th>공급업체</th>
	                            <th>공급업체 담당자</th>
	                            <th>계약 상태</th>
	                        </tr>
	                    </thead>
	                    <tbody>
		                    <c:forEach items="${supplierList }" var="supplier">
		                        <tr class="supplier-row" data-supplieridx="${supplier.supplierIdx }">
		                        	<td>${supplier.supplierIdx }</td>
		                        	<td>${supplier.supplierName }</td>
		                        	<td>${supplier.supplierManager }</td>
		                        	<td>
			                        	<span class="badge
									        ${supplier.status eq '활성'   ? 'badge-confirmed' :
									          supplier.status eq '비활성' ? 'badge-warning'   :
									                                       'badge-urgent'}">
									        ${supplier.status}
									    </span>
								    </td>
		                        </tr>
		                    </c:forEach>
	                        
	                    </tbody>
	                </table>
	            </div>
            </div>
	   		<div class="pager">
				<div>
					<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
						<input type="button" value="이전" 
							onclick="location.href='/admin/systemPreference/supplyCompany?pageNum=${pageInfo.pageNum - 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}'" 
							<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
						<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
							<c:choose>
								<c:when test="${i eq pageInfo.pageNum}">
									<strong>${i}</strong>
								</c:when>
								<c:otherwise>
									<a href="/admin/systemPreference/supplyCompany?pageNum=${i}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}">${i}</a>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<input type="button" value="다음" 
							onclick="location.href='/admin/systemPreference/supplyCompany?pageNum=${pageInfo.pageNum + 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}'" 
						<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
					</c:if>
				</div>
        	</div>
        </div>
    </section>
</body>
</html>