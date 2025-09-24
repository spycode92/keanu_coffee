document.addEventListener("DOMContentLoaded", function() {
	// 뒤로가기 버튼
	document.getElementById("btnBack")?.addEventListener("click", function(e) {
		e.preventDefault();
		history.back();
	});
});

// outboundDetail.js (출고상세 전용 스크립트)
(function (w, d) {
	"use strict";

	function byId(id) { return d.getElementById(id); }

	document.addEventListener("DOMContentLoaded", function () {
		const btnInspection = byId("btnInspection");
		if (!btnInspection) return;

		btnInspection.addEventListener("click", async function () {
			// 버튼 데이터 속성 가져오기
			const obwaitIdx        = btnInspection.dataset.ibwaitIdx;
			const orderNumber      = btnInspection.dataset.orderNumber;
			const status           = btnInspection.dataset.status;
			const manager          = btnInspection.dataset.manager;
			const outboundOrderIdx = btnInspection.dataset.outboundOrderIdx;

			// 로그인 사용자 (principal.getName()을 JSP에서 주입)
			const currentUser = btnInspection.dataset.currentUsername;

			// 1) 담당자 불일치
			if (manager && manager.trim() !== currentUser.trim()) {
				Swal.fire({
					icon: "warning",
					title: "권한 없음",
					text: "담당자가 아니므로 검수할 수 없습니다.",
					confirmButtonText: "확인"
				});
				return;
			}

			// 2) 상태 확인
			if (status !== "출고준비") {
				Swal.fire({
					icon: "warning",
					title: "상태 오류",
					text: "출고준비 상태일 때만 검수가 가능합니다.",
					confirmButtonText: "확인"
				});
				return;
			}

			// 3) Ajax 요청 → 출고검수 페이지 이동
			try {
				const res = await fetch(
					`${contextPath}/outbound/outboundInspection?obwaitIdx=${obwaitIdx}&orderNumber=${encodeURIComponent(orderNumber)}&outboundOrderIdx=${outboundOrderIdx}`,
					{ method: "GET", headers: { "Accept": "text/html" } }
				);

				if (!res.ok) throw new Error("HTTP " + res.status);

				// 페이지 이동
				window.location.href = res.url;
			} catch (err) {
				console.error("검수 요청 실패:", err);
				Swal.fire({
					icon: "error",
					title: "실패",
					text: "검수 페이지 이동에 실패했습니다: " + err.message,
					confirmButtonText: "확인"
				});
			}
		});
	});
})(window, document);

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
