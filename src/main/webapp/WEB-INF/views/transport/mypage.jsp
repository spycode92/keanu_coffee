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
	<link href="${pageContext.request.contextPath}/resources/css/transport/common.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/transport/mypage.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/transport/mypage.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/common/web_socket.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2b14d97248052db181d2cfc125eaa368&libraries=services"></script>	
	<script src="${pageContext.request.contextPath}/resources/js/transport/kakao_map.js"></script>
	<style>
	#alarm-wrapper {
		position: relative;
		display: inline-block;
	}
	
	#alarm-image {
		width: 25px;
		height: 25px;
		vertical-align: bottom;
	}
	
	/* 알람 아이콘 뱃지 */
	#alarm-badge {
		position: absolute;
		/* 우측 하단 고정 */
		bottom: 0;
		right: 0;
		width: 8px;
		height: 8px;
		background-color: red;
		border-radius: 50%; /* 원형 */
		display: none; /* 처음 로딩 시 숨김 */
	}
	
	#noti:hover {
	    transform: translateY(-2px);
	    transition: background-color 0.3s ease, transform 0.3s ease;
	}
	#noti:active {
	    transform: translateY(0);
	    transition: background-color 0.1s ease, transform 0.1s ease;
	}
	
	/* 					notification button */
	#notification-box {
		display: none;
		position: absolute;
		width: 300px;
		border-radius: 20px;
		box-shadow: 0 3.2px 16.2px rgba(0, 0, 0, 0.3);
		margin-top: 200px;
		right: 20px;
		background-color: #fff;
		padding: 20px;
	}
	
	#notification-box > ul > li:nth-child(odd) {
		background-color: #d9d9d9;
	}
	
	#notification-box > h3 {
		padding: 5px;
		border-bottom: #333 solid 2px;
	}
	
	#notification-box > ul > span {
		float: right;
		margin-left: auto;
	}
	#notification-box > ul > li {
		margin-top: 5px;
	}
	#small-menu {
		display:none;
	}
	
	/* notification */
	#notification-box {
	    position: absolute;
	    top: 100%; 
/* 	    right: 240px;   */
	    margin-top: 0.5em; 
	    width: 420px;
	    max-height: 300px;
	    overflow-y: auto;
	    border: 1px solid #ccc;
	    border-radius: 8px;
	    background: white;
	    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
	    display: none;
	    z-index: 100;
	    padding-top: 0;
	}
	
	#notification-list {
	    list-style: none;
	    margin: 0;
	    padding: 0;
	    position: relative;
	}
	
	#notification-list li {
	    padding: 10px;
	    cursor: pointer;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    border-bottom: 1px solid #eee;
	    transition: background 0.2s;
	}
	
	#notification-list li:hover {
	    background: #f9f9f9;
	}
	
	#notification-list li .dot {
	    font-size: 14px;
	}
	
	#notification-header {
		display: flex; 
		justify-content: space-between; 
		align-items: center;
		border-bottom: 1px solid #ddd;
		position: sticky;
		top: 0;
		background: white;
		width: 370px;
		z-index: 999;
	}
	
	#notification-header a {
		color: black;
	}
	
	.no-notification {
	    padding: 10px;
	    color: #888;
	    text-align: center;
	}
	
	#notification-box #notification-list li {
	    padding: 10px;
	    cursor: pointer;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    border-bottom: 1px solid #eee;
	    transition: background 0.2s;
	    background-color: white;
	    white-space: nowrap;       
	  	overflow: hidden;          /* 넘치는 텍스트 감춤 */
	  	text-overflow: ellipsis; 
	}
	
	#notification-list li:hover {
	    background: #f9f9f9;
	}
	
	#notification-box h3 {
	    position: sticky;
	    top: -20px;
	    background: white;
		padding: 10px;
	    margin: 0;
	    font-size: 1.2em;
	    z-index: 10;
	}
	
	.read-status {
	    font-size: 12px;
	    color: #888;
	    margin-left: 10px;
	}
	.no-notification {
	    text-align: center;
	    color: #999;
	    padding: 10px;
	}
	
	.circle {
	    display: inline-block;
	    width: 10px;
	    height: 10px;
	    border-radius: 50%;
	    margin-left: 5px;
	}
	.circle.read {
	    background-color: #ccc; 
	}
	.circle.unread {
	    background-color: red;
	}
	
	#notification-header  div {
		display: flex;
		gap: 20px;
		cursor: pointer;
		color: black;
	}
	
	
	.noti-message {
	  flex: 1;
	  white-space: nowrap;
	  overflow: hidden;
	  text-overflow: ellipsis;
	  color: #333;
	}
	
	#files {
		display: none;
		margin-top: 0.5em;
	}
</style>
</head>
<body>
    <div class="container">
        <h1>기사 마이페이지</h1>

        <!-- 프로필 -->
        <section class="card">
        	<div style="display: flex; justify-content: space-between; align-items: center;">
	            <h2 style="display: inline-block;">프로필</h2>
	            <div id="alarm-wrapper">
					<a id="noti" href="javascript:void(0)" onclick="notification()"><img src="/resources/images/alarm.png" id="alarm-image" /></a>
					<span id="alarm-badge"></span>
		       		<div id="notification-box">
						<div id="notification-header">
							<h3>알림</h3>
							<c:choose>
								<c:when test="${sUT eq 1 }">
									<div>
										<a href="/myPage/notification">전체보기</a>
										<div onclick="readAll()">전체읽음</div>
									</div>
								</c:when>
								<c:otherwise>
									<div>
										<a href="/company/myPage/notification">전체보기</a>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
						<ul id="notification-list"></ul>
		       		</div>			
				</div>
        	</div>
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
            <table class="responsive-table" id="assignTable">
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
                						<button class="btn load-btn">적재하기</button>
                					</c:when>
                					<c:otherwise>
		                				<button class="btn btn-confirm detail-btn">상세</button>
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
        <div class="modal-card lg" role="dialog" aria-modal="true" aria-labelledby="orderTitle">
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
                <button class="btn" id="btnClearPick">선택 초기화</button>
                <button class="btn" id="btnLoadCompleted">적재완료</button>
            </div>
        </div>
    </div>

    <!-- 운송중 상세(납품/현황) 모달 -->
    <div class="modal" id="progressModal" aria-hidden="true">
        <div class="modal-card lg" role="dialog" aria-modal="true" aria-labelledby="progTitle">
            <div class="modal-head">
                <strong id="progTitle">배송 상세</strong>
                <button class="modal-close-btn" >✕</button>
            </div>
            <div class="modal-body">
                <div id="progMeta" class="muted" style="margin-bottom:8px">배차일 -</div>
                <div id="deliverWrap">
                	<table class="detail-table" id="detailItems">
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
                	<input type="file" name="files" id="files" multiple style="display: none;"/>
                </div>
                <h3 style="margin:12px 0 6px">배송 현황</h3>
                <div class="timeline" id="timeline"><!-- 단계 표시 --></div>
                <div id="map" ></div>
            </div>
            <div class="modal-foot">
				<button class="btn" id="detailActionBtn"></button>
            </div>
        </div>
    </div>
</body>
</html>
