(function () {
	const input = () => document.getElementById("pageInput");

	window.goToPage = function (maxPage) {
		const val = input() ? input().value : "";
		const pageNum = parseInt(val, 10);

		if (!isNaN(pageNum) && pageNum >= 1 && pageNum <= maxPage) {
			window.location.href = "?pageNum=" + pageNum;
		} else {
			alert("1 ~ " + maxPage + " 사이의 숫자를 입력하세요.");
			if (input()) input().focus();
		}
	};
})();