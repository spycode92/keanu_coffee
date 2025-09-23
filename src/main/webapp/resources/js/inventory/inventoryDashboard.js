/* ==========================================================
   📌 InventoryDashboard.js (최종 완성본)
   - Controller : InventoryDashboardController
   - API 엔드포인트 : /inventory/api/inventory, /inventory/api/locationUse
   - JSP : <canvas id="inventory_chart">, <canvas id="inventory_detail_chart">
           <div id="pallet_heatmap">, <div id="picking_heatmap">, <div id="tooltip">
   - 참고 : 팀장님 statistics2.js 코드 기반 (차트 + 히트맵 로직 통합)
========================================================== */

document.addEventListener('DOMContentLoaded', () => {
	// 0. KPI 카드
    loadKpiData();
	
    // 1. 카테고리별 재고현황 → 막대차트
    getInventory().then(() => {
        const inventoryChartData = processInventoryData(inventoryRawData);
        drawInventoryChart(inventoryChartData);
    });

    // 2. 로케이션 용적률 → 히트맵
    getLocation().then(() => {
        // 파레트존 / 피킹존 데이터 나누기
        const palletData = locationRawData.filter(d => d.locationType === 1);
        const pickingData = locationRawData.filter(d => d.locationType === 2);

        // 히트맵 데이터 변환
        const palletHeatmapData = buildHeatmapData(palletData);
        const pickingHeatmapData = buildHeatmapData(pickingData);

        // 히트맵 그리기
        drawHeatmap(palletHeatmapData, "#pallet_heatmap", "Pallet Zone");
        drawHeatmap(pickingHeatmapData, "#picking_heatmap", "Picking Zone");

        // 존별 평균 용적률 출력
        totalUsage(palletData, pickingData);
    });
});


/* =========================
   📌 KPI 데이터 불러오기
========================= */
function loadKpiData() {
    ajaxGet('/inventory/api/kpi')
        .then(data => {
            // 현재 재고
            document.getElementById('kpi-value').textContent =
                (data.currentStock || 0).toLocaleString() + " BOX";

            // 증감 수량 (-xxx BOX)
            let changeEl = document.getElementById('kpi-change');
            const changeQty = data.changeQty || 0;

            if (changeQty < 0) {
                // 기존: changeEl.textContent = changeQty + " BOX";
			    changeEl.textContent = changeQty.toLocaleString() + " BOX"; // 천단위 콤마
			    changeEl.style.color = "red";
            } else if (changeQty > 0) {
                // 기존: changeEl.textContent = "+" + changeQty + " BOX";
			    changeEl.textContent = "+" + changeQty.toLocaleString() + " BOX"; // 천단위 콤마
			    changeEl.style.color = "green";
            } else {
                changeEl.textContent = "전날 출고/폐기 : 0 BOX";
                changeEl.style.color = "#666";
            }
        })
        .catch(err => console.error("KPI 불러오기 실패", err));
}
/* =========================
   📌 재고현황
========================= */
let inventoryRawData = [];        // 서버에서 받은 원본 데이터
let inventoryProductChart = null; // 상품별 차트 객체 (destroy 용도)

// 서버에서 재고 데이터 가져오기
function getInventory() {
    return ajaxGet(`/inventory/api/inventory`)
        .then((data) => { inventoryRawData = data; })
        .catch((err) => console.error("재고현황 조회 실패", err));
}

// 데이터 가공 (카테고리별 합계 + 정렬)
function processInventoryData(rawData) {
    const grouped = {};
    rawData.forEach(item => {
        let key = item.categoryName || '기타';    // 카테고리 없으면 "기타"
        const qty = item.inventoryQTY || 0;
        grouped[key] = (grouped[key] || 0) + qty;
    });

    // 수량 기준 내림차순 정렬
    const sorted = Object.entries(grouped).sort((a, b) => b[1] - a[1]);
    const labels = sorted.map(([cat]) => cat);
    const data = sorted.map(([_, qty]) => qty);

    return { labels, data };
}

