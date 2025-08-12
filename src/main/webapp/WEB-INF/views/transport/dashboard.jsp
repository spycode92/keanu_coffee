<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운송관리대시보드</title>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style type="text/css">
.container {
	max-width:1264px; 
	margin:24px auto 56px; 
	padding:0 16px;
}

.card-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(220px, 1fr)); /* 데스크톱: 4개 한 줄 */
  gap: 1rem;
  align-items: start; /* 세로로 늘어지는 거 방지 */
}

/* 카드 개별 스타일(이 섹션 한정) */
.card-grid .card {
  margin-bottom: 0;           /* grid gap만 사용 */
  padding: 14px 16px;         /* 조금 더 컴팩트하게 */
  height: 110px;              /* 카드 높이 짧게 고정 (원하면 100~130px로 조절) */
  display: block;             /* 가운데 정렬 방지, 상단부터 쌓임 */
  overflow: hidden;           /* 내용 길어질 때 넘침 방지 */
}

/* 제목: 얇게, 아래 여백만 */
.card-grid .card-header {
  border: 0;
  padding: 0;
  margin: 0 0 6px;
  font-size: .95rem;
  color: var(--muted-foreground);
}

/* 숫자: 강조 */
.card-grid .kpi-value {
  font-size: 1.75rem;
  font-weight: 700;
  line-height: 1.1;
  margin: 4px 0 6px;
  color: var(--foreground);
}

/* 보조 텍스트 */
.card-grid .kpi-sub {
  font-size: .85rem;
  color: var(--muted-foreground);
}

/* 화면이 줄어들면 2개씩 */
@media (max-width: 1024px) {
  .card-grid {
    grid-template-columns: repeat(2, minmax(220px, 1fr));
  }
}

/* 더 좁으면 1개(선택) */
@media (max-width: 560px) {
  .card-grid {
    grid-template-columns: 1fr;
  }
}

.chart-grid {
	display:grid; 
	grid-template-columns:repeat(2, minmax(280px, 1fr)); 
	gap:1rem; margin:24px 0;
}
.chart-card {
	background:var(--card); 
	border:1px solid var(--border); 
	border-radius:10px; padding:16px; 
	box-shadow:0 1px 2px rgba(16,24,40,.04);
}
.chart-card .card-header { 
	margin-bottom:8px;
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
<section class="container">
	<h1>운송관리</h1>
	<div>
		<section class="card-grid">
		  	<div class="card">
			    <div class="card-header">출고요청</div>
			    <div class="kpi-value">54</div>
		 	</div>
		  	<div class="card">
			    <div class="card-header">배송중</div>
			    <div class="kpi-value">87</div>
		  	</div>
		  	<div class="card">
			    <div class="card-header">배송완료</div>
			    <div class="kpi-value">312</div>
		  	</div>
		  	<div class="card">
			    <div class="card-header">파손율</div>
			    <div class="kpi-value">5</div>
		  	</div>
		  	<div class="card">
			    <div class="card-header">공차율</div>
			    <div class="kpi-value">5</div>
		  	</div>
		</section>
	</div>
	<section class="chart-grid">
    	<div class="chart-card">
	        <div class="card-header">상태 비율</div>
	        <canvas id="statusPie" height="160"></canvas>
      	</div>
      	<div class="chart-card">
	        <div class="card-header">최근 7일 배차 추이</div>
	        <canvas id="dispatchBar" height="160"></canvas>
     	</div>
    </section>
	<div style="margin-bottom: 2em;">
		<div style="display: flex; justify-content: space-between; align-items: center;">
			<h3>오늘 배차 목록</h3>
			<div>전체보기</div>		
		</div>
		<table class="table">
			<thead>
				<tr>
					<th>배차일</th>
					<th>기사명</th>
					<th>차량번호</th>
					<th>적재량</th>
					<th>목적지</th>
					<th>예상도착시간</th>
					<th>상태</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>2025-08-12</td>
					<td>김배송</td>
					<td>89바 ****</td>
					<td>1.5t</td>
					<td>동래구</td>
					<td>18:30</td>
					<td>운행중</td>
				</tr>
				<tr>
					<td>2025-08-12</td>
					<td>이배송</td>
					<td>99바 ****</td>
					<td>1.5t</td>
					<td>남구</td>
					<td>15:30</td>
					<td>운행중</td>
				</tr>
				<tr>
					<td>2025-08-12</td>
					<td>최배송</td>
					<td>79바 ****</td>
					<td>1.5t</td>
					<td>중구</td>
					<td>19:30</td>
					<td>운행중</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div>
		<h3>납품확인서 목록</h3>
		<table class="table">
			<thead>
				<tr>
					<th>제출일</th>
					<th>기사명</th>
					<th>품목</th>
					<th>납품장소</th>
					<th>서류</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>2025-08-11</td>
					<td>김배송</td>
					<td>원두1</td>
					<td>동래구청</td>
					<td>납품확인서_250811</td>
				</tr>
			</tbody>
		</table>
	</div>
</section>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script>
    // 상태 비율 도넛
    new Chart(document.getElementById('statusPie'), {
      type: 'doughnut',
      data: {
        labels: ['예약', '운행중', '완료', '지연'],
        datasets: [{ data: [12, 34, 98, 5], backgroundColor: ['#c7d2fe','#93c5fd','#86efac','#fca5a5'], borderWidth: 0 }]
      },
      options: { plugins: { legend: { position: 'bottom' } }, cutout: '62%' }
    });

    // 최근 7일 배차 추이 막대
    new Chart(document.getElementById('dispatchBar'), {
      type: 'bar',
      data: {
        labels: ['8/6','8/7','8/8','8/9','8/10','8/11','8/12'],
        datasets: [{ label: '배차 건수', data: [42,38,51,47,55,62,58], backgroundColor: '#a5b4fc', borderWidth: 0, borderRadius: 6 }]
      },
      options: { responsive: true, scales: { y: { beginAtZero: true, ticks: { stepSize: 10 } }, x: { grid: { display:false } } }, plugins: { legend: { display:false } } }
    });
  </script>
</body>
</html>