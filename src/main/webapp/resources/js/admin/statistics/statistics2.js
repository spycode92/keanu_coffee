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
	let palletHeatmapData = [];
	let pickingHeatmapData = [];
	
	//창고정보가져오고나서 피킹존, 파레트존 분배
	getlocation().then(() => {
		pickingZoneData = locationRawData.filter(d => d.locationType === 2); // 피킹존
		palletZoneData = locationRawData.filter(d => d.locationType === 1);  // 파레트존
		palletHeatmapData = buildHeatmapData(palletZoneData);
		pickingHeatmapData = buildHeatmapData(pickingZoneData);
		drawHeatmap(palletHeatmapData, "#pallet_heatmap");
		drawHeatmap(pickingHeatmapData, "#picking_heatmap");
		// 필요한 후속 작업 수행
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


	
	    // ----------------------------------------------------------
		// drawHeatmap: rack+bay = X축, level의 숫자 = Y축 + 겹침 오프셋 + 툴팁
		// ----------------------------------------------------------
		function drawHeatmap(data, selector) {
		    const boxSize = 50;                                        // 각 셀 크기(px)
		    const gap = 10;                                            // 셀 간 간격(px)
		    const margin = { top: 60, right: 40, bottom: 40, left: 60 };// SVG 여백(px)
		
		    if (!Array.isArray(data) || data.length === 0) return;     // 데이터 없으면 종료
		
		    // level에서 숫자만 추출하는 함수 (예: 'a1' → 1)
		    const getLevelNumber = (level) => {
		        const m = String(level ?? "").match(/\d+/);            // 숫자 부분 정규식 매칭
		        return m ? Number(m[0]) : 0;                           // 없으면 0으로 처리
		    };
		
		    // 자연 정렬 비교 함수 (문자+숫자 혼합 안전)
		    const toKeyParts = (v) => {
		        const s = String(v ?? "");                             // 문자열 변환
		        const m = s.match(/^([A-Za-z]+)?(\d+)?$/);             // 접두 문자와 숫자 분리
		        return {
		            prefix: (m && m[1]) ? m[1] : "",                   // 문자 접두
		            num: (m && m[2]) ? Number(m[2]) : NaN,             // 숫자 부분
		            raw: s                                             // 원본문자
		        };
		    };
		    const naturalCompare = (a, b) => {
		        const A = toKeyParts(a);                               // a 분해
		        const B = toKeyParts(b);                               // b 분해
		        if (A.prefix !== B.prefix) return A.prefix.localeCompare(B.prefix); // 문자 우선 비교
		        const aHasNum = !Number.isNaN(A.num);                  // a 숫자 여부
		        const bHasNum = !Number.isNaN(B.num);                  // b 숫자 여부
		        if (aHasNum && bHasNum) return A.num - B.num;          // 둘 다 숫자면 숫자 비교
		        if (aHasNum) return -1;                                // a만 숫자면 a 먼저
		        if (bHasNum) return 1;                                 // b만 숫자면 b 먼저
		        return A.raw.localeCompare(B.raw);                     // 둘 다 숫자 없으면 원본 비교
		    };
		
		    // rack, bay, level 숫자 순서 정의
		    const rackOrder = [...new Set(data.map(d => d.rack))].sort(naturalCompare); // rack 고유값 정렬
		    const bayOrder = [...new Set(data.map(d => d.bay))].sort(naturalCompare);   // bay 고유값 정렬
		    const levelNumberOrder = [...new Set(data.map(d => getLevelNumber(d.level)))]
		        .sort((a, b) => a - b);                                // level 숫자 오름차순
		
		    // SVG 크기 계산
		    const cols = rackOrder.length * bayOrder.length;           // 총 열 수
		    const rows = levelNumberOrder.length;                      // 총 행 수
		    const svgWidth = margin.left + cols * (boxSize + gap) - gap + margin.right; // 너비
		    const svgHeight = margin.top + rows * (boxSize + gap) - gap + margin.bottom; // 높이
		
		    // SVG 생성
		    const svg = d3.select(selector)                            // 컨테이너 선택
		        .append("svg")                                         // SVG 요소 생성
		        .attr("width", svgWidth)                               // 너비 설정
		        .attr("height", svgHeight);                            // 높이 설정
		
		    const g = svg.append("g")                                  // 메인 그룹
		        .attr("transform", `translate(${margin.left},${margin.top})`); // 여백만큼 이동
		
		    // 색상 스케일(구간형)
		    const colorScale = d3.scaleThreshold()                     // 임계값 기반 색상
		        .domain([30, 50, 70, 90, 100])                         // 구간 경계
		        .range(["#2196F3", "#4CAF50", "#FFEB3B", "#FF9800", "#F44336"]); // 색상
		
		    // 툴팁 요소 선택(HTML에 #tooltip 필요)
		    const tooltip = d3.select("#tooltip");                     // 툴팁 div 선택
		
		    // 좌표 계산 함수
		    const getXIndex = (rack, bay) => {
		        const rIdx = rackOrder.indexOf(rack);                  // rack 인덱스
		        const bIdx = bayOrder.indexOf(bay);                    // bay 인덱스
		        return rIdx * bayOrder.length + bIdx;                  // 열 인덱스
		    };
		    const getYIndex = (level) => {
		        const num = getLevelNumber(level);                     // level 숫자
		        return levelNumberOrder.indexOf(num);                  // 행 인덱스
		    };
		
		    // 같은 좌표(rack, bay, level 숫자)로 그룹핑
		    const positionKey = (d) => `${d.rack}|${d.bay}|${getLevelNumber(d.level)}`; // 그룹키
		    const groupsMap = new Map();                               // 그룹 맵 생성
		    data.forEach(d => {                                        // 데이터 순회
		        const key = positionKey(d);                            // 그룹 키 계산
		        if (!groupsMap.has(key)) groupsMap.set(key, []);       // 없으면 배열 생성
		        groupsMap.get(key).push(d);                            // 그룹에 푸시
		    });
		
		    // 오프셋 크기(셀 크기에 비례) 및 패턴 정의
		    const offsetStep = Math.max(2, Math.round(boxSize * 0.12)); // 오프셋 기본 단위(px)
		    const offsetPattern = Array.from({ length: 30 }, (_, i) => ({                                    // 오프셋 시퀀스(겹침 순서대로 배정)
		        dx: i * offsetStep
				, dy: -i * offsetStep * 0.3                          
		    }));
		    const getOffset = (i) => offsetPattern[i % offsetPattern.length]; // 인덱스별 오프셋
		
		    // 그룹별로 렌더링
		    for (const [key, items] of groupsMap.entries()) {          // 각 그룹 순회
		        const [rack, bay, levelNumStr] = key.split("|");       // 키 분해
		        const xIndex = getXIndex(rack, bay);                   // X 인덱스 계산
		        const yIndex = levelNumberOrder.indexOf(Number(levelNumStr)); // Y 인덱스 계산
		        if (xIndex < 0 || yIndex < 0) continue;                // 방어: 인덱스 유효성 검사
		
		        const baseX = xIndex * (boxSize + gap);                // 그룹 기준 X 좌표
		        const baseY = yIndex * (boxSize + gap);                // 그룹 기준 Y 좌표
		
		        // 그룹 내 일관된 표시 순서(예: level 접두 a/b 우선 → productName 등)
		        const sorted = items.slice().sort((a, b) => {          // 정렬로 레이어 순서 고정
		            const ap = String(a.level).replace(/\d+/g, "");    // a의 level 접두(문자)
		            const bp = String(b.level).replace(/\d+/g, "");    // b의 level 접두(문자)
		            if (ap !== bp) return ap.localeCompare(bp);        // 접두 우선 비교
		            return String(a.productName || "").localeCompare(String(b.productName || "")); // 보조 기준
		        });
		
		        // 각 아이템 렌더링(오프셋 적용)
		        sorted.forEach((d, i) => {                             // 그룹 내 i번째 아이템
		            const off = getOffset(i);                          // 오프셋 계산
		            const x = baseX + off.dx;                          // 실제 X = 기준 + dx
		            const y = baseY + off.dy;                          // 실제 Y = 기준 + dy
		            const volumeRate = Number.isFinite(d.volumeRate)   // 용적률 안전 처리
		                ? Math.max(0, Math.min(100, d.volumeRate))     // 0~100 클램핑
		                : 0;                                           // 없으면 0
		
//		            const group = g.append("g")                        // 셀 그룹 생성
//		                .attr("transform", `translate(${x},${y})`);    // 위치 적용
		
		            // 테두리 스타일(겹침 강조: 첫 요소 실선, 이후 점선/파선)
		            const strokeStyle = (i === 0) ? "0"                // 0이면 실선
		                : (i % 2 === 0 ? "4,2" : "2,2");               // 번갈아 파선/점선
					
					// 그룹 생성
					const group = g.append("g")
					    .attr("transform", `translate(${x},${y})`)
					    .on("mouseleave", function () {
					        // 그룹 전체에서 마우스가 완전히 벗어났을 때만 복귀
					        group.transition()
					            .duration(150)
					            .attr("transform", `translate(${x},${y})`);
					        tooltip.style("display", "none");
					    });
	
		            // 사각형 + 툴팁 이벤트
		            group.append("rect")                               // 셀 사각형
		                .attr("width", boxSize)                        // 너비
		                .attr("height", boxSize)                       // 높이
		                .attr("rx", 4)                                 // 둥근 모서리
		                .attr("ry", 4)                                 // 둥근 모서리
		                .attr("fill", colorScale(volumeRate))          // 배경색(용적률)
		                .attr("fill-opacity", i === 0 ? 1 : 0.92)      // 겹치면 약간 투명(가독성)
		                .attr("stroke", "#111")                        // 테두리 색
		                .attr("stroke-width", 1)                       // 테두리 두께
		                .attr("stroke-dasharray", strokeStyle)         // 테두리 패턴
		                .on("mouseover", function (event) {            // 마우스 오버(툴팁 표시)
		                    const itemList = (d.items || [])           // items 배열 안전 참조
		                        .map(item => `${item.name} (${item.quantity}개)`) // 항목 구성
		                        .join('<br/>');                        // 줄바꿈
		                    tooltip
		                        .style("display", "block")             // 툴팁 표시
		                        .html(`<strong>${d.rack}-${d.bay}-${d.level}</strong><br/>
		                               용적률: ${volumeRate}%<br/>
		                               물품:<br/>${itemList}`);        // 툴팁 내용
							// 오프셋 확대 적용
					        const scaleFactor = 1.8; // 오프셋 확대 비율
					        const newX = baseX + off.dx * scaleFactor;
					        const newY = baseY + off.dy * scaleFactor;
//					        group.transition()
//					            .duration(150) // 0.15초 부드럽게 이동
//					            .attr("transform", `translate(${newX},${newY})`);
		                })
		                .on("mousemove", function (event) {            // 마우스 이동(위치 갱신)
		                    tooltip
		                        .style("left", (event.pageX + 10) + "px") // 좌표 보정
		                        .style("top", (event.pageY + 10) + "px"); // 좌표 보정
		                });
//		                .on("mouseout", function () {                  // 마우스 아웃(숨김)
//		                    tooltip.style("display", "none");          // 툴팁 숨김
//							// 원래 위치로 복귀
//					        group.transition()
//					            .duration(150)
//					            .attr("transform", `translate(${x},${y})`);
//		                });
		
		            // 라벨 텍스트(위치 코드 + 용적률)
		            const label = `${d.rack}-${d.bay}-${d.level}`;     // 위치 코드
		            const centerX = boxSize / 2;                       // 중앙 X
		            const centerY = boxSize / 2 - 5;                   // 첫 줄 Y
		
		            const text = group.append("text")                  // 텍스트 그룹
		                .attr("x", centerX)                            // 중앙 정렬 X
		                .attr("y", centerY)                            // 중앙 정렬 Y
		                .attr("text-anchor", "middle")                 // 중앙 정렬
		                .attr("dominant-baseline", "middle")           // 수직 중앙
		                .attr("fill", "white")                         // 글자색
		                .attr("font-size", 11)                         // 글자 크기
		                .attr("font-family", "system-ui, -apple-system, Segoe UI, Roboto, sans-serif"); // 폰트
		
		            text.append("tspan")                               // 1줄: 위치 코드
		                .attr("x", centerX)                            // 줄 X 중앙
		                .text(label);                                  // 텍스트
		
		            text.append("tspan")                               // 2줄: 용적률
		                .attr("x", centerX)                            // 줄 X 중앙
		                .attr("dy", "1.2em")                           // 행 간격
		                .text(`${volumeRate}%`);                       // 텍스트
		        });
		    }
		
		    // 헤더: rack-bay 라벨(상단)
		    rackOrder.forEach((rack, rIdx) => {                        // rack 루프
		        bayOrder.forEach((bay, bIdx) => {                      // bay 루프
		            const colIndex = rIdx * bayOrder.length + bIdx;    // 열 인덱스
		            const x = margin.left + colIndex * (boxSize + gap);// 헤더 X
		            const y = margin.top - 20;                         // 헤더 Y
		            svg.append("text")                                 // 텍스트 생성
		                .attr("x", x + boxSize / 2)                    // 셀 중앙 X
		                .attr("y", y)                                  // 헤더 Y
		                .attr("text-anchor", "middle")                 // 중앙
		                .attr("dominant-baseline", "middle")           // 수직 중앙
		                .attr("fill", "#555")                          // 색상
		                .attr("font-size", 11)                         // 크기
		                .text(`${rack}-${bay}`);                       // 라벨
		        });
		    });
		
		    // 헤더: level 숫자 라벨(좌측)
		    levelNumberOrder.forEach((lvNum, rowIdx) => {               // 각 레벨 숫자
		        const x = margin.left - 10;                             // 헤더 X
		        const y = margin.top + rowIdx * (boxSize + gap) + boxSize / 2; // 헤더 Y
		        svg.append("text")                                      // 텍스트 생성
		            .attr("x", x)                                       // 위치
		            .attr("y", y)                                       // 위치
		            .attr("text-anchor", "end")                         // 오른쪽 정렬
		            .attr("dominant-baseline", "middle")                // 수직 중앙
		            .attr("fill", "#555")                               // 색상
		            .attr("font-size", 11)                              // 크기
		            .text(`${lvNum}`);                                  // 라벨
		    });
		}

	
	function calculateVolumeRate(entry) {
	    if (!entry.inventoryQTY || !entry.productVolume || !entry.locationVolume) return 0;
	
	    const totalProductVolume = entry.inventoryQTY * entry.productVolume;
	    return Math.round((totalProductVolume / entry.locationVolume) * 100);
	}
	

	
	
	
});