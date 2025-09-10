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
            // ✅ 현재 재고
            document.getElementById('kpi-value').textContent =
                (data.currentStock || 0).toLocaleString() + " BOX";

            // ✅ 증감 수량 (-xxx BOX)
            let changeEl = document.getElementById('kpi-change');
            const changeQty = data.changeQty || 0;

            if (changeQty < 0) {
                changeEl.textContent = changeQty + " BOX"; // 음수 그대로 표시
                changeEl.style.color = "red";
            } else if (changeQty > 0) {
                changeEl.textContent = "+" + changeQty + " BOX";
                changeEl.style.color = "green";
            } else {
                changeEl.textContent = "0 BOX";
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
            plugins: {
                title: { display: true, text: `${categoryName} 카테고리 상세` },
                datalabels: {
                    anchor: 'end',
                    align: 'top',
                    formatter: (value) => `${value}개`,
                    font: { weight: 'bold' },
                    color: '#333'
                }
            },
            scales: { y: { beginAtZero: true } }
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
   📌 히트맵 (D3.js)
   👉 팀장님 statistics2.js 코드 그대로 이식
========================= */
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

//    svg.append("text")
//        .attr("x", svgWidth / 2)
//        .attr("y", margin.top - 40)
//        .attr("text-anchor", "middle")
//        .attr("fill", "#333")
//        .attr("font-size", 16)
//        .attr("font-weight", "bold")
//        .text(zoneLabel);

    const g = svg.append("g")
        .attr("transform", `translate(${margin.left},${margin.top})`);

    const colorScale = d3.scaleThreshold()
        .domain([30, 50, 70, 80, 90, 100])
        .range(["#2196F3","#4CAF50","#CDDC39","#FFEB3B","#FF9800","#F44336","#6A1B9A"]);

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

    const overlapOffsetStep = Math.round(-boxSize * 0.04);
    const fanoutOffsetStep = Math.round(boxSize * 0.4);

    const getOffset = (i, mode = "overlap") => {
        const step = mode === "fanout" ? fanoutOffsetStep : overlapOffsetStep;
        return { dx: -i * step, dy: i * step };
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
                    .transition().duration(150)
                    .attr("transform", (d, i) => `translate(${i * fanoutOffsetStep}, 0)`);
            })
            .on("pointerleave", function () {
                d3.select(this).selectAll("g.cell")
                    .transition().duration(150)
                    .attr("transform", (d, i) => {
                        const off = getOffset(i);
                        return `translate(${off.dx}, ${off.dy})`;
                    });
                tooltip.style("display", "none");
            });

        sorted.forEach((d, i) => {
            const volumeRate = Number.isFinite(d.volumeRate) ? Math.max(0, d.volumeRate) : 0;

            const cell = group.append("g")
                .attr("class", "cell")
                .attr("transform", `translate(0, 0)`);

            cell.append("rect")
                .attr("width", boxSize).attr("height", boxSize)
                .attr("rx", 4).attr("ry", 4)
                .attr("fill", colorScale(volumeRate))
                .attr("stroke", "#111").attr("stroke-width", 1)
                .on("mouseover", function () {
                    const itemList = (d.items || [])
                        .map(item => `${item.name} (${item.quantity}개)`)
                        .join('<br/>');
                    tooltip.style("display", "block")
                        .html(`<strong>${d.rack}-${d.bay}-${d.level}</strong><br/>
                               용적률: ${volumeRate}%<br/>
                               물품:<br/>${itemList}`);
                })
                .on("mousemove", function (event) {
                    tooltip.style("left", (event.pageX + 10) + "px")
                           .style("top", (event.pageY + 10) + "px");
                });

            const label = `${d.rack}-${d.bay}-${d.level}`;
            const centerX = boxSize / 2;
            const centerY = boxSize / 2 - 5;

            const off = getOffset(i, "overlap");
            cell.attr("transform", `translate(${off.dx}, ${off.dy})`);

            const text = cell.append("text")
                .attr("x", centerX).attr("y", centerY)
                .attr("text-anchor", "middle")
                .attr("dominant-baseline", "middle")
                .attr("fill", "white").attr("font-size", 11);

            text.append("tspan").attr("x", centerX).text(label);
            text.append("tspan").attr("x", centerX).attr("dy", "1.2em").text(`${volumeRate}%`);
        });
    }

    // 상단 rack-bay 라벨
    rackOrder.forEach((rack, rIdx) => {
        bayOrder.forEach((bay, bIdx) => {
            const colIndex = rIdx * bayOrder.length + bIdx;
            const x = margin.left + colIndex * (boxSize + gap);
            const y = margin.top - 20;
            svg.append("text")
                .attr("x", x + boxSize / 2).attr("y", y)
                .attr("text-anchor", "middle")
                .attr("fill", "#555").attr("font-size", 11)
                .text(`${rack}-${bay}`);
        });
    });

    // 좌측 level 라벨
    levelNumberOrder.forEach((lvNum, rowIdx) => {
        const x = margin.left - 10;
        const y = margin.top + rowIdx * (boxSize + gap) + boxSize / 2;
        svg.append("text")
            .attr("x", x).attr("y", y)
            .attr("text-anchor", "end")
            .attr("fill", "#555").attr("font-size", 11)
            .text(`${lvNum}`);
    });
}