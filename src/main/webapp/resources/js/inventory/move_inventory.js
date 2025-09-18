document.addEventListener('DOMContentLoaded', () => {

    //공통 이벤트 핸들러
    function addInputEvents(inputId, callback) {
        const input = document.getElementById(inputId);
        
        //blur
        input.addEventListener('blur', function() {
            const value = this.value.trim();
            callback(value);
        });
        
        //Enter키
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
		console.log("실행됐어요");
        if(lotNumber) {
            searchProductByLotNum(lotNumber);
        }
    }
    
    // 로케이션 이름 입력 처리
    function handleLocationName(locationName) {
	console.log("실행됐어요2321312321");
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
	
	//카트에담을 상품갯수 입력후 blur이벤트
	document.getElementById('mi_quantity').addEventListener('blur', function(event) {
			event.preventDefault();
			const quantity = this.value.trim();
		    checkQuantity(quantity);
	});
	
	//카트에담기 버튼 클릭이벤트
	document.getElementById('mi_addCart').addEventListener('click', function(event) {
		event.preventDefault();
		// 현재 input 값들 가져오기
	    const lotNumber = document.getElementById('mi_lotNumber').value.trim();
	    const locationName = document.getElementById('mi_locationName').value.trim();
	    const quantity = document.getElementById('mi_quantity').value.trim();

		if (lotNumber !== selectLotNumber) {
	        Swal.fire('LOT 번호 불일치', 'LOT 번호를 다시 확인해주세요.', 'warning');
	        return;
	    }
	    
	    if (locationName !== selectLocationName) {
	        Swal.fire('로케이션 불일치', '로케이션을 다시 확인해주세요.', 'warning');
	        return;
	    }
	    
	    if (!quantity) {
	        Swal.fire('수량 입력', '수량을 입력해주세요.', 'warning');
	        return;
	    }
		//한번더 유효성 검사
		if(checkQuantity(quantity)){
			addToCart();
		}
	});
});

let selectLotNumber = "";
let selectLocationName = "";
let selectQuantity = "";
let selectedLocationItems = [];

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
//				console.log("여기까지");
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
		.attr('max', maxQuantity)
		.attr('placeholder', '최대수량 : ' + maxQuantity)
	    .val('');                  // 기존 값 초기화 (옵션)

}

//상품갯수 초기화
function resetQuantity(){
	$('#mi_quantity')
		.val('')
		.removeAttr('max')
		.removeAttr('placeholder')
		.prop('readonly', true); 
}

//상품갯수체크
function checkQuantity(quantity){
	const maxQuantity = parseInt($('#mi_quantity').prop('max'));//숫자변환
	const qty = parseInt(quantity);//숫자변환
	
	if (quantity > maxQuantity) {
        $('#mi_quantity').val('');
		
		Swal.fire({
            icon: 'error',
            title: '최대수량 초과',
            text: '현재 위치에 상품의 갯수를 초과하였습니다.',
            confirmButtonText: '확인'
        });
    } else {
        $('#mi_quantity').val(quantity); // input 값 설정
		selectQuantity = quantity;
		return true;
    }
}

//카트에담기 동작함수
function addToCart(){
	ajaxPost("/inventory/move/addCart",
		{lotNumber : selectLotNumber
		 , locationName : selectLocationName
		 , quantity :selectQuantity }
	).then(data => {
		Swal.fire({
            icon: 'success',
            title: "성공" ,
            text: data.message,
            confirmButtonText: '확인'
        }).then(()=>{
			window.location.reload();
		});
	}).catch(err=> {
		Swal.fire({
            icon: 'error',
            title: "실패" ,
            text: err.message,
            confirmButtonText: '확인'
        }).then(()=>{
			window.location.reload();
		});
	});
}

//--------------- qrscanner 조작 ----------------
function init() {
	const btnScanQR = document.getElementById("qrScanner");
	const qrModal = document.getElementById("qrScannerModal");
	if (!btnScanQR || !qrModal) {
		console.warn("QR 스캐너: 버튼 또는 모달 요소를 찾을 수 없습니다.");
		return;
	}

	// 버튼 클릭 → 모달 열고 카메라 시작
	btnScanQR.addEventListener("click", function() {
		console.log("QR 버튼 클릭됨");
		ModalManager.openModalById("qrScannerModal");
		
		startCamera((scannedText) => {
			if (scannedText.startsWith("LOT")){
				$('#mi_lotNumber').val(scannedText);
				selectLotNumber = $('#mi_lotNumber').val(scannedText);
				searchProductByLotNum(scannedText);
//				resetQuantity();
//				checkInventory();
			} else {
				$('#mi_locationName').val(scannedText);
				searchInventoryByLocation(scannedText);
//				resetQuantity();
//				checkInventory();
			}
		});
	});

	// 모달 닫힐 때 카메라 종료
	const closeBtn = qrModal.querySelector(".modal-close-btn");
	if (closeBtn) {
		closeBtn.addEventListener("click", stopCamera);
	}
	qrModal.addEventListener("click", function(e) {
		if (e.target === qrModal) stopCamera();
	});
}

// ===== QRScanner초기화 =====
if (document.readyState === "loading") {
	document.addEventListener("DOMContentLoaded", init);
} else {
	init();
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


