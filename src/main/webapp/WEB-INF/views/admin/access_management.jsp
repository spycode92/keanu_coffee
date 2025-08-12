<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자페이지</title>
<!-- 기본 양식 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<link href="/resources/css/common/common.css" rel="stylesheet">
<script src="/resources/js/common/common.js"></script>

</head>
<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
<section class="content">

	<div class="row">
		<div class="col-md-3">
			<div class="card">
				<div class="card-header">
					<p>직급관리</p>
					<div style="text-align: right;">⊕ ⊖</div>
				</div>
				<div class="card-body">
						<p>관리자</p>
						<p>운송관리자</p>
						<p>입고관리자</p>
						<p>출고관리자</p>
						<p>재고관리자</p>
				</div>
			</div>
		</div>
  
		<div class="col-md-3">
			<div class="card">
				<div class="card-header">
					부여권한
				</div>
				<div class="card-body">
					<span>입고관리</span>
					<select>
						<option>read only</option>
						<option>read/write</option>
						<option>read/write/modify</option>
					</select><br>
					<span>출고관리</span>
					<select>
						<option>read only</option>
						<option>read/write</option>
						<option>read/write/modify</option>
					</select><br>
					<span>재고관리</span>
					<select>
						<option>read only</option>
						<option>read/write</option>
						<option>read/write/modify</option>
					</select><br>
					<span>운송관리</span>
					<select>
						<option>read only</option>
						<option>read/write</option>
						<option>read/write/modify</option>
					</select><br>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<div class="card">
				<div class="card-header">
					미부여권한
				</div>
				<div class="card-body">
					<p></p>
				</div>
			</div>
		</div>
	</div>
	<div style="text-align: right; width:75%;">
		<input type="button" value="저장" >
	</div>
</section>
	
	</div>

</body>
</html>