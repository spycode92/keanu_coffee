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
	<style type="text/css">
	/* KPI 카드와 차트 카드 공통 크기 스타일 */
.kpi-card {
  flex: 1 1 28%;           /* 카드 크기 조금 키움 (28%) */
  max-width: 28%;
  min-width: 220px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 1.2rem;         /* 카드 내부 패딩 약간 증가 */
}

.card.md-2 {
  flex: 1 1 22%;           /* 차트 크기 줄임 (22%) */
  max-width: 22%;
  min-width: 260px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
}

/* 두 블록을 감싸는 row 컨테이너에 flex 설정 */
.row.mb-4 {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;               /* 아이템 간 간격 */
  justify-content: space-between;
}

/* 차트 카드 내 차트 영역 높이 통일 및 크기 적당히 줄임 */
.card.md-2 .card-body {
  position: relative;
  height: 220px;           /* 차트 영역 높이 줄임 */
  padding: 0;
  display: flex;
}

/* 캔버스는 차트 카드 body 크기에 맞게 꽉 채우기 */
.card.md-2 canvas,
#trendChart {
  width: 100% !important;
  height: 100% !important;
  display: block;
}

/* 반응형 처리: 태블릿 화면에서 2열씩 배치 */
@media (max-width: 1024px) {
  .kpi-card,
  .card.md-2 {
    flex: 1 1 48%;
    max-width: 48%;
  }
  .card.md-2 .card-body {
    height: 200px;
  }
}

/* 모바일 화면에서는 한 줄에 1개씩 */
@media (max-width: 768px) {
  .kpi-card,
  .card.md-2 {
    flex: 1 1 100%;
    max-width: 100%;
  }
  .card.md-2 .card-body {
    height: 180px;
  }
}
	</style>
</head>
<body>
    <!-- 상단/사이드바 -->
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 

    <!-- 메인 내용 -->
    <section class="content">

        <!-- KPI 카드 -->
        <div class="row mb-4">
            <div class="col col-md-2" >
                <div class="kpi-card" >
                    <h3>오늘 입고</h3>
                    <div class="kpi-value">50</div>
                    <div class="kpi-change positive">▲ 1%</div>
                </div>
            </div>
            <div class="col col-md-2">
                <div class="kpi-card" style="width: 100%;">
                    <h3>현재 재고 품목</h3>
                    <div class="kpi-value">200</div>
                    <div class="kpi-change negative">▼ 4%</div>
                </div>
            </div>
            <div class="col col-md-2">
                <div class="kpi-card" style="width: 100%;">
                    <h3>오늘 출고</h3>
                    <div class="kpi-value">45</div>
                    <div class="kpi-change positive">▲ 2%</div>
                </div>
            </div>
            <div class="col col-md-2">
                <div class="kpi-card" style="width: 100%;">
                    <h3>배송 진행</h3>
                    <div class="kpi-value">30</div>
                    <div class="kpi-change positive">정시율 88%</div>
                </div>
            </div>
        </div>

        <!-- 물류 흐름 차트 -->
        <div class="row mb-4" >
        
	        <div class="card md-2" >
				<div class="card-header">
	                <h2 class="card-title">물류 흐름 현황</h2>
	            </div>
	            <div class="card-body">
	            <!-- 차트크기조절 -->
	                <canvas id="logisticsFlowChart" height="100" ></canvas>
	            </div>
	        </div>
	        
	        <div class="card md-2" >
	            <div class="card-header">
	                <h2 class="card-title">입고 추이</h2>
	            </div>
	            <div class="card-body">
	            <!-- 차트크기조절 -->
	                <canvas id="inboundFlowChart" height="100" ></canvas>
	            </div>
	        </div>
	        
	        <div class="card md-2" >
	            <div class="card-header">
	                <h2 class="card-title">출고 추이</h2>
	            </div>
	            <div class="card-body">
	            <!-- 차트크기조절 -->
	                <canvas id="outboundFlowChart" height="100" ></canvas>
	            </div>
	        </div>
	        
	        <div class="card md-2" >
	        
	            <div class="card-header">
	                <h2 class="card-title">운송 추이</h2>
	            </div>
	            <div class="card-body">
	            <!-- 차트크기조절 -->
	                <canvas id="transportFlowChart" height="100" ></canvas>
	            </div>
	        </div>
        </div>

        <!-- 트렌드 분석 차트 -->
        <div class="card mb-2">
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
//KPI 카드 더미 데이터 (이미 JSP에서 세팅된 값이 있으나, 참고용)
const inboundToday = 50;
const inventoryCount = 200;
const outboundToday = 45;
const deliveryProgress = 30;

