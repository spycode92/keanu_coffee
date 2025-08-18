<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>입고 상세</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

	<style>
		/* ===== inbound detail page 전용 오버라이드 (공통 CSS 유지) ===== */
		.inbound-detail {
			font-variant-numeric: tabular-nums;
		}

		.inbound-detail .card { padding: 1rem; }
		.inbound-detail .card-header { margin-bottom: .75rem; padding-bottom: .5rem; }
		.inbound-detail .card-title { margin: 0; }

		/* 읽기전용 느낌: label / value 그리드 */
		.inbound-detail .kv-grid {
			display: grid;
			grid-template-columns: repeat(4, minmax(160px, 1fr));
			gap: .5rem 1rem;
			align-items: center;
		}
		.inbound-detail .kv-item { min-width: 0; }
		.inbound-detail .kv-label { font-size: .9rem; color: var(--muted-foreground); margin-bottom: .25rem; }
		.inbound-detail .kv-value { padding: .45rem .6rem; background: var(--input-background); border: 1px solid var(--border); border-radius: var(--radius); }

		/* 상단 버튼 그룹 */
		.inbound-detail .page-actions { display:flex; gap:.5rem; align-items:center; }

		/* timeline */
		.inbound-detail .timeline {
			display:flex;
			gap:1rem;
			align-items:center;
			padding: .5rem 0;
		}
		.inbound-detail .timeline-step {
			display:flex;
			flex-direction:column;
			align-items:center;
			gap:.25rem;
			text-align:center;
			min-width:90px;
		}
		.inbound-detail .timeline-dot {
			width:18px;
			height:18px;
			border-radius:50%;
			background:var(--muted);
			border:2px solid var(--border);
		}
		.inbound-detail .timeline-step.active .timeline-dot { background:var(--primary); border-color:var(--primary); }

		/* items table */
		.inbound-detail #itemsTable { table-layout: fixed; width:100%; }
		.inbound-detail .table th, .inbound-detail .table td { padding: .55rem .6rem; vertical-align: middle; }
		.inbound-detail .table thead th { background: var(--accent); color: var(--foreground); position: sticky; top:0; z-index:1; }
		.inbound-detail .table .right { text-align:right; }

		/* attachments */
		.inbound-detail .attachments { display:flex; flex-direction:column; gap:.4rem; }
		.inbound-detail .attachment-item { padding:.5rem; background:var(--card); border:1px solid var(--border); border-radius:.375rem; }

		/* responsive */
		@media (max-width: 980px) {
			.inbound-detail .kv-grid { grid-template-columns: 1fr 1fr; }
			.inbound-detail .timeline { flex-wrap:wrap; justify-content:flex-start; }
		}
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content inbound-detail">
		<!-- 헤더 / 액션 -->
		<div class="d-flex justify-content-between align-items-center mb-3">
			<div>
				<h1 class="card-title">입고 상세</h1>
				<div class="text-muted" style="font-size:0.95rem;">입고번호: <strong>IN-20250811-001</strong></div>
			</div>
			<div class="page-actions">
				<button id="btnBack" class="btn btn-secondary btn-sm" title="뒤로가기">← 뒤로</button>
				<button id="btnPrint" class="btn btn-secondary btn-sm">인쇄</button>
				<button id="btnEdit" class="btn btn-primary btn-sm">수정</button>
				<button id="btnConfirm" class="btn btn-primary btn-sm">입고확정</button>
			</div>
		</div>

		<!-- 상단 기본정보 카드 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">기본 정보</div>
				<div class="text-muted">상태: <span class="badge badge-pending">대기</span></div>
			</div>

			<div class="kv-grid">
				<div class="kv-item">
					<div class="kv-label">입고번호</div>
					<div class="kv-value">IN-20250811-001</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">입고일자</div>
					<div class="kv-value">2025-08-11</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">창고</div>
					<div class="kv-value">중앙창고</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">입고구분</div>
					<div class="kv-value">구매입고</div>
				</div>

				<div class="kv-item">
					<div class="kv-label">공급업체</div>
					<div class="kv-value">에이스상사 (1234567890)</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">담당자</div>
					<div class="kv-value">김담당</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">발주번호(PO)</div>
					<div class="kv-value">PO-20250801-001</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">입고위치</div>
					<div class="kv-value">A-01-03</div>
				</div>

				<div class="kv-item">
					<div class="kv-label">총 품목 수</div>
					<div class="kv-value">4</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">총 수량</div>
					<div class="kv-value">540</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">총 금액</div>
					<div class="kv-value">₩ 1,230,000</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">비고</div>
					<div class="kv-value">부분입고 — 검수대기</div>
				</div>
			</div>
		</div>

		<!-- 타임라인 -->
		<div class="card mb-3">
			<div class="card-header">
				<div class="card-title">상태 이력 (타임라인)</div>
			</div>
			<div class="timeline p-2">
				<div class="timeline-step active">
					<div class="timeline-dot"></div>
					<div class="muted" style="font-size:.85rem;">등록</div>
					<div style="font-size:.85rem;">2025-08-11<br/><span class="muted">홍길동</span></div>
				</div>
				<div class="timeline-step">
					<div class="timeline-dot"></div>
					<div class="muted" style="font-size:.85rem;">검수대기</div>
					<div style="font-size:.85rem;">(미완료)</div>
				</div>
				<div class="timeline-step">
					<div class="timeline-dot"></div>
					<div class="muted" style="font-size:.85rem;">확정</div>
					<div style="font-size:.85rem;">-</div>
				</div>
			</div>
		</div>

		<!-- 품목 목록 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">품목 내역</div>
				<div class="muted">총 4건</div>
			</div>

			<div class="table-responsive">
				<table id="itemsTable" class="table">
					<thead>
						<tr>
							<th style="width:40px;">No</th>
							<th>품목명 / 규격</th>
							<th style="width:80px;">수량</th>
							<th style="width:100px;">단위</th>
							<th style="width:120px;">단가</th>
							<th style="width:140px;" class="right">공급가액</th>
							<th style="width:120px;" class="right">부가세</th>
							<th style="width:140px;" class="right">총액</th>
							<th style="width:120px;">비고</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>1</td>
							<td>아라비카 원두 1kg / 로스팅 A</td>
							<td class="right">200</td>
							<td>KG</td>
							<td class="right">₩ 3,000</td>
							<td class="right">₩ 600,000</td>
							<td class="right">₩ 60,000</td>
							<td class="right">₩ 660,000</td>
							<td>부분입고</td>
						</tr>
						<tr>
							<td>2</td>
							<td>종이컵 250ml / 1000pcs</td>
							<td class="right">50</td>
							<td>BOX</td>
							<td class="right">₩ 6,000</td>
							<td class="right">₩ 300,000</td>
							<td class="right">₩ 30,000</td>
							<td class="right">₩ 330,000</td>
							<td>-</td>
						</tr>
						<tr>
							<td>3</td>
							<td>설탕 5kg / 백</td>
							<td class="right">100</td>
							<td>EA</td>
							<td class="right">₩ 1,500</td>
							<td class="right">₩ 150,000</td>
							<td class="right">₩ 15,000</td>
							<td class="right">₩ 165,000</td>
							<td>-</td>
						</tr>
						<tr>
							<td>4</td>
							<td>시럽 1L / 바닐라</td>
							<td class="right">190</td>
							<td>EA</td>
							<td class="right">₩ 5,000</td>
							<td class="right">₩ 950,000</td>
							<td class="right">₩ 95,000</td>
							<td class="right">₩ 1,045,000</td>
							<td>검수요청</td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="5" class="right">합계</td>
							<td class="right">₩ 2,000,000</td>
							<td class="right">₩ 200,000</td>
							<td class="right">₩ 2,200,000</td>
							<td></td>
						</tr>
					</tfoot>
				</table>
			</div>
		</div>

		<!-- 첨부 / 메모 / 로그 -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="card-title">첨부 / 메모 / 변경이력</div>
			</div>

			<div class="row mb-3">
				<div class="col-md-6">
					<div class="muted">첨부파일</div>
					<div class="attachments">
						<div class="attachment-item">packing_list_20250811.pdf</div>
						<div class="attachment-item">inspection_photo_1.jpg</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="muted">메모</div>
					<div class="kv-value" style="min-height:80px;">검수 후 입고확정 필요 — 외관 손상 일부. 공급사에 통보 예정.</div>
				</div>
			</div>

			<div>
				<div class="muted">변경 이력</div>
				<table class="table" style="margin-top:.5rem;">
					<thead>
						<tr>
							<th style="width:160px;">시간</th>
							<th style="width:160px;">사용자</th>
							<th>변경내용</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>2025-08-11 10:12</td>
							<td>홍길동</td>
							<td>입고 요청 등록</td>
						</tr>
						<tr>
							<td>2025-08-11 13:40</td>
							<td>김담당</td>
							<td>부분입고 체크 — 수량 수정 (300 → 200)</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</section>

	<script>
		// 뒤로가기 버튼
		document.getElementById("btnBack").addEventListener("click", function(e){
			e.preventDefault();
			history.back();
		});

		// 간단 UI: 인쇄, 편집(화살표만)
		document.getElementById("btnPrint").addEventListener("click", function(e){
			e.preventDefault(); window.print();
		});
		document.getElementById("btnEdit").addEventListener("click", function(e){
			e.preventDefault(); alert("편집 모드로 이동(구현 필요)");
		});
		document.getElementById("btnConfirm").addEventListener("click", function(e){
			e.preventDefault(); alert("입고확정 처리(모의)");
		});
	</script>
</body>
</html>
