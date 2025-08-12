<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Keanu Coffee - 총괄 대시보드</title>
    <link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
</head>
<body>
    <!-- 상단/사이드바 -->
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 

    <!-- 메인 내용 -->
    <section class="content">

        <!-- KPI 카드 -->
        <div class="row mb-4">
            <div class="col col-md-2">
                <div class="kpi-card">
                    <h3>오늘 입고</h3>
                    <div class="kpi-value">50</div>
                    <div class="kpi-change positive">▲ 1%</div>
                </div>
            </div>
            <div class="col col-md-2">
                <div class="kpi-card">
                    <h3>현재 재고 품목</h3>
                    <div class="kpi-value">200</div>
                    <div class="kpi-change negative">▼ 4%</div>
                </div>
            </div>
            <div class="col col-md-2">
                <div class="kpi-card">
                    <h3>오늘 출고</h3>
                    <div class="kpi-value">45</div>
                    <div class="kpi-change positive">▲ 2%</div>
                </div>
            </div>
            <div class="col col-md-2">
                <div class="kpi-card">
                    <h3>배송 진행</h3>
                    <div class="kpi-value">30</div>
                    <div class="kpi-change positive">정시율 88%</div>
                </div>
            </div>
        </div>

        <!-- 물류 흐름 차트 -->
        <div class="card mb-3">
            <div class="card-header">
                <h2 class="card-title">물류 흐름 현황</h2>
            </div>
            <div class="card-body">
                <canvas id="logisticsFlowChart" height="100"></canvas>
            </div>
        </div>

        <!-- 트렌드 분석 차트 -->
        <div class="card mb-3">
            <div class="card-header">
                <h2 class="card-title">월별 입/출고 트렌드</h2>
            </div>
            <div class="card-body">
                <canvas id="trendChart" height="100"></canvas>
            </div>
        </div>

    </section>

    <!-- 차트 스크립트 -->
    <%
    Integer inboundTodayVal = (Integer) request.getAttribute("inboundToday");
    Integer inventoryCountVal = (Integer) request.getAttribute("inventoryCount");
    Integer outboundTodayVal = (Integer) request.getAttribute("outboundToday");
    Integer deliveryProgressVal = (Integer) request.getAttribute("deliveryProgress");
    
    // JSON 문자열로 받는 대신 Object 타입으로 받음
    Object monthLabelsObj = request.getAttribute("monthLabels");
    Object inboundMonthlyObj = request.getAttribute("inboundMonthly");
    Object outboundMonthlyObj = request.getAttribute("outboundMonthly");

    if (inboundTodayVal == null) inboundTodayVal = 50;
    if (inventoryCountVal == null) inventoryCountVal = 200;
    if (outboundTodayVal == null) outboundTodayVal = 45;
    if (deliveryProgressVal == null) deliveryProgressVal = 30;

    // Object -> JSON 문자열로 변환 (간단히 toString 사용하거나, 외부 라이브러리 가능)
    String monthLabelsVal;
    String inboundMonthlyVal;
    String outboundMonthlyVal;

    if (monthLabelsObj == null) {
        monthLabelsVal = "[\"1월\",\"2월\",\"3월\"]";
    } else {
        monthLabelsVal = monthLabelsObj.toString();
    }

    if (inboundMonthlyObj == null) {
        inboundMonthlyVal = "[120,150,180]";
    } else {
        inboundMonthlyVal = inboundMonthlyObj.toString();
    }

    if (outboundMonthlyObj == null) {
        outboundMonthlyVal = "[100,140,160]";
    } else {
        outboundMonthlyVal = outboundMonthlyObj.toString();
    }
%>

<script>
    const inboundToday = <%= inboundTodayVal %>;
    const inventoryCount = <%= inventoryCountVal %>;
    const outboundToday = <%= outboundTodayVal %>;
    const deliveryProgress = <%= deliveryProgressVal %>;

    const monthLabels = <%= monthLabelsVal %>;
    const inboundMonthly = <%= inboundMonthlyVal %>;
    const outboundMonthly = <%= outboundMonthlyVal %>;


 // 물류 흐름 차트
    new Chart(document.getElementById('logisticsFlowChart'), {
        type: 'bar',
        data: {
            labels: ['입고', '재고', '출고', '운송'],
            datasets: [{
                label: '건수',
                data: [inboundToday, inventoryCount, outboundToday, deliveryProgress],
                backgroundColor: [
                    '#4f46e5',
                    '#3b82f6',
                    '#f97316',
                    '#22c55e'
                ]
            }]
        },
        options: {
            plugins: {
                legend: {
                    labels: {
                        color: '#f00' // 라벨 글씨 색상 지정 (필요시)
                    }
                }
            },
            scales: {
                x: {
                    ticks: { color: '#3b82f6' },
                    grid: { color: '#22c55e' }
                },
                y: {
                    ticks: { color: '#3b82f6' },
                    grid: { color: '#22c55e' }
                }
            }
        }
    });

    // 트렌드 분석 차트
    new Chart(document.getElementById('trendChart'), {
        type: 'line',
        data: {
            labels: monthLabels,
            datasets: [
                {
                    label: '입고',
                    data: inboundMonthly,
                    fill: false,
                    borderColor: '#3b82f6', // 밝은 파랑
                    tension: 0.1
                },
                {
                    label: '출고',
                    data: outboundMonthly,
                    fill: false,
                    borderColor: '#22c55e', // 밝은 초록
                    tension: 0.1
                }
            ]
        },
        options: {
            plugins: {
                legend: { labels: { color: '#fff' } }
            },
            scales: {
                x: { ticks: { color: '#fad212' }, grid: { color: '#ac3211' } },
                y: { ticks: { color: '#f23311' }, grid: { color: '#3ddee2' } }
            }
        }
    });
    
    </script>
</body>
</html>