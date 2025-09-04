 <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>운송관리대시보드</title>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link
	href="${pageContext.request.contextPath}/resources/css/common/common.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/transport/dispatch.js"></script>
<style type="text/css">
.container {
    max-width: 1264px;
    margin: 0 auto;
    padding: 0 16px;
}

header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 12px;
}

/* 검색/필터 바 */
.filters {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 12px;
    display: grid;
    grid-template-columns: repeat(3, minmax(200px, 1fr));
    gap: 10px;
}
.filters .field { display: flex; flex-direction: column; gap: 6px; justify-content: center;
}
.filters .search { display: flex; flex-direction: column; gap: 6px; justify-content: center;
}
.search { width: 500px; }
.filters input, .filters select {
    height: 38px; padding: 0 10px; border: 1px solid var(--border); border-radius: 10px; background: #fff;
}
.filters .actions {
    display: flex; align-items: end; justify-content: center; gap: 8px;
}

.badge { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: .8rem; font-weight: 700; }
.badge.run { background: #dcfce7; color: #166534; }      /* 운행중 */
.badge.book { background: #e0e7ff; color: #3730a3; }     /* 예약 */
.badge.done { background: #e5ffe9; color: #047857; }     /* 완료 */
.badge.cancel { background: #fee2e2; color: #991b1b; }   /* 취소 */

.field { display: flex; flex-direction: column; gap: 6px; margin-bottom: 10px; }
.field input, .field select { height: 38px; padding: 0 10px; border: 1px solid var(--border); border-radius: 10px; }
.help, .hint { font-size: .83rem; color: var(--muted-foreground); }

@media (max-width: 1100px) {
    .filters { grid-template-columns: repeat(3, minmax(140px, 1fr)); }
}
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

    <div class="container">
        <header>
            <h1>배차 관리</h1>
            <div style="display:flex; gap:8px">
                <button class="btn secondary" id="openRegister">+ 배차 등록</button>
                <button onclick="location.href='/transport/mypage'">기사마이페이지</button>
                <button onclick="location.href='/transport/region'">구역관리</button>
            </div>
        </header>

        <!-- 검색/필터 -->
        <section class="filters" aria-label="검색 및 필터">
            <div class="field">
                <select id="filterStatus">
                    <option value="">전체</option>
                    <option value="예약">예약</option>
                    <option value="운행중">운행중</option>
                    <option value="완료">완료</option>
                    <option value="취소">취소</option>
                </select>
            </div>
            <div class="search">
                <input id="filterText" type="text" placeholder="기사명 / 차량번호 / 목적지 검색" />
            </div>
            <div class="actions">
                <button class="btn secondary" id="btnReset">초기화</button>
                <button class="btn" id="btnSearch">검색</button>
            </div>
        </section>

        <!-- 배차 목록 -->
        <section style="margin-top:14px">
            <h3>배차목록</h3>
            <table class="table" id="dispatchTable">
                <thead>
                    <tr>
                        <th>배차일</th>
                        <th>기사명</th>
                        <th>차량번호</th>
                        <th>요청중량</th>
                        <th>담당구역</th>
                        <th>예상도착시간</th>
                        <th>상태</th>
                    </tr>
                </thead>
                <tbody><!-- JS 렌더링 --></tbody>
            </table>
        </section>
    </div>

    <!-- 등록(대기/추가 필요만) 모달 -->
    <div class="modal" id="assignModal" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="assignTitle">
            <div class="modal-head">
                <strong id="assignTitle">배차 등록/수정</strong>
                <button class="modal-close-btn" >✕</button>
            </div>
            <div class="modal-body">
                <div style="display:grid; grid-template-columns:2fr 1fr; gap:12px;">
                    <!-- 좌: 대기/추가 필요 리스트 -->
                    <div>
                        <table class="table" id="assignList">
                            <thead>
                                <tr>
                                    <th style="width:44px">선택</th>
                                    <th>배차일</th>
                                    <th>배차시간</th>
                                    <th>구역명</th>
                                    <th>총적재량</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody><!-- JS 렌더링 --></tbody>
                        </table>
                    </div>
                    <!-- 우: 선택건 조치 -->
                    <div>
                        <div class="field">
                            <label>선택된 배차</label>
                            <input id="selAssignSummary" disabled />
                        </div>
                        <div class="field">
                            <label>가용 가능한 기사</label>
                            <select id="primaryDriverSelect"></select>
                            <button class="btn btn-primary" id="btnAssignDriver" style="justify-content: center;">기사 배정</button>
                        </div>

                        <div class="field" id="extraDriverBlock" style="display:none">
                           <span>추가 배차가 필요합니다.</span>
                        </div>

                        <div class="field">
                            <label>요청중량 / 배정 확정 한도</label>
                            <input id="capacityInfo" disabled />
                        </div>
                        
                        <div class="field">
							<label>배정된 기사/차량</label>
						  	<div id="assignedDriverList"></div>
						</div>
                    </div>
                </div>
            </div>
            <div class="modal-foot">
           		<button class="btn btn-cancel" id="btnCancelAssign">배차 취소</button>
       			<button class="btn btn-confirm" id="btnSaveAssign">배차등록</button>
            </div>
        </div>
    </div>

    <!-- 상세 모달(배차 클릭 시) -->
    <div class="modal" id="detailModal" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="detailTitle">
            <div class="modal-head">
                <strong id="detailTitle">배차 상세</strong>
                <button class="btn secondary" id="closeDetail">닫기</button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <label>기사(들)</label>
                    <input id="detailDrivers" disabled />
                </div>
                <div class="field">
                    <label>담당 구역</label>
                    <input id="detailRegion" disabled />
                </div>
                <div class="field">
                    <label>배송 상태</label>
                    <input id="detailStatus" disabled />
                </div>

                <div class="card" style="margin-top:10px">
                    <div class="card-header">주문서(품목)</div>
                    <table class="table" id="detailItems">
                        <thead>
                            <tr>
                                <th>지점</th>
                                <th>품목</th>
                                <th>수량</th>
                                <th>중량</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody><!-- JS 렌더링 --></tbody>
                    </table>
                </div>
            </div>
            <div class="modal-foot">
                <button class="btn secondary" id="closeDetail2">닫기</button>
            </div>
        </div>
    </div>
</body>
</html>