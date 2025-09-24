<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>입고요청 등록</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

	<style>
		/* ====== inbound-page 전용 오버라이드 (공통 CSS 유지) ====== */
		.inbound-page { font-variant-numeric: tabular-nums; }
		.inbound-page .card { padding: 1rem; }
		.inbound-page .card-header { margin-bottom: .75rem; padding-bottom: .5rem; }
		.inbound-page .card-title { margin: 0; }

		/* 통일된 입력/선택/버튼 높이 */
		.inbound-page .form-control { height: 36px; line-height: 34px; padding: 0 10px; box-sizing: border-box; }
		.inbound-page select.form-control { padding-right: 28px; }
		.inbound-page .btn.btn-sm { height: 36px; line-height: 34px; padding: 0 12px; }
		.inbound-page .inline { display:flex; gap:.5rem; align-items:center; width:100%; }
		.inbound-page .inline .form-control { flex:1 1 auto; }
		.inbound-page .inline .btn { flex: 0 0 auto; }

		/* 폼 레이아웃: 2열 그리드 */
		.inbound-page .form-grid {
			display: grid;
			grid-template-columns: repeat(2, minmax(300px, 1fr));
			gap: .75rem 1rem;
			align-items: start;
		}
		.inbound-page .form-item { min-width: 0; }
		.inbound-page .form-item-span2 { grid-column: 1 / -1; }

		/* 테이블 안정화 */
		.inbound-page #itemsTable { table-layout: fixed; width:100%; }
		.inbound-page .table th, .inbound-page .table td { padding: .5rem .6rem; vertical-align: middle; overflow: hidden; }
		.inbound-page .cell-name-spec { display:flex; gap:.5rem; align-items:center; }
		.inbound-page .cell-name-spec > * { min-width: 0; flex:1; }

		/* 숫자열 우측정렬 */
		.inbound-page .right { text-align: right; }

		/* 합계 강조 */
		.inbound-page tfoot td { font-weight: var(--font-weight-medium); }

		/* 반응형 */
		@media (max-width: 980px) {
			.inbound-page .form-grid { grid-template-columns: 1fr; }
		}
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content inbound-page">
		<!-- 헤더 -->
		<div class="d-flex justify-content-between align-items-center mb-3">
			<h1 class="card-title">입고요청 등록</h1>
			<div class="d-flex gap-2">
				<a href="#" id="btnSaveDraft" class="btn btn-secondary btn-sm">임시저장</a>
				<a href="#" id="btnSubmitInbound" class="btn btn-primary btn-sm">요청 제출</a>
			</div>
		</div>

		<!-- 기본정보 카드 -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="card-title">입고 기본정보</div>
			</div>

			<div class="form-grid">
				<div class="form-item">
					<label class="form-label">입고구분</label>
					<select id="inboundType" class="form-control">
						<option value="PURCHASE" selected>구매입고</option>
						<option value="RETURN">반품입고</option>
						<option value="TRANSFER">이동입고</option>
					</select>
				</div>

				<div class="form-item">
					<label class="form-label">창고</label>
					<select id="warehouse" class="form-control">
						<option value="MAIN">중앙창고</option>
						<option value="EAST">동부창고</option>
						<option value="WEST">서부창고</option>
					</select>
				</div>

				<div class="form-item">
					<label class="form-label">도착예정일</label>
					<input id="etaDate" type="date" class="form-control" />
				</div>

				<div class="form-item">
					<label class="form-label">담당자</label>
					<input id="owner" type="text" class="form-control" placeholder="담당자명" />
				</div>

				<div class="form-item">
					<label class="form-label">발주번호(PO)</label>
					<input id="poNo" type="text" class="form-control" placeholder="예: PO-2025-0001" />
				</div>

				<div class="form-item">
					<label class="form-label">공급업체</label>
					<div class="inline">
						<input id="vendorKeyword" type="text" class="form-control" placeholder="업체명/사업자번호 입력" />
						<button id="btnVendorLookup" class="btn btn-primary btn-sm">조회</button>
					</div>
				</div>

				<!-- 업체 표시 (span2) -->
				<div class="form-item form-item-span2">
					<div class="d-flex gap-3">
						<div>
							<div class="muted">업체명</div>
							<div id="vendorName">-</div>
						</div>
						<div>
							<div class="muted">사업자번호</div>
							<div id="vendorBizNo">-</div>
						</div>
						<div>
							<div class="muted">연락처</div>
							<div id="vendorPhone">-</div>
						</div>
					</div>
				</div>
			</div><!-- /.form-grid -->
		</div>

		<!-- 품목 목록 카드 -->
		<div class="card mb-4">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">품목 목록</div>
				<div class="d-flex gap-2">
					<button id="btnAddItem" class="btn btn-primary btn-sm">행 추가</button>
					<button id="btnRemoveItem" class="btn btn-secondary btn-sm">행 삭제</button>
				</div>
			</div>

			<div class="table-responsive">
				<table id="itemsTable" class="table">
					<thead>
						<tr>
							<th class="col-no">No</th>
							<th>품목명</th>
							<th class="col-qty">수량</th>
							<th class="col-unit">단위</th>
							<th class="col-price">단가</th>
							<th class="col-amount right">금액</th>
							<th>비고</th>
						</tr>
					</thead>
					<tbody>
						<!-- JS가 1행 삽입 -->
					</tbody>
					<tfoot>
						<tr>
							<td colspan="2" class="right">합계</td>
							<td id="totalQty" class="right">0</td>
							<td></td>
							<td></td>
							<td id="totalAmount" class="right">0</td>
							<td></td>
						</tr>
					</tfoot>
				</table>
			</div>

			<div class="mt-2 muted">수량/단가 입력 시 금액(수량×단가)와 합계가 자동 계산됩니다.</div>
		</div>

		<!-- 첨부/메모 -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="card-title">첨부 / 메모</div>
			</div>

			<div class="row">
				<div class="col-md-6">
					<label class="form-label">메모</label>
					<textarea id="inboundMemo" class="form-control" rows="4" placeholder="검수/포장/요청사항"></textarea>
				</div>
				<div class="col-md-6">
					<label class="form-label">첨부</label>
					<div class="inline">
						<input id="inboundFiles" type="file" class="form-control" multiple />
						<button id="btnFakeFile" class="btn btn-secondary btn-sm">업로드(모의)</button>
					</div>
					<div id="fileList" class="muted mt-2">첨부된 파일 없음</div>
				</div>
			</div>
		</div>
	</section>

	<script>
		/* ===== 모의 업체 DB ===== */
		const VENDORS = {
			"ACE123": { name: "에이스상사", biz: "1234567890", phone: "02-111-2222" },
			"GREEN01": { name: "그린푸드", biz: "1112223334", phone: "031-333-4444" }
		};

		/* 유틸 */
		const fmtKRW = n => Number(n||0).toLocaleString("ko-KR");
		const parseNum = v => { const n = Number(String(v).replace(/[^0-9.-]+/g,"")); return isNaN(n)?0:n; };

		/* 초기화 */
		document.addEventListener("DOMContentLoaded", () => {
			addItemRow();

			document.getElementById("btnVendorLookup").addEventListener("click", vendorLookup);
			document.getElementById("btnAddItem").addEventListener("click", (e)=>{ e.preventDefault(); addItemRow(); });
			document.getElementById("btnRemoveItem").addEventListener("click", (e)=>{ e.preventDefault(); removeLastItem(); });
			document.getElementById("btnFakeFile").addEventListener("click", fakeFileUpload);
			document.getElementById("btnSaveDraft").addEventListener("click", (e)=>{ e.preventDefault(); console.log('[임시저장]', gatherPayload()); alert('임시저장(모의)'); });
			document.getElementById("btnSubmitInbound").addEventListener("click", onSubmitInbound);
		});

		/* 업체 조회(모의): 키워드로 간단 탐색 */
		function vendorLookup(e){
			e.preventDefault();
			const kw = document.getElementById("vendorKeyword").value.trim();
			if(!kw){ alert("업체명 또는 코드로 검색하세요."); return; }
			// 간단 매칭(키 포함)
			const found = Object.values(VENDORS).find(v => v.name.includes(kw) || v.biz.includes(kw));
			if(found){
				document.getElementById("vendorName").textContent = found.name;
				document.getElementById("vendorBizNo").textContent = found.biz;
				document.getElementById("vendorPhone").textContent = found.phone;
			}else{
				alert("업체를 찾지 못했습니다. (모의)");
			}
		}

		/* 품목 행 관리 */
		function tbody(){ return document.querySelector("#itemsTable tbody"); }

		function addItemRow(){
			const idx = tbody().children.length + 1;
			const tr = document.createElement("tr");
			tr.innerHTML =
				"\t<td class=\"col-no\">" + idx + "</td>\n" +
				"\t<td><input type=\"text\" class=\"form-control item-name\" placeholder=\"품목명\" /></td>\n" +
				"\t<td><input type=\"number\" min=\"0\" step=\"1\" class=\"form-control item-qty\" value=\"1\" /></td>\n" +
				"\t<td>\n" +
				"\t\t<select class=\"form-control item-unit\">\n" +
				"\t\t\t<option>EA</option>\n" +
				"\t\t\t<option>BOX</option>\n" +
				"\t\t\t<option>KG</option>\n" +
				"\t\t</select>\n" +
				"\t</td>\n" +
				"\t<td><input type=\"text\" class=\"form-control item-price\" value=\"0\" /></td>\n" +
				"\t<td class=\"right cell-amount\">0</td>\n" +
				"\t<td><input type=\"text\" class=\"form-control item-note\" placeholder=\"비고\" /></td>\n";
			tbody().appendChild(tr);

			tr.querySelector(".item-qty").addEventListener("input", recalcItems);
			tr.querySelector(".item-price").addEventListener("input", (e)=>{ e.target.value = formatNumInput(e.target.value); recalcItems(); });

			recalcItems();
		}

		function removeLastItem(){
			if(tbody().children.length <= 1){ alert("최소 1행은 필요합니다."); return; }
			tbody().removeChild(tbody().lastElementChild);
			[...tbody().children].forEach((tr,i)=> tr.children[0].textContent = i+1);
			recalcItems();
		}

		function formatNumInput(v){
			const n = String(v).replace(/[^0-9.-]+/g,"");
			if(n==="") return "";
			return Number(n).toLocaleString("ko-KR");
		}

		function recalcItems(){
			let totalQty = 0;
			let totalAmount = 0;
			[...tbody().children].forEach(tr=>{
				const qty = parseNum(tr.querySelector(".item-qty").value);
				const price = parseNum(tr.querySelector(".item-price").value);
				const amt = Math.round(qty * price);
				tr.querySelector(".cell-amount").textContent = fmtKRW(amt);
				totalQty += qty;
				totalAmount += amt;
			});
			document.getElementById("totalQty").textContent = fmtKRW(totalQty);
			document.getElementById("totalAmount").textContent = fmtKRW(totalAmount);
		}

		/* 첨부(모의) */
		function fakeFileUpload(e){
			e.preventDefault();
			const files = document.getElementById("inboundFiles").files;
			if(!files || files.length===0){ alert("파일을 선택하세요."); return; }
			const names = [...files].map(f=>f.name).join(", ");
			document.getElementById("fileList").textContent = "첨부됨: " + names + " (모의)";
			alert("첨부(모의) 완료");
		}

		/* 페이로드 수집 & 제출(모의) */
		function gatherPayload(){
			const items = [...tbody().children].map(tr => ({
				name: tr.querySelector(".item-name").value.trim(),
				qty: parseNum(tr.querySelector(".item-qty").value),
				unit: tr.querySelector(".item-unit").value,
				price: parseNum(tr.querySelector(".item-price").value),
				amount: parseNum(tr.querySelector(".cell-amount").textContent),
				note: tr.querySelector(".item-note").value.trim()
			}));
			return {
				inboundType: document.getElementById("inboundType").value,
				warehouse: document.getElementById("warehouse").value,
				etaDate: document.getElementById("etaDate").value,
				owner: document.getElementById("owner").value,
				poNo: document.getElementById("poNo").value,
				vendor: {
					name: document.getElementById("vendorName").textContent,
					bizNo: document.getElementById("vendorBizNo").textContent,
					phone: document.getElementById("vendorPhone").textContent
				},
				files: "첨부(모의)",
				memo: document.getElementById("inboundMemo").value,
				items,
				summary: {
					totalQty: parseNum(document.getElementById("totalQty").textContent),
					totalAmount: parseNum(document.getElementById("totalAmount").textContent)
				}
			};
		}

		function onSubmitInbound(e){
			e.preventDefault();
			// 간단 검증
			if([...tbody().children].some(tr => !tr.querySelector(".item-name").value.trim())){ alert("품목명을 모두 입력하세요."); return; }
			const payload = gatherPayload();
			console.log("[입고요청 제출] payload:", payload);
			alert("입고요청이 제출되었습니다. (모의)");
		}
	</script>
</body>
</html>
