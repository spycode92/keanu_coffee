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
	    grid-template-columns: repeat(3, 1fr); /* [변경] 3열 */
	    gap: 20px;
	    margin: 20px;
	}
	/* [추가] 제목 바: 그리드 전체 가로폭 차지 */
	.page-bar {
	    grid-column: 1 / -1;
	    display: flex;
	    align-items: center;
	    justify-content: space-between;
	    margin-top: 0;
	    margin-bottom: 6px;
	}
	.page-bar h2 {
	    margin: 0;
	}

	.card {
	    border: 1px solid #ccc;
	    border-radius: 10px;
	    padding: 20px;
	    box-shadow: 2px 2px 8px rgba(0,0,0,0.1);
	}
	.card h3 { margin-bottom: 10px; }

	table { width: 100%; border-collapse: collapse; margin-top: 10px; }
	th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
	th { background-color: #f8f8f8; }
	canvas { max-width: 100%; }

	.refresh-btn {
	    border: none; background: none; cursor: pointer;
	    font-size: 20px; color: #4e73df; padding: 4px;
	    transition: transform 0.2s ease;
	}
	.refresh-btn:hover { transform: rotate(90deg); }
</style>
</head>
<body>

	<!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	
	<!-- 제목: 그래프/대시보드 바로 위 -->
	<div class="dashboard-container">
		<!-- [추가] 대시보드 상단 제목 바 (그래프/카드 '위') -->
		<div class="page-bar">
			<h2>재고관리 대시보드</h2>
			<button id="refreshBtn" class="refresh-btn" title="새로고침">&#x21bb;</button>
		</div>

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

	    <!-- 로케이션 용적률 (같은 줄) -->
	    <div class="card" style="height: 200px;">
	        <h3>로케이션 용적률</h3>
	        <canvas id="locationChart" style="width:100%; height:120px;"></canvas>
	    </div>

	    <!-- 상품별 재고 현황 (아래 가로 전체) -->
	    <div class="card" style="grid-column: 1 / -1;">
	        <h3>상품별 재고 현황</h3>
	        <canvas id="stockChart" style="width: 100%; height: 260px;"></canvas> <!-- [변경] 조금 더 키움 -->
	    </div>
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
	                backgroundColor: '#4e73df',
	                hoverBackgroundColor: 'rgba(200, 0, 200, 1)' // ← 마우스 오버 시 색상
	            }]
	        },
	        options: {
	            responsive: true,
	            plugins: { legend: { display: false }, title: { display: false } },
	            scales: { y: { beginAtZero: true } }
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
	                backgroundColor: 'rgba(28, 200, 138, 1)',
	                hoverBackgroundColor: 'rgba(200, 0, 200, 1)'
	            }]
	        },
	        options: {
	            responsive: true,
	            plugins: { legend: { display: false } },
	            scales: { y: { beginAtZero: true, max: 100 } }
	        }
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
