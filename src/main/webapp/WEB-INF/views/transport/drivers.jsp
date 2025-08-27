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
	href="${pageContext.request.contextPath}/resources/css/transport/common.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/resources/css/common/common.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/transport/driver.js"></script>
<style type="text/css">

.badge {
	display: inline-block;
	padding: 2px 8px;
	border-radius: 999px;
	font-size: .8rem;
	font-weight: 700
}

.badge.wait { /* 대기 */
	background: #e5e7eb;
	color: #111827
}

.badge.run { /* 운행중 */
	background: #dbeafe;
	color: #1e40af
}

.badge.left { /* 퇴사 */
	background: #fee2e2;
	color: #991b1b
}

/* 모달 공통 */
.modal { position: fixed; inset: 0; display: none; align-items: center; justify-content: center; padding: 20px; background: rgba(0,0,0,.45); z-index: 100; }
.modal.open { display: flex; }
.modal-card { width: min(900px, 96vw); background: #fff; border: 1px solid var(--border); border-radius: 12px; overflow: hidden; }
.modal-head { display: flex; justify-content: space-between; align-items: center; padding: 14px 16px; border-bottom: 1px solid var(--border); }
.modal-body { padding: 14px 16px; }
.modal-foot { display: flex; justify-content: flex-end; gap: 8px; padding: 12px 16px; border-top: 1px solid var(--border); }
.btn { display: inline-flex; align-items: center; gap: .5rem; padding: .55rem .85rem; border-radius: 10px; border: 1px solid var(--border); background: var(--primary); color: #fff; cursor: pointer; }
.btn.secondary { background: #eef2ff; color: #3949ab; border-color: #c7d2fe; }
.btn.outline { background: #fff; color: #111; }
.btn.danger { background: #ef4444; border-color: #ef4444; }

.grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.field { display: flex; flex-direction: column; gap: 6px; }
.field input { height: 38px; border: 1px solid var(--border); border-radius: 10px; padding: 0 10px; background: #f9fafb; }
.field input[disabled] { color: #4b5563; }
.section-title { font-weight: 700; margin: 10px 0 6px; }

 /* 차량 카드 / 비어있을 때 */
 .vehicle-box { border: 1px dashed #cdd3ff; border-radius: 12px; padding: 12px; background: #fafbff; display: flex; justify-content: space-between; gap: 12px; align-items: center; }
 .vehicle-meta { display: grid; gap: 4px; }
 .vehicle-meta small { color: var(--muted); }

 /* 차량 선택 모달(서브) */
 .sub-card { width: min(760px, 96vw); background: #fff; border: 1px solid var(--border); border-radius: 12px; overflow: hidden; }
 .toolbar { display: flex; gap: 8px; margin-bottom: 10px; }
 .toolbar input, .toolbar select { height: 36px; border: 1px solid var(--border); border-radius: 10px; padding: 0 10px; }
 .radio { width: 18px; height: 18px; }

</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	<div class="container">
		<h1>기사관리</h1>
		<div class="content">
			<!-- 검색/필터 -->
	        <form class="filters" aria-label="검색 및 필터">
	            <div class="field">
	                <select id="filterStatus" name="filter">
	                    <option value="전체">전체</option>
	                    <option value="대기">대기</option>
	                    <option value="운행중">운행중</option>
	                </select>
	            </div>
	            <div class="search">
	                <input id="filterText" type="text" name="searchKeyword" placeholder="이름/차량번호 검색 가능" />
	            </div>
	            <div class="actions">
	                <button class="btn" id="btnSearch">검색</button>
	            </div>
	        </form>
			<div>
				<h3>기사목록</h3>
				<c:choose>
					<c:when test="${empty driverList}">
						<div class="empty-result">검색된 차량이 없습니다.</div>
					</c:when>
					<c:otherwise>
						<table class="table" id="driverTable">
					    	<thead>
		                        <tr>
		                            <th>이름</th>
		                            <th>연락처</th>
		                            <th>차량번호</th>
		                            <th>적재량</th>
		                            <th>운송상태</th>
		                            <th>상태</th>
		                        </tr>
		                    </thead>
							<tbody id="driverTbody">
								<c:forEach var="driver" items="${driverList}">
									<tr class="driverInfo" data-driver-idx="${driver.empIdx}">
										<td>${driver.empName}</td>
										<td>${driver.empPhone}</td>
										<td>
											${driver.vehicleNumber ? driver.vehicleNumber : "미배정"}
										</td>
										<td>
											${driver.capacity == 1000 ? "1.0t" : "1.5t"}
										</td>
										<td>
											${driver.status eq "운행중" ? "운행중" : "대기"}
										</td>
										<td>${driver.empStatus}</td>
									</tr>
								
								</c:forEach>
							</tbody>
						</table>
					
					</c:otherwise>
				</c:choose> 
			</div>
		</div>
		<div class="pager">
			<div>
				<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
					<input type="button" value="이전" 
						onclick="location.href='/transport/vehicle?pageNum=${pageInfo.pageNum - 1}&filter=${param.filter}&searchKeyword=${param.searchKeyword}'" 
						<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
					<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
						<c:choose>
							<c:when test="${i eq pageInfo.pageNum}">
								<strong>${i}</strong>
							</c:when>
							<c:otherwise>
								<a href="/transport/vehicle?pageNum=${i}&filter=${param.filter}&searchKeyword=${param.searchKeyword}">${i}</a>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<input type="button" value="다음" 
						onclick="location.href='/transport/vehicle?pageNum=${pageInfo.pageNum + 1}&filter=${param.filter}&searchKeyword=${param.searchKeyword}'" 
					<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
				</c:if>
			</div>
		</div>
	</div>
	<!-- 기사 상세 + 차량 배정/변경 모달 -->
        <div class="modal" id="formModal" aria-hidden="true">
            <div class="modal-card modal-form lg">
                <div class="modal-head">
                    <strong id="driverTitle">기사 정보</strong>
                    <button class="modal-close-btn" onclick="ModalManager.closeModal(document.getElementById('formModal'))">✕</button>
                </div>
                <div class="modal-body">
                    <div style="margin-bottom:12px">
                        <div class="field">
                            <label>사번</label>
                            <input id="empNo" disabled />
                        </div>
                        <div class="field">
                            <label>이름</label>
                            <input id="empName" disabled />
                        </div>
                        <div class="field">
                            <label>연락처</label>
                            <input id="empPhone" disabled />
                        </div>
                        <div class="field">
                            <label>상태</label>
                            <input id="empStatus" disabled />
                        </div>
                    </div>
					<!-- 차량 선택 -->
                    <div class="section-title">차량</div>
					<table class="table responsive" aria-label="차량 선택 테이블">
						<thead>
				            <tr>
				              <th scope="col" class="col-radio"></th>
				              <th scope="col">차량번호</th>
				              <th scope="col">차종</th>
				              <th scope="col">적재량(kg)</th>
				              <th scope="col">상태</th>
				            </tr>
				    	</thead>
					    <tbody id="vehicleRows">
					    <!-- Ajax로 행 렌더링 -->
						</tbody>
					</table>
                </div>
                <div class="modal-foot">
                    <button class="btn outline" id="vehicleAssignBtn" style="display:none">차량 배정</button>
                    <button class="btn" id="vehicleChangeBtn" style="display:none">차량 변경</button>
                </div>
            </div>
        </div>
	</body>
</html>