<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>출고 상세</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

	<style>
		/* ===== outbound detail page 전용 오버라이드 (공통 CSS 유지) ===== */
		.outbound-detail { font-variant-numeric: tabular-nums; }

		.outbound-detail .card { padding: 1rem; }
		.outbound-detail .card-header { margin-bottom: .75rem; padding-bottom: .5rem; }
		.outbound-detail .card-title { margin: 0; }

		/* key/value 그리드 (읽기 전용) */
		.outbound-detail .kv-grid {
			display: grid;
			grid-template-columns: repeat(4, minmax(160px, 1fr));
			gap: .5rem 1rem;
			align-items: center;
		}
		.outbound-detail .kv-item { min-width: 0; }
		.outbound-detail .kv-label { font-size: .9rem; color: var(--muted-foreground); margin-bottom: .25rem; }
		.outbound-detail .kv-value { padding: .45rem .6rem; background: var(--input-background); border: 1px solid var(--border); border-radius: var(--radius); }

		/* 상단 버튼 그룹 */
		.outbound-detail .page-actions { display:flex; gap:.5rem; align-items:center; }

		/* 타임라인 */
		.outbound-detail .timeline { display:flex; gap:1rem; align-items:center; padding: .5rem 0; }
		.outbound-detail .timeline-step { display:flex; flex-direction:column; align-items:center; gap:.25rem; text-align:center; min-width:90px; }
		.outbound-detail .timeline-dot { width:18px; height:18px; border-radius:50%; background:var(--muted); border:2px solid var(--border); }
		.outbound-detail .timeline-step.active .timeline-dot { background:var(--primary); border-color:var(--primary); }

		/* 품목 테이블 */
		.outbound-detail #itemsTable { table-layout: fixed; width:100%; }
		.outbound-detail .table th, .outbound-detail .table td { padding: .55rem .6rem; vertical-align: middle; }
		.outbound-detail .table thead th { background: var(--accent); color: var(--foreground); position: sticky; top:0; z-index:1; }
		.outbound-detail .table .right { text-align:right; }

		/* 송장 / 배송 정보 */
		.outbound-detail .shipping-grid {
			display: grid;
			grid-template-columns: repeat(3, minmax(200px, 1fr));
			gap: .5rem 1rem;
			align-items: start;
		}

		/* 첨부/메모/로그 */
		.outbound-detail .attachments { display:flex; flex-direction:column; gap:.4rem; }
		.outbound-detail .attachment-item { padding:.5rem; background:var(--card); border:1px solid var(--border); border-radius:.375rem; }

		/* 반응형 */
		@media (max-width: 980px) {
			.outbound-detail .kv-grid { grid-template-columns: 1fr 1fr; }
			.outbound-detail .shipping-grid { grid-template-columns: 1fr; }
			.outbound-detail .timeline { flex-wrap:wrap; justify-content:flex-start; }
		}
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content outbound-detail">
		<!-- 헤더 / 액션 -->
		<div class="d-flex justify-content-between align-items-center mb-3">
			<div>
				<h1 class="card-title">출고 상세</h1>
				<div class="text-muted" style="font-size:0.95rem;">출고번호: <strong>OUT-20250812-007</strong></div>
			</div>
			<div class="page-actions">
				<button id="btnBack" class="btn btn-secondary btn-sm" title="뒤로가기">← 뒤로</button>
				<button id="btnPrint" class="btn btn-secondary btn-sm">인쇄</button>
				<button id="btnEdit" class="btn btn-primary btn-sm">편집</button>
				<button id="btnShip" class="btn btn-primary btn-sm">출고확정</button>
				<button id="btnCancel" class="btn btn-secondary btn-sm">출고취소</button>
			</div>
		</div>

		<!-- 기본정보 카드 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">기본 정보</div>
				<div class="text-muted">상태: <span class="badge badge-confirmed">확정</span></div>
			</div>

			<div class="kv-grid">
				<div class="kv-item">
					<div class="kv-label">출고번호</div>
					<div class="kv-value">OUT-20250812-007</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">출고일자</div>
					<div class="kv-value">2025-08-12</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">출고유형</div>
					<div class="kv-value">판매출고</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">창고</div>
					<div class="kv-value">중앙창고</div>
				</div>

				<div class="kv-item">
					<div class="kv-label">출고처(고객)</div>
					<div class="kv-value">카페문방구 / 9876543210</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">담당자</div>
					<div class="kv-value">이담당</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">주문번호</div>
					<div class="kv-value">SO-20250810-211</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">출고위치</div>
					<div class="kv-value">B-02-05</div>
				</div>

				<div class="kv-item">
					<div class="kv-label">총 품목 수</div>
					<div class="kv-value">3</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">총 수량</div>
					<div class="kv-value">420</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">총 금액</div>
					<div class="kv-value">₩ 1,040,000</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">비고</div>
					<div class="kv-value">빠른 출고 요청</div>
				</div>
			</div>
		</div>

		<!-- 타임라인 -->
		<div class="card mb-3">
			<div class="card-header">
				<div class="card-title">처리 이력 (타임라인)</div>
			</div>
			<div class="timeline p-2">
				<div class="timeline-step active">
					<div class="timeline-dot"></div>
					<div class="muted" style="font-size:.85rem;">요청</div>
					<div style="font-size:.85rem;">2025-08-11<br/><span class="muted">판매팀</span></div>
				</div>
				<div class="timeline-step">
					<div class="timeline-dot"></div>
					<div class="muted" style="font-size:.85rem;">피킹</div>
					<div style="font-size:.85rem;">2025-08-12<br/><span class="muted">물류팀</span></div>
				</div>
				<div class="timeline-step">
					<div class="timeline-dot"></div>
					<div class="muted" style="font-size:.85rem;">출고확정</div>
					<div style="font-size:.85rem;">2025-08-12 14:20</div>
				</div>
			</div>
		</div>

		<!-- 품목 목록 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">품목 내역</div>
				<div class="muted">총 3건</div>
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
							<th style="width:140px;" class="right">금액</th>
							<th style="width:140px;" class="right">재고후 수량</th>
							<th style="width:120px;">로트/유통기한</th>
							<th style="width:120px;">비고</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>1</td>
							<td>아라비카 원두 1kg / 로스팅 A</td>
							<td class="right">120</td>
							<td>KG</td>
							<td class="right">₩ 3,000</td>
							<td class="right">₩ 360,000</td>
							<td class="right">1,080</td>
							<td>LOT-20250701 / 2026-07-01</td>
							<td>-</td>
						</tr>
						<tr>
							<td>2</td>
							<td>시럽 1L / 바닐라</td>
							<td class="right">200</td>
							<td>EA</td>
							<td class="right">₩ 1,800</td>
							<td class="right">₩ 360,000</td>
							<td class="right">800</td>
							<td>LOT-20250520 / 2026-05-20</td>
							<td>포장주의</td>
						</tr>
						<tr>
							<td>3</td>
							<td>종이컵 250ml / 1000pcs</td>
							<td class="right">100</td>
							<td>BOX</td>
							<td class="right">₩ 3,200</td>
							<td class="right">₩ 320,000</td>
							<td class="right">450</td>
							<td>LOT-20250610 / 2026-06-10</td>
							<td>-</td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="5" class="right">합계</td>
							<td class="right">₩ 1,040,000</td>
							<td class="right">1, -</td>
							<td></td>
							<td></td>
						</tr>
					</tfoot>
				</table>
			</div>
		</div>

		<!-- 배송/운송 정보 -->
		<div class="card mb-3">
			<div class="card-header">
				<div class="card-title">배송 / 운송 정보</div>
			</div>

			<div class="shipping-grid p-2">
				<div>
					<div class="kv-label">운송업체</div>
					<div class="kv-value">한진택배</div>
				</div>
				<div>
					<div class="kv-label">운송장번호</div>
					<div class="kv-value">HJ20250812-998877</div>
				</div>
				<div>
					<div class="kv-label">출고완료일</div>
					<div class="kv-value">2025-08-12 14:30</div>
				</div>
			</div>
		</div>

		<!-- 첨부 / 메모 / 변경이력 -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="card-title">첨부 / 메모 / 변경이력</div>
			</div>

			<div class="row mb-3">
				<div class="col-md-6">
					<div class="muted">첨부파일</div>
					<div class="attachments">
						<div class="attachment-item">delivery_note_20250812.pdf</div>
						<div class="attachment-item">packing_photo.jpg</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="muted">메모</div>
					<div class="kv-value" style="min-height:80px;">긴급출고. 수취처 요청으로 우선 발송.</div>
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
							<td>2025-08-11 18:05</td>
							<td>판매팀</td>
							<td>출고요청 생성</td>
						</tr>
						<tr>
							<td>2025-08-12 13:50</td>
							<td>물류팀</td>
							<td>피킹 완료</td>
						</tr>
						<tr>
							<td>2025-08-12 14:30</td>
							<td>물류팀</td>
							<td>출고확정 / 운송장 등록</td>
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

		// 인쇄/편집/출고확정/취소 (모의 행동)
		document.getElementById("btnPrint").addEventListener("click", function(e){
			e.preventDefault(); window.print();
		});
		document.getElementById("btnEdit").addEventListener("click", function(e){
			e.preventDefault(); alert("편집 모드로 이동 (구현 필요)");
		});
		document.getElementById("btnShip").addEventListener("click", function(e){
			e.preventDefault(); alert("출고확정 처리 (모의)");
		});
		document.getElementById("btnCancel").addEventListener("click", function(e){
			e.preventDefault(); if(confirm("출고를 취소하시겠습니까?")) alert("출고취소(모의) 수행");
		});
	</script>
</body>
</html>
