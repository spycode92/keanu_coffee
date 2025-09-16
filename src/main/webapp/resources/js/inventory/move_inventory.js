document.addEventListener('DOMContentLoaded', () => {
	console.log("Ddddd");
	//lot번호가 입력되었을때 실행
	document.getElementById('mi_lotNum').addEventListener('blur', function() {
		const lotNum = this.value.trim(); 
	    searchProductByLotNum(lotNum);
	});
});


//상품찾기
function searchProductByLotNum(lotNum){
	console.log("ddddddd", lotNum);
	ajaxGet("/inventory/move/getProductDetail",lotNum)
		.then(data => {
			
		})
		.catch(err => {
			
		});
}














//웹소켓 구독 코드
subscribeRoom("inventory", function(message) {
    console.log("📦 새 재고 이벤트 발생!");
//    console.log("   roomId :", message.roomId);
//    console.log("   sender :", message.sender);
//    console.log("   text   :", message.message);

    // ✅ KPI 카드 새로고침
    loadKpiData();

    // ✅ 카테고리별 재고 현황 차트 새로고침
    getInventory().then(() => {
        const inventoryChartData = processInventoryData(inventoryRawData);
        drawInventoryChart(inventoryChartData);
    });

    // ✅ 로케이션 용적률 히트맵 새로고침
    getLocation().then(() => {
        const palletData = locationRawData.filter(d => d.locationType === 1);
        const pickingData = locationRawData.filter(d => d.locationType === 2);

        const palletHeatmapData = buildHeatmapData(palletData);
        const pickingHeatmapData = buildHeatmapData(pickingData);

        drawHeatmap(palletHeatmapData, "#pallet_heatmap", "Pallet Zone");
        drawHeatmap(pickingHeatmapData, "#picking_heatmap", "Picking Zone");
        totalUsage(palletData, pickingData);
    });
});


