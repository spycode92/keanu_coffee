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

// 검수 이동 (EL 제거, data-* 사용)
document.getElementById("btnEdit").addEventListener("click", function(){
	const btn	= document.getElementById("btnEdit");
	const ib	= btn.dataset.ibwaitIdx || "";
	const ord	= btn.dataset.orderNumber || "";
	const ctx	= document.body.getAttribute("data-context") || "";
	window.location.href = `${ctx}/inbound/inboundInspection?ibwaitIdx=${encodeURIComponent(ib)}&orderNumber=${encodeURIComponent(ord)}`;
});
