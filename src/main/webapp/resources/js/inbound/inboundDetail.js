/**
 * inboundDetail.js - 입고 상세 페이지 전용 스크립트
 * - 뒤로가기 버튼
 * - 인쇄
 * - 검수 이동 (조건 검증)
 * - F5 새로고침 차단 (파라미터 유지)
 * SweetAlert2 필요
 */

document.addEventListener("DOMContentLoaded", () => {

	// ================= 뒤로가기 버튼 =================
	const btnBack = document.getElementById("btnBack");
	if (btnBack) {
		btnBack.addEventListener("click", (e) => {
			e.preventDefault();
			history.back();
		});
	}

	// ================= 인쇄 버튼 =================
	const btnPrint = document.getElementById("btnPrint");
	if (btnPrint) {
		btnPrint.addEventListener("click", (e) => {
			e.preventDefault();
			window.print();
		});
	}

	// ================= 검수 이동 (조건 검증) =================
	const btnEdit = document.getElementById("btnEdit");
	if (btnEdit) {
		btnEdit.addEventListener("click", (e) => {
			e.preventDefault();

			const status  = btnEdit.dataset.status  || "";
			const manager = btnEdit.dataset.manager || "";

			// 상태 검증
			if (status === "재고등록완료") {
				Swal.fire("알림", "이미 검수가 끝난 물류입니다 ❌", "warning");
				return;
			}
			if (status !== "대기" && status !== "검수중") {
				Swal.fire("알림", "검수는 '대기' 또는 '검수중' 상태에서만 가능합니다 ❌", "warning");
				return;
			}

			// 담당자 검증
			if (!manager.trim()) {
				Swal.fire("알림", "담당자가 지정되어야 검수 가능합니다 ❌", "warning");
				return;
			}

			// 모든 조건 통과 → 검수 페이지 이동
			const ibwaitIdx   = btnEdit.dataset.ibwaitIdx;
			const orderNumber = btnEdit.dataset.orderNumber;
			const ctx         = document.body.dataset.context || "";

			window.location.href =
				`${ctx}/inbound/inboundInspection?ibwaitIdx=${encodeURIComponent(ibwaitIdx)}&orderNumber=${encodeURIComponent(orderNumber)}`;
		});
	}

	// ================= F5 새로고침 차단 =================
	document.addEventListener("keydown", (e) => {
		if (e.key === "F5" || e.keyCode === 116) {
			e.preventDefault();
			Swal.fire({
				icon: "question",
				title: "페이지를 초기화하시겠습니까?",
				html: "확인 시 현재 입력값 모두 초기화되고<br>목록이 처음부터 표시됩니다.",
				showCancelButton: true,
				confirmButtonText: "예",
				cancelButtonText: "아니오"
			}).then(result => {
				if (result.isConfirmed) {
					// 현재 경로와 파라미터 유지
					window.location.href = window.location.pathname + window.location.search;
				}
			});
		}
	});

});
