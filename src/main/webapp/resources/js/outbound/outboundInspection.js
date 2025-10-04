document.addEventListener("DOMContentLoaded", function () {
    const itemsTable = document.getElementById("itemsTable");

    // "검수완료" 버튼 이벤트 위임
    itemsTable.addEventListener("click", function (e) {
        if (!e.target.classList.contains("btn-inspect")) return;

        const row = e.target.closest("tr");

        // 행 데이터 추출
        const lotNumber   = row.children[1].textContent.trim();
        const productName = row.children[2].textContent.trim();
        const quantity    = row.children[3].textContent.trim();
        const discardInput = row.querySelector(".discard-qty");
        const discardQty  = discardInput.value;

        // Swal로 표시
        Swal.fire({
            icon: "info",
            title: "검수 완료",
            html: `
                <b>LOT번호:</b> ${lotNumber}<br/>
                <b>상품명:</b> ${productName}<br/>
                <b>출고수량:</b> ${quantity}<br/>
                <b>폐기수량:</b> ${discardQty}
            `,
            confirmButtonText: "확인"
        });

        // 버튼 비활성화
        e.target.disabled = true;
        e.target.textContent = "완료됨";
        e.target.classList.remove("btn-primary");
        e.target.classList.add("btn-secondary");
        
        // 폐기수량 입력칸 비활성화
        discardInput.disabled = true;       // 값 변경 불가
        discardInput.classList.add("disabled-input"); // CSS로 회색 처리 가능
    });
});



// 출고확정 버튼
// 출고확정 버튼
document.addEventListener("DOMContentLoaded", function () {
  const btn = document.getElementById("btnOutboundComplete");
  if (!btn) return;

  btn.addEventListener("click", function () {
    const link = document.getElementById("outboundLink");
    const obwaitNumber = link?.dataset.orderNumber;
    const outboundOrderIdx = link?.dataset.outboundOrderIdx;

    // 🔎 1) 출고위치 지정 여부 확인
    const locationField = document.getElementById("fieldOutboundLocation");
    const locationName = locationField?.textContent.trim();
    if (!locationName || locationName === "-") {
      Swal.fire("경고", "출고위치가 지정되지 않았습니다 ❌", "warning");
      return;
    }

    // 🔎 2) 모든 품목 검수완료 여부 확인
    const allInspected = Array.from(document.querySelectorAll("#itemsTable tbody .btn-inspect"))
      .every(btn => btn.disabled); // 버튼이 비활성화되어 있으면 검수완료됨
    if (!allInspected) {
      Swal.fire("경고", "모든 품목이 검수완료되지 않았습니다 ❌", "warning");
      return;
    }

    if (!obwaitNumber || !outboundOrderIdx) {
      Swal.fire("오류", "출고번호 또는 오더 PK가 누락되었습니다.", "error");
      return;
    }

    // CSRF
    const tokenMeta  = document.querySelector('meta[name="_csrf"]');
    const headerMeta = document.querySelector('meta[name="_csrf_header"]');
    const csrfHeaderName  = headerMeta?.getAttribute("content");
    const csrfHeaderValue = tokenMeta?.getAttribute("content");

    const headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    };
    if (csrfHeaderName && csrfHeaderValue) {
      headers[csrfHeaderName] = csrfHeaderValue;
    }

    // ✅ 검증 통과 시 fetch 실행
    fetch(`${contextPath}/outbound/updateStatusDispatchWait`, {
      method: "POST",
      credentials: "same-origin",
      headers,
      body: JSON.stringify({ obwaitNumber, outboundOrderIdx })
    })
    .then(async (res) => {
      const ct = (res.headers.get("content-type") || "").toLowerCase();
      const text = await res.text();

      if (!res.ok) throw new Error(`HTTP ${res.status}`);

      if (ct.includes("application/json")) {
        let data;
        try { data = JSON.parse(text); } catch (e) { throw new Error("JSON 파싱 실패"); }

        if (data.ok) {
          return Swal.fire("성공", `출고 상태가 '${data.nextStatusLabel}'로 변경되었습니다.`, "success")
            .then(() => {
              location.href = `${contextPath}/outbound/outboundDetail?`
                + `obwaitNumber=${encodeURIComponent(obwaitNumber)}&`
                + `outboundOrderIdx=${encodeURIComponent(outboundOrderIdx)}`;
            });
        } else {
          throw new Error(data.message || "상태 변경 실패");
        }
      }

      if (text.startsWith("<!DOCTYPE") || text.includes("로그인")) {
        throw new Error("AUTH");
      }
      throw new Error("예상치 못한 응답");
    })
    .catch((err) => {
      if (err.message === "AUTH") {
        Swal.fire("로그인이 필요합니다", "세션이 만료되었거나 인증이 필요합니다.", "warning")
          .then(() => location.reload());
        return;
      }
      Swal.fire("오류", err.message || "요청 실패", "error");
    });
  });
});


document.addEventListener("DOMContentLoaded", function () {
    // ------------------------
    // 뒤로가기 버튼
    // ------------------------
    const btnBack = document.getElementById("btnBack");
    btnBack?.addEventListener("click", function (e) {
        e.preventDefault();
        history.back();
    });

    
});

document.addEventListener("DOMContentLoaded", function () {
	const navEntries = performance.getEntriesByType("navigation");
	if (navEntries.length > 0 && navEntries[0].type === "reload") {
		Swal.fire({
			icon: "info",
			title: "새로고침 감지",
			text: "이 페이지를 새로고침했습니다.",
			confirmButtonText: "확인"
		});
	}
});
