document.addEventListener('DOMContentLoaded', () => {

    // 공통 이벤트 핸들러 함수
    function addInputEvents(inputId, callback) {
        const input = document.getElementById(inputId);
        
        // blur 이벤트
        input.addEventListener('blur', function() {
            const value = this.value.trim();
            callback(value);
        });
        
        // Enter 키 이벤트
        input.addEventListener('keydown', function(event) {
            if(event.key === 'Enter') {
                event.preventDefault();
                const value = this.value.trim();
                callback(value);
            }
        });
    }
    
    // LOT 번호 입력 처리
    function handleLotNumber(lotNumber) {
        if(lotNumber) {
            searchProductByLotNum(lotNumber);
        }
    }
    
    // 로케이션 이름 입력 처리
    function handleLocationName(locationName) {
        if(locationName) {
            selectedLocationItems = [];
            searchInventoryByLocation(locationName);
        }
    }
    
    // 이벤트 등록
    addInputEvents('mi_lotNumber', handleLotNumber);
    addInputEvents('mi_locationName', handleLocationName);
	
	//카트에담을 상품갯수 입력시 실행
	document.getElementById('mi_quantity').addEventListener('keydown', function(event) {
		if(event.key === 'Enter') {
			event.preventDefault();
			const quantity = this.value.trim();
		    checkQuantity(quantity);
		}
	});
});

let selectLotNumber = "";
let selectLocationName = "";
let selectQuantity = "";
let selectedLocationItems = [];
let selectedQuantity = "";

//상품찾기
function searchProductByLotNum(lotNumber){
	ajaxGet(`/inventory/move/getProductDetail/${lotNumber}`)
		.then(data => {
			if(data.success) {
				console.log(data.fileIdx);
				let url = "";
				//상품이미지 보여주기
				url = data.fileIdx ? '/file/thumbnail/' + data.fileIdx : '/resources/images/default_product.jpg';
				$('#productPreview').attr('src',url).show();
				selectLotNumber = lotNumber;
				resetQuantity();
				checkInventory();
				console.log("여기까지");
            } else {
                Swal.fire({
                    icon: 'warning',
                    title: '조회 실패',
                    text: data.message,
                    confirmButtonText: '확인'
                }).then(()=>{
					resetQuantity();
				})
            }
		})
		.catch(err => {
			Swal.fire({
                icon: 'error',
                title: '오류 발생',
                text: '서버와의 통신 중 오류가 발생했습니다.',
                confirmButtonText: '확인'
            });
		});
}

//재고위치찾기
function searchInventoryByLocation(locationName){
	ajaxGet(`/inventory/move/getInventoryLocation/${locationName}`)
		.then(data => {
			if(data.success) {
				data.inventoryList.forEach(function(inventory) {
                    selectedLocationItems.push({
						lotNumber: inventory.lotNumber
						, quantity: inventory.quantity
					})
                });
				selectLocationName = locationName;
				resetQuantity();
				checkInventory();
            } else {
                Swal.fire({
                    icon: 'warning',
                    title: '조회 실패',
                    text: data.message,
                    confirmButtonText: '확인'
                }).then(()=>{
					resetQuantity();
				})
            }
		})
		.catch(err => {
			Swal.fire({
                icon: 'error',
                title: '오류 발생',
                text: '서버와의 통신 중 오류가 발생했습니다.',
                confirmButtonText: '확인'
            });
		});
}

//선택한 위치에 선택한 재고 있나 검사
function checkInventory(){
	//둘다입력됐을때만 함수실행
	if(!selectLotNumber || !selectLocationName) {
	    return; 
    }
	
    // 해당 상품이 해당 로케이션에 없는 경우
	const foundItem = selectedLocationItems.find(item => item.lotNumber === selectLotNumber);
	console.log("파운드아이템",foundItem);
	
	if(!foundItem) {
        Swal.fire({
            icon: 'error',
            title: '재고 없음',
            text: '해당 상품은 해당 로케이션에 존재하지 않습니다.',
            confirmButtonText: '확인'
        });
        return;
    }
	const maxQuantity = foundItem.quantity;
	resetQuantity();
	// 선택한 로케이션에 해당 상품이 재고로 존재할때
    $('#mi_quantity')
		.removeAttr('readonly')
		.attr('max', maxQuantity)  // 최대값 설정
	    .val('');                  // 기존 값 초기화 (옵션)

}

function resetQuantity(){
	$('#mi_quantity')
		.val('')
		.removeAttr('max')
		.removeAttr('placeholder')
		.prop('readonly', true); 
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


