// inboundChart.js

document.addEventListener('DOMContentLoaded', () => {
    // 샘플 수신 데이터 (총 발주 수량 포함, 폐기 수량 명시)
    const inboundRawData = [
        { date: '2025-09-01', product: '상품A', category: '카테고리1', inboundWaiting: 25, inboundCompleted: 15, disposal: 5 },
        { date: '2025-09-01', product: '상품B', category: '카테고리2', inboundWaiting: 30, inboundCompleted: 20, disposal: 5 },
        { date: '2025-09-02', product: '상품A', category: '카테고리1', inboundWaiting: 22, inboundCompleted: 12, disposal: 6 },
        { date: '2025-09-02', product: '상품B', category: '카테고리2', inboundWaiting: 25, inboundCompleted: 14, disposal: 7 }
        // ... 추가 데이터
    ];

    // 1. 날짜별 카테고리별 데이터 집계 함수 (입고대기량 재계산 포함)
    function aggregateCategoryData(rawData) {
        const result = {};
        rawData.forEach(item => {
            const key = item.date;
            if (!result[key]) result[key] = {};
            if (!result[key][item.category]) {
                result[key][item.category] = { waiting: 0, completed: 0, disposal: 0 };
            }
            result[key][item.category].waiting += (item.inboundWaiting - item.inboundCompleted - item.disposal);
            result[key][item.category].completed += item.inboundCompleted;
            result[key][item.category].disposal += item.disposal;
        });
        return result;
    }

    // 2. 전체 합산 데이터 생성 함수
    function aggregateTotalData(categoryData) {
        const totalData = {};
        Object.keys(categoryData).forEach(date => {
            let totalWaiting = 0;
            let totalCompleted = 0;
            let totalDisposal = 0;
            Object.values(categoryData[date]).forEach(catData => {
                totalWaiting += catData.waiting;
                totalCompleted += catData.completed;
                totalDisposal += catData.disposal;
            });
            totalData[date] = { waiting: totalWaiting, completed: totalCompleted, disposal: totalDisposal };
        });
        return totalData;
    }

    // 3. 전체 요약 누적 막대차트용 데이터 생성
    function createOverallChartData(totalData) {
        const labels = Object.keys(totalData).sort();
        return {
            labels,
            datasets: [
                {
                    label: '입고 완료',
                    data: labels.map(date => totalData[date].completed),
                    backgroundColor: 'rgba(75, 192, 192, 0.9)',
                    stack: 'stack1'
                },
                {
                    label: '폐기',
                    data: labels.map(date => totalData[date].disposal),
                    backgroundColor: 'rgba(220, 53, 69, 0.8)',
                    stack: 'stack1'
                },
                {
                    label: '미입고 대기',
                    data: labels.map(date => totalData[date].waiting),
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    stack: 'stack1'
                }
            ]
        };
    }

    // 4. 카테고리별 누적 막대차트용 데이터 생성
    function createCategoryChartData(categoryData) {
        const dates = Object.keys(categoryData).sort();
        const categories = new Set();
        Object.values(categoryData).forEach(catObj => {
            Object.keys(catObj).forEach(cat => categories.add(cat));
        });
        const colors = ['#4bc0c0', '#ff6384', '#36a2eb', '#ffcd56', '#9966ff'];
        const categoriesArr = Array.from(categories);
        const datasets = [];

        categoriesArr.forEach((cat, idx) => {
            const completedData = dates.map(date => categoryData[date][cat]?.completed ?? 0);
            const disposalData = dates.map(date => categoryData[date][cat]?.disposal ?? 0);
            const waitingData = dates.map(date => categoryData[date][cat]?.waiting ?? 0);

            datasets.push({
                label: `${cat} 입고 완료`,
                data: completedData,
                backgroundColor: colors[idx % colors.length],
                stack: 'stack1'
            });
            datasets.push({
                label: `${cat} 폐기`,
                data: disposalData,
                backgroundColor: lightenColor(colors[idx % colors.length], 0.6, true),
                stack: 'stack1'
            });
            datasets.push({
                label: `${cat} 미입고 대기`,
                data: waitingData,
                backgroundColor: lightenColor(colors[idx % colors.length], 0.8, true),
                stack: 'stack1'
            });
        });

        return {
            labels: dates,
            datasets
        };
    }

    // 5. 도넛 차트용 데이터 생성 (특정 날짜와 카테고리의 상품별 입고완료/폐기/미입고)
    function createDetailDonutData(rawData, date, category) {
        const filtered = rawData.filter(item => item.date === date && item.category === category);
        const labels = filtered.map(i => i.product);
        const completed = filtered.map(i => i.inboundCompleted);
        const disposal = filtered.map(i => i.disposal);
        const waiting = filtered.map(i => i.inboundWaiting - i.inboundCompleted - i.disposal);

        return {
            labels,
            datasets: [
                {
                    label: '입고 완료',
                    data: completed,
                    backgroundColor: 'rgba(75, 192, 192, 0.9)'
                },
                {
                    label: '폐기',
                    data: disposal,
                    backgroundColor: 'rgba(220, 53, 69, 0.8)'
                },
                {
                    label: '미입고 대기',
                    data: waiting,
                    backgroundColor: 'rgba(54, 162, 235, 0.6)'
                }
            ]
        };
    }

    // 색상 밝기 조정 함수 (alpha 조정 추가)
    function lightenColor(color, alpha, useAlpha = false) {
        if (useAlpha) {
            const c = hexToRgb(color);
            return `rgba(${c.r},${c.g},${c.b},${alpha})`;
        }
        const num = parseInt(color.replace("#", ""), 16),
            amt = Math.round(2.55 * 100 * alpha),
            R = (num >> 16) + amt,
            G = ((num >> 8) & 0x00FF) + amt,
            B = (num & 0x0000FF) + amt;
        return "#" + (
            0x1000000 +
            (R < 255 ? (R < 1 ? 0 : R) : 255) * 0x10000 +
            (G < 255 ? (G < 1 ? 0 : G) : 255) * 0x100 +
            (B < 255 ? (B < 1 ? 0 : B) : 255)
        ).toString(16).slice(1);
    }

    function hexToRgb(hex) {
        const bigint = parseInt(hex.replace("#", ""), 16);
        return {
            r: (bigint >> 16) & 255,
            g: (bigint >> 8) & 255,
            b: bigint & 255
        };
    }

    // 캔버스 컨텍스트 가져오기
    const overallCtx = document.getElementById('overallChart').getContext('2d');
    const categoryCtx = document.getElementById('categoryChart').getContext('2d');
    const detailDonutCtx = document.getElementById('detailDonutChart').getContext('2d');

    // 데이터 집계 및 가공
    const categoryData = aggregateCategoryData(inboundRawData);
    const totalData = aggregateTotalData(categoryData);
    const overallChartData = createOverallChartData(totalData);
    const categoryChartData = createCategoryChartData(categoryData);

    // 초기 선택값 설정: 첫 날짜, 첫 카테고리
    const firstDate = overallChartData.labels[0];
    const categoriesSet = new Set();
    Object.values(categoryData).forEach(catObj => Object.keys(catObj).forEach(cat => categoriesSet.add(cat)));
    const firstCategory = categoriesSet.size > 0 ? Array.from(categoriesSet)[0] : null;
    const detailDonutData = firstDate && firstCategory ? createDetailDonutData(inboundRawData, firstDate, firstCategory) : { labels: [], datasets: [] };

    // 차트 인스턴스 생성
    const overallChart = new Chart(overallCtx, {
        type: 'bar',
        data: overallChartData,
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'top' }
            },
            scales: {
                x: { stacked: true },
                y: { stacked: true, beginAtZero: true }
            }
        }
    });

    const categoryChart = new Chart(categoryCtx, {
        type: 'bar',
        data: categoryChartData,
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'top' }
            },
            scales: {
                x: { stacked: true },
                y: { stacked: true, beginAtZero: true }
            },
            onClick: (evt) => {
                const points = categoryChart.getElementsAtEventForMode(evt, 'nearest', { intersect: true }, false);
                if (points.length) {
                    const idx = points[0].datasetIndex;
                    const datasetLabel = categoryChart.data.datasets[idx].label;
                    const clickedCategory = datasetLabel.split(' ')[0];
                    updateDetailDonut(firstDate, clickedCategory);
                }
            }
        }
    });

    const detailDonutChart = new Chart(detailDonutCtx, {
        type: 'doughnut',
        data: detailDonutData,
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'right' }
            }
        }
    });

    // 도넛 차트 업데이트 함수
    function updateDetailDonut(date, category) {
        const newData = createDetailDonutData(inboundRawData, date, category);
        detailDonutChart.data = newData;
        detailDonutChart.update();
    }

    // 기간 버튼 클릭 이벤트 (TODO: AJAX 호출 및 데이터 재집계 로직으로 확장 가능)
    document.querySelectorAll('.btn-group .btn').forEach(button => {
        button.addEventListener('click', () => {
            const period = button.getAttribute('data-period');
            document.querySelectorAll('.btn-group .btn').forEach(btn => {
                btn.classList.remove('btn-primary');
                btn.classList.add('btn-secondary');
            });
            button.classList.add('btn-primary');
            button.classList.remove('btn-secondary');

            // 현재는 샘플 데이터를 재활용하여 차트 갱신 (기간별 실제 데이터 연동 필요)
            const categoryData = aggregateCategoryData(inboundRawData);
            const totalData = aggregateTotalData(categoryData);
            const overallData = createOverallChartData(totalData);
            const categoryDataForChart = createCategoryChartData(categoryData);

            overallChart.data = overallData;
            overallChart.update();

            categoryChart.data = categoryDataForChart;
            categoryChart.update();

            if (overallData.labels.length > 0 && categoryDataForChart.datasets.length > 0) {
                const firstCategoryBtn = categoryDataForChart.datasets[0].label.split(' ')[0];
                updateDetailDonut(overallData.labels[0], firstCategoryBtn);
            }
        });
    });

    // 초기 버튼 스타일 설정
    const defaultBtn = document.querySelector('.btn-group .btn[data-period="daily"]');
    if (defaultBtn) {
        defaultBtn.classList.add('btn-primary');
        defaultBtn.classList.remove('btn-secondary');
    }
});