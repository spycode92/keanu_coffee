<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>출고 관리</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

	<style>
		/* KPI 가로 4등분 (대시보드 전용) */
		.kpi-row {
			display: grid;
			grid-template-columns: repeat(4, minmax(0, 1fr));
			gap: 1rem;
			padding: 0;
			box-sizing: border-box;
			width: 100%;
			max-width: 100%;
		}
		.kpi-row > .col-md-3 {
			flex: initial;
			max-width: initial;
			padding: 0;
		}
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
		@media (max-width: 1024px) {
			.kpi-row { grid-template-columns: repeat(2, minmax(0, 1fr)); }
		}
		@media (max-width: 600px) {
			.kpi-row { grid-template-columns: 1fr; }
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
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<section class="content">
		<!-- 상단 KPI -->
		<div class="row kpi-row mb-4 text-center">
			<div class="col-md-3">
				<div class="kpi-card">
					<div class="text-muted">총 출고건수(월)</div>
					<div class="kpi-value">980건</div>
					<div class="kpi-change positive">+95건 (전월 대비)</div>
				</div>
			</div>
			<div class="col-md-3">
				<div class="kpi-card">
					<div class="text-muted">총 반품건수(월)</div>
					<div class="kpi-value">35건</div>
					<div class="kpi-change negative">-5건 (전월 대비)</div>
				</div>
			</div>
			<div class="col-md-3">
				<div class="kpi-card">
					<div class="text-muted">총 출고 수량</div>
					<div class="kpi-value">72,450</div>
					<div class="text-muted">EA</div>
				</div>
			</div>
			<div class="col-md-3">
				<div class="kpi-card">
					<div class="text-muted">지연 출고 건</div>
					<div class="kpi-value">6건</div>
					<div class="kpi-change negative">확인 필요</div>
				</div>
			</div>
		</div>

		<!-- 그래프 영역 -->
		<div class="row mt-4">
		    <!-- 막대그래프 -->
		    <div class="col-md-6 mb-4">
		        <div class="card">
		            <div class="card-header">월별 출고 건수</div>
		            <div class="card-body">
		                <canvas id="barChart"></canvas>
		            </div>
		        </div>
		    </div>

		    <!-- 원형그래프 -->
		    <div class="col-md-6 mb-4">
		        <div class="card">
		            <div class="card-header">창고별 출고 비율</div>
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
		            <div class="card-header">최근 7일 출고 추이</div>
		            <div class="card-body">
		                <canvas id="lineChart"></canvas>
		            </div>
		        </div>
		    </div>
		</div>
	</section>

	<script>
	document.addEventListener("DOMContentLoaded", function () {
	    // 월별 출고 건수 (막대그래프)
	    new Chart(document.getElementById("barChart"), {
	        type: 'bar',
	        data: {
	            labels: ["1월", "2월", "3월", "4월", "5월", "6월", "7월"],
	            datasets: [{
	                label: "출고 건수",
	                data: [100, 130, 160, 120, 190, 180, 210],
	                backgroundColor: '#ff6384'
	            }]
	        },
	        options: { responsive: true, maintainAspectRatio: false }
	    });

	    // 창고별 출고 비율 (원형그래프)
	    new Chart(document.getElementById("pieChart"), {
	        type: 'pie',
	        data: {
	            labels: ["중앙창고", "동부창고", "서부창고"],
	            datasets: [{
	                data: [40, 38, 22],
	                backgroundColor: ['#36a2eb', '#ffcd56', '#4bc0c0']
	            }]
	        },
	        options: { responsive: true, maintainAspectRatio: false }
	    });

	    // 최근 7일 출고 추이 (선그래프)
	    new Chart(document.getElementById("lineChart"), {
	        type: 'line',
	        data: {
	            labels: ["8/05", "8/06", "8/07", "8/08", "8/09", "8/10", "8/11"],
	            datasets: [{
	                label: "출고 수량",
	                data: [450, 700, 550, 880, 640, 1000, 970],
	                borderColor: '#36a2eb',
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
