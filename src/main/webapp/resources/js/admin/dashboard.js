// inboundChart.js

document.addEventListener('DOMContentLoaded', () => {
	//전역변수
	// 그래프 범위 날짜 구하기
	let startDate = null;
	let endDate = null;
	let needData = null;
	
	// 입고차트에 필요한 변수들
    let inboundRawData = [    ];
	let overallChart = null;    // 누적 막대그래프
	let categoryChart = null; // 카테고리 누적막대
	let productChart = null; // 도넛차트
	
	let savedCategoryData = null; //카테고리 누적막대 정보저장
	let savedDetailRows = null;   
	let currentSelectedDate = null; // 선택한 날짜 저장
	
	// 출고 차트에 필요한 변수들
	let outboundRawData = [    ];
	let oubboundOverallchart = null;
	let outboundCategoryChart = null;
	let outboundProductChart = null;
	
	let savedOutboundCategoryData = null;
	let savedOutboundDetailRows = null;
	let outboundCurrentSelectedDate = null; 
	
	//날짜인풋
	const dateInput = document.getElementById('baseDate');
    // 초기 버튼 스타일 설정
    const defaultBtn = document.querySelector('.btn-group .btn[data-period="daily"]');
    //처음 버튼선택, 초기값 설정
	if (defaultBtn) {
		needData = defaultBtn.getAttribute('data-period');
		printSelectedDate();
        defaultBtn.classList.add('btn-primary');
        defaultBtn.classList.remove('btn-secondary');
		getOutboundData().then(() =>{
			const OutboundChartData = outboundProcessChartData(outboundRawData);
			console.log("출고데이터",OutboundChartData);
			upgradeOutboundOverallChart(OutboundChartData);
		});
		getDayInbound().then( () => {
			const firstChartData = processChartData(inboundRawData);
			upgradeOverallChart(firstChartData);
		});
	}
	
	//날짜선택함수
	function printSelectedDate() {
        let selectedDate = dateInput.value;
		if(!selectedDate){
			const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
            dateInput.value = today;
            selectedDate = today;
		}
        calculateDateRange(selectedDate, needData);
		document.getElementById("dateRangeInfo")
			.innerHTML = `${startDate} ~ ${endDate}`;
    }

	dateInput.addEventListener('change', () => {
		printSelectedDate();
	});
	
	//날짜 범위 계산
	function calculateDateRange(endD, period) {
	    const end = new Date(endD);
	    const start = new Date(endD);
	    if (period === 'daily') {
	        start.setDate(start.getDate() - 15);  // 15일 전
	    } else if (period === 'weekly') {
	        start.setDate(start.getDate() - (8 * 7));  // 8주 전 (56일)
	    } else if (period === 'monthly') {
	        start.setMonth(start.getMonth() - 12);  // 12개월 전
	    }
	    
	    startDate = start.toISOString().split('T')[0];
		endDate = end.toISOString().split('T')[0];
	}
	
    // 기간 버튼 클릭 이벤트 (TODO: AJAX 호출 및 데이터 재집계 로직으로 확장 가능)
    document.querySelectorAll('.btn-group .btn').forEach(button => {
        button.addEventListener('click', () => {
			//버튼선택시 표시
            const period = button.getAttribute('data-period');
			needData = period;
            document.querySelectorAll('.btn-group .btn').forEach(btn => {
                btn.classList.remove('btn-primary');
                btn.classList.add('btn-secondary');
            });
            button.classList.add('btn-primary');
            button.classList.remove('btn-secondary');
			//날짜범위선택
			printSelectedDate()
			//입고정보조회후 차트그리기
			getOutboundData().then(()=>{
				const OutboundChartData = outboundProcessChartData(outboundRawData);
				upgradeOutboundOverallChart(OutboundChartData);
			});
			getDayInbound().then(() =>{
				const firstChartData = processChartData(inboundRawData);
				upgradeOverallChart(firstChartData);
			})
        });
    });
	
	// 데이터 검증 및 빈 데이터 처리 함수
	function handleEmptyData(ctx, message) {
	    // 캔버스 초기화
	    ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
	    
	    // 텍스트 스타일 설정
	    ctx.font = '18px Arial';
	    ctx.fillStyle = '#6c757d';
	    ctx.textAlign = 'center';
	    ctx.textBaseline = 'middle';
	    
	    // 메시지 출력 (캔버스 중앙)
	    const centerX = ctx.canvas.width / 2;
	    const centerY = ctx.canvas.height / 2;
	    ctx.fillText(message, centerX, centerY);
	}

	//inboundRawData에 넣을 데이터 가져오기
	function getDayInbound(){
		return ajaxGet(`/admin/dashboard/inbound/${needData}?startDate=${startDate}&endDate=${endDate}`
			)
			.then((data)=>{
				inboundRawData = data;
			
			}).catch((data)=>{
				console.log("error " + data)	
			})
	}

	
	// 데이터 가공 함수
	function processChartData(rawData) {
	    const grouped = {};
	    
	    // 날짜별로 데이터 집계
	    rawData.forEach(item => {
	        // period에 따라 key 결정
	        let key = null;
	        if (needData === 'daily') {
	            key = item.arrivalDate;       
	        } else if (needData === 'weekly') {
	            key = item.arrivalMonthWeek;    
	        } else if (needData === 'monthly') {
	            key = item.arrivalMonth;       
	        }
	        
	        if (!key) return; // null인 경우 건너뜀
	        
	        const ibwquantity = item.ibwquantity || 0;      // 입고대기량
	        const riquantity = item.riquantity || 0;        // 입고완료량  
	        const disposalQuantity = item.disposalQuantity || 0; // 폐기량
	        
	        // 계산
	        const 미입고 = Math.max(0, ibwquantity - riquantity);           // 음수 방지
	        const 입고완료 = Math.max(0, riquantity - disposalQuantity);      // 음수 방지
	        const 폐기 = disposalQuantity;
	        
	        if (!grouped[key]) {
	            grouped[key] = { 미입고: 0, 입고완료: 0, 폐기: 0 };
	        }
	        
	        grouped[key].미입고 += 미입고;
	        grouped[key].입고완료 += 입고완료; 
	        grouped[key].폐기 += 폐기;
	    });
	    
	    // 날짜 정렬
	    const dates = Object.keys(grouped).sort();
	    console.log(grouped);
	    // Chart.js 형태로 변환
	    return {
	        labels: dates,  // X축: 날짜들
	        datasets: [
	            {
	                label: '입고완료', 
	                data: dates.map(date => grouped[date].입고완료),
	                backgroundColor: '#4BC0C0'  // 청록색
	            },
	            {
	                label: '폐기',
	                data: dates.map(date => grouped[date].폐기),
	                backgroundColor: '#FF6384'  // 빨간색
	            },
	            {
	                label: '미입고',
	                data: dates.map(date => grouped[date].미입고),
	                backgroundColor: '#FFCE56'  // 노란색
	            }
	        ]
	    };
	}
	
	//누적막대그래프차트 생성[입고]
	function upgradeOverallChart(inputData){
        // 기존 차트 제거
	    if (overallChart) {
	        overallChart.destroy();
	    }
	    if (categoryChart) {
	        categoryChart.destroy();
	    }
	    if (productChart) {
	        productChart.destroy();
	    }

        $("#inbound_title").html(`입고현황`);

        // 중첩막대그래프 [입고]
        const ctx = document.getElementById('IBoverallChart').getContext('2d');
        
        // 차트 데이터 (나중에 가공된 데이터로 교체 예정)
        const chartData = inputData;
        if(!inputData || !inputData.labels || inputData.labels.length === 0){
			handleEmptyData(ctx, '해당 기간에 입고 데이터가 없습니다');
			return;
		}
		
        overallChart = new Chart(ctx, {
	        type: 'bar',
	        data: chartData,
	        options: {
	            responsive: true,
				aspectRatio: 3,
	            scales: {
	                x: { stacked: true },
	                y: { stacked: true, beginAtZero: true }
	            },
				onClick: (event, elements) => {
					if (!elements.length) return;
					
					console.log(elements);
					const idx = elements[0].index;
	                const dateKey = overallChart.data.labels[idx];
					
	                // 상세 데이터 필터링
	                let detailRows = null;
	                if(needData == 'daily'){
	                    detailRows = inboundRawData.filter(rec => rec.arrivalDate === dateKey);
	                } else if (needData == 'weekly'){
	                    detailRows = inboundRawData.filter(rec => rec.arrivalMonthWeek === dateKey);
	                } else {
	                    detailRows = inboundRawData.filter(rec => rec.arrivalMonth === dateKey);
	                }
	
					const newdata = categoryData(detailRows);
					
					savedCategoryData = newdata;
			        savedDetailRows = detailRows;
			        currentSelectedDate = dateKey;

					upgradeCategoryChart(savedCategoryData);
		        }
			}
	    });
	}
	
	// 카테고리차트데이터로 변환 함수[입고]
	function categoryData(detailRows){
		const grouped = {};
	    
	    // 카테고리별로 데이터 집계
	    detailRows.forEach(item => {
	        const key = item.categoryName;  // 🔑 날짜 대신 카테고리명을 키로 사용
	        
	        if (!key) return; // categoryName이 없으면 건너뜀
	        
	        const ibwquantity = item.ibwquantity || 0;      // 입고대기량
	        const riquantity = item.riquantity || 0;        // 입고완료량  
	        const disposalQuantity = item.disposalQuantity || 0; // 폐기량
	        
	        // 계산 (원래 processChartData와 동일한 로직)
	        const 미입고 = Math.max(0, ibwquantity - riquantity);           
	        const 입고완료 = Math.max(0, riquantity - disposalQuantity);      
	        const 폐기 = disposalQuantity;
	        
	        if (!grouped[key]) {
	            grouped[key] = { 미입고: 0, 입고완료: 0, 폐기: 0 };
	        }
	        
	        grouped[key].미입고 += 미입고;
	        grouped[key].입고완료 += 입고완료; 
	        grouped[key].폐기 += 폐기;
	    });
	    
	    // 카테고리명 정렬
	    const categories = Object.keys(grouped).sort();
	    
	    console.log('카테고리별 집계:', grouped);
	    
	    // Chart.js 형태로 변환
	    return {
	        labels: categories,  // X축: 카테고리명
	        datasets: [
	            {
	                label: '입고완료', 
	                data: categories.map(category => grouped[category].입고완료),
	                backgroundColor: '#4BC0C0'  // 청록색
	            },
	            {
	                label: '폐기',
	                data: categories.map(category => grouped[category].폐기),
	                backgroundColor: '#FF6384'  // 빨간색
	            },
	            {
	                label: '미입고',
	                data: categories.map(category => grouped[category].미입고),
	                backgroundColor: '#FFCE56'  // 노란색
	            }
	        ]
	    };
		
	};
	
	//  카테고리별 차트생성 함수[입고]
	function upgradeCategoryChart(inputData){
	    if (overallChart) {
	        overallChart.destroy();
	    }
	    if (productChart) {
	        productChart.destroy();
	    }
	    
	    const ctx2 = document.getElementById('IBoverallChart').getContext('2d');
	    
		$("#inbound_title").html(`${currentSelectedDate} 카테고리별 입고현황`);
		
	    categoryChart = new Chart(ctx2, {
	        type: 'bar',
	        data: inputData,
	        options: {
	            responsive: true,
				aspectRatio: 3,
	            scales: {
	                x: { stacked: true },
	                y: { stacked: true, beginAtZero: true }
	            },
	            onClick: (event, elements) => {
	                if (!elements.length) return;
	                
	                const idx = elements[0].index;
	                const categoryKey = categoryChart.data.labels[idx];
	                
				    // 해당 카테고리의 제품들만 필터링
				    const categoryProducts = savedDetailRows.filter(item => 
				        item.categoryName === categoryKey
				    );

					const donutData = productDonutData(categoryProducts);
					upgradeProductChart(donutData, categoryKey, currentSelectedDate);
	            }
	        }
	    });
		
	};
	
	//도넛그래프 데이터[입고]
	function productDonutData(categoryProducts){
		const productGrouped = {};
		let totalDisposal = 0;
	    
	    // 제품별로 수량 집계
	    categoryProducts.forEach(item => {
	        const productName = item.productName;  // 제품명
	        const quantity = item.riquantity || 0; // 입고완료량 (또는 다른 기준)
        	const disposalQuantity = item.disposalQuantity || 0; // 폐기량
			const netInbound = Math.max(0, quantity - disposalQuantity);
			
	        if (!productGrouped[productName]) {
	            productGrouped[productName] = 0;
	        }
	        
	        productGrouped[productName] += netInbound;
	        totalDisposal += disposalQuantity;
	    });
	    
	    // 제품명과 수량 배열 생성
	    const products = Object.keys(productGrouped);
	    const quantities = products.map(product => productGrouped[product]);
	    
		const labels = [...products, '폐기'];
    	const data = [...quantities, totalDisposal];

	    // 색상 배열 생성 (제품 수만큼)
	    const productColors = generateColors(products.length);
   		const colors = [...productColors, '#FFF']; // 폐기는 빨간색

	    // Chart.js 도넛차트 형식으로 변환
	    return {
	        labels: labels,
	        datasets: [{
	            data: data,
	            backgroundColor: colors,
	            borderWidth: 2,
	            borderColor: '#fff'
	        }]
	    };
	};
	
	//도넛색상생성함수[입고]
	function generateColors(count) {
	    const colors = [
	        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', 
	        '#9966FF', '#FF9F40', '#C9CBCF', '#4BC0C0',
	        '#FF6384', '#36A2EB'  
	    ];
	    return colors.slice(0, count);
	}
	
	//도넛차트만들기[입고]
	function upgradeProductChart(inputData, categoryName, selectedDate) {
	    // 기존 차트 제거
	    if (productChart) {
	        productChart.destroy();
	    }
		if(categoryChart) {
			categoryChart.destroy();
		}
	    
	    const ctx3 = document.getElementById('IBoverallChart').getContext('2d');
		$("#inbound_title").html(`${selectedDate} > ${categoryName} 카테고리별 입고상품 제품별 분포`);
	    productChart = new Chart(ctx3, {
	        type: 'doughnut',
	        data: inputData,
	        options: {
	            responsive: true,
				aspectRatio: 3,
				radius: 70,
				cutout: '20%',
	            plugins: {
	                legend: {
	                    position: 'right',  // 범례를 오른쪽에 배치
	                },
	                // 퍼센테이지 표시
	                tooltip: {
	                    callbacks: {
	                        label: function(context) {
	                            const label = context.label || '';
	                            const value = context.raw;
	                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
	                            const percentage = ((value / total) * 100).toFixed(1);
	                            return `${label}: ${value}개 (${percentage}%)`;
	                        }
	                    }
	                }
	            },
	            // 도넛차트 클릭 이벤트 (필요시)
	            onClick: (event, elements) => {
	                if (!elements.length) return;
	                
	                const idx = elements[0].index;
	                const productName = productChart.data.labels[idx];
	                
	                upgradeCategoryChart(savedCategoryData);

	            }
	        }
	    });
	}
	
	
	//outboundRawData에 넣을 데이터 가져오기
	function getOutboundData(){
		return ajaxGet(`/admin/dashboard/outbound/${needData}?startDate=${startDate}&endDate=${endDate}`
			)
			.then((data)=>{
				console.log(data);
				outboundRawData = data;
			
			}).catch((data)=>{
				console.log("error " + data)	
			})
	}
	
	//출고현황 그래프에 넣을 데이터 가공
	function outboundProcessChartData(rawData) {
	    const grouped = {};
	
	    rawData.forEach(item => {
	        let key = null;
	        if (needData === 'daily') {
	            key = item.transportDate;
	        } else if (needData === 'weekly') {
	            key = item.transportWeek;
	        } else if (needData === 'monthly') {
	            key = item.transportMonth;
	        }
	
	        if (!key) return;
	
	        const obQuantity = item.oboquantity || 0;
	        const diQuantity = item.diquantity || 0;
	        const disposalQuantity = item.disposalQuantity || 0;
	
	        const 미출고 = Math.max(0, obQuantity - diQuantity - disposalQuantity);
	        const 수주완료 = diQuantity;
	        const 폐기 = disposalQuantity;
	
	        if (!grouped[key]) {
	            grouped[key] = { 미출고: 0, 수주완료: 0, 폐기: 0 };
	        }
	
	        grouped[key].미출고 += 미출고;
	        grouped[key].수주완료 += 수주완료;
	        grouped[key].폐기 += 폐기;
	    });
	
	    const dates = Object.keys(grouped).sort();
	    return {
	        labels: dates,
	        datasets: [
	            {
	                label: '수주완료',
	                data: dates.map(date => grouped[date].수주완료),
	                backgroundColor: '#4BC0C0'
	            },
	            {
	                label: '폐기',
	                data: dates.map(date => grouped[date].폐기),
	                backgroundColor: '#FF6384'
	            },
	            {
	                label: '미출고',
	                data: dates.map(date => grouped[date].미출고),
	                backgroundColor: '#FFCE56'
	            }
	        ]
	    };
	}
	
	// 가공된 출고데이터 차트로 출력
	function upgradeOutboundOverallChart(inputData) {
	    // 기존 차트 제거
	    if (oubboundOverallchart) {
	        oubboundOverallchart.destroy();
	    }
	    if (outboundCategoryChart) {
	        outboundCategoryChart.destroy();
	    }
	    if (outboundProductChart) {
	        outboundProductChart.destroy();
	    }
	
	    $("#outbound_title").html(`출고/운송 현황`);
	
	    const ctx = document.getElementById('OBoverallChart').getContext('2d');
	    if (!inputData || !inputData.labels || inputData.labels.length === 0) {
	        handleEmptyData(ctx, '해당 기간에 출고/운송 데이터가 없습니다');
	        return;
	    }
	
	    oubboundOverallchart = new Chart(ctx, {
	        type: 'bar',
	        data: inputData,
	        options: {
	            responsive: true,
	            aspectRatio: 3,
	            scales: {
	                x: { stacked: true },
	                y: { stacked: true, beginAtZero: true }
	            },
	            onClick: (event, elements) => {
	                if (!elements.length) return;
	
	                const idx = elements[0].index;
	                const dateKey = oubboundOverallchart.data.labels[idx];
					outboundCurrentSelectedDate = dateKey;
	
	                let detailRows = null;
	                if (needData === 'daily') {
	                    detailRows = outboundRawData.filter(rec => rec.transportDate === dateKey);
	                } else if (needData === 'weekly') {
	                    detailRows = outboundRawData.filter(rec => rec.transportWeek === dateKey);
	                } else {
	                    detailRows = outboundRawData.filter(rec => rec.transportMonth === dateKey);
	                }
	
	                const newdata = outboundCategoryData(detailRows);
	                savedOutboundCategoryData = newdata;
	                savedOutboundDetailRows = detailRows;
	                outboundCurrentSelectedDate = dateKey;
	
	                upgradeOutboundCategoryChart(newdata);
	            }
	        }
	    });
	}
	// 출고 카테고리별 데이터 가공함수
	function outboundCategoryData(detailRows) {
	    const grouped = {};
	
	    detailRows.forEach(item => {
	        const key = item.categoryName;
	        if (!key) return;
	
	        const obQuantity = item.oboquantity || 0;
	        const diQuantity = item.diquantity || 0;
	        const disposalQuantity = item.disposalQuantity || 0;
	
	        const 미출고 = Math.max(0, obQuantity - diQuantity - disposalQuantity);
	        const 수주완료 = diQuantity;
	        const 폐기 = disposalQuantity;
	
	        if (!grouped[key]) {
	            grouped[key] = { 미출고: 0, 수주완료: 0, 폐기: 0 };
	        }
	
	        grouped[key].미출고 += 미출고;
	        grouped[key].수주완료 += 수주완료;
	        grouped[key].폐기 += 폐기;
	    });
	
	    const categories = Object.keys(grouped).sort();
		console.log(categories);
		console.log(categories.map(c => grouped[c].수주완료));
		console.log(categories.map(c => grouped[c].폐기));
		console.log(categories.map(c => grouped[c].미출고));
	    return {
	        labels: categories,
	        datasets: [
	            {
	                label: '수주완료',
	                data: categories.map(c => grouped[c].수주완료),
	                backgroundColor: '#4BC0C0'
	            },
	            {
	                label: '폐기',
	                data: categories.map(c => grouped[c].폐기),
	                backgroundColor: '#FF6384'
	            },
	            {
	                label: '미출고',
	                data: categories.map(c => grouped[c].미출고),
	                backgroundColor: '#FFCE56'
	            }
	        ]
	    };
	}
	// 카테고리별 누적차트[출고]
	function upgradeOutboundCategoryChart(inputData) {
	    // 기존 차트 제거
	    if (oubboundOverallchart) {
	        oubboundOverallchart.destroy();
	    }
	    if (outboundProductChart) {
	        outboundProductChart.destroy();
	    }
	    const ctx2 = document.getElementById('OBoverallChart').getContext('2d');


		outboundCategoryChart = new Chart(ctx2, {
	        type: 'bar',
	        data: inputData,
	        options: {
	            responsive: true,
	            aspectRatio: 3,
	            scales: {
	                x: { stacked: true },
	                y: { stacked: true, beginAtZero: true }
	            },
	            plugins: {
//	                title: {
//	                    display: true,
//	                    text: '카테고리별 출고/운송 현황'
//	                }
	            },
	            onClick: (event, elements) => {
	                if (!elements.length) return;
					
	                const idx = elements[0].index;
	                const categoryKey = outboundCategoryChart.data.labels[idx];
	
	                const categoryProducts = savedOutboundDetailRows.filter(item =>
	                    item.categoryName === categoryKey
	                );
	
	                const donutData = outboundProductDonutData(categoryProducts);
	                upgradeOutboundProductChart(donutData, categoryKey, outboundCurrentSelectedDate);
	            }
	        }
	    });		
		$("#outbound_title").html(`${outboundCurrentSelectedDate} 카테고리별 출고/운송 현황`);
	}
	
	//수주완료품목 도넛차트데이터가공[출고]
	function outboundProductDonutData(categoryProducts) {
	    const productGrouped = {};
	    let totalDisposal = 0;
	
	    categoryProducts.forEach(item => {
	        const productName = item.productName;
	        const diQuantity = item.diquantity || 0;
	        const disposalQuantity = item.disposalQuantity || 0;
	
	        // 폐기 포함한 수주완료 수량으로 집계
	        if (!productGrouped[productName]) {
	            productGrouped[productName] = 0;
	        }
	
	        productGrouped[productName] += diQuantity;
	        totalDisposal += disposalQuantity;
	    });
	
	    const products = Object.keys(productGrouped);
	    const quantities = products.map(product => productGrouped[product]);
	
	    const labels = [...products, '폐기'];
	    const data = [...quantities, totalDisposal];
	
	    const productColors = generateColors(products.length);
	    const colors = [...productColors, '#FFF']; // 폐기는 흰색으로 구분
	
	    return {
	        labels: labels,
	        datasets: [{
	            data: data,
	            backgroundColor: colors,
	            borderWidth: 2,
	            borderColor: '#fff'
	        }]
	    };
	}
	//도넛차트생성[출고]
	function upgradeOutboundProductChart(inputData, categoryName, selectedDate) {
	    // 기존 차트 제거
	    if (outboundProductChart) {
	        outboundProductChart.destroy();
	    }
	    if (outboundCategoryChart) {
	        outboundCategoryChart.destroy();
	    }
	
	    const ctx3 = document.getElementById('OBoverallChart').getContext('2d');
	
	    outboundProductChart = new Chart(ctx3, {
	        type: 'doughnut',
	        data: inputData,
	        options: {
	            responsive: true,
	            aspectRatio: 3,
	            radius: 70,
	            cutout: '20%',
	            plugins: {
//	                title: {
//	                    display: true,
//	                    text: `${selectedDate} > ${categoryName} 제품별 출고 분포`
//	                },
	                legend: {
	                    position: 'right'
	                },
	                tooltip: {
	                    callbacks: {
	                        label: function(context) {
	                            const label = context.label || '';
	                            const value = context.raw;
	                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
	                            const percentage = ((value / total) * 100).toFixed(1);
	                            return `${label}: ${value}개 (${percentage}%)`;
	                        }
	                    }
	                }
	            },
	            onClick: (event, elements) => {
	                if (!elements.length) return;
	
	                const idx = elements[0].index;
	                const productName = outboundProductChart.data.labels[idx];
	
	                // 도넛 클릭 시 카테고리 차트로 돌아가기
	                upgradeOutboundCategoryChart(savedOutboundCategoryData);
	            }
	        }
	    });
		$("#outbound_title").html(`${selectedDate} > ${categoryName} 카테고리별 출고/운송 상품분포`);

	}

	
		
});