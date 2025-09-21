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
//				console.log(data);
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
	let locationRawData = [];
	let pickingZoneData = [];
	let palletZoneData = [];
	let palletHeatmapData = [];
	let pickingHeatmapData = [];
	
	//창고정보가져오고나서 피킹존, 파레트존 분배
	getlocation().then(() => {
		pickingZoneData = locationRawData.filter(d => d.locationType === 2); // 피킹존
		palletZoneData = locationRawData.filter(d => d.locationType === 1);  // 파레트존
		pickingHeatmapData = buildHeatmapData(pickingZoneData);
		palletHeatmapData = buildHeatmapData(palletZoneData);
		drawHeatmap(palletHeatmapData, "#pallet_heatmap", "Pallet_Zone");
		drawHeatmap(pickingHeatmapData, "#picking_heatmap", "Picking_Zone");
		totalUsage();
	});
	
	//창고정보가져오기
	function getlocation(){
		return ajaxGet(`/admin/dashboard/locationUse`)
			.then((data)=>{
				locationRawData = data;
			}).catch((data)=>{
				console.log("error " + data)	
			})
	}
	
	
    // 박스에 들어갈 데이터 정의
	function buildHeatmapData(zoneData) {
	    const grouped = {};
	
	    zoneData.forEach(entry => {
	        const key = `${entry.rack}-${entry.bay}-${entry.levelPosition}`;
	        const volumeRate = calculateVolumeRate(entry);
	
	        if (!grouped[key]) {
	            grouped[key] = {
	                rack: entry.rack,
	                bay: entry.bay,
	                level: entry.levelPosition,
	                volumeRate: 0,
	                items: []
	            };
	        }
	
	        grouped[key].volumeRate += volumeRate;
	        grouped[key].items.push({
	            name: entry.productName || '상품없음',
	            quantity: entry.inventoryQTY || 0
	        });
	    });
	
	    return Object.values(grouped);
	}
	
	//존별 총사용량 체크함수
	function calculateUsage(zoneData) {
	    const valid = zoneData.filter(d =>
	        Number.isFinite(d.inventoryQTY) &&
	        Number.isFinite(d.productVolume) &&
	        Number.isFinite(d.locationVolume) &&
	        d.locationVolume > 0
	    );
	
	    if (valid.length === 0) return 0;
	
	    const totalRate = valid.reduce((sum, d) => {
	        const usedVolume = d.inventoryQTY * d.productVolume;
	        const rate = (usedVolume / d.locationVolume) * 100;
	        return sum + rate;
	    }, 0);
	
	    return Math.round(totalRate / valid.length);
	}
	
	function totalUsage(){
		const palletUsage = calculateUsage(palletZoneData);
		const pickingUsage = calculateUsage(pickingZoneData);
		
		const titleEl = document.getElementById("location_title");
		
		const usageInfo = document.createElement("span");
		usageInfo.innerHTML = `
		    <span style="margin-left: 12px; font-size: 14px; color: #555;">
		        🟦 파레트존: <strong>${palletUsage}%</strong> |
		        🟩 피킹존: <strong>${pickingUsage}%</strong>
		    </span>
		`;
		titleEl.appendChild(usageInfo);
		
	}
	
	
	
	
	//히트맵그리기
	function drawHeatmap(data, selector, zoneLabel) {
	    const boxSize = 50;
	    const gap = 10;
	    const margin = { top: 60, right: 40, bottom: 40, left: 60 };
	
	    if (!Array.isArray(data) || data.length === 0) return;
	
	    const getLevelNumber = (level) => {
	        const m = String(level ?? "").match(/\d+/);
	        return m ? Number(m[0]) : 0;
	    };
	
	    const toKeyParts = (v) => {
	        const s = String(v ?? "");
	        const m = s.match(/^([A-Za-z]+)?(\d+)?$/);
	        return {
	            prefix: (m && m[1]) ? m[1] : "",
	            num: (m && m[2]) ? Number(m[2]) : NaN,
	            raw: s
	        };
	    };

	    const naturalCompare = (a, b) => {
	        const A = toKeyParts(a);
	        const B = toKeyParts(b);
	        if (A.prefix !== B.prefix) return A.prefix.localeCompare(B.prefix);
	        const aHasNum = !Number.isNaN(A.num);
	        const bHasNum = !Number.isNaN(B.num);
	        if (aHasNum && bHasNum) return A.num - B.num;
	        if (aHasNum) return -1;
	        if (bHasNum) return 1;
	        return A.raw.localeCompare(B.raw);
	    };
	
	    const rackOrder = [...new Set(data.map(d => d.rack))].sort(naturalCompare);
	    const bayOrder = [...new Set(data.map(d => d.bay))].sort(naturalCompare);
	    const levelNumberOrder = [...new Set(data.map(d => getLevelNumber(d.level)))].sort((a, b) => a - b);
	
	    const cols = rackOrder.length * bayOrder.length;
	    const rows = levelNumberOrder.length;
	    const svgWidth = margin.left + cols * (boxSize + gap) - gap + margin.right;
	    const svgHeight = margin.top + rows * (boxSize + gap) - gap + margin.bottom;
	
	    const svg = d3.select(selector)
	        .append("svg")
	        .attr("width", svgWidth)
	        .attr("height", svgHeight);
		
		svg.append("text")
		    .attr("x", svgWidth / 2)
		    .attr("y", margin.top - 40)
		    .attr("text-anchor", "middle")
		    .attr("fill", "#333")
		    .attr("font-size", 16)
		    .attr("font-weight", "bold")
		    .text(zoneLabel);
	
	    const g = svg.append("g")
	        .attr("transform", `translate(${margin.left},${margin.top})`);
	
	    const colorScale = d3.scaleThreshold()
		    .domain([30, 50, 70, 80, 90, 100]) // 세분화된 구간
		    .range([
		        "#2196F3", // 0–30% → 파랑
		        "#4CAF50", // 30–50% → 초록
		        "#CDDC39", // 50–70% → 연두
		        "#FFEB3B", // 70–80% → 노랑
		        "#FF9800", // 80–90% → 주황
		        "#F44336", // 90–100% → 빨강
		        "#6A1B9A"  // 100% 초과 → 진한 보라 (과적)
		    ]);
	
	    const tooltip = d3.select("#tooltip");
	
	    const getXIndex = (rack, bay) => {
	        const rIdx = rackOrder.indexOf(rack);
	        const bIdx = bayOrder.indexOf(bay);
	        return rIdx * bayOrder.length + bIdx;
	    };
	
	    const positionKey = (d) => `${d.rack}|${d.bay}|${getLevelNumber(d.level)}`;
	    const groupsMap = new Map();
	    data.forEach(d => {
	        const key = positionKey(d);
	        if (!groupsMap.has(key)) groupsMap.set(key, []);
	        groupsMap.get(key).push(d);
	    });
	
	    const overlapOffsetStep = Math.round(-boxSize * 0.04); // 겹침 간격
		const fanoutOffsetStep = Math.round(boxSize * 0.4);   // 팬아웃 간격
		
		const getOffset = (i, mode = "overlap") => {
		    const step = mode === "fanout" ? fanoutOffsetStep : overlapOffsetStep;
		    return {
		        dx: -i * step,
		        dy: i * step
		    };
		};
		
	    for (const [key, items] of groupsMap.entries()) {
	        const [rack, bay, levelNumStr] = key.split("|");
	        const xIndex = getXIndex(rack, bay);
	        const yIndex = levelNumberOrder.indexOf(Number(levelNumStr));
	        if (xIndex < 0 || yIndex < 0) continue;
	
	        const baseX = xIndex * (boxSize + gap);
	        const baseY = yIndex * (boxSize + gap);
	
	        const sorted = items.slice().sort((a, b) => {
	            const ap = String(a.level).replace(/\d+/g, "");
	            const bp = String(b.level).replace(/\d+/g, "");
	            return ap.localeCompare(bp);
	        });
	
	        const group = g.append("g")
	            .attr("transform", `translate(${baseX},${baseY})`)
	            .on("pointerenter", function () {
					d3.select(this).raise();
	                d3.select(this).selectAll("g.cell")
	                    .transition()
	                    .duration(150)
	                    .attr("transform", (d, i) => `translate(${i * fanoutOffsetStep}, 0)`);
	            })
	            .on("pointerleave", function () {
	                d3.select(this).selectAll("g.cell")
	                    .transition()
	                    .duration(150)
	                    .attr("transform", (d, i) => {
						    const off = getOffset(i); // 겹침 간격 기준으로 복귀
						    return `translate(${off.dx}, ${off.dy})`;
						});
	                tooltip.style("display", "none");
	            });
	
	        sorted.forEach((d, i) => {
	            const volumeRate = Number.isFinite(d.volumeRate)
	                ? Math.max(0, d.volumeRate)
	                : 0;
	
	            const cell = group.append("g")
	                .attr("class", "cell")
	                .attr("transform", `translate(0, 0)`); // 기본 겹침
	
	            cell.append("rect")
	                .attr("width", boxSize)
	                .attr("height", boxSize)
	                .attr("rx", 4)
	                .attr("ry", 4)
	                .attr("fill", colorScale(volumeRate))
//	                .attr("fill-opacity", 1 - i * 0.15) // 겹침 순서에 따라 투명도
	                .attr("stroke", "#111")
	                .attr("stroke-width", 1)
	                .on("mouseover", function (event) {
	                    const itemList = (d.items || [])
	                        .map(item => `${item.name} (${item.quantity}개)`)
	                        .join('<br/>');
	                    tooltip
	                        .style("display", "block")
	                        .html(`<strong>${d.rack}-${d.bay}-${d.level}</strong><br/>
	                               용적률: ${volumeRate}%<br/>
	                               물품:<br/>${itemList}`);
	                })
	                .on("mousemove", function (event) {
	                    tooltip
	                        .style("left", (event.pageX + 10) + "px")
	                        .style("top", (event.pageY + 10) + "px");
	                });
	
	            const label = `${d.rack}-${d.bay}-${d.level}`;
	            const centerX = boxSize / 2;
	            const centerY = boxSize / 2 - 5;
				
				const off = getOffset(i, "overlap");
				cell.attr("transform", `translate(${off.dx}, ${off.dy})`);
				
	            const text = cell.append("text")
	                .attr("x", centerX)
	                .attr("y", centerY)
	                .attr("text-anchor", "middle")
	                .attr("dominant-baseline", "middle")
	                .attr("fill", "white")
	                .attr("font-size", 11)
	                .attr("font-family", "system-ui, -apple-system, Segoe UI, Roboto, sans-serif");
	
	            text.append("tspan")
	                .attr("x", centerX)
	                .text(label);
	
	            text.append("tspan")
	                .attr("x", centerX)
	                .attr("dy", "1.2em")
	                .text(`${volumeRate}%`);
	        });
	    }
	
	    // 상단 rack-bay 라벨
	    rackOrder.forEach((rack, rIdx) => {
	        bayOrder.forEach((bay, bIdx) => {
	            const colIndex = rIdx * bayOrder.length + bIdx;
	            const x = margin.left + colIndex * (boxSize + gap);
	            const y = margin.top - 20;
	            svg.append("text")
	                .attr("x", x + boxSize / 2)
	                .attr("y", y)
	                .attr("text-anchor", "middle")
	                .attr("dominant-baseline", "middle")
	                .attr("fill", "#555")
	                .attr("font-size", 11)
	                .text(`${rack}-${bay}`);
	        });
	    });
	
	    // 좌측 level 숫자 라벨
	    levelNumberOrder.forEach((lvNum, rowIdx) => {
	        const x = margin.left - 10;
	        const y = margin.top + rowIdx * (boxSize + gap) + boxSize / 2;
	        svg.append("text")
	            .attr("x", x)
	            .attr("y", y)
	            .attr("text-anchor", "end")
	            .attr("dominant-baseline", "middle")
	            .attr("fill", "#555")
	            .attr("font-size", 11)
	            .text(`${lvNum}`);
	    });
	}

	
	function calculateVolumeRate(entry) {
	    if (!entry.inventoryQTY || !entry.productVolume || !entry.locationVolume) return 0;
	
	    const totalProductVolume = entry.inventoryQTY * entry.productVolume;
	    return Math.round((totalProductVolume / entry.locationVolume) * 100);
	}
	

	
	
	
});