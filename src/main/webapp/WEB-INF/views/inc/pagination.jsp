<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

	<!-- 페이징 -->
   	<div class="pager">
		<div>
			<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
				<input type="button" value="이전" 
					onclick="location.href='${pageUrl}?pageNum=${pageInfo.pageNum - 1}&filter=${param.filter}&searchKeyword=${param.searchKeyword}'" 
					<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
				<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
					<c:choose>
						<c:when test="${i eq pageInfo.pageNum}">
							<strong>${i}</strong>
						</c:when>
						<c:otherwise>
							<a href="${pageUrl}?pageNum=${i}&filter=${param.filter}&searchKeyword=${param.searchKeyword}">${i}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<input type="button" value="다음" 
					onclick="location.href='${pageUrl}?pageNum=${pageInfo.pageNum + 1}&filter=${param.filter}&searchKeyword=${param.searchKeyword}'" 
				<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
			</c:if>
		</div>
   	</div>