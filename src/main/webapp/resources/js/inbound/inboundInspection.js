// 뒤로가기 버튼
document.getElementById("btnBack").addEventListener("click", function(e){
	e.preventDefault();
	history.back();
});

// ------------------------
// 검수완료 버튼 AJAX
// ------------------------
itemsTable.querySelectorAll("tbody .inspection input[type=button]").forEach(btn => {
    btn.addEventListener("click", function() {
        const row = btn.closest("tr");
        const lotVal = row.querySelector("input[name=lotNumber]").value;

        // ✅ LOT번호 입력 체크
        if (!lotVal || lotVal === "-") {
            Swal.fire("경고", "LOT 번호를 먼저 입력하세요!", "warning");
            return;
        }

        const payload = {
            ibwaitIdx: document.getElementById("inboundLink").dataset.ibwaitIdx,
            productIdx: row.dataset.productIdx,
            lotNumber:  lotVal,
            quantity:   row.querySelector(".quantity").value,
            unitPrice:  row.querySelector(".unitPrice").value,
            amount:     row.querySelector(".amount").dataset.value,
            tax:        row.querySelector(".tax").dataset.value,
            totalPrice: row.querySelector(".totalPrice").dataset.value
        };

        $.ajax({
            url: "/inbound/inspectionComplete",
            type: "POST",
            data: JSON.stringify(payload),
            contentType: "application/json",
            beforeSend: function(xhr) {
                if (header && token) {
                    xhr.setRequestHeader(header, token);
                }
            },
            success: function(res) {
                if (res.ok) {
                    Swal.fire("성공", "검수완료 처리됨 ✅", "success");
                    btn.disabled = true;
                } else {
                    Swal.fire("실패", "처리 실패 ❌", "error");
                }
            },
            error: function(xhr) {
                Swal.fire("에러", "서버 오류 발생: " + xhr.status, "error");
            }
        });
    });
});
