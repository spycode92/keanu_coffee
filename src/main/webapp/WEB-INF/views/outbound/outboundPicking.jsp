<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>출고 피킹</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

	<style>
		.outbound-pick { font-variant-numeric: tabular-nums; }
		.outbound-pick .card { padding:1rem; }
		.outbound-pick .form-control { height:36px; box-sizing:border-box; padding:0 10px; }
		.outbound-pick .btn.btn-sm { height:36px; line-height:34px; padding:0 12px; }
		.outbound-pick .table th, .outbound-pick .table td { padding:.55rem .6rem; vertical-align:middle; }
		.outbound-pick .right { text-align:right; }
		.outbound-pick .pick-actions { display:flex; gap:.5rem; align-items:center; }
		.outbound-pick .picker-info { font-size:.95rem; color:var(--muted-foreground); }
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content outbound-pick">
		<div class="d-flex justify-content-between align-items-center mb-3">
			<div>
				<h1 class="card-title">출고 피킹</h1>
				<div class="text-muted">피킹리스트: <strong>PICK-20250812-01</strong></div>
			</div>
			<div class="d-flex gap-2">
				<button id="btnBack" class="btn btn-secondary btn-sm">← 뒤로</button>
				<button id="btnStart" class="btn btn-primary btn-sm">피킹시작</button>
				<button id="btnFinish" class="btn btn-primary btn-sm">피킹완료</button>
			</div>
		</div>

		<!-- 피커 정보 -->
		<div class="card mb-3">
			<div class="card-header">
				<div class="card-title">피커 정보 / 요약</div>
			</div>
			<div class="p-3 d-flex justify-content-between align-items-center">
				<div class="picker-info">
					<span>담당자: 박피커</span> &nbsp; | &nbsp; <span>창고: 중앙창고</span> &nbsp; | &nbsp; <span>총 품목: 5</span>
				</div>
				<div class="pick-actions">
					<button id="btnScan" class="btn btn-secondary btn-sm">바코드 스캔(모의)</button>
					<button id="btnBulkAssign" class="btn btn-secondary btn-sm">로케이션 할당</button>
				</div>
			</div>
		</div>

		<!-- 피킹 테이블 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">피킹 항목</div>
				<div class="muted">리스트: PICK-20250812-01</div>
			</div>

			<div class="table-responsive">
				<table class="table" aria-label="피킹 항목">
					<thead>
						<tr>
							<th style="width:40px;">No</th>
							<th>품목명 / 규격</th>
							<th style="width:110px;">지시수량</th>
							<th style="width:110px;">피킹수량</th>
							<th style="width:140px;">피킹로케이션</th>
							<th style="width:120px;">상태</th>
							<th style="width:120px;">비고</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>1</td>
							<td>아라비카 원두 1kg</td>
							<td class="right">120</td>
							<td><input class="form-control" type="number" value="120" /></td>
							<td><input class="form-control" type="text" value="A-01-03" /></td>
							<td>
								<select class="form-control">
									<option>대기</option>
									<option selected>피킹완료</option>
									<option>부분피킹</option>
								</select>
							</td>
							<td><input class="form-control" type="text" placeholder="비고" /></td>
						</tr>
						<tr>
							<td>2</td>
							<td>시럽 1L / 바닐라</td>
							<td class="right">200</td>
							<td><input class="form-control" type="number" value="200" /></td>
							<td><input class="form-control" type="text" value="B-02-05" /></td>
							<td>
								<select class="form-control">
									<option selected>피킹완료</option>
									<option>대기</option>
									<option>부분피킹</option>
								</select>
							</td>
							<td><input class="form-control" type="text" placeholder="비고" /></td>
						</tr>
						<tr>
							<td>3</td>
							<td>종이컵 250ml / 1000pcs</td>
							<td class="right">100</td>
							<td><input class="form-control" type="number" value="100" /></td>
							<td><input class="form-control" type="text" value="C-03-01" /></td>
							<td>
								<select class="form-control">
									<option selected>피킹완료</option>
									<option>대기</option>
									<option>부분피킹</option>
								</select>
							</td>
							<td><input class="form-control" type="text" placeholder="비고" /></td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="d-flex justify-content-end p-3 gap-2">
				<button id="btnPartial" class="btn btn-secondary btn-sm">부분피킹 처리</button>
				<button id="btnConfirmPick" class="btn btn-primary btn-sm">피킹확정(모의)</button>
			</div>
		</div>
	</section>

	<script>
		document.getElementById("btnBack").addEventListener("click", function(e){ e.preventDefault(); history.back(); });
		document.getElementById("btnStart").addEventListener("click", function(e){ e.preventDefault(); alert("피킹시작(모의)"); });
		document.getElementById("btnFinish").addEventListener("click", function(e){ e.preventDefault(); alert("피킹완료(모의)"); });
		document.getElementById("btnConfirmPick").addEventListener("click", function(e){ e.preventDefault(); alert("피킹확정(모의)"); });
	</script>
</body>
</html>
