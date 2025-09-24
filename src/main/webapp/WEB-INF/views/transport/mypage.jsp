<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>기사 마이페이지</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
	<link href="${pageContext.request.contextPath}/resources/css/transport/common.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/transport/mypage.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
    <link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/common/web_socket.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script src="https://kit.fontawesome.com/a96e186b03.js" crossorigin="anonymous"></script>
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/transport/mypage.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
	<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=2b14d97248052db181d2cfc125eaa368&libraries=services"></script>	
	<script src="${pageContext.request.contextPath}/resources/js/transport/kakao_map.js"></script>
	<script type="text/javascript"> const role = "${pageContext.request.userPrincipal.principal.role.roleName}";</script>
</head>
<body>
    <div class="container">
        <h1>기사 마이페이지</h1>
		<%-- 프로필 --%>
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
					<i class="fa-solid fa-right-from-bracket" data-action="logout"></i>
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
        <%-- 배차 요청 목록 --%>
        <section class="card" style="margin-top:12px; max-height: 650px; overflow: auto;">
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
	<%-- 예약 상세(주문서/선택) 모달 --%>
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
	<%-- 운송중 상세(납품/현황) 모달 --%>
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
                	<div class="field">
	                    <input type="file" name="files" id="files" multiple accept="image/*"  style="display: none;"/>
	                    <div id="productImagePreviewContainer"  style="margin-top:0.5rem; display:flex; flex-wrap:wrap;"></div>
	                     <div id="fileDownloadContainer"></div>
                	</div>
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
