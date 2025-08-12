<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고현황</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style>
	.dashboard-container {
	    display: grid;
	    grid-template-columns: repeat(2, 1fr);
	    gap: 20px;
	    margin: 20px;
	}
	.card {
	    border: 1px solid #ccc;
	    border-radius: 10px;
	    padding: 20px;
	    box-shadow: 2px 2px 8px rgba(0,0,0,0.1);
	}
	.card h3 {
	    margin-bottom: 10px;
	}
	
	.ctxCard {
		border: 1px solid #ccc;
	    border-radius: 10px;
	    padding: 20px;
	    box-shadow: 2px 2px 8px rgba(0,0,0,0.1);
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
	    border: none;
	    background: none;
	    cursor: pointer;
	    font-size: 20px;
	    color: #4e73df;
	    padding: 4px;
	    transition: transform 0.2s ease;
	}
	.refresh-btn:hover { transform: rotate(90deg); }
	
	.page-title {
	    margin-top: 5px;     /* 위 간격 줄이기 */
	    margin-bottom: 10px; /* 아래 간격 */
	}
</style>
</head>
<body>

	<!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	
	<!-- 제목: 그래프/대시보드 바로 위 -->
	<div>
		<h2 class="page-title" style="
		    display:flex;
		    align-items:center;
		    gap:10px;
		    margin: 0 0 10px 80px;  /* 상단 여백 제거 + 좌측 위치 조정 */
		">
		    재고관리 대시보드
		    <button id="refreshBtn" class="refresh-btn" title="새로고침">&#x21bb;</button>
		</h2>
	</div>
	<div class="dashboard-container">
	    <!-- 총 재고 수량 -->
	    <div class="card">
	        <h3>총 재고 수량</h3>
	        <p style="font-size: 28px; font-weight: bold;">3,150개</p>
	    </div>
	
	    <!-- 입고/출고 현황 -->
	    <div class="card">
	        <h3>입고/출고 현황</h3>
	        <p>오늘 입고: <strong>15건</strong></p>
	        <p>오늘 출고: <strong>10건</strong></p>
	    </div>
	
	    <!-- 상품별 재고 현황 -->
	    <div class="card">
	        <h3>상품별 재고 현황</h3>
	        <canvas id="stockChart"></canvas>
	    </div>
	
	    <!-- 임박/만료 재고 현황 -->
	    <div class="card">
	        <h3>임박/만료 재고</h3>
	        <canvas id="expireChart"></canvas>
	    </div>
		</div>
	    <!-- 로케이션 용적률 -->
	    <div class="ctxCard" style="grid-column: span 2;">
	        <h3>로케이션 용적률</h3>
	        <canvas id="locationChart"></canvas>
	    </div>
	<script>
	    // 상품별 재고 차트
	    const stockCtx = document.getElementById('stockChart').getContext('2d');
	    new Chart(stockCtx, {
	        type: 'bar',
	        data: {
	            labels: ['컵 3호', '컵 4호', '컵 5호', '설탕 시럽', '헤이즐넛 시럽', '빨대(큰거)', '빨대(작은거)', '원두(다크)', '원두(디카페인)', '냅킨'],
	            datasets: [{
	                label: '재고 수량',
	                data: [500, 400, 300, 250, 230, 180, 170, 200, 150, 270],
	                backgroundColor: '#4e73df'
	            }]
	        },
	        options: {
	            responsive: true,
	            plugins: {
	                legend: { display: false },
	                title: { display: false }
	            },
	            scales: {
	                y: {
	                    beginAtZero: true
	                }
	            }
	        }
	    });
	
	    // 임박/만료 재고 차트
	    const expireCtx = document.getElementById('expireChart').getContext('2d');
	    new Chart(expireCtx, {
	        type: 'doughnut',
	        data: {
	            labels: ['임박', '만료'],
	            datasets: [{
	                label: '건수',
	                data: [12, 3],
	                backgroundColor: ['#f6c23e', '#e74a3b']
	            }]
	        },
	        options: {
	            responsive: true,
	            plugins: {
	                legend: { position: 'bottom' }
	            }
	        }
	    });
	
	    // 로케이션 용적률 차트
	    const locationCtx = document.getElementById('locationChart').getContext('2d');
		new Chart(locationCtx, {
		    type: 'bar',
		    data: {
		        labels: ['A-1', 'A-2', 'B-1', 'B-2', 'C-1'],
		        datasets: [{
		            label: '용적률 (%)',
		            data: [90, 70, 100, 60, 50],
		            backgroundColor: 'rgba(28, 200, 138, 0.8)',
		            hoverBackgroundColor: 'rgba(199, 200, 138, 1)'
		        }]
		    },
		    options: {
		        responsive: true,
		        plugins: {
		            legend: { display: false }
		        },
		        scales: {
		            y: {
		                beginAtZero: true,
		                max: 100
		            }
		        }
		    }
		});

		// 새로고침 버튼 동작
		$('#refreshBtn').on('click', function(){
			// 여기에 데이터 갱신 로직 추가
			alert('대시보드 데이터를 새로 불러옵니다.');
		});
	</script>
</body>
</html>