// 카테고리별 막대차트
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
            maintainAspectRatio: false,
            plugins: {
                title: { display: true, text: '카테고리별 재고 현황' },
                tooltip: {
                    callbacks: {
                        label: (context) => `${context.label}: ${context.parsed.y}개`
                    }
                },
                datalabels: {
                    anchor: 'end',
                    align: 'top',
                    formatter: (value) => `${value}개`,
                    font: { weight: 'bold' },
                    color: '#333'
                }
            },
            scales: {
                y: { beginAtZero: true, title: { display: true, text: '수량' } },
                x: { title: { display: true, text: '카테고리' } }
            },
            // 📌 카테고리 클릭 시 → 상품별 차트 표시
            onClick: function(event, elements) {
                if (elements.length > 0) {
                    const idx = elements[0].index;
                    const categoryName = this.data.labels[idx];
                    showProductChart(categoryName);
                }
            }
        },
        plugins: [ChartDataLabels]
    });
}

// 특정 카테고리 클릭 시 → 상품별 차트 데이터 준비
function showProductChart(categoryName) {
    const filtered = inventoryRawData.filter(item => item.categoryName === categoryName);
    const productMap = {};

    filtered.forEach(item => {
        const name = item.productName || '이름없음';
        const qty = Number(item.inventoryQTY) || 0;
        productMap[name] = (productMap[name] || 0) + qty;
    });

    const labels = Object.keys(productMap);
    const data = Object.values(productMap);
    drawProductChart({ labels, data, categoryName });
}

// 상품별 상세 차트 (막대차트)
function drawProductChart({ labels, data, categoryName }) {
    if (inventoryProductChart) inventoryProductChart.destroy();

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
            maintainAspectRatio: false,

            // ✅ 가로 막대 차트로 변경
            indexAxis: 'y',

            plugins: {
                title: { display: true, text: `${categoryName} 카테고리 상세` },
                datalabels: {
                    anchor: 'end',
                    align: 'right',
                    formatter: (value) => `${value.toLocaleString()}개`, // 천단위 콤마
                    font: { size: 12, weight: 'bold' },
   					color: '#fff'   // 다크모드 기준, 라이트모드일 땐 '#000'
                }
            },
            scales: {
                x: { beginAtZero: true },
                y: {
                    ticks: {
                        // ✅ 상품명이 너무 길면 줄여서 표시
                        callback: function(value) {
                            let label = this.getLabelForValue(value);
                            return label.length > 8 ? label.substr(0, 8) + '…' : label;
                        }
                    }
                }
            }
        },
        plugins: [ChartDataLabels]
    });
}

/* =========================
   📌 로케이션 용적률 (히트맵)
========================= */
let locationRawData = [];

// 서버에서 로케이션 데이터 가져오기
function getLocation() {
    return ajaxGet(`/inventory/api/locationUse`)
        .then((data) => { locationRawData = data; })
        .catch((err) => console.error("로케이션 용적률 조회 실패", err));
}

// 히트맵 데이터 변환
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

// 용적률 계산
function calculateVolumeRate(entry) {
    if (!entry.inventoryQTY || !entry.productVolume || !entry.locationVolume) return 0;
    const totalProductVolume = entry.inventoryQTY * entry.productVolume;
    return Math.round((totalProductVolume / entry.locationVolume) * 100);
}

// 존별 평균 용적률 계산
function calculateUsage(zoneData) {
    const valid = zoneData.filter(d =>
        Number.isFinite(d.inventoryQTY) &&
        Number.isFinite(d.productVolume) &&
        Number.isFinite(d.locationVolume) &&
        d.locationVolume > 0
    );
    if (valid.length === 0) return 0;

    const totalRate = valid.reduce((sum, d) => {
        const used = d.inventoryQTY * d.productVolume;
        return sum + (used / d.locationVolume) * 100;
    }, 0);
    return Math.round(totalRate / valid.length);
}

