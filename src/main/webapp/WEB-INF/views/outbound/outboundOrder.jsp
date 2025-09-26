<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>출고 관리</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link href="<c:url value='/resources/css/common/common.css'/>" rel="stylesheet" />
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<script src="<c:url value='/resources/js/common/common.js'/>"></script>
	<style>
		.form-container { margin: 32px 24px 80px 24px; max-width: 960px; }
		.form-grid     { display: grid; grid-template-columns: 160px 1fr 160px 1fr; gap: 12px 16px; align-items: center; }
		.inline-row    { display: grid; grid-template-columns: 160px 1fr 160px 1fr auto; gap: 12px 16px; align-items: center; margin-top: 12px; }
		.summary-bar   { display:flex; gap:12px; align-items:center; margin-top:12px; padding:8px 12px; border:1px solid #e5e7eb; border-radius:8px; background:#fafafa; }
		.badge         { display:inline-block; padding:4px 8px; border-radius:999px; border:1px solid #e5e7eb; }
		table          { width: 100%; border-collapse: collapse; margin-top: 12px; }
		th, td         { border: 1px solid #e5e7eb; padding: 8px 10px; text-align: left; }
		th             { background: #f9fafb; }
		.text-right    { text-align: right; }
		.muted         { color: #6b7280; font-size: 12px; }
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<div class="form-container">
		<h2>출고 요청 생성</h2>
		<p class="muted">가맹점/긴급여부 선택 후 품목을 추가하세요. 최종 제출 시 함께 저장됩니다.</p>

		<form id="outboundForm" action="<c:url value='/order/insert'/>" method="post">
			<c:if test="${not empty _csrf}">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
			</c:if>

			<!-- 기본 정보 -->
			<div class="form-grid">
				<label for="franchiseIdx">가맹점 선택</label>
				<select name="franchiseIdx" id="franchiseIdx" required>
					<option value="">선택</option>
					<c:forEach var="franchise" items="${franchiseList}">
						<option value="${franchise.franchiseIdx}">${franchise.franchiseName}</option>
					</c:forEach>
				</select>

				<label for="urgent">긴급 여부</label>
				<select name="urgent" id="urgent" required>
					<option value="N" selected>일반</option>
					<option value="Y">긴급</option>
				</select>
			</div>

			<hr style="margin:16px 0;" />

			<!-- 품목 추가 -->
			<div class="inline-row">
				<label for="productIdx">제품</label>
				<select id="productIdx">
					<option value="">선택</option>
					<c:forEach var="product" items="${productList}">
						<option value="${product.productIdx}">${product.productName}</option>
					</c:forEach>
				</select>

				<label for="quantity">수량</label>
				<input type="number" id="quantity" min="1" placeholder="1 이상 정수" />
				<br>
				<label for="note">비고</label>
    			<textarea id="note" rows="1" style="resize:none;width:100%;"></textarea>
				<br>
				<button type="button" id="addItemBtn">추가</button>
			</div>

			<!-- 요약 바(가맹점/긴급/품목수/총수량) -->
			<div class="summary-bar" id="summaryBar" aria-live="polite">
				<span class="badge">가맹점: <b id="summaryFranchise">-</b></span>
				<span class="badge">긴급여부: <b id="summaryUrgent">-</b></span>
				<span class="badge">품목수: <b id="summaryItemCount">0</b></span>
				<span class="badge">총수량: <b id="summaryTotalQty">0</b></span>
			</div>

			<!-- 리스트 -->
			<div class="list-container">
				<table id="itemTable" aria-label="출고 품목 리스트">
					<thead>
						<tr>
							<th style="width: 140px;">제품번호</th>
							<th class="text-right" style="width: 140px;">수량</th>
							<th>비고</th>
							<th style="width: 120px;">작업</th>
						</tr>
					</thead>
					<tbody id="itemTbody">
						<tr id="emptyRow"><td colspan="4" class="muted">추가된 품목이 없습니다.</td></tr>
					</tbody>
				</table>
			</div>

			<!-- 서버 전송용 hidden -->
			<input type="hidden" name="itemsJson" id="itemsJson" />
			<input type="hidden" name="totalQuantity" id="totalQuantity" /> <!-- 4번째 파라미터 -->

			<div style="margin-top:12px; display:flex; gap:8px;">
				<button type="submit" id="submitBtn">최종 제출</button>
				<button type="button" id="clearAllBtn">전체 비우기</button>
			</div>
		</form>
	</div>

	<script>
		let itemList = []; // { productIdx:number, quantity:number }

		// refs
		const productSel = document.getElementById("productIdx");
		const qtyInput   = document.getElementById("quantity");
		const addBtn     = document.getElementById("addItemBtn");
		const tbody      = document.getElementById("itemTbody");
		const emptyRow   = document.getElementById("emptyRow");
		const itemsJson  = document.getElementById("itemsJson");
		const totalQtyEl = document.getElementById("totalQuantity");
		const clearAll   = document.getElementById("clearAllBtn");
		const form       = document.getElementById("outboundForm");

		// summary refs
		const sumFranchise = document.getElementById("summaryFranchise");
		const sumUrgent    = document.getElementById("summaryUrgent");
		const sumItemCount = document.getElementById("summaryItemCount");
		const sumTotalQty  = document.getElementById("summaryTotalQty");

		// helper: 총수량 계산
		function calcTotalQty() {
			return itemList.reduce((acc, it) => acc + (it.quantity || 0), 0);
		}

		// 요약바 갱신
		function renderSummary() {
			const fSel = document.getElementById("franchiseIdx");
			const uSel = document.getElementById("urgent");

			sumFranchise.textContent = fSel.value ? (fSel.value + "번") : "-";
			sumUrgent.textContent    = uSel.value === "Y" ? "긴급" : (uSel.value === "N" ? "일반" : "-");
			sumItemCount.textContent = itemList.length.toString();
			sumTotalQty.textContent  = calcTotalQty().toLocaleString();
		}

		// 테이블 렌더
		function renderTable() {
			tbody.innerHTML = "";
			if (itemList.length === 0) {
				tbody.appendChild(emptyRow);
				emptyRow.style.display = "";
			} else {
				emptyRow.style.display = "none";
			}

			itemList.forEach((item, idx) => {
				const tr = document.createElement("tr");

				const tdProd = document.createElement("td");
				tdProd.textContent = item.productIdx;

				const tdQty = document.createElement("td");
				tdQty.className = "text-right";
				tdQty.textContent = item.quantity.toLocaleString();

				const tdNote = document.createElement("td");
				tdNote.textContent = item.note || "";

				const tdAct = document.createElement("td");
				
				const btnMinus = document.createElement("button");
				btnMinus.type = "button";
				btnMinus.textContent = "-1";
				btnMinus.addEventListener("click", () => changeQty(idx, -1));

				const btnPlus = document.createElement("button");
				btnPlus.type = "button";
				btnPlus.textContent = "+1";
				btnPlus.style.marginLeft = "6px";
				btnPlus.addEventListener("click", () => changeQty(idx, +1));

				const btnRemove = document.createElement("button");
				btnRemove.type = "button";
				btnRemove.textContent = "삭제";
				btnRemove.style.marginLeft = "6px";
				btnRemove.addEventListener("click", () => removeItem(idx));

				tdAct.appendChild(btnMinus);
				tdAct.appendChild(btnPlus);
				tdAct.appendChild(btnRemove);

				tr.appendChild(tdProd);
				tr.appendChild(tdQty);
				tr.appendChild(tdNote);
				tr.appendChild(tdAct);
				tbody.appendChild(tr);
			});

			renderSummary();
		}

		function changeQty(index, diff) {
			const next = itemList[index].quantity + diff;
			if (next <= 0) removeItem(index);
			else { itemList[index].quantity = next; renderTable(); }
		}

		function removeItem(index) {
			itemList.splice(index, 1);
			renderTable();
		}

		function addItem() {
			const productIdx = parseInt(productSel.value, 10);
			const quantity   = parseInt(qtyInput.value, 10);
			const note       = document.getElementById("note").value.trim();

			if (!productIdx) { alert("제품을 선택해주세요."); productSel.focus(); return; }
			if (!quantity || quantity <= 0) { alert("수량은 1 이상의 정수로 입력해주세요."); qtyInput.focus(); return; }

			const exists = itemList.find((it) => it.productIdx === productIdx);
			if (exists){
				exists.quantity += quantity;
				if(note) exists.note = note;
			} else {
				itemList.push({ productIdx, quantity, note });
			}

			productSel.value = ""; 
			qtyInput.value = "";
			document.getElementById("note").value = "";
			
			renderTable();
		}

		// 이벤트
		addBtn.addEventListener("click", addItem);
		clearAll.addEventListener("click", () => { itemList = []; renderTable(); });
		document.getElementById("franchiseIdx").addEventListener("change", renderSummary);
		document.getElementById("urgent").addEventListener("change", renderSummary);

		// 제출 직전 직렬화(4개 파라미터 전송)
		form.addEventListener("submit", function (e) {
			const franchiseIdx = document.getElementById("franchiseIdx").value;
			const urgent       = document.getElementById("urgent").value;

			if (!franchiseIdx) { alert("가맹점을 선택해주세요."); e.preventDefault(); return; }
			if (!urgent) { alert("긴급 여부를 선택해주세요."); e.preventDefault(); return; }
			if (itemList.length === 0) { alert("출고 품목을 하나 이상 추가해주세요."); e.preventDefault(); return; }

			itemsJson.value = JSON.stringify(itemList);  // 3
			totalQtyEl.value = calcTotalQty();           // 4
			// 나머지 1,2는 select의 name 으로 자동 전송됨
		});

		// 초기
		renderTable();
	</script>
</body>
</html>
