// 뒤로가기 버튼
document.getElementById("btnBack").addEventListener("click", function(e){
    e.preventDefault();
    history.back();
});

// 인쇄
document.getElementById("btnPrint").addEventListener("click", function(e){
    e.preventDefault();
    window.print();
});

// 검수 이동 (조건 검증 포함)
document.addEventListener("DOMContentLoaded", () => {
    const btnEdit = document.getElementById("btnEdit");
    if (!btnEdit) return;

    btnEdit.addEventListener("click", (e) => {
        e.preventDefault();

        const status  = btnEdit.dataset.status || "";
        const manager = btnEdit.dataset.manager || "";

        if (status === "재고등록완료") {
            Swal.fire("알림", "이미 검수가 끝난 물류입니다 ❌", "warning");
            return;
        }

		if (status !== "대기" && status !== "검수중") {
            Swal.fire("알림", "검수는 '대기' 또는 '검수중' 상태에서만 가능합니다 ❌", "warning");
            return;
        }

        if (!manager || manager.trim() === "") {
            Swal.fire("알림", "담당자가 지정되어야 검수 가능합니다 ❌", "warning");
            return;
        }

        // 모든 조건 통과 → 검수 페이지로 이동
        const ibwaitIdx   = btnEdit.dataset.ibwaitIdx;
        const orderNumber = btnEdit.dataset.orderNumber;
        const ctx         = document.body.getAttribute("data-context") || "";

        window.location.href = `${ctx}/inbound/inboundInspection?ibwaitIdx=${encodeURIComponent(ibwaitIdx)}&orderNumber=${encodeURIComponent(orderNumber)}`;
    });
});
