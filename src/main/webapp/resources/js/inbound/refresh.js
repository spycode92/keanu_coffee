document.addEventListener("keydown", function (e) {
	// F5 또는 Ctrl+R 모두 차단
	if (e.key === "F5" || e.keyCode === 116 || (e.ctrlKey && e.key === "r")) {
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
				window.location.href = `${contextPath}/inbound/detail`;
			}
		});
	}
});