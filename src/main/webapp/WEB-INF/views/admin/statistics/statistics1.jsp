<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>통계</title>
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
	<link rel="icon" href="resources/images/keanu_favicon.ico">
	
</head>
<body>
    <!-- 상단/사이드바 -->
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 

    <!-- 메인 내용 -->
    <section class="content">
   			<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
		        <h3>통계</h3>
            </div>
<!--     	<input type="button" value="입출고폐기" class="btn-primary" id="statistics1"/> -->
<!--     	<input type="button" value="재고" class="btn-secondary" id="statistics2"/> -->
	    <div class="card">
	        <div class="card-header d-flex justify-content-between align-items-center">
			    <!-- 왼쪽: 제목 + 날짜 선택기 -->
			    <div class="d-flex align-items-center gap-2">
			        <div class="date-selection card-title">
			            <div class="d-flex align-items-center gap-2">
			                <div>
			                    날짜선택 <input type="date" id="baseDate" class="form-control date-input-small" style="max-width:100px">
			                </div>
			                <div>
			                    <span id="dateRangeInfo" class="text-muted" style="font-size: 0.8rem; max-width: 200px;">
			                        <!-- 계산된 범위 표시 -->
			                    </span>
			                </div>
			            </div>
			        </div>
			    </div>
	            <div class="period-selector-wrapper">
	                <div class="btn-group" role="group" aria-label="그래프 선택">
	                    <button type="button" class="btn btn-secondary btn-sm" data-period="daily">일별</button>
	                    <button type="button" class="btn btn-secondary btn-sm" data-period="weekly">주별</button>
	                    <button type="button" class="btn btn-secondary btn-sm" data-period="monthly">월별</button>
	                </div>
	            </div>
	        </div>
	        <div class="dashboard-charts">
	            <!-- 입고차트 -->
	            <div class="chart-card" >
	                <h3 class="card-title" id="inbound_title">입고현황</h3>
	                <canvas id="IBoverallChart" style="width:80%; height:200px;"></canvas>
	            </div>
	            <br>
	            <!-- 운송/출고 차트 -->
	            <div class="chart-card">
	                <h3 class="card-title" id="outbound_title">출고/운송 현황</h3>
	                <canvas id="OBoverallChart" style="width:80%; height:200px;"></canvas>
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

   
    <script src="/resources/js/admin/statistics/statistics1.js"></script>
</body>
</html>