<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>재고현황</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

<!-- Chart.js & 플러그인 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>

<!-- D3.js -->
<script src="https://d3js.org/d3.v7.min.js"></script>
<style>
	.card-title {
	    font-size: 1.3rem;
	    font-weight: bold;
	    margin-bottom: 5px;
	}
	
	.chart-card hr {
	    border: none;
	    border-bottom: 2px solid #666;
	    margin-bottom: 15px;
	}
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
    @media (max-width: 768px) {
        .dashboard-charts { flex-direction: column; }
        .chart-card { max-width: 100%; min-width: auto; }
        #heatmap-container { flex-direction: column; }
    }
	#pallet_heatmap, #picking_heatmap {
	    width: 100%;
	    overflow-x: auto;       /* 가로 스크롤 가능 */
	    overflow-y: hidden;     /* 세로 스크롤 막기 */
	    white-space: nowrap;    /* 줄바꿈 방지 */
	    padding: 10px;
	    background: #fff;
	    border-radius: 6px;
	    box-sizing: border-box;
	}
	.heatmap-scroll {
	    width: 100%;
	    overflow-x: auto;   /* 가로 스크롤 */
	    overflow-y: hidden;
	    white-space: nowrap; /* 줄바꿈 방지 */
	    padding: 10px;
	    background: #fff;
	    border-radius: 6px;
	    box-sizing: border-box;
	}
	/* Pallet Zone / Picking Zone 제목 스타일 */
	.heatmap-title {
	    font-size: 20px;       /* 글자 크기 키움 (기본 16px → 20px) */
	    font-weight: bold;     /* 굵게 */
	    margin: 8px 0;         /* 위아래 여백 */
	    color: #333;           /* 글자색 진하게 */
	}	
</style>
</head>
<body>

	<!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	
	<!-- 메인 내용 -->
    <section class="content">
        <div class="card">
        	<h1 align="center">재고현황 - 대시보드</h1>
        
        	<!-- KPI 카드 -->
        	<div class="chart-card">
	        	<h3 class="card-title" align="center">현재 재고</h3>
				<hr>
				<div class="dashboard-kpi" style="display: flex; justify-content: center; margin-bottom: 20px;">
				    <div class="kpi-card" style="flex:1; text-align:center; padding:20px; background:#f8f9fa; border-radius:8px;">
				        <div id="kpi-value" class="kpi-value" style="font-size:2rem; font-weight:bold;">--</div>
<!-- 				        <div class="kpi-label" style="font-size:1rem; color:#666;">현재 재고</div> -->
				        <div id="kpi-change" class="kpi-change" style="font-size:0.9rem; margin-top:8px;">--</div>
				    </div>
				</div>
			</div>
	        
	        <br>
	        
            <div class="dashboard-charts">
                <!-- 📌 재고현황 -->
				<div class="chart-card">
				    <h3 class="card-title" align="center">카테고리별 재고 현황</h3>
				    <hr> <!-- 제목 밑에 선 -->
				
				    <div style="display: flex; gap: 20px;">
				        <div class="chart-wrapper">
				            <canvas id="inventory_chart"></canvas>
				        </div>
				        <div class="chart-wrapper">
				            <canvas id="inventory_detail_chart"></canvas>
				        </div>
				    </div>
				</div>

                <br>

                <!-- 로케이션 용적률 -->
                <div class="chart-card">
                    <h3 class="card-title" id="location_title" align="center">로케이션 용적률</h3>
                    <hr>
                    <!--?Pallet Zone -->
				    <div style="margin-bottom: 10px;">
					    <h4 class="heatmap-title" align="center">Pallet Zone</h4>
					    <div id="pallet_heatmap" class="heatmap-scroll"></div>
					</div>
				
				    <!-- Picking Zone -->
				    <div>
					    <h4 class="heatmap-title" align="center">Picking Zone</h4>
					    <div id="picking_heatmap" class="heatmap-scroll"></div>
					</div>
				    
				     <!-- 범례 -->
                    <div id="heatmap-legend" style="display: flex; align-items: center; gap: 8px; margin-top: 16px; padding-left: 4px; font-size: 12px; color: #333;">
                        <span>Empty</span>
                        <div style="width: 20px; height: 20px; background: #2196F3;"></div>
                        <div style="width: 20px; height: 20px; background: #4CAF50;"></div>
                        <div style="width: 20px; height: 20px; background: #CDDC39;"></div>
                        <div style="width: 20px; height: 20px; background: #FFEB3B;"></div>
                        <div style="width: 20px; height: 20px; background: #FF9800;"></div>
                        <div style="width: 20px; height: 20px; background: #F44336;"></div>
                        <div style="width: 20px; height: 20px; background: #6A1B9A;"></div>
                        <span>Full</span>
                    </div>
                    
                    <!-- ?히트맵 툴팁 -->
                    <div id="tooltip" style="position: absolute; background: rgba(0,0,0,0.8); color: white; padding: 8px; border-radius: 4px; font-size: 14px; display: none; pointer-events: none;"></div>
                </div>
            </div>
        </div>
    </section>

    <!-- 별도 JS 파일 -->
    <script src="${pageContext.request.contextPath}/resources/js/inventory/inventoryDashboard.js"></script>
</body>
</html>
