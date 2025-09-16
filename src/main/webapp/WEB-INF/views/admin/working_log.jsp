<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>메인 페이지 - 시스템 로그</title>
<style type="text/css">
.filters{
    width:100%;                       /* 전체 폭 70em 고정 */
    display:grid;
    grid-template-columns: 180px 1fr 110px;
    gap:10px;
    align-items:center;
    border:1px solid var(--border);
    border-radius:12px;
    padding:12px;
}

.filters .field{display:flex;gap:6px;margin-right:1.5em}
.filters select,
.filters input{
    width:100%;height:38px;
    padding:0 10px;
    border:1px solid var(--border);
    border-radius:10px;
    background:#fff;
}

.filters .actions{display:flex;justify-content:center;width:100%}
.filters .actions .btn{height:38px;width:10em;display:flex;justify-content:center}

/* 900 px 이하일 때 세로 스택 */
@media (max-width:900px){
    .filters{grid-template-columns:1fr}
    .filters .actions .btn{width:100%}
}
</style>
<sec:csrfMetaTags/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
</head>

<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"/>

<section class="content">

    <!-- 검색 바 : 공통 .filters 패턴 -->
	<div style="display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 1rem;">
    
	    <form class="filters" aria-label="검색 및 필터">
	        <div class="field">
	            <select name="searchType">
	                <option value="이름">이름</option>
	                <option value="사번">사번</option>
	                <option value="상품">상품</option>
	            </select>
	        </div>
	
	        <div class="search">
	            <input type="text" class="form-control" name="searchKeyword" placeholder="검색어 입력">
	        </div>
	
	        <div class="actions">
	            <button type="submit" class="btn btn-sm btn-primary">검색</button>
	        </div>
	    </form>
    </div>

    <!-- 로그 테이블 : 공통 .table 스타일 -->
	<table class="table">
	    <thead>
	        <tr>
	            <th style="width:15%;">시간</th>
	            <th>Log</th>
	            <th style="width:15%;">작업자</th>
	        </tr>
	    </thead>
	    <tbody>
	        <!-- 더미 데이터 : 실제로는 forEach로 교체 -->
	        <tr>
	            <td>2025-08-13&nbsp;13:11:11</td>
	            <td>상품 케냐AA원두10kg(88900110211) x 10 을 location A03-0A-001 → C11-0F-013 재고 이동</td>
	            <td>장덕배(110022113322)</td>
	        </tr>
	        <tr>
	            <td>2025-08-13&nbsp;13:11:09</td>
	            <td>상품 케냐AA원두10kg(88900110211) 100개 발주</td>
	            <td>장덕배(110022113322)</td>
	        </tr>
	        <!-- …필요 시 반복 -->
	    </tbody>
	</table>

    <!-- 페이지네이션 : include 파일 그대로 사용 -->
    <jsp:include page="/WEB-INF/views/inc/pagination.jsp">
        <jsp:param name="pageUrl" value="/dashboard/log" />
    </jsp:include>

</section>
</body>
</html>