// 존별 평균 용적률을 타이틀 옆에 표시
function totalUsage(palletZoneData, pickingZoneData) {
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

/* =========================
   📌 히트맵 (D3.js) - 최종정리본 + 그룹 단위 hover
   👉 rack(E/F/G…) = Y축, bay(1,2,3…) = X축
   👉 개선: hover 시 해당 그룹만 오른쪽으로 fan-out (버벅임 방지)
========================= */
function drawHeatmap(data, selector, zoneLabel) {
    const boxSize = 50;
    const gap = 40; 

    // ✅ fan-out offset 계산 (오른쪽으로 튀어나가는 여백 고려)
    const fanoutOffsetStep  = Math.round(boxSize * 0.5);

    // ✅ 오른쪽 margin 넉넉히 (기존 40 → 120)
    const margin = { top: 60, right: 120, bottom: 40, left: 80 };

    if (!Array.isArray(data) || data.length === 0) return;

    // 📌 문자열 natural sort
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
        const A = toKeyParts(a), B = toKeyParts(b);
        if (A.prefix !== B.prefix) return A.prefix.localeCompare(B.prefix);
        const aHasNum = !Number.isNaN(A.num), bHasNum = !Number.isNaN(B.num);
        if (aHasNum && bHasNum) return A.num - B.num;
        if (aHasNum) return -1;
        if (bHasNum) return 1;
        return A.raw.localeCompare(B.raw);
    };

    // 📌 rack = Y축, bay = X축
    const rackOrder = [...new Set(data.map(d => d.rack))].sort(naturalCompare);
    const bayOrder  = [...new Set(data.map(d => d.bay))].sort(naturalCompare);

    const cols = bayOrder.length;
    const rows = rackOrder.length;

    const contentWidth  = cols * (boxSize + gap) - gap;
    const contentHeight = rows * (boxSize + gap) - gap;

    // ✅ svgWidth 계산 시 fanoutOffsetStep * 2 보정 추가
    const svgWidth  = margin.left + contentWidth + margin.right + fanoutOffsetStep * 2;
    const svgHeight = margin.top  + contentHeight + margin.bottom;

    const svg = d3.select(selector)
        .append("svg")
        .attr("width", svgWidth)
        .attr("height", svgHeight)
        .style("display", "block")
        .style("margin", "0 auto");

    const g = svg.append("g")
        .attr("transform", `translate(${margin.left},${margin.top})`);

    // 📌 색상 스케일
    const colorScale = d3.scaleThreshold()
        .domain([30, 50, 70, 80, 90, 100])
        .range(["#2196F3","#4CAF50","#CDDC39","#FFEB3B","#FF9800","#F44336","#6A1B9A"]);

    const tooltip = d3.select("#tooltip");

    // 📌 좌표계 (bay=X, rack=Y)
    const getXIndex = (bay)  => bayOrder.indexOf(bay);
    const getYIndex = (rack) => rackOrder.indexOf(rack);

    // 📌 그룹핑
    const getLevelNumber = (level) => {
        const m = String(level ?? "").match(/\d+/);
        return m ? Number(m[0]) : 0;
    };
    const positionKey = (d) => `${d.rack}|${d.bay}|${getLevelNumber(d.level)}`;
    const groupsMap = new Map();
    data.forEach(d => {
        const key = positionKey(d);
        if (!groupsMap.has(key)) groupsMap.set(key, []);
        groupsMap.get(key).push(d);
    });

    // 📌 fan-out offset
    const overlapOffsetStep = Math.round(-boxSize * 0.05);
    const getOffset = (i, mode = "overlap") => {
        return { dx: i * (mode === "fanout" ? fanoutOffsetStep : overlapOffsetStep), dy: 0 };
    };

    // 📌 라벨 저장
    const bayLabels = new Map();
    const rackLabels = new Map();

    // 📌 각 그룹(칸) 처리
    for (const [key, items] of groupsMap.entries()) {
        const [rack, bay] = key.split("|");
        const xIndex = getXIndex(bay), yIndex = getYIndex(rack);
        if (xIndex < 0 || yIndex < 0) continue;

        const baseX = xIndex * (boxSize + gap);
        const baseY = yIndex * (boxSize + gap);

        const sorted = items.slice().sort((a, b) => {
            const ap = String(a.level).replace(/\d+/g, "");
            const bp = String(b.level).replace(/\d+/g, "");
            return ap.localeCompare(bp);
        });

        // ✅ 그룹(g) 단위 hover
        const group = g.append("g")
            .attr("transform", `translate(${baseX},${baseY})`)
            .on("mouseenter", function () {
                d3.select(this).raise();
                d3.select(this).selectAll("g.cell")
                    .transition().duration(150)
                    .attr("transform", (d, i) => {
                        const off = getOffset(i, "fanout");
                        return `translate(${off.dx}, ${off.dy})`;
                    });
                bayLabels.get(bay).attr("fill", "#000").attr("font-weight", "bold");
                rackLabels.get(rack).attr("fill", "#000").attr("font-weight", "bold");
            })
            .on("mouseleave", function () {
                d3.select(this).selectAll("g.cell")
                    .transition().duration(150)
                    .attr("transform", (d, i) => {
                        const off = getOffset(i, "overlap");
                        return `translate(${off.dx}, ${off.dy})`;
                    });
                tooltip.style("display", "none");
                bayLabels.get(bay).attr("fill", "#555").attr("font-weight", "normal");
                rackLabels.get(rack).attr("fill", "#555").attr("font-weight", "normal");
            });

        // 📌 셀(카드) 그리기
        sorted.forEach((d, i) => {
            const volumeRate = Number.isFinite(d.volumeRate) ? Math.max(0, d.volumeRate) : 0;
            const cell = group.append("g").attr("class", "cell");

            cell.append("rect")
                .attr("width", boxSize).attr("height", boxSize)
                .attr("rx", 4).attr("ry", 4)
                .attr("fill", colorScale(volumeRate))
                .attr("stroke", "#111").attr("stroke-width", 1)
                .on("mousemove", function (event) {
                    const itemList = (d.items || []).map(item => `${item.name} (${item.quantity}개)`).join('<br/>');
                    const tooltipNode = tooltip.node();
                    const tooltipWidth = tooltipNode.offsetWidth || 150;
                    const pageWidth = window.innerWidth;

                    let left = event.pageX + 15;  
                    if (left + tooltipWidth > pageWidth) {
                        left = pageWidth - tooltipWidth - 10;
                    }

                    tooltip
                        .style("display", "block")
                        .html(`
                            <strong>${d.rack}-${d.bay}-${d.level}</strong><br/>
                            용적률: ${volumeRate}%<br/>
                            물품:<br/>${itemList}
                        `)
                        .style("left", left + "px")
                        .style("top", (event.pageY + 10) + "px");
                });

            const off = getOffset(i, "overlap");
            cell.attr("transform", `translate(${off.dx}, ${off.dy})`);

            const label = `${d.rack}-${d.bay}-${d.level}`;
            const centerX = boxSize / 2, centerY = boxSize / 2 - 5;
            const text = cell.append("text")
                .attr("x", centerX).attr("y", centerY)
                .attr("text-anchor", "middle")
                .attr("dominant-baseline", "middle")
                .attr("fill", "white").attr("font-size", 11);
            text.append("tspan").attr("x", centerX).text(label);
            text.append("tspan").attr("x", centerX).attr("dy", "1.2em").text(`${volumeRate}%`);
        });
    }

    // 📌 상단 bay 라벨
    bayOrder.forEach((bay, bIdx) => {
        const x = margin.left + bIdx * (boxSize + gap);
        const y = margin.top - 20;
        const lbl = svg.append("text")
            .attr("x", x + boxSize / 2).attr("y", y)
            .attr("text-anchor", "middle")
            .attr("fill", "#555").attr("font-size", 12)
            .text(`${bay}`);
        bayLabels.set(bay, lbl);
    });

    // 📌 좌측 rack 라벨
    rackOrder.forEach((rack, rIdx) => {
        const x = margin.left - 25;
        const y = margin.top + rIdx * (boxSize + gap) + boxSize / 2;
        const lbl = svg.append("text")
            .attr("x", x).attr("y", y)
            .attr("text-anchor", "end")
            .attr("fill", "#555").attr("font-size", 12)
            .text(`${rack}`);
        rackLabels.set(rack, lbl);
    });
}

/* ========================================================================
   🚨 [웹소켓 구독 코드 추가됨] 🚨
   - 작성자: (너 이름)
   - 목적 : 재고현황 대시보드 실시간 갱신
   - topic : /topic/inventory
   - 설명 : 서버에서 메시지 브로드캐스트 시 KPI/차트/히트맵 자동 새로고침
======================================================================== */
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


