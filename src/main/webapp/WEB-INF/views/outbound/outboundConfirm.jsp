<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>출고확정</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

	<style>
		.outbound-confirm { font-variant-numeric: tabular-nums; }
		.outbound-confirm .card { padding:1rem; }
		.outbound-confirm .form-control { height:36px; box-sizing:border-box; padding:0 10px; }
		.outbound-confirm .table th, .outbound-confirm .table td { padding:.55rem .6rem; vertical-align:middle; }
		.outbound-confirm .right { text-align:right; }
		.outbound-confirm .ship-info { display:flex; gap:1rem; align-items:center; }
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content outbound-confirm">
		<div class="d-flex justify-content-between align-items-center mb-3">
			<div>
				<h1 class="card-title">출고확정</h1>
				<div class="text-muted">확정 전 출고 대기 목록</div>
			</div>
			<div class="d-flex gap-2">
				<button id="btnBack" class="btn btn-secondary btn-sm">← 뒤로</button>
				<button id="btnAssignCarrier" class="btn btn-secondary btn-sm">운송사/운송장 일괄등록</button>
				<button id="btnConfirmShip" class="btn btn-primary btn-sm">선택출고확정</button>
			</div>
		</div>

		<div class="card mb-3">
			<div class="card-header">
				<div class="card-title">확정 대기 출고 목록</div>
			</div>

			<div class="table-responsive">
				<table class="table" aria-label="출고 확정 목록">
					<thead>
						<tr>
							<th style="width:36px;"><input id="selectAllOut" type="checkbox" /></th>
							<th>출고번호</th>
							<th style="width:140px;">출고일자</th>
							<th>출고처</th>
							<th style="width:120px;">총수량</th>
							<th style="width:180px;">운송사 / 운송장</th>
							<th>상태</th>
							<th>비고</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="checkbox" class="row-out" /></td>
							<td>OUT-20250812-007</td>
							<td>2025-08-12</td>
							<td>카페문방구</td>
							<td class="right">420</td>
							<td><input class="form-control" type="text" placeholder="운송사 / 운송장" value="한진택배 / HJ20250812-998877" /></td>
							<td><span class="badge badge-pending">피킹완료</span></td>
							<td>긴급출고</td>
						</tr>
						<tr>
							<td><input type="checkbox" class="row-out" /></td>
							<td>OUT-20250812-009</td>
							<td>2025-08-12</td>
							<td>동네카페</td>
							<td class="right">60</td>
							<td><input class="form-control" type="text" placeholder="운송사 / 운송장" /></td>
							<td><span class="badge badge-pending">피킹완료</span></td>
							<td>-</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="d-flex justify-content-end p-3 gap-2">
				<button id="btnCreateManifest" class="btn btn-secondary btn-sm">송장 생성(모의)</button>
				<button id="btnConfirmAllOut" class="btn btn-primary btn-sm">모두확정(모의)</button>
			</div>
		</div>
	</section>

	<script>
		document.getElementById("btnBack").addEventListener("click", function(e){ e.preventDefault(); history.back(); });
		document.getElementById("selectAllOut").addEventListener("change", function(){ const v=this.checked; document.querySelectorAll(".row-out").forEach(x => x.checked = v); });
		document.getElementById("btnConfirmShip").addEventListener("click", function(e){ e.preventDefault(); alert("선택 출고확정(모의)"); });
		document.getElementById("btnConfirmAllOut").addEventListener("click", function(e){ e.preventDefault(); alert("모두 출고확정(모의)"); });
		document.getElementById("btnCreateManifest").addEventListener("click", function(e){ e.preventDefault(); alert("송장 생성(모의)"); });
	</script>
</body>
</html>
