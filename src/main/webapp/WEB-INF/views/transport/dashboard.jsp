<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운송관리대시보드</title>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/transport/common.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0"></script>
<script src="/resources/js/admin/statistics/statistics1.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2b14d97248052db181d2cfc125eaa368&libraries=services"></script>	
<script src="${pageContext.request.contextPath}/resources/js/transport/dispatch.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/deliveryConfirmation.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/transport/kakao_map.js"></script>
<style type="text/css">
.container {
	max-width: 1264px;
	margin: 24px auto 56px;
	padding: 0 16px;
}

.card-grid {
	display: grid;
	grid-template-columns: repeat(4, minmax(220px, 1fr));
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
	font-size: 1.2rem;
	text-align: center;
	color: var(--muted-foreground);
	font-weight: bold;
}

/* 숫자: 강조 */
.card-grid .kpi-value {
	font-size: 2rem;
	font-weight: 700;
	line-height: 1.1;
	margin: 4px 0 6px;
	color: var(--foreground);
	text-align: center;
	margin-top: .5em;
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

 /* 각 차트 박스 공통 스타일 */
 
 .dashboard-charts {
 	display: flex;
	flex-direction: row;
	gap: 10px;
}
 
.chart-card {
    flex: 1 1 300px;
    min-width: 240px;
    min-height: 300px;
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

.help, .hint { font-size: .83rem; color: var(--muted-foreground); }


button:disabled {
  background: linear-gradient(145deg, #e0e0e0, #c0c0c0);
  color: #999;
  border: 1px solid #bbb;
  cursor: not-allowed;
  opacity: 0.7;
  transform: none;   /* hover시 scale 효과 제거 */
}

.field { display: flex; flex-direction: column; gap: 6px; }
.field input { height: 38px; border: 1px solid var(--border); border-radius: 10px; padding: 0 10px; background: #f9fafb; }

.link {
	color: #64748b;
	font-size: 0.9rem;
	cursor: pointer;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	<section class="content">
		<h1>운송관리</h1>
		<div>
			<section class="card-grid">
				<div class="card">
					<div class="card-header">배차대기(일)</div>
					<div class="kpi-value">${pendingDispatchCount}건</div>
				</div>
				<div class="card">
					<div class="card-header">배송중(일)</div>
					<div class="kpi-value">${dispatchInProgressCount}건</div>
				</div>
				<div class="card">
					<div class="card-header">배송완료(일)</div>
					<div class="kpi-value">${dispatchCompletedCount}건</div>
				</div>
				<div class="card">
					<div class="card-header">긴급요청</div>
					<div class="kpi-value">${urgentDispatchCount}건</div>
				</div>
			</section>
		</div>
		<!-- 그래프 그리드 -->
	    <div class="card">
	        <div class="card-header d-flex justify-content-between align-items-center">
			    <!-- 왼쪽: 제목 + 날짜 선택기 -->
			    <div class="d-flex align-items-center gap-2">
			        <div class="date-selection">
			            <div class="d-flex align-items-center gap-2">
			                <div>
			                    <input type="date" id="baseDate" class="form-control date-input-small" style="max-width:100px">
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
	            <br>
	            <!-- 운송/출고 차트 -->
	            <div class="chart-card">
	                <h3 class="card-title" id="outbound_title">출고/운송 현황</h3>
	                <canvas id="OBoverallChart" style="width:80%; height:100%;"></canvas>
	            </div>
	            <br>
	            <!-- 폐기량 꺽은선차트 -->
	            <div class="chart-card">
	                <h3 class="card-title">폐기 현황1</h3>
	                <canvas id="disposalChart" style="width:80%; height:100%;"></canvas>
	            </div>
	        </div>
	    </div>

		<div style="margin-bottom: 2em;" class="card">
			<div
				style="display: flex; justify-content: space-between; align-items: center;">
				<h3>오늘 배차 목록</h3>
				<div><a href="/transport/dispatches" class="link">전체보기</a></div>
			</div>
			<c:choose>
				<c:when test="${empty dispatchList}">
					<div class="empty-result">오늘 배정된 배차가 없습니다.</div>
				</c:when>
				<c:otherwise>
					<table class="table">
						<thead>
							<tr>
								<th>배차일</th>
								<th>배차시간</th>
								<th>기사명</th>
		                        <th>차량번호</th>
		                        <th>차량용량</th>
		                        <th>구역</th>
		                        <th>상태</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="dispatch" items="${dispatchList}">
								<tr data-dispatch-idx="${dispatch.dispatchIdx }" 
		                			data-vehicle-idx="${dispatch.vehicleIdx}" class="dispatchInfo">
									<td>
										<fmt:formatDate value="${dispatch.dispatchDate}" pattern="yyyy-MM-dd"/>
									</td>
									<td>${dispatch.startSlot}</td>
									<td>${dispatch.driverName}</td>
									<td>${dispatch.vehicleNumber}</td>
									<td>
	                					<c:choose>
											<c:when test="${dispatch.capacity == 1000 }">
												1.0t
											</c:when>
											<c:otherwise>
												1.5t
											</c:otherwise>
										</c:choose>
		                			</td>
		                			<td>${dispatch.regionName}</td>
		                			<td>
		                				<c:choose>
		                					<c:when test="${dispatch.status eq '완료'}">
		                						<span class="badge done">완료</span>
		                					</c:when>
		                					<c:when test="${dispatch.status eq '예약'}">
		                						<span class="badge book">예약</span>
		                					</c:when>
		                					<c:when test="${dispatch.status eq '적재완료'}">
		                						<span class="badge loaded">적재완료</span>
		                					</c:when>
		                					<c:when test="${dispatch.status eq '운행중'}">
		                						<span class="badge run">운행중</span>
		                					</c:when>
		                					<c:otherwise>
		                						<span class="badge cancel">취소</span>
		                					</c:otherwise>
		                				</c:choose>
		                			</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:otherwise>
			</c:choose>
		</div>
		<%-- 상세 모달(배차 클릭 시) --%>
		<jsp:include page="/WEB-INF/views/transport/modal/detail_dispatch.jsp"></jsp:include>
		<div class="card">
			<h3>수주확인서 목록</h3>
			<table class="table">
				<thead>
					<tr>
						<th>제출일</th>
						<th>기사명</th>
						<th>지점명</th>
						<th>수령자</th>
						<th>서류</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="deliveryConfirmation" items="${deliveryConfirmationList}">
						<tr>
							<td>
								<fmt:formatDate value="${deliveryConfirmation.updated_at}" pattern="yyyy-MM-dd"/>
							</td>
							<td>${deliveryConfirmation.emp_name}</td>
							<td>${deliveryConfirmation.franchise_name}</td>
							<td>${deliveryConfirmation.receiver_name}</td>
							<td>수주확인서${deliveryConfirmation.delivery_confirmation_idx}</td>
							<td>
								<button class="btn btn-destructive" onclick="openDeliveryConfirmationDetail('${deliveryConfirmation.delivery_confirmation_idx}')">상세보기</button>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</section>
</body>
</html>