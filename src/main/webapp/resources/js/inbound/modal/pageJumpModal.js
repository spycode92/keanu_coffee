(function () {
	const input = () => document.getElementById("pageInput");

	window.goToPage = function (maxPage) {
		const val = input() ? input().value : "";
		const pageNum = parseInt(val, 10);

		if (!isNaN(pageNum) && pageNum >= 1 && pageNum <= maxPage) {
			window.location.href = "?pageNum=" + pageNum;
		} else {
			Swal.fire({
			    icon: "warning",
			    title: "잘못된 입력",
			    text: "1 ~ " + maxPage + " 사이의 숫자를 입력하세요.",
			    confirmButtonText: "확인"
			});
			if (input()) input().focus();
		}
	};
})();