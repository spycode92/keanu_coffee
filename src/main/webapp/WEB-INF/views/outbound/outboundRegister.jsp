<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>출고요청 등록</title>
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet" />
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

	<style>
		/* ===== outbound-request 전용 오버라이드 (공통 CSS 유지) ===== */
		.outbound-page { font-variant-numeric: tabular-nums; }
		.outbound-page .card { padding: 1rem; }
		.outbound-page .card-header { margin-bottom: .75rem; padding-bottom: .5rem; }
		.outbound-page .card-title { margin: 0; }

		/* 입력/셀렉트/버튼 높이 통일 */
		.outbound-page .form-control { height: 36px; line-height: 34px; padding: 0 10px; box-sizing: border-box; }
		.outbound-page select.form-control { padding-right: 28px; }
		.outbound-page .btn.btn-sm { height: 36px; line-height: 34px; padding: 0 12px; }
		.outbound-page .inline { display:flex; gap:.5rem; align-items:center; width:100%; }
		.outbound-page .inline .form-control { flex:1 1 auto; }
		.outbound-page .inline .btn { flex: 0 0 auto; }

		/* 폼 레이아웃: 2열 그리드 */
		.outbound-page .form-grid {
			display: grid;
			grid-template-columns: repeat(2, minmax(300px, 1fr));
			gap: .75rem 1rem;
			align-items: start;
		}
		.outbound-page .form-item { min-width: 0; }
		.outbound-page .form-item-span2 { grid-column: 1 / -1; }

		/* 테이블 안정화 */
		.outbound-page #itemsTable { table-layout: fixed; width:100%; }
		.outbound-page .table th, .outbound-page .table td { padding: .5rem .6rem; vertical-align: middle; overflow: hidden; }
		.outbound-page .cell-name-dest { display:grid; grid-template-columns: 1fr 1fr; gap:.5rem; align-items:center; }
		.outbound-page .cell-name-dest > * { min-width: 0; }

		/* 우측 정렬 */
		.outbound-page .right { text-align: right; }

		/* 합계 강조 */
		.outbound-page tfoot td { font-weight: var(--font-weight-medium); }

		/* attachments */
		.outbound-page .attachments { display:flex; flex-direction:column; gap:.4rem; }
		.outbound-page .attachment-item { padding:.5rem; background:var(--card); border:1px solid var(--border); border-radius:.375rem; }

		/* 반응형 */
		@media (max-width: 980px) {
			.outbound-page .form-grid { grid-template-columns: 1fr; }
			.outbound-page .cell-name-dest { grid-template-columns: 1fr; }
		}
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content outbound-page">
		<!-- 상단 헤더 -->
		<div class="d-flex justify-content-between align-items-center mb-3">
			<h1 class="card-title">출고요청 등록</h1>
			<div class="d-flex gap-2">
				<a href="#" id="btnSaveDraft" class="btn btn-secondary btn-sm">임시저장</a>
				<a href="#" id="btnSubmit" class="btn btn-primary btn-sm">요청 제출</a>
			</div>
		</div>

		<!-- 1) 출고 기본정보 -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="card-title">출고 기본정보</div>
			</div>

			<div class="form-grid">
				<div class="form-item">
					<label class="form-label">출고구분</label>
					<select id="outboundType" class="form-control">
						<option value="SALES" selected>판매출고</option>
						<option value="TRANSFER">이동출고</option>
						<option value="ADJUST">조정출고</option>
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
					<label class="form-label">요청출고일</label>
					<input id="reqDate" type="date" class="form-control" />
				</div>

				<div class="form-item">
					<label class="form-label">담당자</label>
					<input id="owner" type="text" class="form-control" placeholder="담당자명" />
				</div>

				<div class="form-item">
					<label class="form-label">주문번호/내부참조</label>
					<input id="orderNo" type="text" class="form-control" placeholder="예: SO-2025-0001" />
				</div>

				<div class="form-item">
					<label class="form-label">출고처(고객)</label>
					<div class="inline">
						<input id="custKeyword" type="text" class="form-control" placeholder="고객명/사업자번호/코드 입력" />
						<button id="btnCustLookup" class="btn btn-primary btn-sm">조회</button>
					</div>
				</div>

				<div class="form-item form-item-span2">
					<div class="d-flex gap-3">
						<div>
							<div class="muted">출고처명</div>
							<div id="custName">-</div>
						</div>
						<div>
							<div class="muted">사업자번호</div>
							<div id="custBizNo">-</div>
						</div>
						<div>
							<div class="muted">수령지(주소)</div>
							<div id="custAddr">-</div>
						</div>
					</div>
				</div>
			</div><!-- /.form-grid -->
		</div>

		<!-- 2) 품목 항목 -->
		<div class="card mb-4">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">품목 목록</div>
				<div class="d-flex gap-2">
					<button id="btnAddRow" class="btn btn-primary btn-sm">행 추가</button>
					<button id="btnRemoveRow" class="btn btn-secondary btn-sm">행 삭제</button>
				</div>
			</div>

			<div class="table-responsive">
				<table id="itemsTable" class="table" aria-label="출고 품목">
					<thead>
						<tr>
							<th class="col-no">No</th>
							<th>품목명 / 출고지</th>
							<th class="col-qty">수량</th>
							<th class="col-unit">단위</th>
							<th class="col-price">단가</th>
							<th class="col-amount right">금액</th>
							<th>로트 / 유통기한</th>
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
							<td></td>
						</tr>
					</tfoot>
				</table>
			</div>

			<div class="muted mt-2">수량 입력 시 금액(수량×단가)과 합계가 자동 계산됩니다.</div>
		</div>

		<!-- 3) 배송 / 운송 정보 -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="card-title">배송 / 운송 정보</div>
			</div>

			<div class="form-grid">
				<div class="form-item">
					<label class="form-label">운송수단</label>
					<select id="carrier" class="form-control">
						<option>직거래(방문수령)</option>
						<option>택배</option>
						<option>퀵서비스</option>
						<option>자체배송</option>
					</select>
				</div>
				<div class="form-item">
					<label class="form-label">운송업체 / 운송장</label>
					<div class="inline">
						<input id="tracking" type="text" class="form-control" placeholder="운송업체 / 운송장번호" />
					</div>
				</div>

				<div class="form-item">
					<label class="form-label">수령자명</label>
					<input id="receiver" type="text" class="form-control" placeholder="수령자명" />
				</div>
				<div class="form-item">
					<label class="form-label">수령 연락처</label>
					<input id="receiverPhone" type="text" class="form-control" placeholder="예: 010-1234-5678" />
				</div>

				<div class="form-item form-item-span2">
					<label class="form-label">특이사항 / 요청사항</label>
					<input id="shipNote" type="text" class="form-control" placeholder="배송 시 주의사항" />
				</div>
			</div>
		</div>

		<!-- 4) 첨부 / 메모 -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="card-title">첨부 / 메모</div>
			</div>

			<div class="row">
				<div class="col-md-6">
					<label class="form-label">메모</label>
					<textarea id="memo" class="form-control" rows="4" placeholder="출고 특이사항 / 내부메모"></textarea>
				</div>
				<div class="col-md-6">
					<label class="form-label">첨부</label>
					<div class="inline">
						<input id="files" type="file" class="form-control" multiple />
						<button id="btnUpload" class="btn btn-secondary btn-sm">업로드(모의)</button>
					</div>
					<div id="fileList" class="muted mt-2">첨부된 파일 없음</div>
				</div>
			</div>
		</div>
	</section>

	<script>
		/* ===== 모의 고객 DB ===== */
		const CUSTOMERS = {
			"CUST01": { name: "카페문방구", biz: "9876543210", addr: "서울 마포구 월드컵로 12", phone: "02-555-6666" },
			"CUST02": { name: "동네카페", biz: "2223334445", addr: "부산 해운대구 센텀로 9", phone: "051-777-8888" }
		};

		/* 유틸 */
		const fmtKRW = n => Number(n||0).toLocaleString("ko-KR");
		const parseNum = v => { const n = Number(String(v).replace(/[^0-9.-]+/g,"")); return isNaN(n)?0:n; };

		/* 초기화 */
		document.addEventListener("DOMContentLoaded", () => {
			addRow();

			document.getElementById("btnCustLookup").addEventListener("click", customerLookup);
			document.getElementById("btnAddRow").addEventListener("click", (e)=>{ e.preventDefault(); addRow(); });
			document.getElementById("btnRemoveRow").addEventListener("click", (e)=>{ e.preventDefault(); removeLastRow(); });
			document.getElementById("btnUpload").addEventListener("click", fakeUpload);
			document.getElementById("btnSaveDraft").addEventListener("click", (e)=>{ e.preventDefault(); console.log('[임시저장]', gatherPayload()); alert('임시저장(모의)'); });
			document.getElementById("btnSubmit").addEventListener("click", onSubmit);
		});

		/* 고객 조회(모의) */
		function customerLookup(e){
			e.preventDefault();
			const kw = document.getElementById("custKeyword").value.trim();
			if(!kw){ alert("고객명 또는 사업자번호로 검색하세요."); return; }
			const found = Object.values(CUSTOMERS).find(c => c.name.includes(kw) || c.biz.includes(kw));
			if(found){
				document.getElementById("custName").textContent = found.name;
				document.getElementById("custBizNo").textContent = found.biz;
				document.getElementById("custAddr").textContent = found.addr;
			}else{
				alert("고객을 찾지 못했습니다. (모의)");
			}
		}

		/* 테이블 행 관리 */
		function tbody(){ return document.querySelector("#itemsTable tbody"); }

		function addRow(){
			const idx = tbody().children.length + 1;
			const tr = document.createElement("tr");
			tr.innerHTML =
				"\t<td class=\"col-no\">" + idx + "</td>\n" +
				"\t<td>\n" +
				"\t\t<div class=\"cell-name-dest\">\n" +
				"\t\t\t<input type=\"text\" class=\"form-control item-name\" placeholder=\"품목명\" />\n" +
				"\t\t\t<input type=\"text\" class=\"form-control item-dest\" placeholder=\"출고지(예: 매장명/구역)\" />\n" +
				"\t\t</div>\n" +
				"\t</td>\n" +
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
				"\t<td><input type=\"text\" class=\"form-control item-lot\" placeholder=\"LOT / YYYY-MM-DD\" /></td>\n" +
				"\t<td><input type=\"text\" class=\"form-control item-note\" placeholder=\"비고\" /></td>\n";
			tbody().appendChild(tr);

			tr.querySelector(".item-qty").addEventListener("input", recalc);
			tr.querySelector(".item-price").addEventListener("input", (e)=>{ e.target.value = formatNumInput(e.target.value); recalc(); });
			recalc();
		}

		function removeLastRow(){
			if(tbody().children.length <= 1){ alert("최소 1행은 필요합니다."); return; }
			tbody().removeChild(tbody().lastElementChild);
			[...tbody().children].forEach((tr,i)=> tr.children[0].textContent = i+1);
			recalc();
		}

		function formatNumInput(v){
			const n = String(v).replace(/[^0-9.-]+/g,"");
			if(n==="") return "";
			return Number(n).toLocaleString("ko-KR");
		}

		function recalc(){
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
		function fakeUpload(e){
			e.preventDefault();
			const files = document.getElementById("files").files;
			if(!files || files.length===0){ alert("파일을 선택하세요."); return; }
			const names = [...files].map(f=>f.name).join(", ");
			document.getElementById("fileList").textContent = "첨부됨: " + names + " (모의)";
			alert("첨부(모의) 완료");
		}

		/* 페이로드 수집 & 제출(모의) */
		function gatherPayload(){
			const items = [...tbody().children].map(tr => ({
				name: tr.querySelector(".item-name").value.trim(),
				dest: tr.querySelector(".item-dest").value.trim(),
				qty: parseNum(tr.querySelector(".item-qty").value),
				unit: tr.querySelector(".item-unit").value,
				price: parseNum(tr.querySelector(".item-price").value),
				amount: parseNum(tr.querySelector(".cell-amount").textContent),
				lot: tr.querySelector(".item-lot").value.trim(),
				note: tr.querySelector(".item-note").value.trim()
			}));
			return {
				outboundType: document.getElementById("outboundType").value,
				warehouse: document.getElementById("warehouse").value,
				reqDate: document.getElementById("reqDate").value,
				owner: document.getElementById("owner").value,
				orderNo: document.getElementById("orderNo").value,
				customer: {
					keyword: document.getElementById("custKeyword").value,
					name: document.getElementById("custName").textContent,
					bizNo: document.getElementById("custBizNo").textContent,
					addr: document.getElementById("custAddr").textContent
				},
				shipping: {
					carrier: document.getElementById("carrier")?document.getElementById("carrier").value:"",
					tracking: document.getElementById("tracking")?document.getElementById("tracking").value:""
				},
				memo: document.getElementById("memo").value,
				items,
				summary: {
					totalQty: parseNum(document.getElementById("totalQty").textContent),
					totalAmount: parseNum(document.getElementById("totalAmount").textContent)
				}
			};
		}

		function onSubmit(e){
			e.preventDefault();
			// 간단 검증: 품목명 확인
			if([...tbody().children].some(tr => !tr.querySelector(".item-name").value.trim())){ alert("모든 품목의 품목명을 입력하세요."); return; }
			const payload = gatherPayload();
			console.log("[출고요청 제출] payload:", payload);
			alert("출고요청이 제출되었습니다. (모의)");
		}
	</script>
</body>
</html>
