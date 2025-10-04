<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>입고 관리</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

	<style>
		/* =========================
		   KPI 가로 4등분 (대시보드 전용)
		   ========================= */
		.kpi-row {
			display: grid;
			grid-template-columns: repeat(4, minmax(0, 1fr));
			gap: 1rem;
			padding: 0;
			box-sizing: border-box;
			width: 100%;
			max-width: 100%;
		}
	
		/* 상단 KPI는 .col-md-3가 있으므로 패딩 제거 */
		.kpi-row > .col-md-3 {
			flex: initial;
			max-width: initial;
			padding: 0;
		}
	
		/* KPI 카드 스타일 */
		.kpi-row .kpi-card {
			max-width: 85%;
			min-width: 75%;
			margin-left: 10px;
			margin-bottom: 2rem;
			min-height: 120px;
			display: flex;
			flex-direction: column;
			justify-content: space-between;
		}

		
		.card-body canvas {
		    height: 300px !important;
		}
		
		.col-md-6 {
		    flex: 0 0 50%;
		    max-width: 49%;
		    padding: 0.5rem;
		}
		.col-md-12 {
		    flex: 0 0 100%;
		    max-width: 99%;
		    padding: 0.5rem;
		}
		
	</style>

</head>


<body>
	<!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<!-- 반드시 content 안에서 시작 -->
	<section class="content">

		<!-- 상단 KPI (월간) : 4개 한 줄 -->
		<div class="row kpi-row mb-4 text-center">
			<div class="col-md-3">
				<div class="kpi-card">
					<div class="text-muted">총 입고건수(월)</div>
					<div class="kpi-value">990건</div>
					<div class="kpi-change positive">+120건 (전월 대비)</div>
				</div>
			</div>
			<div class="col-md-3">
				<div class="kpi-card">
					<div class="text-muted">총 출고건수(월)</div>
					<div class="kpi-value">980건</div>
					<div class="kpi-change negative">-45건 (전월 대비)</div>
				</div>
			</div>
			<div class="col-md-3">
				<div class="kpi-card">
					<div class="text-muted">총 재고수량</div>
					<div class="kpi-value">85,320</div>
					<div class="text-muted">EA</div>
				</div>
			</div>
			<div class="col-md-3">
				<div class="kpi-card">
					<div class="text-muted">지연 처리 건</div>
					<div class="kpi-value">8건</div>
					<div class="kpi-change negative">확인 필요</div>
				</div>
			</div>
		</div>
		<!-- 그래프 영역 -->
		<!-- 월별 입고 건수 & 창고별 입고 비율 -->
		<div class="row mt-4">
		    <!-- 막대그래프 -->
		    <div class="col-md-6 mb-4">
		        <div class="card">
		            <div class="card-header">월별 입고 건수</div>
		            <div class="card-body">
		                <canvas id="barChart"></canvas>
		            </div>
		        </div>
		    </div>
		
		    <!-- 원형그래프 -->
		    <div class="col-md-6 mb-4">
		        <div class="card">
		            <div class="card-header">창고별 입고 비율</div>
		            <div class="card-body">
		                <canvas id="pieChart"></canvas>
		            </div>
		        </div>
		    </div>
		</div>
		
		<!-- 선그래프 -->
		<div class="row">
		    <div class="col-md-12 mb-4">
		        <div class="card">
		            <div class="card-header">최근 7일 입고 추이</div>
		            <div class="card-body">
		                <canvas id="lineChart"></canvas>
		            </div>
		        </div>
		    </div>
		</div>
		
	</section>
	
	<script>
	document.addEventListener("DOMContentLoaded", function () {
	    // 막대그래프
	    new Chart(document.getElementById("barChart"), {
	        type: 'bar',
	        data: {
	            labels: ["1월", "2월", "3월", "4월", "5월", "6월", "7월"],
	            datasets: [{
	                label: "입고 건수",
	                data: [120, 150, 180, 90, 200, 170, 220],
	                backgroundColor: '#4e73df'
	            }]
	        },
	        options: { responsive: true, maintainAspectRatio: false }
	    });
	
	    // 원형그래프
	    new Chart(document.getElementById("pieChart"), {
	        type: 'pie',
	        data: {
	            labels: ["중앙창고", "동부창고", "서부창고"],
	            datasets: [{
	                data: [45, 35, 20],
	                backgroundColor: ['#1cc88a', '#36b9cc', '#f6c23e']
	            }]
	        },
	        options: { responsive: true, maintainAspectRatio: false }
	    });
	
	    // 선그래프
	    new Chart(document.getElementById("lineChart"), {
	        type: 'line',
	        data: {
	            labels: ["8/05", "8/06", "8/07", "8/08", "8/09", "8/10", "8/11"],
	            datasets: [{
	                label: "입고 수량",
	                data: [500, 800, 600, 900, 700, 1200, 1100],
	                borderColor: '#e74a3b',
	                fill: false,
	                tension: 0.3
	            }]
	        },
	        options: { responsive: true, maintainAspectRatio: false }
	    });
	    
	    
	    
	});
	</script>
	
</body>
</html>
