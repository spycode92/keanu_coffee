<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>지점 관리</title>
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">   	
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="/resources/css/common/common.css" rel="stylesheet" />
    <script src="/resources/js/common/common.js"></script>
    <script src="/resources/js/admin/system_preferences/franchise_manage.js"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
   	<sec:csrfMetaTags />
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp" />
    <jsp:include page="/WEB-INF/views/admin/preference_modal/add_franchise.jsp" />
    <jsp:include page="/WEB-INF/views/admin/preference_modal/detail_franchise.jsp" />

    <section class="content">
        <div class="container mt-4">
			<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                <h3 class="mb-0">지점 관리</h3>
                <button id="btnAddFranchise" class="btn btn-primary">지점 추가</button>
            </div>
			<div style="display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 1rem;">
		    	<form class="filters" aria-label="검색 및 필터">
		    		<div class="field">
			    		<select name="searchType" >
							<option value="">전체</option>
		                    <option value="운영" <c:if test="${searchType eq '운영' }">selected</c:if>>운영</option>
		                    <option value="휴점" <c:if test="${searchType eq '휴점' }">selected</c:if>>휴점</option>
		                    <option value="폐점" <c:if test="${searchType eq '폐점' }">selected</c:if>>폐점</option>
			            </select>
		            </div>
		            <div class="search">
		                <input id="filterText" type="text" name="searchKeyword" placeholder="지점명" />
		            </div>
		            <div class="actions">
		                <button class="btn btn-primary" id="btnSearch">검색</button>
		            </div>
		        </form>    
		    </div>
		    <div class="card">
	            <div class="table-responsive" style="overflow-y:auto;">
	                <table id="franchiseTable" class="table franchise-table mb-0">
	                    <thead>
	                        <tr>
	                            <th>지점번호</th>
	                            <th>지점명</th>
	                            <th>지점장</th>
	                            <th>지점번호</th>
	                            <th>상태</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                        <c:forEach items="${franchiseList}" var="franchise">
	                        	<tr data-franchise-idx="${franchise.franchiseIdx }" class="franchise-row">
	                        		<td>${franchise.franchiseIdx }</td>
	                        		<td>${franchise.franchiseName }</td>
	                        		<td>${franchise.franchiseManagerName }</td>
	                        		<td>${franchise.franchisePhone }</td>
	                        		<td>
	                        			<span class="badge
							                  ${franchise.status eq '운영'   ? 'badge-confirmed' :
							                    franchise.status eq '휴점' ? 'badge-warning'   :
							                                                'badge-urgent'}">
							                  ${franchise.status}
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
							onclick="location.href='/admin/systemPreference/franchise?pageNum=${pageInfo.pageNum - 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod=${param.orderMethod}&filterStatus=${param.filterStatus}'" 
							<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
						<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
							<c:choose>
								<c:when test="${i eq pageInfo.pageNum}">
									<strong>${i}</strong>
								</c:when>
								<c:otherwise>
									<a href="/admin/systemPreference/franchise?pageNum=${i}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod=${param.orderMethod}&filterStatus=${param.filterStatus}">${i}</a>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<input type="button" value="다음" 
							onclick="location.href='/admin/systemPreference/franchise?pageNum=${pageInfo.pageNum + 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod=${param.orderMethod}&filterStatus=${param.filterStatus}'" 
						<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
					</c:if>
				</div>
			</div>
        </div>
    </section>
</body>
</html>