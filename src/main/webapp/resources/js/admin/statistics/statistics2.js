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
	//재고정보불러오기
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
	
	
	// ----------------------------------------------------------
	// 히트맵
	//inventoryRawData에 넣을 데이터 가져오기
	let locationRawData = [    ];
	let pickingZoneData = [];
	let palletZoneData = [];
	//창고정보가져오고나서 피킹존, 파레트존 분배
	getlocation().then(() => {
		pickingZoneData = locationRawData.filter(d => d.locationType === 2); // 피킹존
		palletZoneData = locationRawData.filter(d => d.locationType === 1);  // 파레트존

		// 필요한 후속 작업 수행
		console.log('피킹존:', pickingZoneData);
		console.log('파레트존:', palletZoneData);
	});
	
	function getlocation(){
		return ajaxGet(`/admin/dashboard/locationUse`)
			.then((data)=>{
				console.log(data);
				locationRawData = data;
			}).catch((data)=>{
				console.log("error " + data)	
			})
	}
	
	
    // 박스에 들어갈 데이터 정의
    const data = [
        {
            rack: 'A', bay: '01', level: 'a1', volumeRate: 75,
            items: [
                { name: '상품A', quantity: 12 },
                { name: '상품B', quantity: 5 }
            ]
        },
        {
            rack: 'A', bay: '01', level: 'b1', volumeRate: 40,
            items: [
                { name: '상품C', quantity: 20 }
            ]
        }
    ];

    // SVG 영역 크기 설정
    const svgWidth = 800;
    const svgHeight = 600;
    const boxSize = 50; // 박스 하나의 크기

    // SVG 요소 생성
    const svg = d3.select("#heatmap")
        .append("svg")
        .attr("width", svgWidth)
        .attr("height", svgHeight);

    // 용적율에 따라 색상을 결정하는 색상 스케일 정의
    const colorScale = d3.scaleThreshold()
        .domain([30, 50, 70, 90, 100]) // 기준 구간
        .range(["#2196F3", "#4CAF50", "#FFEB3B", "#FF9800", "#F44336"]); // 각 구간에 대응하는 색상

    // level과 rack의 순서를 정의 (좌표 계산용)
    const levelOrder = ['a1', 'a2', 'b1', 'b2', 'c1', 'c2'];
    const rackOrder = ['A', 'B', 'C'];

    // 툴팁 요소 선택
    const tooltip = d3.select("#tooltip");

    // 데이터 순회하면서 박스와 텍스트 생성
    data.forEach((d) => {
        // x, y 좌표 계산: rack과 level의 인덱스를 기반으로 위치 결정
        const x = 100 + rackOrder.indexOf(d.rack) * (boxSize + 10);
        const y = 100 + levelOrder.indexOf(d.level) * (boxSize + 10);

        // 박스와 텍스트를 함께 묶을 그룹 생성
        const group = svg.append("g")
            .attr("transform", `translate(${x}, ${y})`);

        // 박스(rect) 생성
        group.append("rect")
            .attr("width", boxSize)
            .attr("height", boxSize)
            .attr("fill", colorScale(d.volumeRate)) // 용적율에 따라 색상 지정
            .attr("stroke", "black") // 테두리
            .on("mouseover", function(event) {
                // 마우스를 올렸을 때 툴팁 표시
                const itemList = d.items.map(item => `${item.name} (${item.quantity}개)`).join('<br/>');

                tooltip.style("display", "block")
                    .html(`<strong>${d.rack}-${d.bay}-${d.level}</strong><br/>
                           용적율: ${d.volumeRate}%<br/>
                           물품:<br/>${itemList}`);
            })
            .on("mousemove", function(event) {
                // 마우스 움직일 때 툴팁 위치 따라다님
                tooltip.style("left", (event.pageX + 10) + "px")
                       .style("top", (event.pageY + 10) + "px");
            })
            .on("mouseout", function() {
                // 마우스가 박스를 벗어나면 툴팁 숨김
                tooltip.style("display", "none");
            });

        // 박스 중앙에 텍스트 표시
        group.append("text")
            .attr("x", boxSize / 2)
            .attr("y", boxSize / 2)
            .attr("text-anchor", "middle") // 가운데 정렬
            .attr("dominant-baseline", "middle") // 수직 가운데 정렬
            .attr("fill", "white") // 글자색
            .text(`${d.rack}-${d.bay}-${d.level}\n${d.volumeRate}%`); // 표시할 텍스트
    });
	
	
	

	
	
	
});