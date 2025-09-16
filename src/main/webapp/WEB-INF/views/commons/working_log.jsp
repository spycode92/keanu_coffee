<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>작업로그</title>
<!-- 기본 양식 -->
<sec:csrfMetaTags/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/resources/js/admin/system_notification.js"></script>
</head>

<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
<section class="content">
	<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
		<h4>작업로그</h4>
		<input type="button" value="직원추가" id="addEmployee" class="btn btn-primary" data-target="#addEmployeeModal">
	</div>
	<div style="display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 1rem;">
		<form class="filters" aria-label="검색 및 필터">
			<div class="field">
				<select id="filterStatus" name="searchType">
					<option value="emp_no" <c:if test="${searchType eq 'empNo' }">selected</c:if>>사번</option>
					<option value="log_message"<c:if test="${searchType eq 'log_message' }">selected</c:if>>메세지</option>
				</select>
			</div>
			<div class="search">
				<input class="filterText" placeholder="텍스트 입력" name="searchKeyword" >
			</div>
			<div class="actions">
				<button class="btn btn-primary" value="검색" id="btnSearch">검색</button>
			</div>
		</form>
	</div>
	<div class="card">
    	<div class="table-responsive mt-3" >
		
			<table class="table table-striped table-bordered" >
				<tr>
					<c:if test="${param.orderKey eq log_idx }"></c:if>
					<th>번호</th>
					<th data-key="created_at" onclick="allineTable(this)">
						로그생성일시
						<c:choose>
							<c:when test="${param.orderKey eq 'created_at'}">
								<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
								<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
							</c:when>
							 <c:otherwise>
								↕
							 </c:otherwise>
						</c:choose>
					</th>
					<th >작업자</th>
					<th data-key="sub_section" onclick="allineTable(this)">
						작업영역
						<c:choose>
							<c:when test="${param.orderKey eq 'sub_section'}">
								<c:if test="${param.orderMethod eq 'asc' }">▲</c:if>
								<c:if test="${param.orderMethod eq 'desc' }">▼</c:if>
							</c:when>
							 <c:otherwise>
								↕
							 </c:otherwise>
						</c:choose>
					</th>
					<th >
						로그메세지
					</th>
					
				</tr>
				<c:forEach var="workingLog" items="${workingLogList }">
					<tr class="workingLog-row" data-emp-idx="${workingLog.logIdx}">
						<td>${workingLog.logIdx }</td>
						<td><fmt:formatDate value="${workingLog.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td>${workingLog.empNo }</td>
						<td>${workingLog.subSection }</td>
						<td>${workingLog.logMessage }</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
 				<div class="pager">
					<div>
						<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
							<input type="button" value="이전" 
								onclick="location.href='/admin/systemnotification?pageNum=${pageInfo.pageNum - 1}&filter=${param.filter}&searchType=${param.searchType }&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod${param.orderMethod}'" 
								<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
							
							<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
								<c:choose>
									<c:when test="${i eq pageInfo.pageNum}">
										<strong>${i}</strong>
									</c:when>
									<c:otherwise>
										<a href="/admin/systemnotification?pageNum=${i}&filter=${param.filter}&searchType=${param.searchType }&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod${param.orderMethod}">${i}</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							
							<input type="button" value="다음" 
								onclick="location.href='/admin/systemnotification?pageNum=${pageInfo.pageNum + 1}&filter=${param.filter}&searchType=${param.searchType }&searchKeyword=${param.searchKeyword}&orderKey=${param.orderKey}&orderMethod${param.orderMethod}'" 
							<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
						</c:if>
					</div>
				</div>
			</div>
		

	</section>
	
</div>

</body>
</html>