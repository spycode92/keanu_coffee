<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>기사 마이페이지 (모바일)</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link
	href="${pageContext.request.contextPath}/resources/css/common/common.css"
	rel="stylesheet">
	<link
		href="${pageContext.request.contextPath}/resources/css/transport/mypage.css"
		rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script
	src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script
	src="${pageContext.request.contextPath}/resources/js/transport/mypage.js"></script>
</head>
<body>
    <div class="container">
        <h1>기사 마이페이지</h1>

        <!-- 프로필 -->
        <section class="card">
            <h2>프로필</h2>
            <div class="kv">
            	<input type="hidden" value="${driverInfo.capacity}" id="capacity" />
                <div class="muted">사번</div><div id="pf_no">${driverInfo.empNo}</div>
                <div class="muted">이름</div><div id="pf_name">${driverInfo.empName}</div>
                <div class="muted">연락처</div><div id="pf_phone">${driverInfo.empPhone}</div>
                <div class="muted">차량</div><div id="pf_vehicle">${driverInfo.vehicleNumber} (${driverInfo.capacity == 1000 ? '1.0t' : '1.5t'})</div>
                <div class="muted">상태</div><div><span id="pf_status" class="chip book">${driverInfo.status}</span></div>

            </div>
        </section>

        <!-- 배차 요청 목록 -->
        <section class="card" style="margin-top:12px">
            <h2>배차 요청 목록</h2>
            <table id="assignTable">
                <thead>
                    <tr>
                        <th>배차일</th>
                        <th>배차시간</th>
                        <th>구역명</th>
                        <th>총적재량</th>
                        <th>상태</th>
                        <th>작업</th>
                    </tr>
                </thead>
                <tbody>
                	<c:set var="status" value="${dispatch.status }"/>
                	<c:forEach var="dispatch" items="${dispatchInfo}">
                		<tr data-dispatch-idx="${dispatch.dispatchIdx}" data-vehicle-idx="${dispatch.vehicleIdx}"
                		    data-requires-additional="${dispatch.requiresAdditional}">
                			<td>
                				<fmt:formatDate value="${dispatch.dispatchDate}" pattern="yyyy-MM-dd"/>
                			</td>
                			<td>${dispatch.startSlot}</td>
                			<td>${dispatch.regionName}</td>
                			<td>${dispatch.totalVolume}</td>
                			<td>${dispatch.status}</td>
                			<td>
                				<c:choose>
                					<c:when test="${dispatch.status eq '예약'}">
                						<button class="btn ghost load-btn">적재하기</button>
                					</c:when>
                					<c:otherwise>
		                				<button class="btn ghost detail-btn">상세</button>
                					</c:otherwise>
                				</c:choose>
                			</td>
                		</tr>
                	</c:forEach>
                </tbody>
            </table>
        </section>
    </div>

    <!-- 예약 상세(주문서/선택) 모달 -->
    <div class="modal" id="orderModal" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="orderTitle">
            <div class="modal-head">
                <strong id="orderTitle">주문서 확인 및 적재</strong>
                <button class="modal-close-btn" >✕</button>
            </div>
            <div class="modal-body">
              	<input type="hidden" id="currentDispatchIdx" />
  				<input type="hidden" id="currentVehicleIdx" />
                <div id="orderMeta" class="muted" style="margin-bottom:8px">배차일 -</div>
                <div id="groupWrap"><!-- 지점 그룹 --></div>
            </div>

            <div class="picked-bar">
                <div id="pickedSummary" class="picked-summary"><span class="area">선택 없음</span></div>
            </div>

            <div class="modal-foot">
                <button class="btn ghost" id="btnClearPick">선택 초기화</button>
                <button class="btn ghost" id="btnLoadCompleted">적재완료</button>
            </div>
        </div>
    </div>

    <!-- 운송중 상세(납품/현황) 모달 -->
    <div class="modal" id="progressModal" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="progTitle">
            <div class="modal-head">
                <strong id="progTitle">배송 상세</strong>
                <button class="modal-close-btn" >✕</button>
            </div>
            <div class="modal-body">
                <div id="progMeta" class="muted" style="margin-bottom:8px">배차일 -</div>
                <div id="deliverWrap">
                	<table id="detailItems">
                		<thead>
                			<tr>
                				<th>지점명</th>
                				<th>품목명</th>
                				<th>주문수량</th>
                				<th>반품수량</th>
                				<th>상태</th>
                				<th></th>
                			</tr>
                		</thead>
                		<tbody></tbody>
                	</table>
                </div>
                <h3 style="margin:12px 0 6px">배송 현황</h3>
                <div class="timeline" id="timeline"><!-- 단계 표시 --></div>
            </div>
            <div class="modal-foot">
				<button class="btn ghost" id="detailActionBtn"></button>
            </div>
        </div>
    </div>
</body>
</html>
