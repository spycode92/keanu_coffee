 <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
	href="${pageContext.request.contextPath}/resources/css/transport/common.css"
	rel="stylesheet">
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

.badge { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: .8rem; font-weight: 700; }
.badge.run { background: #dcfce7; color: #166534; }      /* 운행중 */
.badge.book { background: #e0e7ff; color: #3730a3; }     /* 예약 */
.badge.done { background: #e5ffe9; color: #047857; }     /* 완료 */
.badge.cancel { background: #fee2e2; color: #991b1b; }   /* 취소 */

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
        <form class="filters" aria-label="검색 및 필터">
            <div class="field">
                <select id="filterStatus" name="filter">
                    <option value="전체">전체</option>
                    <option value="예약">예약</option>
                    <option value="운행중">운행중</option>
                    <option value="완료">완료</option>
                    <option value="취소">취소</option>
                </select>
            </div>
            <div class="search">
                <input id="filterText" type="text" name="searchKeyword" placeholder="기사명 / 차량번호 / 구역명 검색" />
            </div>
            <div class="actions">
                <button class="btn" id="btnSearch">검색</button>
            </div>
        </form>

        <!-- 배차 목록 -->
        <section style="margin-top:14px">
            <h3>배차목록</h3>
            <c:choose>
            	<c:when test="${empty dispatchList}">
            		<div class="empty-result">검색된 배차가 없습니다.</div>
            	</c:when>
            	<c:otherwise>
		            <table class="table" id="dispatchTable">
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
		                			<td>${dispatch.status}</td>
		                		</tr>
		                	</c:forEach>
		                </tbody>
		            </table>
            	</c:otherwise>
            </c:choose>
        </section>
		<jsp:include page="/WEB-INF/views/inc/pagination.jsp">
			<jsp:param value="/transport/dispatches" name="pageUrl"/>
		</jsp:include>
	</div>

    <!-- 등록 모달 -->
	<jsp:include page="/WEB-INF/views/transport/modal/add_dispatch.jsp"></jsp:include>

    <!-- 상세 모달(배차 클릭 시) -->
    <div class="modal" id="detailModal" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="detailTitle">
            <div class="modal-head">
                <strong id="detailTitle">배차 상세</strong>
                <button class="modal-close-btn" >✕</button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <label>담당 기사 정보</label>
                    <input id="detailDriver" disabled />
                </div>

                <div class="card" style="margin-top:10px" id="summary">
                    <div class="card-header">주문서(품목)</div>
                    <table class="table" id="summaryInfo">
                        <thead>
                            <tr>
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
                <div class="card" style="margin-top:10px" id="detail">
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
            <button type="button"
                    class="btn btn-secondary"
                    onclick="ModalManager.closeModal(document.getElementById('detailModal'))">
                닫기
            </button>
            </div>
        </div>
    </div>
</body>
</html>