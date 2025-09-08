// inboundChart.js

document.addEventListener('DOMContentLoaded', () => {
	
	const statistics1 = document.getElementById("statistics1");
	const statistics2 = document.getElementById("statistics2");
	
	statistics1.addEventListener('click', () =>{
		window.location.href = "/admin/statistics1"		
	});
	statistics2.addEventListener('click', () =>{
		window.location.href = "/admin/statistics2"		
	});
	
	getInventory().then(()=>{
		const InventoryChartData = processInventoryData(inventoryRawData);
		drawInventoryChart(InventoryChartData);
	})
	
	//전역변수
	// 재고차트에 필요한 변수들
    let inventoryRawData = [    ];
	let inventoryProductChart = null;    // 상품별막대그래프
	let categoryChart = null; // 카테고리 누적막대
	let productChart = null; // 도넛차트
	
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

	//inventoryRawData에 넣을 데이터 가져오기
	function getInventory(){
		return ajaxGet(`/admin/dashboard/inventory`)
			.then((data)=>{
				console.log(data);
				inventoryRawData = data;
			}).catch((data)=>{
				console.log("error " + data)	
			})
	}

	// 재고데이터 가공 함수
	function processInventoryData(rawData) {
	    const grouped = {};
	    
	    // 날짜별로 데이터 집계
	    rawData.forEach(item => {
	        // period에 따라 key 결정
	        let key = item.categoryName || '기타';
	        const inventoryQTY = item.inventoryQTY || 0;      //카테고리별재고량

	        if (!key) return; // null인 경우 건너뜀
	        
	        if (grouped[key]) {
	            grouped[key] += inventoryQTY;
	        } else {
	            grouped[key] = inventoryQTY;
	        }
	    });
	    
	    // 날짜 정렬
	    console.log(grouped);
	    const sorted = Object.entries(grouped).sort((a, b) => b[1] - a[1]);
		const labels = sorted.map(([category]) => category);
		const data = sorted.map(([_, qty]) => qty);
	    // Chart.js 형태로 변환
	    return { labels, data };
	}
	
	//카테고리별 재고차트그리기
	function drawInventoryChart({ labels, data }) {
	    const ctx = document.getElementById('inventory_chart').getContext('2d');
	
	    new Chart(ctx, {
	        type: 'bar',
	        data: {
	            labels: labels,
	            datasets: [{
	                label: '카테고리별 재고 수량',
	                data: data,
	                backgroundColor: 'rgba(75, 192, 192, 0.6)',
	                borderColor: 'rgba(75, 192, 192, 1)',
	                borderWidth: 1
	            }]
	        },
	        options: {
	            responsive: true,
				aspectRatio: 4,
				maintainAspectRatio: false,
	            plugins: {
	                title: {
	                    display: true, text: '카테고리별 재고 현황'
	                },
	                tooltip: {
	                    callbacks: {
	                        label: function(context) {
	                            return `${context.label}: ${context.parsed.y}개`;
	                        }
	                    }
	                },
	                datalabels: {
		                anchor: 'end',
		                align: 'top',
		                formatter: function(value) {
		                    return `${value}개`;
		                },
		                font: {
		                    weight: 'bold'
		                },
		                color: '#333'
		            }
	            },
	            scales: {
	                y: {
	                    beginAtZero: true,
	                    title: {
	                        display: true, text: '수량'
	                    }
	                },
	                x: {
	                    title: {
	                        display: true, text: '카테고리'
	                    }
	                }
	            },
				onClick: function(event, elements) {
				    if (elements.length > 0) {
				        const clickedIndex = elements[0].index;
				        const categoryName = this.data.labels[clickedIndex];
				
				        console.log("클릭된 카테고리:", categoryName);
				        showProductChart(categoryName);
				    }
				}
	        },
			plugins: [ChartDataLabels]
	    });
	}
	
	//선택한 카테고리 막대차트에서 상품별차트그리기
	function showProductChart(categoryName) {
	    const filtered = inventoryRawData.filter(item => item.categoryName === categoryName);
	
	    const productMap = {};
	    filtered.forEach(item => {
	        const name = item.productName || '이름없음';
	        const qty = Number(item.inventoryQTY) || 0;
	
	        if (productMap[name]) {
	            productMap[name] += qty;
	        } else {
	            productMap[name] = qty;
	        }
	    });
	
	    const labels = Object.keys(productMap);
	    const data = Object.values(productMap);
	
	    drawProductChart({ labels, data, categoryName });
	}
	
	//상품별 차트 그리기
	function drawProductChart({ labels, data, categoryName }) {
	    if (inventoryProductChart) {
	        inventoryProductChart.destroy();
	    }
		
	    const ctx = document.getElementById('inventory_detail_chart').getContext('2d');
	
	    inventoryProductChart = new Chart(ctx, {
	        type: 'bar',
	        data: {
	            labels: labels,
	            datasets: [{
	                label: `상품 갯수`,
	                data: data,
	                backgroundColor: 'rgba(255, 159, 64, 0.6)',
	                borderColor: 'rgba(255, 159, 64, 1)',
	                borderWidth: 1
	            }]
	        },
	        options: {
	            responsive: true,
				aspectRatio: 4,
				maintainAspectRatio: false,
	            plugins: {
	                title: {
	                    display: true,
	                    text: `${categoryName} 카테고리 상세`
	                },
					datalabels: {
	                    anchor: 'end',
	                    align: 'top',
	                    formatter: function(value) {
	                        return `${value}개`;
	                    },
	                    font: {
	                        weight: 'bold'
	                    },
	                    color: '#333'
	                }
	            },
	            scales: {
	                y: {
	                    beginAtZero: true
	                }
	            }
	        },
			plugins: [ChartDataLabels]
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
				aspectRatio: 4,
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
				aspectRatio: 4,
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
	            aspectRatio: 4,
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
	            aspectRatio: 4,
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
	            aspectRatio: 4,
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
	
	// 폐기량 데이터 불러오기
	function getDisposalData(){
		return ajaxGet(`/admin/dashboard/disposal/${needData}?startDate=${startDate}&endDate=${endDate}`
			)
			.then((data)=>{
				console.log("어어엉어",data)
				disposalRawData = data;
			}).catch((data)=>{
				console.log("error " + data)	
			})
	}
	
	function processDisposalChartData(rawData) {
	    const grouped = {};
	
	    rawData.forEach(item => {
	        let dateKey = null;
	
	        if (needData === 'daily') {
	            dateKey = item.disposalDate;
	        } else if (needData === 'weekly') {
	            dateKey = item.disposalWeek;
	        } else if (needData === 'monthly') {
	            dateKey = item.disposalMonth;
	        }
	
	        const section = item.section;
	        const quantity = item.disposalQuantity || 0;
	
	        if (!dateKey || !section) return;
	
	        if (!grouped[section]) grouped[section] = {};
	        if (!grouped[section][dateKey]) grouped[section][dateKey] = 0;
	
	        grouped[section][dateKey] += quantity;
	    });
	
	    const allDates = new Set();
	    Object.values(grouped).forEach(sectionData => {
	        Object.keys(sectionData).forEach(date => allDates.add(date));
	    });
	
	    const sortedDates = Array.from(allDates).sort();
	
	    const datasets = Object.entries(grouped).map(([section, dateMap]) => ({
	        label: section,
	        data: sortedDates.map(date => dateMap[date] || 0),
	        borderColor: getSectionColor(section),
	        backgroundColor: getSectionColor(section),
	        fill: false,
	        tension: 0.3
	    }));
	
	    return {
	        labels: sortedDates,
	        datasets
	    };
	}
	
	//꺽은선색
	function getSectionColor(section) {
	    const colors = {
	        INBOUND: '#36A2EB',
	        INVENTORY: '#FFCE56',
	        OUTBOUND: '#4BC0C0',
	        TRANSPORT: '#FF6384',
	        DEFAULT: '#999'
	    };
	    return colors[section] || colors.DEFAULT;
	}
	
	//폐기꺽은선차트 그리기함수
	function renderDisposalChart(chartData) {
		if (disposalChart) {
	        disposalChart.destroy();
	    }
		
	    const ctx = document.getElementById('disposalChart').getContext('2d');
	    if (!chartData || !chartData.labels || chartData.labels.length === 0) {
	        handleEmptyData(ctx, '해당 기간에 폐기 데이터가 없습니다');
	        return;
	    }
	    disposalChart = new Chart(ctx, {
	        type: 'line',
	        data: chartData,
	        options: {
	            responsive: true,
	            aspectRatio: 4,
	            plugins: {
	                title: {
	                    display: true,
	                    text: '공정별 폐기량 추이'
	                },
	                legend: {
	                    position: 'bottom'
	                },
	                tooltip: {
	                    mode: 'index',
	                    intersect: false
	                }
	            },
	            interaction: {
	                mode: 'nearest',
	                axis: 'x',
	                intersect: false
	            },
	            scales: {
	                x: {
	                    title: {
	                        display: true,
	                        text: needData === 'daily' ? '일자' :
	                              needData === 'weekly' ? '주차' : '월'
	                    }
	                },
	                y: {
	                    title: {
	                        display: true,
	                        text: '폐기량'
	                    },
	                    beginAtZero: true
	                }
	            }
	        }
	    });
	}
	

	
	
	
});