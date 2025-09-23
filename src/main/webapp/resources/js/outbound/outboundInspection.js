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
document.addEventListener("DOMContentLoaded", function () {
  const btn = document.getElementById("btnOutboundComplete");
  if (!btn) return;

  btn.addEventListener("click", function () {
    const link = document.getElementById("outboundLink");
    const obwaitNumber = link?.dataset.orderNumber;
    const outboundOrderIdx = link?.dataset.outboundOrderIdx;

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
      "X-Requested-With": "XMLHttpRequest" // 401로 떨어지도록 힌트
    };
    if (csrfHeaderName && csrfHeaderValue) {
      headers[csrfHeaderName] = csrfHeaderValue;
    }

    fetch(`${contextPath}/outbound/updateStatusDispatchWait`, {
      method: "POST",
      credentials: "same-origin", // ★ 쿠키(JSESSIONID) 포함
      headers,
      body: JSON.stringify({ obwaitNumber, outboundOrderIdx })
    })
    .then(async (res) => {
      const ct = (res.headers.get("content-type") || "").toLowerCase();
      const text = await res.text();

      // (1) 비정상 상태코드
      if (!res.ok) throw new Error(`HTTP ${res.status}`);

      // (2) JSON 정상 응답
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

      // (3) JSON이 아니면(거의 로그인 페이지 HTML)
      if (text.startsWith("<!DOCTYPE") || text.includes("로그인")) {
        throw new Error("AUTH"); // 세션만료/인증실패
      }

      // (4) 그 외
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
