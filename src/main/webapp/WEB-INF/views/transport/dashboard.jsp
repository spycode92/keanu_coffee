<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운송관리대시보드</title>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link
	href="${pageContext.request.contextPath}/resources/css/common/common.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style type="text/css">
.container {
	max-width: 1264px;
	margin: 24px auto 56px;
	padding: 0 16px;
}

.card-grid {
	display: grid;
	grid-template-columns: repeat(5, minmax(220px, 1fr));
	gap: 1rem;
	align-items: start; /* 세로로 늘어지는 거 방지 */
	margin-bottom: 1em;
}

/* 카드 개별 스타일(이 섹션 한정) */
.card-grid .card {
	margin-bottom: 0; 
	padding: 14px 16px; 
	height: 110px;
	display: block; 
	overflow: hidden; 
}

/* 제목: 얇게, 아래 여백만 */
.card-grid .card-header {
	border: 0;
	padding: 0;
	margin: 0 0 6px;
	font-size: .95rem;
	color: var(- -muted-foreground);
}

/* 숫자: 강조 */
.card-grid .kpi-value {
	font-size: 1.75rem;
	font-weight: 700;
	line-height: 1.1;
	margin: 4px 0 6px;
	color: var(- -foreground);
}

/* 보조 텍스트 */
.card-grid .kpi-sub {
	font-size: .85rem;
	color: var(- -muted-foreground);
}

/* 화면이 줄어들면 2개씩 */
@media ( max-width : 1024px) {
	.card-grid {
		grid-template-columns: repeat(2, minmax(220px, 1fr));
	}
}

/* 더 좁으면 1개(선택) */
@media ( max-width : 560px) {
	.card-grid {
		grid-template-columns: 1fr;
	}
}

.chart-card{
    background: var(--card);
    color: var(--card-foreground);
    border: 1px solid var(--border);
    border-radius: var(--radius, 12px);
    padding: 12px;
}
.chart-card .card-header{
    font-weight: 600;
    margin-bottom: 8px;
    border-bottom: 1px solid var(--border);
    padding-bottom: 8px;
}

/* 그래프를 안정적으로 고정 높이로 */
.chart-wrap{
    position: relative;
    height: 220px;          /* 필요 시 180~260px로 조절 */
    width: 100%;
}
.chart-wrap canvas{
    display: block;         /* 인라인 여백 제거 */
    width: 100% !important;
    height: 100% !important;
}

/* 기존 그리드는 그대로 사용 */
.chart-grid{
    display: grid;
    grid-template-columns: repeat(2, minmax(260px, 1fr));
    gap: 1rem;
}
@media (max-width: 900px){
    .chart-grid{ grid-template-columns: 1fr; }
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
					<div class="card-header">공차율</div>
					<div class="kpi-value">5</div>
				</div>
				<div class="card">
					<div class="card-header">추가 차량 배정</div>
					<div class="kpi-value">2</div>
				</div>
			</section>
		</div>
		<!-- 그래프 그리드 -->
		<section class="chart-grid">
		    <div class="chart-card">
		        <div class="card-header">기사별 파손율</div>
		        <div class="chart-wrap">
		            <canvas id="driverDamageChart"></canvas>
		        </div>
		    </div>
		    <div class="chart-card">
		        <div class="card-header">구역별 평균 운송시간</div>
		        <div class="chart-wrap">
		            <canvas id="regionTimeChart"></canvas>
		        </div>
		    </div>
		</section>
		<div style="margin-bottom: 2em;">
			<div
				style="display: flex; justify-content: space-between; align-items: center;">
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
						<th>첨부파일</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>2025-08-11</td>
						<td>김배송</td>
						<td>원두1</td>
						<td>동래구청</td>
						<td>납품확인서_250811</td>
						<td>file</td>
					</tr>
				</tbody>
			</table>
		</div>
	</section>
	<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
	<script>
		//CSS 변수 읽기(라이트/다크 자동 연동)
		function cssVar(name) {
			return getComputedStyle(document.documentElement).getPropertyValue(
					name).trim();
		}
		var cPrimary = cssVar('--primary') || '#5660fe';
		var cGrid = cssVar('--border') || '#e5e7eb';
		var cFg = cssVar('--foreground') || '#111827';
		var cIndigo = '#a5b4fc';
		var cBlue = '#93c5fd';

		Chart.defaults.font.family = "-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Arial,sans-serif";
		Chart.defaults.color = cFg;
		Chart.defaults.borderColor = cGrid;

		/* ===================== 더미 데이터 ===================== */
		// 1) 기사별 파손율(%) — 막대 그래프
		var driverLabels = [ '김배송', '이배송', '최배송', '박배송', '정배송', '오배송' ];
		var damageRates = [ 0.8, 1.6, 0.4, 1.1, 0.6, 2.0 ]; // %

		// 2) 구역별 평균 운송시간(분) — 막대(또는 선) 그래프
		var regionLabels = [ '동래구', '남구', '수영구', '해운대구', '연제구', '부산진구' ];
		var avgMinutes = [ 42, 55, 38, 62, 47, 51 ]; // 분

		/* ===================== 1) 기사별 파손율 ===================== */
		var ctxDamage = document.getElementById('driverDamageChart');
		new Chart(ctxDamage, {
			type : 'bar',
			data : {
				labels : driverLabels,
				datasets : [ {
					label : '파손율(%)',
					data : damageRates,
					backgroundColor : cIndigo,
					borderWidth : 0,
					borderRadius : 6,
					maxBarThickness : 38
				} ]
			},
			options : {
				responsive : true,
				maintainAspectRatio : false,
				scales : {
					y : {
						beginAtZero : true,
						suggestedMax : 3, // 필요 시 조정
						ticks : {
							callback : function(v) {
								return v + '%';
							}
						},
						grid : {
							drawBorder : false
						}
					},
					x : {
						grid : {
							display : false
						}
					}
				},
				plugins : {
					legend : {
						display : false
					},
					tooltip : {
						callbacks : {
							label : function(ctx) {
								return ' ' + (ctx.raw || 0) + '%';
							}
						}
					}
				}
			}
		});

		/* ===================== 2) 구역별 평균 운송시간 ===================== */
		var ctxRegion = document.getElementById('regionTimeChart');
		new Chart(ctxRegion, {
			type : 'bar', // 선형으로 바꾸려면 'line'
			data : {
				labels : regionLabels,
				datasets : [ {
					label : '평균 운송시간(분)',
					data : avgMinutes,
					backgroundColor : cBlue,
					borderWidth : 0,
					borderRadius : 6,
					maxBarThickness : 38,
				// type: 'line', borderColor: cPrimary, fill: false, tension: 0.3  // 혼합형 예시
				} ]
			},
			options : {
				responsive : true,
				maintainAspectRatio : false,
				scales : {
					y : {
						beginAtZero : true,
						suggestedMax : 70,
						ticks : {
							callback : function(v) {
								return v + '분';
							}
						},
						grid : {
							drawBorder : false
						}
					},
					x : {
						grid : {
							display : false
						}
					}
				},
				plugins : {
					legend : {
						display : false
					},
					tooltip : {
						callbacks : {
							label : function(ctx) {
								return ' ' + (ctx.raw || 0) + '분';
							}
						}
					}
				}
			}
		});
	</script>
</body>
</html>