<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Keanu Coffee - 총괄 대시보드</title>
    <style>
        /* 차트 컨테이너 flex 박스로 일렬 배치 */
        .dashboard-charts {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
            overflow-x: auto;
            padding-bottom: 1rem;
        }
        /* 각 차트 박스 공통 스타일 */
        .chart-card {
            flex: 1 1 300px;
            min-width: 280px;
            max-width: 33%;
            background-color: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1rem;
            color: var(--card-foreground);
            box-sizing: border-box;
        }
        /* 버튼 그룹 위치 왼쪽 상단 고정 */
        .period-selector-wrapper {
            display: flex;
            justify-content: flex-start;
        }
        /* 모바일 대응(세로 스크롤) */
        @media (max-width: 768px) {
            .dashboard-charts {
                flex-direction: column;
            }
            .chart-card {
                max-width: 100%;
                min-width: auto;
            }
        }
    </style>
    <sec:csrfMetaTags/>
    <link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <!-- 상단/사이드바 -->
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 

    <!-- 메인 내용 -->
    <section class="content">
	    <div class="card">
	        <div class="card-header d-flex justify-content-between align-items-center">
	            <h2 class="card-title">입고 대시보드</h2>
	            <div class="period-selector-wrapper">
	                <div class="btn-group" role="group" aria-label="기간 선택">
	                    <button type="button" class="btn btn-secondary btn-sm" data-period="daily">일별</button>
	                    <button type="button" class="btn btn-secondary btn-sm" data-period="weekly">주별</button>
	                    <button type="button" class="btn btn-secondary btn-sm" data-period="monthly">월별</button>
	                </div>
	            </div>
	        </div>
	        <div class="dashboard-charts">
	            <!-- 전체 요약 누적 막대차트 -->
	            <div class="chart-card">
	                <h3 class="card-title">전체 입고 요약</h3>
	                <canvas id="overallChart" width="400" height="300"></canvas>
	            </div>
	            <!-- 카테고리별 누적 막대차트 -->
	            <div class="chart-card">
	                <h3 class="card-title">카테고리별 입고 현황</h3>
	                <canvas id="categoryChart" width="400" height="300"></canvas>
	            </div>
	            <!-- 상품별 입고율 및 폐기율 도넛 차트(예: 카테고리 선택시 동적 표시) -->
	            <div class="chart-card">
	                <h3 class="card-title">상세 입고/폐기 현황</h3>
	                <canvas id="detailDonutChart" width="300" height="300"></canvas>
	            </div>
	        </div>
	    </div>

    </section>

   
    <script src="/resources/js/admin/dashboard/inboundChart.js"></script>
</body>
</html>