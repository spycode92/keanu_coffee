<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>출고검수</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

	<style>
		.outbound-inspect { font-variant-numeric: tabular-nums; }
		.outbound-inspect .card { padding: 1rem; }
		.outbound-inspect .card-header { margin-bottom:.75rem; padding-bottom:.5rem; }
		.outbound-inspect .form-control { height:36px; line-height:34px; box-sizing:border-box; padding:0 10px; }
		.outbound-inspect .btn.btn-sm { height:36px; line-height:34px; padding:0 12px; }
		.outbound-inspect .table th, .outbound-inspect .table td { padding:.55rem .6rem; vertical-align:middle; }
		.outbound-inspect .right { text-align:right; }
		.outbound-inspect .status-select { min-width:110px; }
		.outbound-inspect .attachment { margin-top:.4rem; font-size:.9rem; color:var(--muted-foreground); }
		.outbound-inspect .kv { display:flex; gap:1rem; align-items:center; }
		@media (max-width:980px) {
			.outbound-inspect .kv { flex-direction:column; align-items:stretch; gap:.5rem; }
		}
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content outbound-inspect">
		<div class="d-flex justify-content-between align-items-center mb-3">
			<div>
				<h1 class="card-title">출고검수</h1>
				<div class="text-muted">출고번호: <strong>OUT-20250812-007</strong></div>
			</div>
			<div class="d-flex gap-2">
				<button id="btnBack" class="btn btn-secondary btn-sm">← 뒤로</button>
				<button id="btnSave" class="btn btn-secondary btn-sm">임시저장</button>
				<button id="btnComplete" class="btn btn-primary btn-sm">검수완료(확정)</button>
			</div>
		</div>

		<!-- 기본 정보 -->
		<div class="card mb-3">
			<div class="card-header">
				<div class="card-title">기본 정보</div>
			</div>
			<div class="p-3 kv">
				<div>
					<div class="muted">출고번호</div>
					<div class="kv-value">OUT-20250812-007</div>
				</div>
				<div>
					<div class="muted">창고</div>
					<div class="kv-value">중앙창고</div>
				</div>
				<div>
					<div class="muted">담당자</div>
					<div class="kv-value">이담당</div>
				</div>
				<div>
					<div class="muted">검수일시</div>
					<div class="kv-value">2025-08-12 14:10</div>
				</div>
			</div>
		</div>

		<!-- 품목 검수 테이블 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">검수 항목</div>
				<div class="muted">총 3건</div>
			</div>

			<div class="table-responsive">
				<table class="table" aria-label="검수 항목">
					<thead>
						<tr>
							<th style="width:40px;">No</th>
							<th>품목명 / 규격</th>
							<th style="width:100px;">계획수량</th>
							<th style="width:110px;">검수수량</th>
							<th style="width:110px;">불량수량</th>
							<th style="width:140px;">검수상태</th>
							<th style="width:160px;">비고 / 사진</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>1</td>
							<td>아라비카 원두 1kg / 로스팅 A</td>
							<td class="right">120</td>
							<td><input class="form-control" type="number" value="120" /></td>
							<td><input class="form-control" type="number" value="0" /></td>
							<td>
								<select class="form-control status-select">
									<option value="PASS" selected>합격</option>
									<option value="FAIL">불합격</option>
									<option value="HOLD">보류</option>
								</select>
							</td>
							<td>
								<input class="form-control" type="text" placeholder="검수 메모" />
								<div class="attachment">사진: inspection_1.jpg</div>
							</td>
						</tr>
						<tr>
							<td>2</td>
							<td>시럽 1L / 바닐라</td>
							<td class="right">200</td>
							<td><input class="form-control" type="number" value="190" /></td>
							<td><input class="form-control" type="number" value="10" /></td>
							<td>
								<select class="form-control status-select">
									<option value="PASS">합격</option>
									<option value="FAIL" selected>불합격</option>
									<option value="HOLD">보류</option>
								</select>
							</td>
							<td>
								<input class="form-control" type="text" placeholder="불량 사유" />
								<div class="attachment">사진: syrup_damage.jpg</div>
							</td>
						</tr>
						<tr>
							<td>3</td>
							<td>종이컵 250ml / 1000pcs</td>
							<td class="right">100</td>
							<td><input class="form-control" type="number" value="100" /></td>
							<td><input class="form-control" type="number" value="0" /></td>
							<td>
								<select class="form-control status-select">
									<option value="PASS" selected>합격</option>
									<option value="FAIL">불합격</option>
									<option value="HOLD">보류</option>
								</select>
							</td>
							<td>
								<input class="form-control" type="text" placeholder="메모" />
								<div class="attachment">사진: -</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="d-flex justify-content-between align-items-center p-3">
				<div class="muted">검수 완료 시 '검수완료'를 눌러 상태를 변경하세요.</div>
				<div class="d-flex gap-2">
					<button id="btnRejectNotify" class="btn btn-secondary btn-sm">불량통보(모의)</button>
					<button id="btnFinalize" class="btn btn-primary btn-sm">검수완료(모의)</button>
				</div>
			</div>
		</div>
	</section>

	<script>
		document.getElementById("btnBack").addEventListener("click", function(e){ e.preventDefault(); history.back(); });
		document.getElementById("btnSave").addEventListener("click", function(e){ e.preventDefault(); alert("임시저장(모의)"); });
		document.getElementById("btnComplete").addEventListener("click", function(e){ e.preventDefault(); alert("검수완료(모의) — 상태 변경 예정"); });
		document.getElementById("btnFinalize").addEventListener("click", function(e){ e.preventDefault(); alert("검수완료(모의)"); });
		document.getElementById("btnRejectNotify").addEventListener("click", function(e){ e.preventDefault(); alert("공급사 불량 통보(모의)"); });
	</script>
</body>
</html>
