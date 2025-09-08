<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Keanu Coffee - 통계</title>
    <style>
        /* 각 차트 박스 공통 스타일 */
        .chart-card {
            flex: 1 1 300px;
            min-width: 280px;
            width: 100%;
            background-color: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1rem;
            color: var(--card-foreground);
            box-sizing: border-box;
        }
		.chart-wrapper {
		    width: 100%;
		    max-width: 40%; 
		    height: 400px;
		    position: relative;
		}
		
		.chart-wrapper canvas {
		    width: 100% !important;
		    height: 100% !important;
		    position: absolute;
		    top: 0;
		    left: 0;
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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0"></script>
	
</head>
<body>
    <!-- 상단/사이드바 -->
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 

    <!-- 메인 내용 -->
    <section class="content">
    	<input type="button" value="입출고폐기" class="btn-secondary" id="statistics1"/>
    	<input type="button" value="재고" class="btn-primary" id="statistics2"/>
	    <div class="card">
	        <div class="card-header d-flex justify-content-between align-items-center">
			    <!-- 왼쪽: 제목 + 날짜 선택기 -->
			    <div class="d-flex align-items-center gap-2">
			        <h2 class="card-title" style="margin-bottom: 0; margin-right: 1rem;">통계</h2>
			    </div>
	        </div>
	        <div class="dashboard-charts">
	            <!-- 입고차트 -->
	            <div class="chart-card" style="display: flex;">
	                <h3 class="card-title" id="inventory_title">재고현황</h3>
	                <div class="chart-wrapper">
		                <canvas id="inventory_chart" ></canvas>
	                </div>
	                <div class="chart-wrapper">
		                <canvas id="inventory_detail_chart" ></canvas>
		            </div>
	            </div>
	            <br>
	            <!-- 운송/출고 차트 -->
	            <div class="chart-card">
	                <h3 class="card-title" id="location_title">로케이션 용적율</h3>
	                <canvas id="location_using_chart" style="width:80%; height:200px;"></canvas>
	            </div>
	            <br>
	            <!-- 폐기량 꺽은선차트 -->
	            <div class="chart-card">
	                <h3 class="card-title">폐기 현황</h3>
	                <canvas id="disposalChart" style="width:80%; height:200px;"></canvas>
	            </div>
	        </div>
	    </div>

    </section>

   
    <script src="/resources/js/admin/statistics/statistics2.js"></script>
</body>
</html>