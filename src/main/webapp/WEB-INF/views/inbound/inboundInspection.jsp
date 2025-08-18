<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>입고검수</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

	<style>
		/* ===== inbound inspection 전용 오버라이드 (공통 유지) ===== */
		.inbound-inspect { font-variant-numeric: tabular-nums; }

		.inbound-inspect .card { padding: 1rem; }
		.inbound-inspect .card-header { margin-bottom: .75rem; padding-bottom: .5rem; }
		.inbound-inspect .card-title { margin: 0; }

		/* 입력/선택/버튼 높이 통일 (공통과 동일한 느낌) */
		.inbound-inspect .form-control { height: 36px; line-height: 34px; padding: 0 10px; box-sizing: border-box; }
		.inbound-inspect select.form-control { padding-right: 28px; }
		.inbound-inspect .btn.btn-sm { min-width: 90px; height: 36px; line-height: 34px; padding: 0 12px; }
		.inbound-inspect .inline { display:flex; gap:.5rem; align-items:center; }
		.inbound-inspect .inline .form-control { flex:1 1 auto; }

		/* 기본 정보 kv-grid */
		.inbound-inspect .kv-grid {
			display: grid;
			grid-template-columns: repeat(4, minmax(160px, 1fr));
			gap: .5rem 1rem;
			align-items: center;
		}
		.inbound-inspect .kv-item { min-width: 0; }
		.inbound-inspect .kv-label { font-size:.9rem; color:var(--muted-foreground); margin-bottom:.25rem; }
		.inbound-inspect .kv-value { padding:.45rem .6rem; background:var(--input-background); border:1px solid var(--border); border-radius:var(--radius); }

		/* 검수 테이블 안정화 */
		.inbound-inspect #inspectTable { table-layout: fixed; width:100%; border-collapse:collapse; }
		.inbound-inspect .table th, .inbound-inspect .table td { padding: .5rem .6rem; vertical-align: middle; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }
		.inbound-inspect .table thead th { background: var(--accent); color: var(--foreground); position: sticky; top:0; z-index:1; }

		/* 컬럼 너비 조정: 2열(품목명/규격) 줄이고, 7열(첨부) 키움 */
		.inbound-inspect #inspectTable th:nth-child(2),
		.inbound-inspect #inspectTable td:nth-child(2) {
			width: 300px; /* 예: 기존보다 좁게 */
		}
		.inbound-inspect #inspectTable th:nth-child(7),
		.inbound-inspect #inspectTable td:nth-child(7) {
			width: 260px; /* 첨부 칸을 충분히 넓힘 */
		}

		/* 파일 입력 영역 스타일 */
		.inbound-inspect .file-wrap {
			display:flex;
			gap:.5rem;
			align-items:center;
			min-width:0;
		}
		.inbound-inspect .file-wrap input[type="file"] {
			flex:1 1 auto;
			min-width:0;
			cursor: pointer;
		}
		.inbound-inspect .file-wrap .file-filename {
			flex:1 1 auto;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
			font-size:.88rem;
			color:var(--muted-foreground);
			padding: .25rem .5rem;
		}
		.inbound-inspect .file-btn {
			padding:.35rem .6rem;
			border-radius:.375rem;
			border:1px solid var(--border);
			background: var(--card);
			cursor: pointer;
			font-size: .9rem;
		}

		/* 썸네일 크기 증가 (가시성 향상) */
		.inbound-inspect .thumb { width:72px; height:72px; object-fit:cover; border-radius:4px; border:1px solid var(--border); }

		/* 검수 상태/버튼 컬러 보정(공통 팔레트 의존) */
		.inbound-inspect .badge-pass { background:#dcfce7; color:#166534; padding:.25rem .5rem; border-radius:.25rem; }
		.inbound-inspect .badge-fail { background:#fecaca; color:#991b1b; padding:.25rem .5rem; border-radius:.25rem; }
		.inbound-inspect .badge-hold { background:#fef3c7; color:#92400e; padding:.25rem .5rem; border-radius:.25rem; }

		/* 요약 카드 */
		.inbound-inspect .summary { display:flex; gap:1rem; align-items:center; }
		.inbound-inspect .summary .item { padding:.6rem .8rem; background:var(--card); border:1px solid var(--border); border-radius:var(--radius); min-width:120px; text-align:center; }

		/* 반응형 */
		@media (max-width: 980px) {
			.inbound-inspect .kv-grid { grid-template-columns: 1fr 1fr; }
			.inbound-inspect .summary { flex-direction:column; align-items:stretch; }
			/* 모바일에서는 첨부 칸을 줄임 (스크롤 가능) */
			.inbound-inspect #inspectTable th:nth-child(7),
			.inbound-inspect #inspectTable td:nth-child(7) {
				width: 160px;
			}
			.inbound-inspect #inspectTable th:nth-child(2),
			.inbound-inspect #inspectTable td:nth-child(2) {
				width: auto;
			}
			.inbound-inspect .file-wrap { flex-direction: column; align-items:stretch; gap:.25rem; }
			.inbound-inspect .thumb { width:56px; height:56px; }
		}
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content inbound-inspect">
		<!-- 헤더 / 액션 -->
		<div class="d-flex justify-content-between align-items-center mb-3">
			<div>
				<h1 class="card-title">입고검수</h1>
				<div class="text-muted" style="font-size:0.95rem;">입고번호: <strong>IN-20250811-001</strong></div>
			</div>
			<div class="d-flex gap-2">
				<button id="btnBack" class="btn btn-secondary btn-sm" title="뒤로가기">← 뒤로</button>
				<button id="btnSave" class="btn btn-secondary btn-sm">임시저장</button>
				<button id="btnNotifyVendor" class="btn btn-secondary btn-sm">불량통보</button>
				<button id="btnFinalize" class="btn btn-primary btn-sm">검수완료(확정)</button>
			</div>
		</div>

		<!-- 기본 정보 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">기본 정보</div>
				<div class="muted">상태: <span class="badge badge-pending">검수중</span></div>
			</div>

			<div class="kv-grid p-3">
				<div class="kv-item">
					<div class="kv-label">입고번호</div>
					<div class="kv-value">IN-20250811-001</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">입고일자</div>
					<div class="kv-value">2025-08-11</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">공급업체</div>
					<div class="kv-value">에이스상사 (123-45-67890)</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">창고 / 위치</div>
					<div class="kv-value">중앙창고 / A-01-03</div>
				</div>

				<div class="kv-item">
					<div class="kv-label">담당자</div>
					<div class="kv-value">김담당</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">검수 시작</div>
					<div class="kv-value">2025-08-11 10:12</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">문서번호</div>
					<div class="kv-value">RQ-20250811-0001</div>
				</div>
				<div class="kv-item">
					<div class="kv-label">비고</div>
					<div class="kv-value">부분입고 — 물류팀 확인 필요</div>
				</div>
			</div>
		</div>

		<!-- 요약 -->
		<div class="card mb-3">
			<div class="card-header">
				<div class="card-title">검수 요약</div>
			</div>

			<div class="p-3 summary">
				<div class="item">
					<div class="muted">지시 총수량</div>
					<div id="sumPlanned" style="font-weight:600; margin-top:.25rem;">540</div>
				</div>
				<div class="item">
					<div class="muted">검수 총수량</div>
					<div id="sumInspected" style="font-weight:600; margin-top:.25rem;">540</div>
				</div>
				<div class="item">
					<div class="muted">총 불량수량</div>
					<div id="sumDefect" style="font-weight:600; margin-top:.25rem;">10</div>
				</div>
				<div class="item">
					<div class="muted">합격 항목 수</div>
					<div id="countPass" style="font-weight:600; margin-top:.25rem;">3</div>
				</div>
			</div>
		</div>

		<!-- 검수 항목 테이블 -->
		<div class="card mb-3">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">검수 항목</div>
				<div class="muted">총 <span id="itemCount">4</span>건</div>
			</div>

			<div class="table-responsive">
				<table id="inspectTable" class="table" aria-label="검수 항목">
					<thead>
						<tr>
							<th style="width:40px;">No</th>
							<th>품목명 / 규격</th>
							<th style="width:110px;">지시수량</th>
							<th style="width:110px;">검수수량</th>
							<th style="width:110px;">불량수량</th>
							<th style="width:140px;">판정</th>
							<th style="width:260px;">첨부(사진)</th>
							<th style="width:160px;">비고</th>
						</tr>
					</thead>
					<tbody>
						<tr data-planned="200">
							<td>1</td>
							<td>아라비카 원두 1kg / 로스팅A</td>
							<td class="right">200</td>
							<td><input class="form-control inp-inspected" type="number" min="0" value="200" /></td>
							<td><input class="form-control inp-defect" type="number" min="0" value="0" /></td>
							<td>
								<select class="form-control inp-judge">
									<option value="PASS" selected>합격</option>
									<option value="FAIL">불합격</option>
									<option value="HOLD">보류</option>
								</select>
							</td>
							<td>
								<div class="file-wrap">
									<img src="${pageContext.request.contextPath}/resources/img/thumb-placeholder.png" alt="thumb" class="thumb" />
									<input class="" type="file" accept="image/*" />
								</div>
							</td>
							<td><input class="form-control inp-note" type="text" placeholder="메모" /></td>
						</tr>

						<tr data-planned="200">
							<td>2</td>
							<td>시럽 1L / 바닐라</td>
							<td class="right">200</td>
							<td><input class="form-control inp-inspected" type="number" min="0" value="190" /></td>
							<td><input class="form-control inp-defect" type="number" min="0" value="10" /></td>
							<td>
								<select class="form-control inp-judge">
									<option value="PASS">합격</option>
									<option value="FAIL" selected>불합격</option>
									<option value="HOLD">보류</option>
								</select>
							</td>
							<td>
								<div class="file-wrap">
									<img src="${pageContext.request.contextPath}/resources/img/syrup-damage.jpg" alt="thumb" class="thumb" />
									<input class="" type="file" accept="image/*" />
								</div>
							</td>
							<td><input class="form-control inp-note" type="text" placeholder="불량사유" /></td>
						</tr>

						<tr data-planned="100">
							<td>3</td>
							<td>종이컵 250ml / 1000pcs</td>
							<td class="right">100</td>
							<td><input class="form-control inp-inspected" type="number" min="0" value="100" /></td>
							<td><input class="form-control inp-defect" type="number" min="0" value="0" /></td>
							<td>
								<select class="form-control inp-judge">
									<option value="PASS" selected>합격</option>
									<option value="FAIL">불합격</option>
									<option value="HOLD">보류</option>
								</select>
							</td>
							<td>
								<div class="file-wrap">
									<img src="${pageContext.request.contextPath}/resources/img/thumb-placeholder.png" alt="thumb" class="thumb" />
									<input class="" type="file" accept="image/*" />
								</div>
							</td>
							<td><input class="form-control inp-note" type="text" placeholder="메모" /></td>
						</tr>

						<tr data-planned="40">
							<td>4</td>
							<td>부자재(포장재) / 규격X</td>
							<td class="right">40</td>
							<td><input class="form-control inp-inspected" type="number" min="0" value="50" /></td>
							<td><input class="form-control inp-defect" type="number" min="0" value="0" /></td>
							<td>
								<select class="form-control inp-judge">
									<option value="PASS" selected>합격</option>
									<option value="FAIL">불합격</option>
									<option value="HOLD">보류</option>
								</select>
							</td>
							<td>
								<div class="file-wrap">
									<img src="${pageContext.request.contextPath}/resources/img/thumb-placeholder.png" alt="thumb" class="thumb" />
									<input class="" type="file" accept="image/*" />
								</div>
							</td>
							<td><input class="form-control inp-note" type="text" placeholder="메모" /></td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="2" class="right">합계</td>
							<td id="tfoot-planned" class="right">540</td>
							<td id="tfoot-inspected" class="right">540</td>
							<td id="tfoot-defect" class="right">10</td>
							<td colspan="3"></td>
						</tr>
					</tfoot>
				</table>
			</div>

			<div class="d-flex justify-content-between align-items-center p-3">
				<div class="muted"></div>
				<div class="d-flex gap-2">
					<button id="btnScan" class="btn btn-secondary btn-sm">바코드 스캔(모의)</button>
					<button id="btnRejectNotify2" class="btn btn-secondary btn-sm">불량통보(모의)</button>
					<button id="btnFinalize2" class="btn btn-primary btn-sm">검수완료(모의)</button>
				</div>
			</div>
		</div>

		<!-- 변화 로그 / 메모 -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="card-title">메모 / 변경이력</div>
			</div>

			<div class="row mb-3">
				<div class="col-md-6">
					<label class="form-label">검수메모</label>
					<textarea id="inspectMemo" class="form-control" rows="4" placeholder="검수 소견을 입력하세요."></textarea>
				</div>
				<div class="col-md-6">
					<label class="form-label">첨부파일</label>
					<div class="inline">
						<input id="inspectFiles" type="file" class="form-control" multiple accept="image/*" />
						<button id="btnUploadInspect" class="btn btn-secondary btn-sm">업로드(모의)</button>
					</div>
					<div id="inspectFileList" class="muted mt-2">첨부된 파일 없음</div>
				</div>
			</div>
			<br>
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
							<td>검수 시작 — 일부 불량 확인</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</section>

	<script>
		// 유틸
		const parseNum = v => { const n = Number(String(v).replace(/[^0-9.-]+/g,"")); return isNaN(n)?0:n; };
		const fmtKRW = n => Number(n||0).toLocaleString("ko-KR");

		// 요약 재계산
		function recalcSummary(){
			let planned = 0, inspected = 0, defect = 0, passCount = 0;
			const rows = document.querySelectorAll("#inspectTable tbody tr");
			rows.forEach(tr => {
				const p = parseNum(tr.getAttribute("data-planned")||0);
				const ins = parseNum(tr.querySelector(".inp-inspected").value||0);
				const def = parseNum(tr.querySelector(".inp-defect").value||0);
				const judge = tr.querySelector(".inp-judge").value;
				planned += p;
				inspected += ins;
				defect += def;
				if(judge === "PASS") passCount++;
			});
			document.getElementById("sumPlanned").textContent = fmtKRW(planned);
			document.getElementById("sumInspected").textContent = fmtKRW(inspected);
			document.getElementById("sumDefect").textContent = fmtKRW(defect);
			document.getElementById("countPass").textContent = passCount;
			document.getElementById("tfoot-planned").textContent = fmtKRW(planned);
			document.getElementById("tfoot-inspected").textContent = fmtKRW(inspected);
			document.getElementById("tfoot-defect").textContent = fmtKRW(defect);
			document.getElementById("itemCount").textContent = rows.length;
		}

		// 초기: 이벤트 바인딩
		document.addEventListener("DOMContentLoaded", () => {
			document.querySelectorAll(".inp-inspected, .inp-defect, .inp-judge").forEach(el => {
				el.addEventListener("input", recalcSummary);
				el.addEventListener("change", recalcSummary);
			});
			// 파일 업로드(모의)
			document.getElementById("btnUploadInspect").addEventListener("click", (e)=>{
				e.preventDefault();
				const files = document.getElementById("inspectFiles").files;
				if(!files || files.length === 0){ alert("선택된 파일이 없습니다."); return; }
				const names = [...files].map(f => f.name).join(", ");
				document.getElementById("inspectFileList").textContent = "첨부됨: " + names + " (모의)";
				alert("파일 업로드(모의) 완료");
			});

			// 바코드 스캔(모의)
			document.getElementById("btnScan").addEventListener("click", function(e){
				e.preventDefault();
				alert("바코드 스캔(모의): 스캔 입력기와 연결되면 자동으로 해당 행으로 포커스/체크됩니다.");
			});
			// 불량통보 / 검수완료 버튼
			["btnNotifyVendor","btnNotifyVendor2","btnRejectNotify","btnRejectNotify2"].forEach(id=>{
				const el = document.getElementById(id);
				if(el) el.addEventListener("click", (e)=>{ e.preventDefault(); alert("불량통보(모의): 공급사에 통보합니다."); });
			});
			document.getElementById("btnFinalize").addEventListener("click", (e)=>{ e.preventDefault(); alert("검수완료(모의) — 상태 변경 예정"); });
			document.getElementById("btnFinalize2").addEventListener("click", (e)=>{ e.preventDefault(); alert("검수완료(모의) — 상태 변경 예정"); });

			// 임시저장 / 뒤로가기
			document.getElementById("btnSave").addEventListener("click", (e)=>{ e.preventDefault(); alert("임시저장(모의) — 데이터는 클라이언트 콘솔에만 출력됩니다."); console.log("임시저장 payload (모의)", gatherPayload()); });
			document.getElementById("btnBack").addEventListener("click", (e)=>{ e.preventDefault(); history.back(); });

			// 행 내 파일 선택 시 thumbnail 미리보기(모의)
			document.querySelectorAll('#inspectTable input[type="file"]').forEach(inp=>{
				inp.addEventListener("change", function(){
					const file = this.files && this.files[0];
					if(!file) return;
					const img = this.closest('td').querySelector('img.thumb');
					if(img){
						const reader = new FileReader();
						reader.onload = function(ev){ img.src = ev.target.result; };
						reader.readAsDataURL(file);
					}
				});
			});

			// 초기 요약 계산
			recalcSummary();
		});

		// 페이로드 수집(모의)
		function gatherPayload(){
			const items = [...document.querySelectorAll("#inspectTable tbody tr")].map(tr => ({
				name: tr.children[1].textContent.trim(),
				planned: parseNum(tr.getAttribute("data-planned")||0),
				inspected: parseNum(tr.querySelector(".inp-inspected").value||0),
				defect: parseNum(tr.querySelector(".inp-defect").value||0),
				judge: tr.querySelector(".inp-judge").value,
				note: tr.querySelector(".inp-note").value.trim()
			}));
			return {
				inboundNo: "IN-20250811-001",
				inspector: "김담당",
				startAt: "2025-08-11T10:12:00",
				memo: document.getElementById("inspectMemo").value,
				items
			};
		}
	</script>
</body>
</html>
