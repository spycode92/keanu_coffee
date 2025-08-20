<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
</head>
<body>
<!-- 기본양식 -->
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 

<section class="content">
	<div style="display: flex; align-items: center; gap: 8px; width: 35%">
		<select>
		<ins>검색</ins>
			<option>이름</option>
			<option>사번</option>
			<option>상품</option>
		</select>
		<input class="form-control" placeholder="텍스트 입력">
		<input type="button" value="검색" class="btn btn-sm btn-primary">
	</div>
	
	<table class="table" style="color:green;">
		<tr>
			<th style="width:15%;">시간</th>
			<th>log</th>
			<th style="width:5%;">작업자</th>
		</tr>
		<tr>
			<td>2025-08-13 13:11:11</td>
			<td>상품 케냐AA원두10kg(88900110211) x 10 을 location A03-0A-001 에서 location C11-0F-013으로 재고이동하였습니다.</td>
			<td>장덕배(110022113322)</td>
		</tr>
		<tr>
			<td>2025-08-13 13:11:09</td>
			<td>상품 케냐AA원두10kg(88900110211) 을 재고관리시스템 에서 100개 발주 하였습니다.</td>
			<td>장덕배(110022113322)</td>
		</tr>
		<tr>
			<td>2025-08-13 13:11:08</td>
			<td>상품 케냐AA원두10kg(88900110211) x 10 을 location A01-0B-011 에서 집품준비 하였습니다.</td>
			<td>장덕배(110022113322)</td>
		</tr>
		<tr>
			<td>2025-08-13 13:11:11</td>
			<td>상품 케냐AA원두10kg(88900110211) x 10 을 location A03-0A-001 에서 location C11-0F-013으로 재고이동하였습니다.</td>
			<td>장덕배(110022113322)</td>
		</tr>
		<tr>
			<td>2025-08-13 13:11:11</td>
			<td>상품 케냐AA원두10kg(88900110211) x 10 을 location A03-0A-001 에서 location C11-0F-013으로 재고이동하였습니다.</td>
			<td>장덕배(110022113322)</td>
		</tr>
		<tr>
			<td>2025-08-13 13:11:11</td>
			<td>상품 케냐AA원두10kg(88900110211) x 10 을 location A03-0A-001 에서 location C11-0F-013으로 재고이동하였습니다.</td>
			<td>장덕배(110022113322)</td>
		</tr>
		<tr>
			<td>2025-08-13 13:11:11</td>
			<td>상품 케냐AA원두10kg(88900110211) x 10 을 location A03-0A-001 에서 location C11-0F-013으로 재고이동하였습니다.</td>
			<td>장덕배(110022113322)</td>			
		</tr>
		<tr>
			<td>2025-08-13 13:11:11</td>
			<td>상품 케냐AA원두10kg(88900110211) x 10 을 location A03-0A-001 에서 location C11-0F-013으로 재고이동하였습니다.</td>
			<td>장덕배(110022113322)</td>
		</tr>
		<tr>
			<td>2025-08-13 13:11:11</td>
			<td>상품 케냐AA원두10kg(88900110211) x 10 을 location A03-0A-001 에서 location C11-0F-013으로 재고이동하였습니다.</td>
			<td>장덕배(110022113322)</td>
		</tr>
		<tr>
			<td>2025-08-13 13:11:11</td>
			<td>상품 케냐AA원두10kg(88900110211) x 10 을 location A03-0A-001 에서 location C11-0F-013으로 재고이동하였습니다.</td>
			<td>장덕배(110022113322)</td>
		</tr>
		<tr>
			<td>2025-08-13 13:11:11</td>
			<td>상품 케냐AA원두10kg(88900110211) x 10 을 location A03-0A-001 에서 location C11-0F-013으로 재고이동하였습니다.</td>
			<td>장덕배(110022113322)</td>
		</tr>
	</table>
</section>









<script>
$("#adminPage").click(function(){
  location.href="/admin/main";
});
</script>
</div>
</body>
</html>