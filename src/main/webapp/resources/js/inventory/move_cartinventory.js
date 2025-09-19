document.addEventListener('DOMContentLoaded', () => {
	//로케이션정보가져오기
//	getLocationList();

	// 모든 tr 요소 선택 (tbody 내부)
	const rows = document.querySelectorAll('#cartList tbody tr');
	
	rows.forEach(row => {
	    row.addEventListener('click', () => {
	        // data 속성값 읽기
	        const lotNumber = row.getAttribute('data-lotNumber');
	        const quantity = parseInt(row.getAttribute('data-maxQuantity'), 10);
			
			selectLotNumber = lotNumber;
			
			maxQuantity = quantity;
	
	        // 또는 input 요소에 값 채우기
	        const lotInput = document.getElementById('mi_lotNumber');
	        if (lotInput) lotInput.value = lotNumber;
			searchProductByLotNum(lotNumber);
			checkBeforeMove();
	    });
	});
	
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
    
    // 로케이션 이름 입력 처리
    function handleLocationName(locationName) {
        if(locationName) {
            isLocationExist(locationName);
			checkBeforeMove();
        }
    }
    
    // 이벤트 등록
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
	
	//재고이동 버튼 클릭이벤트
	document.getElementById('mi_moveToLocation').addEventListener('click', function(event) {
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
			cartToLocation();
		}
	});
});

let selectLotNumber = "";
let selectLocationName = "";
let maxQuantity = "";
let selectQuantity = "";

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

//로케이션이존재하는지체크
function getLocationList() {
	ajaxGet("/inventory/move/getLocationList")
	.then(data => {
		console.log(data);
	})
}

//상품, 위치, 상품수량 체크
function checkBeforeMove(){
	//둘다입력됐을때만 함수실행
	if(!selectLotNumber || !selectLocationName) {
	    return; 
    }
	
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
	const parseMaxQuantity = parseInt($('#mi_quantity').prop('max'));//숫자변환
	const qty = parseInt(quantity);//숫자변환
	
	if (qty > parseMaxQuantity) {
        $('#mi_quantity').val('');
		
		Swal.fire({
            icon: 'error',
            title: '최대수량 초과',
            text: '선택 가능한 상품의 갯수를 초과하였습니다.',
            confirmButtonText: '확인'
        });
    } else if(qty < 1){
		$('#mi_quantity').val('');
		
		Swal.fire({
            icon: 'error',
            title: '최소 수량 미만',
            text: '최소 선택 갯수는 상품의 1개 입니다.',
            confirmButtonText: '확인'
        });
	}else {
        $('#mi_quantity').val(qty); // input 값 설정
		selectQuantity = qty;
		return true;
    }
}

//재고이동 동작함수
function cartToLocation(){
	ajaxPost("/inventory/move/moveLocation",
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

//존재하는 로케이션인지 확인후 selectLocationName에 저장
function isLocationExist(locationName){
	ajaxGet(`/inventory/move/isLocationExist/${locationName}`)
	.then((data) => {
		selectLocationName = locationName;
	}).catch(() =>{
		Swal.fire({
            icon: 'error',
            title: "실패" ,
            text: '존재하지않는 로케이션입니다.',
            confirmButtonText: '확인'
        }).then(()=>{
			selectLocationName = '';
			$('#mi_locationName').focus();
			$('#mi_locationName').val('');
//			window.location.reload();
		});
	})
}

//카트에 있는 상품있는지 체크
function checkLotNumberInCart(lotNumber){
	const rows = document.querySelectorAll('tr[data-lotNumber]');
	const lotNumberArray = Array.from(rows).map(row => row.getAttribute('data-lotNumber'));
	
	return lotNumberArray.includes(lotNumber);
}

//--------------- qrscanner 조작 ----------------
function init() {
	const btnScanQR = document.getElementById("qrScanner");
	const qrModal = document.getElementById("qrScannerModal");
	if (!btnScanQR || !qrModal) {
//		console.warn("QR 스캐너: 버튼 또는 모달 요소를 찾을 수 없습니다.");
		return;
	}
	

	// 버튼 클릭 → 모달 열고 카메라 시작
	btnScanQR.addEventListener("click", function() {
		console.log("QR 버튼 클릭됨");
		ModalManager.openModalById("qrScannerModal");
		//큐알스캔후 콜백함수실행
		startCamera((scannedText) => {
			//스캔한 QR코드가 LOT로시작한다면
			if (scannedText.startsWith("LOT")){
				// 카트에 해당 로트넘버가 있을때
				if(checkLotNumberInCart(scannedText)){
//					selectLotNumber = $('#mi_lotNumber').val(scannedText);
					const targetRow = document.querySelector(`tr[data-lotNumber="${scannedText}"]`);
					
					maxQuantity = targetRow.getAttribute('data-maxQuantity');
					selectLotNumber = scannedText;
					
					$('#mi_lotNumber').val(scannedText);
					searchProductByLotNum(scannedText);
					checkBeforeMove();
				} else {
					Swal.fire('경고', '카트에 없는 상품입니다.', 'warning');
				}
				
//				resetQuantity();
//				checkInventory();
			} else { // QR코드에 LOT가없을때 location입력
				$('#mi_locationName').val(scannedText);
				isLocationExist(scannedText);
				checkBeforeMove();
				$('#mi_locationName').blur();
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


