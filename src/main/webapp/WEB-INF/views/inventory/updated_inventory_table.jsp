<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style type="text/css">
	section {
		width: 1200px;
		margin: 0 auto;
	}
	#paging {
	
		width: 400px;
		margin: 50px auto;
	}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	<section>
		<h1>업데이트된 재고 테이블</h1>
		
  <form id="searchForm" action="inventory/productHistorySearch" method="get">
    <label class="form-label" for="searchInput">재고 ID:</label>
    <input class="form-control" type="text" id="searchInput" placeholder="제품 이름이나 아이디를 입력하세요..." >
    <input class="btn btn-sm btn-primary"  type="submit"><br>
  </form><br>
		
		<div class="table-responsive">
		<table class="table">
  <thead>
    <tr>
      <th>재고 ID</th>
      <th>재고 이름</th>
      <th>수량이 변경되었습니다</th>
      <th>타임스탬프</th>
      <th>직원 ID</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>INV001</td>
      <td>플라스틱 박스</td>
      <td>+50</td>
      <td>2025-08-13 09:15</td>
      <td>EMP102</td>
    </tr>
    <tr>
      <td>INV002</td>
      <td>금속 선반</td>
      <td>-10</td>
      <td>2025-08-13 09:22</td>
      <td>EMP087</td>
    </tr>
    <tr>
      <td>INV003</td>
      <td>포장 테이프</td>
      <td>+200</td>
      <td>2025-08-13 09:30</td>
      <td>EMP145</td>
    </tr>
    <tr>
      <td>INV004</td>
      <td>라벨 스티커</td>
      <td>-25</td>
      <td>2025-08-13 09:45</td>
      <td>EMP076</td>
    </tr>
    <tr>
      <td>INV005</td>
      <td>팔레트</td>
      <td>+15</td>
      <td>2025-08-13 10:00</td>
      <td>EMP033</td>
    </tr>
    <tr>
      <td>INV006</td>
      <td>박스 커터</td>
      <td>-5</td>
      <td>2025-08-13 10:10</td>
      <td>EMP198</td>
    </tr>
    <tr>
      <td>INV007</td>
      <td>보호 장갑</td>
      <td>+100</td>
      <td>2025-08-13 10:25</td>
      <td>EMP056</td>
    </tr>
    <tr>
      <td>INV008</td>
      <td>스트레치 필름</td>
      <td>-30</td>
      <td>2025-08-13 10:40</td>
      <td>EMP121</td>
    </tr>
    <tr>
      <td>INV009</td>
      <td>종이 상자</td>
      <td>+75</td>
      <td>2025-08-13 10:55</td>
      <td>EMP099</td>
    </tr>
    <tr>
      <td>INV010</td>
      <td>청소용 스프레이</td>
      <td>-12</td>
      <td>2025-08-13 11:05</td>
      <td>EMP064</td>
    </tr>
  </tbody>
</table>
	  </div>
	  <div id="paging" >
        <div class="d-flex gap-2">
          <a href="#" class="btn btn-secondary btn-sm">« 처음</a>
          <a href="#" class="btn btn-secondary btn-sm">‹ 이전</a>
          <a href="#" class="btn btn-primary btn-sm">1</a>
          <a href="#" class="btn btn-secondary btn-sm">2</a>
          <a href="#" class="btn btn-secondary btn-sm">3</a>
          <a href="#" class="btn btn-secondary btn-sm">다음 ›</a>
          <a href="#" class="btn btn-secondary btn-sm">끝 »</a>
        </div>
      </div>
	</section>
</body>
</html>