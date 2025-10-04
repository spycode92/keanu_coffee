<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>입고확정</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

	<style>
		.inbound-confirm { font-variant-numeric: tabular-nums; }
		.inbound-confirm .card { padding:1rem; }
		.inbound-confirm .form-control { height:36px; box-sizing:border-box; padding:0 10px; }
		.inbound-confirm .table th, .inbound-confirm .table td { padding:.55rem .6rem; vertical-align:middle; }
		.inbound-confirm .right { text-align:right; }
		.inbound-confirm .assign-loc { width:200px; }
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content inbound-confirm">
		<div class="d-flex justify-content-between align-items-center mb-3">
			<div>
				<h1 class="card-title">입고확정</h1>
				<div class="text-muted">검수완료 대기 목록</div>
			</div>
			<div class="d-flex gap-2">
				<button id="btnBack" class="btn btn-secondary btn-sm">← 뒤로</button>
				<button id="btnBulkAssign" class="btn btn-secondary btn-sm">로케이션 일괄할당</button>
				<button id="btnConfirmSelected" class="btn btn-primary btn-sm">선택확정(재고반영)</button>
			</div>
		</div>

		<div class="card mb-3">
			<div class="card-header">
				<div class="card-title">확정 대기 입고 목록</div>
			</div>

			<div class="table-responsive">
				<table class="table" aria-label="확정 대기 목록">
					<thead>
						<tr>
							<th style="width:36px;"><input id="selectAll" type="checkbox" /></th>
							<th>입고번호</th>
							<th style="width:140px;">입고일자</th>
							<th>공급업체</th>
							<th style="width:120px;">총수량</th>
							<th style="width:160px;">로케이션(할당)</th>
							<th>상태</th>
							<th>비고</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="checkbox" class="row-check" /></td>
							<td>-</td>
							<td>-</td>
							<td>-</td>
							<td class="right">-</td>
							<td><input class="form-control assign-loc" type="text" value="A-01-03" />-</td>
							<td><span class="badge badge-pending"></span></td>
							<td>-</td>
						</tr>
						<tr>
							<td><input type="checkbox" class="row-check" /></td>
							<td>IN-20250810-015</td>
							<td>2025-08-10</td>
							<td>베스트유통</td>
							<td class="right">180</td>
							<td><input class="form-control assign-loc" type="text" value="B-02-01" /></td>
							<td><span class="badge badge-pending">검수완료</span></td>
							<td>-</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="d-flex justify-content-end gap-2 p-3">
				<button id="btnConfirmAll" class="btn btn-primary btn-sm">모두확정(모의)</button>
			</div>
		</div>
	</section>

	<script>
		document.getElementById("btnBack").addEventListener("click", function(e){ e.preventDefault(); history.back(); });
		document.getElementById("selectAll").addEventListener("change", function(){
			const checked = this.checked;
			document.querySelectorAll(".row-check").forEach(ch => ch.checked = checked);
		});
		document.getElementById("btnConfirmSelected").addEventListener("click", function(e){ e.preventDefault(); alert("선택 확정(모의) — 재고 반영"); });
		document.getElementById("btnConfirmAll").addEventListener("click", function(e){ e.preventDefault(); alert("모두 확정(모의) — 재고 반영"); });
	</script>
</body>
</html>
