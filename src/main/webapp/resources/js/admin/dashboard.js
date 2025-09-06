// inboundChart.js

document.addEventListener('DOMContentLoaded', () => {
	
    // 샘플 수신 데이터 (총 발주 수량 포함, 폐기 수량 명시)
    let inboundRawData = [    ];
	let needData = null;
	let overallChart = null;    // 누적 막대그래프
	let categoryChart = null; // 누적막대그래프 분해
	let productChart = null; // 도넛차트
	let savedCategoryData = null;
	let savedDetailRows = null;   
	let currentSelectedDate = null;
	let startDate = null;
	let endDate = null;
	
	//날짜인풋
	const dateInput = document.getElementById('baseDate');
    // 초기 버튼 스타일 설정
    const defaultBtn = document.querySelector('.btn-group .btn[data-period="daily"]');
    
	if (defaultBtn) {
		needData = defaultBtn.getAttribute('data-period');
		printSelectedDate();
        defaultBtn.classList.add('btn-primary');
        defaultBtn.classList.remove('btn-secondary');
		getDayInbound().then( () => {
			const firstChartData = processChartData(inboundRawData);
			upgradeOverallChart(firstChartData);
		});
	}
	
	
	function printSelectedDate() {
        let selectedDate = dateInput.value;
		if(!selectedDate){
			const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
            dateInput.value = today;
            selectedDate = today;
		}
        calculateDateRange(selectedDate, needData);
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
			printSelectedDate()
			getDayInbound().then(() =>{
				const firstChartData = processChartData(inboundRawData);
				upgradeOverallChart(firstChartData);
			})
        });
    });

	
	// 데이터 가공 함수 (upgradeOverallChart 함수 위에 추가)
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
	//누적막대그래프차트 생성[제일왼쪽]
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
        
        overallChart = new Chart(ctx, {
	        type: 'bar',
	        data: chartData,
	        options: {
	            responsive: true,
	            scales: {
	                x: { stacked: true },
	                y: { stacked: true, beginAtZero: true }
	            },
				onClick: (event, elements) => {
					if (!elements.length) return;
					
					console.log(elements);
					const idx = elements[0].index;
	                const dateKey = overallChart.data.labels[idx];
					$("#inbound_title").html(`${dateKey} 카테고리별 입고현황`);
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
	
	// 카테고리차트데이터로 변환 함수
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
	
	// 입고 카테고리별 차트생성 함수
	function upgradeCategoryChart(inputData){
	    if (overallChart) {
	        overallChart.destroy();
	    }
	    if (productChart) {
	        productChart.destroy();
	    }
	    
	    const ctx2 = document.getElementById('IBoverallChart').getContext('2d');
	    
	    categoryChart = new Chart(ctx2, {
	        type: 'bar',
	        data: inputData,
	        options: {
	            responsive: true,
	            scales: {
	                x: { stacked: true },
	                y: { stacked: true, beginAtZero: true }
	            },
	            plugins: {
	                title: {
	                    display: true,
	                    text: '카테고리별 입고 현황'
	                }
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
	
	//도넛그래프 데이터
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
	
	//도넛색상생성함수
	function generateColors(count) {
	    const colors = [
	        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', 
	        '#9966FF', '#FF9F40', '#C9CBCF', '#4BC0C0',
	        '#FF6384', '#36A2EB'  
	    ];
	    return colors.slice(0, count);
	}
	
	//도넛차트만들기
	function upgradeProductChart(inputData, categoryName, selectedDate) {
	    // 기존 차트 제거
	    if (productChart) {
	        productChart.destroy();
	    }
		if(categoryChart) {
			categoryChart.destroy();
		}
	    
	    const ctx3 = document.getElementById('IBoverallChart').getContext('2d');
	    
	    productChart = new Chart(ctx3, {
	        type: 'doughnut',
	        data: inputData,
	        options: {
	            responsive: true,
				aspectRatio:2,
	            plugins: {
	                title: {
	                    display: true,
	                    text: `${selectedDate} > ${categoryName} 제품별 분포`
	                },
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
		
});