// 월별 입/출고 라벨과 데이터 (3개월치 예시)
const monthLabels = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월","10월", "11월", "12월"];
const inboundMonthly = [120, 150, 180, 130, 120, 110, 150, 180, 210, 170, 160, 150];
const outboundMonthly = [100, 140, 160, 180, 120, 110, 180, 130, 170, 180, 180, 120];

// 물류 흐름 차트 더미 데이터 (최근 7일 각 항목별 건수 예시)
// 배열 순서: 입고, 재고, 출고, 운송, 입고, 재고, 출고 (7일치 예시)
const logisticsFlowData = [40, 180, 35, 25, 45, 190, 50];

// 입고 추이 더미 데이터 (7일간 입고 수량 예시)
const inboundFlowData = [40, 45, 50, 43, 48, 52, 55];

// 출고 추이 더미 데이터 (7일간 출고 수량 예시)
const outboundFlowData = [38, 40, 42, 37, 39, 44, 46];

// 운송 추이 더미 데이터 (7일간 운송 건수 예시)
const transportFlowData = [20, 22, 19, 21, 25, 23, 24];


//물류 흐름 차트 - 데이터 배열 수정
new Chart(document.getElementById('logisticsFlowChart'), {
    type: 'bar',
    data: {
        labels: ['입고', '재고', '출고', '운송'],
        datasets: [{
            label: '건수',
            data: logisticsFlowData, // 기존 배열 변수를 바로 사용
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
                labels: { color: '#f00' }
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
        },
        responsive: true,
        maintainAspectRatio: false,
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
                legend: { labels: { color: '#f00' } }
            },
            scales: {
                x: { ticks: { color: '#fad212' }, grid: { color: '#ac3211' } },
                y: { ticks: { color: '#f23311' }, grid: { color: '#3ddee2' } }
            }
        },
        //차트크기
        responsive: true,
        maintainAspectRatio: false,
    });
    
 // 입고 추이 꺾은선 그래프
    new Chart(document.getElementById('inboundFlowChart'), {
        type: 'line',
        data: {
            labels: ["1일", "2일", "3일", "4일", "5일", "6일", "7일"], // 7일간 라벨 예시
            datasets: [{
                label: '입고 수량',
                data: inboundFlowData,
                fill: false,
                borderColor: '#3b82f6', // 파랑색
                tension: 0.1
            }]
        },
        options: {
            plugins: {
                legend: { labels: { color: '#f00' } }
            },
            scales: {
                x: { ticks: { color: '#3b82f6' }, grid: { color: '#ccc' } },
                y: { ticks: { color: '#3b82f6' }, grid: { color: '#eee' } }
            },
            responsive: true,
            maintainAspectRatio: false,
        }
    });

    // 출고 추이 꺾은선 그래프
    new Chart(document.getElementById('outboundFlowChart'), {
        type: 'line',
        data: {
            labels: ["1일", "2일", "3일", "4일", "5일", "6일", "7일"],
            datasets: [{
                label: '출고 수량',
                data: outboundFlowData,
                fill: false,
                borderColor: '#22c55e', // 초록색
                tension: 0.1
            }]
        },
        options: {
            plugins: {
                legend: { labels: { color: '#f00' } }
            },
            scales: {
                x: { ticks: { color: '#22c55e' }, grid: { color: '#ccc' } },
                y: { ticks: { color: '#22c55e' }, grid: { color: '#eee' } }
            },
            responsive: true,
            maintainAspectRatio: false,
        }
    });

    // 운송 추이 꺾은선 그래프
    new Chart(document.getElementById('transportFlowChart'), {
        type: 'line',
        data: {
            labels: ["1일", "2일", "3일", "4일", "5일", "6일", "7일"],
            datasets: [{
                label: '운송 건수',
                data: transportFlowData,
                fill: false,
                borderColor: '#f97316', // 주황색
                tension: 0.1
            }]
        },
        options: {
            plugins: {
                legend: { labels: { color: '#f00' } }
            },
            scales: {
                x: { ticks: { color: '#f97316' }, grid: { color: '#ccc' } },
                y: { ticks: { color: '#f97316' }, grid: { color: '#eee' } }
            },
            responsive: true,
            maintainAspectRatio: false,
        }
    });
    
    
    
    </script>
</body>
</html>