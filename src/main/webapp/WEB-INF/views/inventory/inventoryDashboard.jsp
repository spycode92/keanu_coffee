<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고현황 대시보드</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style>
	/* !!! 추가: 대시보드 폭 고정용 래퍼 */
	.dash-wrap {
		padding: 20px;
	}
	
	.dash-inner {
		max-width: 1200px;   /* 필요시 1280~1360px로 조정 */
		margin: 0 auto;
		width: 100%;
	}
	
	.dashboard-container {
	    display: grid;
	    grid-template-columns: repeat(3, minmax(0, 1fr)); /* !!! 변경: minmax로 폭 안정화 */
	    gap: 20px;
	    /* margin: 20px; → !!! 변경: 바깥 여백은 dash-wrap에 위임 */
	}
	
	/* !!! 추가: 제목 바 전체 폭 차지 */
	.page-bar {
	    grid-column: 1 / -1;
	    display: flex;
	    align-items: center;
	    justify-content: space-between;
	    margin: 0 0 6px 0;
	}
	
	.page-bar h2 {
	    margin: 0;
	}
	
	.card {
	    border: 1px solid #ccc;
	    border-radius: 10px;
	    padding: 20px;
	    box-shadow: 2px 2px 8px rgba(0,0,0,0.1);
	    background: rgba(255,255,255,0.18); /* !!! 추가: 가이드 톤 반투명 */
	    backdrop-filter: blur(2px);          /* !!! 추가: 유리 느낌 */
	}
	
	.card h3 {
		margin-bottom: 10px;
	}
	
	table {
		width: 100%;
		border-collapse: collapse;
		margin-top: 10px;
	}
	
	th, td {
		border: 1px solid #ddd;
		padding: 8px;
		text-align: center;
	}
	
	th {
		background-color: #f8f8f8;
	}
	
	canvas {
		max-width: 100%;
	}

	.refresh-btn {
	    border: none; background: none; cursor: pointer;
	    font-size: 20px; color: #4e73df; padding: 4px;
	    transition: transform 0.2s ease;
	}
	.refresh-btn:hover { 
		transform: rotate(90deg);
	}
	
	/* !!! 추가: KPI 카드 높이 통일 */
	.kpi { min-height: 220px; }
	
	/* !!! 추가: 반응형 그리드 */
	@media (max-width: 1024px) {
		.dashboard-container { grid-template-columns: repeat(2, minmax(0,1fr)); }
	}
	
	@media (max-width: 640px) {
		.dashboard-container { grid-template-columns: 1fr; }
	}
