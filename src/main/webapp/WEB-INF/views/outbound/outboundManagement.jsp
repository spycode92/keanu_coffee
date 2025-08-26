<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>출고 관리</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

	<style>
		/* 페이지 전용 최소 스타일 (공용 CSS 보완용) */
		.inbound-simple-search {
			display: flex;
			gap: 0.5rem;
			align-items: center;
		}
		.inbound-simple-search input {
			flex: 1;
		}

		/* 검색/필터 카드 overflow 방지 */
		.inbound-filters .row { margin-left: 0; margin-right: 0; }
		.inbound-filters .form-control, .inbound-filters .search-select { box-sizing: border-box; width:100%; }

		/* 테이블 중앙정렬 */
		.table th, .table td {
			text-align: center;
			vertical-align: middle;
		}

		/* KPI 그리드 (간단 조정) */
		.kpi-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; width:100%; }
		.kpi-row .kpi-card { padding: 1rem; min-height: 100px; display:flex; flex-direction:column; justify-content:space-between; }
		@media (max-width:1024px) { .kpi-row { grid-template-columns: repeat(2, 1fr); } }
		@media (max-width:600px) { .kpi-row { grid-template-columns: 1fr; } }
	</style>
</head>
<body>
	<!-- 상단/사이드 레이아웃 포함 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content">
		<!-- 페이지 제목 -->
		<div class="d-flex justify-content-between align-items-center mb-2">
			<h1 class="card-title" style="margin:0;">출고관리</h1>
		</div>

		<!-- 간단 검색바 (품목 코드/명) -->
		<div class="card mb-3 inbound-simple-search p-3">
			<input type="text" class="form-control" id="simpleItemKeyword" placeholder="품목 코드/명 검색" />
			<button class="btn btn-primary btn-sm" id="simpleSearchBtn">검색</button>
			<button class="btn btn-secondary btn-sm" id="toggleDetailSearchBtn">상세검색</button>
		</div>

		<!-- 상세검색 카드 (기본 숨김) -->
		<div class="card mb-4 inbound-filters" id="detailSearchCard" style="display:none;">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">검색 / 필터</div>
				<div class="d-flex gap-2">
					<a href="#" class="btn btn-secondary btn-sm">설정</a>
				</div>
			</div>

			<div class="row p-3">
				<div class="col-md-3">
					<label class="form-label">검색 기준</label>
					<select class="form-control search-select" id="dateBasis">
						<option value="start" selected>출고 시작일 기준</option>
						<option value="end">출고 완료일 기준</option>
						<option value="range">기간 기준</option>
					</select>
				</div>

				<div class="col-md-3 date-field date-start">
					<label class="form-label">출고 시작일</label>
					<input type="date" class="form-control search-input" id="outStartDate" />
				</div>

				<div class="col-md-3 date-field date-end" style="display:none;">
					<label class="form-label">출고 종료일(완료일)</label>
					<input type="date" class="form-control search-input" id="outEndDate" />
				</div>

				<div class="col-md-3 date-field date-range" style="display:none;">
					<label class="form-label">기간(시작)</label>
					<input type="date" class="form-control search-input" id="outRangeStart" />
				</div>
				<div class="col-md-3 date-field date-range" style="display:none;">
					<label class="form-label">기간(종료)</label>
					<input type="date" class="form-control search-input" id="outRangeEnd" />
				</div>

				<!-- 줄 바꿈 후 기타 필터 -->
				<div class="col-md-3 mt-3">
					<label class="form-label">창고</label>
					<select class="form-control search-select" id="warehouse">
						<option value="">전체</option>
						<option>중앙창고</option>
						<option>동부창고</option>
						<option>서부창고</option>
					</select>
				</div>
				<div class="col-md-3 mt-3">
					<label class="form-label">상태</label>
					<select class="form-control search-select" id="status">
						<option value="">전체</option>
						<option value="PENDING">대기</option>
						<option value="CONFIRMED">확정</option>
						<option value="DISPATCHED">출고중</option>
						<option value="COMPLETED">완료</option>
					</select>
				</div>
				<div class="col-md-3 mt-3">
					<label class="form-label">품목 코드/명</label>
					<input type="text" class="form-control search-input" placeholder="예) SKU-0001" id="itemKeyword" />
				</div>
				<div class="col-md-3 mt-3"></div>

				<div class="col-md-3 mt-3">
					<label class="form-label">출하 담당</label>
					<input type="text" class="form-control search-input" id="ownerKeyword" placeholder="담당자명" />
				</div>
				<div class="col-md-9 mt-3"></div>

				<div class="col-md-12 d-flex align-items-center gap-2 mt-3">
					<button class="btn btn-primary btn-search">검색</button>
					<button class="btn btn-secondary btn-reset">초기화</button>
				</div>
			</div>
		</div>

		<!-- 목록 카드 (상단에 새출고 / 엑셀 등 버튼 포함) -->
		<div class="card">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">출고 목록 <span class="text-muted" style="font-size:0.9em;">검색결과: 총 <strong>145</strong>건</span></div>
				<div class="d-flex gap-2">
					<a href="#" class="btn btn-primary btn-sm">새 출고 등록</a>
					<a href="#" class="btn btn-secondary btn-sm">엑셀 다운로드</a>
					<a href="#" class="btn btn-secondary btn-sm">설정</a>
					<a href="#" class="btn btn-secondary btn-sm">선택삭제</a>
				</div>
			</div>

			<div class="table-responsive">
				<table class="table">
					<thead>
						<tr>
							<th style="width:36px;"><input type="checkbox" class="select-all" /></th>
							<th>출고번호</th>
							<th>출고일자</th>
							<th>공급처</th>
							<th>창고</th>
							<th>상태</th>
							<th>품목수</th>
							<th>총수량</th>
							<th>출고예정일</th>
							<th>담당자</th>
							<th>비고</th>
						</tr>
					</thead>
					<tbody>
						<tr><td><input type="checkbox" /></td><td>OUT-20250811-001</td><td>2025-08-11</td><td>에이스상사</td><td>중앙창고</td><td><span class="badge badge-pending">대기</span></td><td>5</td><td>680</td><td>2025-08-13</td><td>김담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250811-002</td><td>2025-08-11</td><td>그린푸드</td><td>동부창고</td><td><span class="badge badge-dispatched">출고중</span></td><td>3</td><td>420</td><td>2025-08-12</td><td>이담당</td><td>긴급</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250810-015</td><td>2025-08-10</td><td>베스트유통</td><td>서부창고</td><td><span class="badge badge-completed">완료</span></td><td>6</td><td>900</td><td>2025-08-10</td><td>박담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250809-014</td><td>2025-08-09</td><td>프레시마켓</td><td>중앙창고</td><td><span class="badge badge-confirmed">확정</span></td><td>4</td><td>520</td><td>2025-08-11</td><td>최담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250808-013</td><td>2025-08-08</td><td>그린푸드</td><td>동부창고</td><td><span class="badge badge-pending">대기</span></td><td>8</td><td>1200</td><td>2025-08-14</td><td>김담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250808-012</td><td>2025-08-08</td><td>에이스상사</td><td>서부창고</td><td><span class="badge badge-confirmed">확정</span></td><td>2</td><td>180</td><td>2025-08-09</td><td>이담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250807-011</td><td>2025-08-07</td><td>베스트유통</td><td>중앙창고</td><td><span class="badge badge-pending">대기</span></td><td>7</td><td>980</td><td>2025-08-13</td><td>박담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250807-010</td><td>2025-08-07</td><td>프레시마켓</td><td>동부창고</td><td><span class="badge badge-dispatched">출고중</span></td><td>5</td><td>650</td><td>2025-08-12</td><td>최담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250806-009</td><td>2025-08-06</td><td>그린푸드</td><td>서부창고</td><td><span class="badge badge-confirmed">확정</span></td><td>3</td><td>360</td><td>2025-08-10</td><td>김담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250806-008</td><td>2025-08-06</td><td>에이스상사</td><td>중앙창고</td><td><span class="badge badge-pending">대기</span></td><td>6</td><td>900</td><td>2025-08-15</td><td>이담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250805-007</td><td>2025-08-05</td><td>프레시마켓</td><td>동부창고</td><td><span class="badge badge-completed">완료</span></td><td>9</td><td>1350</td><td>2025-08-05</td><td>박담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250805-006</td><td>2025-08-05</td><td>베스트유통</td><td>서부창고</td><td><span class="badge badge-confirmed">확정</span></td><td>4</td><td>480</td><td>2025-08-09</td><td>최담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250804-005</td><td>2025-08-04</td><td>에이스상사</td><td>중앙창고</td><td><span class="badge badge-pending">대기</span></td><td>2</td><td>220</td><td>2025-08-10</td><td>김담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250804-004</td><td>2025-08-04</td><td>그린푸드</td><td>동부창고</td><td><span class="badge badge-confirmed">확정</span></td><td>7</td><td>980</td><td>2025-08-11</td><td>이담당</td><td>-</td></tr>
						<tr><td><input type="checkbox" /></td><td>OUT-20250803-003</td><td>2025-08-03</td><td>베스트유통</td><td>서부창고</td><td><span class="badge badge-completed">완료</span></td><td>8</td><td>1120</td><td>2025-08-03</td><td>박담당</td><td>-</td></tr>
					</tbody>
				</table>
			</div>

			<div class="d-flex justify-content-between align-items-center p-3">
				<div class="text-muted">페이지 1 / 15</div>
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
		</div>

		<!-- 설정 모달 (공통) -->
		<div id="settings-modal" class="settings-modal" aria-hidden="true">
			<div class="settings-content">
				<div class="settings-header">
					<div class="card-title">페이지 설정</div>
					<button id="settings-close" class="settings-close" aria-label="닫기">&times;</button>
				</div>
				<div class="mb-3">
					<label class="form-label">기본 정렬</label>
					<select class="form-control">
						<option>출고일자 최신순</option>
						<option>출고번호 오름차순</option>
						<option>상태순</option>
					</select>
				</div>
				<div class="d-flex justify-content-between">
					<button id="settings-cancel" class="btn btn-secondary">취소</button>
					<button class="btn btn-primary">저장</button>
				</div>
			</div>
		</div>
	</section>

	<script>
		// 상단 버튼 이동 (관리자 페이지 링크)
		$("#adminPage").click(function(){ location.href="/admin/main"; });

		// 날짜 기준 토글 (start / end / range)
		document.addEventListener('change', function(e) {
			if (e.target && e.target.id === 'dateBasis') {
				const basis = e.target.value;
				document.querySelectorAll('.date-field').forEach(el => el.style.display = 'none');
				if (basis === 'start') {
					document.querySelectorAll('.date-start').forEach(el => el.style.display = '');
				} else if (basis === 'end') {
					document.querySelectorAll('.date-end').forEach(el => el.style.display = '');
				} else if (basis === 'range') {
					document.querySelectorAll('.date-range').forEach(el => el.style.display = '');
				}
			}
		});
		window.addEventListener('DOMContentLoaded', function() {
			const sel = document.getElementById('dateBasis');
			if (sel) sel.dispatchEvent(new Event('change'));
		});

		// 상세검색 토글
		document.getElementById('toggleDetailSearchBtn').addEventListener('click', function() {
			const detailCard = document.getElementById('detailSearchCard');
			if (detailCard.style.display === 'none' || detailCard.style.display === '') {
				detailCard.style.display = 'block';
				this.textContent = '상세검색 닫기';
			} else {
				detailCard.style.display = 'none';
				this.textContent = '상세검색';
			}
		});

		// 간단 검색 버튼
		document.getElementById('simpleSearchBtn').addEventListener('click', function() {
			const keyword = document.getElementById('simpleItemKeyword').value.trim();
			if (!keyword) {
				alert('품목 코드/명을 입력하세요.');
				return;
			}
			// TODO: 실제 검색 로직(AJAX)을 이곳에 연결
			console.log('간단검색 키워드:', keyword);
		});
	</script>
</body>
</html>