</style>
</head>
<body>

	<!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	
	<!-- !!! 추가: 폭 고정 래퍼 -->
	<main class="dash-wrap">
	<div class="dash-inner">
	
		<!-- 제목: 그래프/대시보드 바로 위 -->
		<div class="dashboard-container">
			<!-- [추가] 대시보드 상단 제목 바 (그래프/카드 '위') -->
			<div class="page-bar">
				<h2>재고현황 대시보드</h2>
				<button id="refreshBtn" class="refresh-btn" title="새로고침">&#x21bb;</button>
			</div>
	
		    <!-- 총 재고 수량 -->
		    <div class="card">
			    <h3>총 재고 수량</h3>
			    <p id="totalStock" style="font-size: 28px; font-weight: bold;">0개</p>
			</div>
	
		    <!-- 입고/출고 현황 -->
		    <div class="card">
			    <h3>입고/출고 현황</h3>
			    <p>금일 입고: <strong id="todayInbound">0건</strong></p>
			    <p>금일 출고: <strong id="todayOutbound">0건</strong></p>
			</div>
	
		    <!-- 로케이션 용적률 -->
			<div class="card" style="height: 200px;">
			    <h3>로케이션 용적률</h3>
			    <canvas id="locationChart" style="width:100%; height:120px;"></canvas>
			</div>
	
		    <!-- 카테고리별 재고 현황 -->
		    <div class="card" style="grid-column: 1 / -1;">
		        <h3>카테고리별 재고 현황</h3>
		        <canvas id="stockChart" style="width: 100%; height: 260px;"></canvas> <!-- [변경] 조금 더 키움 -->
		    </div>
		</div>
	</div>
	</main>
	
	<script>
		// ================ 총 재고 수량 불러오기 ================
		function loadTotalStock() {
		    $.getJSON('${pageContext.request.contextPath}/inventory/api/total-stock', function(data) {
		        $('#totalStock').text(data.totalStock + '개');
		    });
		}
	
		// 페이지 로딩 시 실행
		$(document).ready(function() {
		    loadTotalStock();
		})
		
		// ================ 금일 입고/출고 현황 불러오기 ================
		function loadTodayInOut() {
		    $.getJSON('${pageContext.request.contextPath}/inventory/api/today-inout', function(data) {
		        $('#todayInbound').text(data.inbound + '건');
		        $('#todayOutbound').text(data.outbound + '건');
		    });
		}

		$(document).ready(function() {
		    loadTodayInOut();
		});
		
		// ================ 로케이션 용적률 ================
	    function loadLocationUsage() {
		    $.getJSON('${pageContext.request.contextPath}/inventory/api/location-usage', function(data) {
		        console.log(data); // 확인용
		
		        const labels = data.map(item => item.location_name); // ✅ 로케이션명
		        const values = data.map(item => item.usage_rate);    // ✅ 용적률(%)
		
		        const ctx = document.getElementById('locationChart').getContext('2d');
		        new Chart(ctx, {
		            type: 'bar',
		            data: {
		                labels: labels,
		                datasets: [{
		                    label: '용적률 (%)',
		                    data: values,
		                    backgroundColor: 'rgba(28, 200, 138, 1)'
		                }]
		            },
		            options: {
		                responsive: true,
		                plugins: { legend: { display: false } },
		                scales: { y: { beginAtZero: true, max: 100 } }
		            }
		        });
		    });
		}
		
		// 페이지 로드 시 실행
		$(document).ready(function() {
		    loadLocationUsage();
		});
			
	    // ================ 카테고리별 재고 차트 (카테고리 기준) ================
		const stockCtx = document.getElementById('stockChart').getContext('2d');
		let stockChart;
		
		function loadCategoryStock() {
		    $.getJSON('${pageContext.request.contextPath}/inventory/api/category-stock', function(data) {
		        const labels = data.labels; // 카테고리 이름들 (예: 식품, 시럽, 소모품)
		        const values = data.values; // 각 카테고리별 재고 수량
		
		        if (stockChart) {
		            // 이미 차트가 있으면 데이터만 업데이트
		            stockChart.data.labels = labels;
		            stockChart.data.datasets[0].data = values;
		            stockChart.update();
		        } else {
		            // 처음 로딩 시 차트 생성
		            stockChart = new Chart(stockCtx, {
		                type: 'bar',
		                data: {
		                    labels: labels,
		                    datasets: [{
		                        label: '카테고리별 재고 수량',
		                        data: values,
		                        backgroundColor: '#4e73df',
		                        hoverBackgroundColor: 'rgba(200, 0, 200, 1)',
		                        barPercentage: 0.5,       // ✅ 막대 두께 줄이기 (기본 0.9)
		                        categoryPercentage: 0.6   // ✅ 카테고리별 간격 조정 (기본 0.8)
		                    }]
		                },
		                options: {
		                    responsive: true,
		                    plugins: { legend: { display: false } },
		                    scales: { y: { beginAtZero: true } }
		                }
		            });
		        }
		    });
		}
		
		// 페이지 로드되면 자동 실행
		$(document).ready(function() {
		    loadCategoryStock();
		});
	
	    // 새로고침 버튼 동작
	    $('#refreshBtn').on('click', function(){
	        // TODO: 데이터 갱신 로직
	        alert('대시보드 데이터를 새로 불러옵니다.');
	    	console.log("새로고침됨");
	    });
	</script>
</body>
</html>
