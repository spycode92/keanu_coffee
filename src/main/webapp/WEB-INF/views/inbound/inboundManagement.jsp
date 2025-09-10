<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>입고 관리</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

	<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
	<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>

	<style>
		
		/* 검색/필터 카드 – 상단 KPI와 간격 조금만 줄이기 */
		.d-flex.mb-2 { margin-bottom: .5rem; }  /* 기존 mb-2 보다 더 촘촘하게 하고 싶을 때 */
		
		/* 하단 KPI와 '검색결과' 바 사이 간격 조절 */
		.inbound-kpi-row { margin-bottom: .75rem; }
		
		/* '검색결과' 바 좌우 여백을 카드와 완벽히 동일하게 (이미 rail을 쓰고 있다면 유지) */
		.content .rail { padding-left: 1.5rem; padding-right: 1.5rem; }
		
		/* 달력 아이콘/입력 테두리 충돌 보정(이미 적용되어 있으면 생략) */
		.inbound-filters input[type="date"]::-webkit-calendar-picker-indicator { margin-right: 2px; }
		
		.content .rail {
		    margin-left: 0 !important;
		    margin-right: 0 !important;
		    padding-left: 1.5rem !important;
		    padding-right: 1.5rem !important;
		    box-sizing: border-box;
		}
		
		/* =========================
		   검색/필터 카드 내부 넘침 방지
		   ========================= */
		.inbound-filters .row {
			margin-left: 0;
			margin-right: 0;
		}
		.inbound-filters {
			overflow: hidden; /* 카드 안에서만 내용 표시 */
		}
		.inbound-filters .form-control,
		.inbound-filters .search-select {
			box-sizing: border-box;
			width: 100%;
		}
		.inbound-filters input[type="date"]::-webkit-calendar-picker-indicator {
			margin-right: 2px; /* 달력 아이콘 붙어 보이는 현상 보정 */
		}

		/* =========================
		   카드와 동일 좌우 여백 rail (검색결과 바에 사용)
		   ========================= */
		.content .rail {
			padding-left: 1.5rem;   /* .card 내부 패딩과 통일 */
			padding-right: 1.5rem;
		}
		.inbound-simple-search {
		    display: flex;
		    gap: 0.5rem;
		}
		.inbound-simple-search input {
		    flex: 1;
		}
		
		.table th, 
		.table td {
		    text-align: center;
		    vertical-align: middle; /* 세로 중앙정렬 */
		}
		
		.link-order-number {
			color: inherit;
			text-decoration: none;
			cursor: pointer;
		}
		
	</style>
</head>
<body>
	<!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

	<!-- 반드시 content 안에서 시작 -->
	<section class="content">

		<!-- 페이지 타이틀 -->
		<div class="d-flex justify-content-between align-items-center mb-2">
		     <h1 class="card-title" style="margin:0;">입고관리</h1>
		</div>

		<!-- 간단 검색바 -->
		<div class="card mb-3 inbound-simple-search d-flex align-items-center p-3 gap-2">
		    <input type="text" class="form-control" id="simpleItemKeyword" placeholder="품목 코드/명 검색" />
		    <button class="btn btn-primary btn-sm" id="simpleSearchBtn">검색</button>
		    <button class="btn btn-secondary btn-sm" id="toggleDetailSearchBtn">상세검색</button>
		</div>
		
		<!-- 검색/필터 -->
		<div class="card mb-4 inbound-filters" id="detailSearchCard" style="display:none;">
			<div class="card-header d-flex justify-content-between align-items-center">
				<div class="card-title">검색 / 필터</div>
			</div>

			<!-- 날짜 + 기준 -->
			<div class="row">
				<div class="col-md-3">
					<label class="form-label">검색 기준</label>
					<select class="form-control search-select" id="dateBasis">
						<option value="start" selected>시작일 기준</option>
						<option value="end">종료일(완료일) 기준</option>
						<option value="range">기간 기준</option>
					</select>
				</div>

				<div class="col-md-3 date-field date-start">
					<label class="form-label">입고 시작일</label>
					<input type="date" class="form-control search-input" id="inStartDate" />
				</div>

				<div class="col-md-3 date-field date-end" style="display:none;">
					<label class="form-label">입고 종료일(완료일)</label>
					<input type="date" class="form-control search-input" id="inEndDate" />
				</div>

				<div class="col-md-3 date-field date-range" style="display:none;">
					<label class="form-label">기간(시작)</label>
					<input type="date" class="form-control search-input" id="inRangeStart" />
				</div>
				<div class="col-md-3 date-field date-range" style="display:none;">
					<label class="form-label">기간(종료)</label>
					<input type="date" class="form-control search-input" id="inRangeEnd" />
				</div>
			</div>

			<!-- 1줄: 창고 · 상태 · 품목 -->
			<div class="row">
				<div class="col-md-3">
					<label class="form-label">창고</label>
					<select class="form-control search-select" id="warehouse">
						<option value="">전체</option>
						<option>중앙창고</option>
						<option>동부창고</option>
						<option>서부창고</option>
					</select>
				</div>
				<div class="col-md-3">
					<label class="form-label">상태</label>
					<select class="form-control search-select" id="status">
						<option value="">전체</option>
						<option value="PENDING">대기</option>
						<option value="CONFIRMED">확정</option>
						<option value="COMPLETED">완료</option>
					</select>
				</div>
				<div class="col-md-3">
					<label class="form-label">품목 코드/명</label>
					<input type="text" class="form-control search-input" placeholder="예) SKU-0001" id="itemKeyword" />
				</div>
				<div class="col-md-3"></div>
			</div>

			<!-- 2줄: 공급업체만 -->
			<div class="row">
				<div class="col-md-3">
					<label class="form-label">공급업체</label>
					<input type="text" class="form-control search-input" placeholder="업체명/코드 검색" id="vendorKeyword" />
				</div>
				<div class="col-md-9"></div>
			</div>

			<!-- 버튼 -->
			<div class="row">
				<div class="col-md-12 d-flex align-items-center gap-2 mt-3">
					<button class="btn btn-primary btn-search">검색</button>
					<button class="btn btn-secondary btn-reset">초기화</button>
				</div>
			</div>
		</div>

		
		<!-- 액션 바 (rail로 좌우 여백 통일) -->
		<div class="card">
		    <div class="card-header d-flex justify-content-between align-items-center">
		        <div class="card-title">
		            입고 목록
		            <span class="text-muted" style="font-size: 0.9em;">검색결과: 총 <strong id="resultCount"></strong>건</span>
		        </div>
		        <div class="d-flex gap-2">
					<a href="#" class="btn btn-primary btn-sm">새 입고 등록</a>
		            <a href="#" class="btn btn-secondary btn-sm">엑셀 다운로드</a>
					<a href="#" id="settings-button" class="btn btn-secondary btn-sm">설정</a>
		            <a href="#" class="btn btn-secondary btn-sm">선택삭제</a>
		        </div>
		    </div>
			<div class="table-responsive">
				<table class="table">
					<thead>
						<tr>
							<th style="width:36px;"><input type="checkbox" class="select-all" /></th>
							<th>발주번호</th>
							<th>입고번호</th>
							<th>입고일자</th>
							<th>공급업체</th>
							<th>상태</th>
							<th>품목수</th>
<!-- 							<th>총수량</th> -->
							<th>입고예정수량</th>
							<th>담당자</th>
							<th>비고</th>
						</tr>
					</thead>
	<!-- ==============================================================================================================리스트 존========= -->				
					<tbody>
					    <!-- 출력 카운터 초기화 -->
					    <c:set var="displayCount" value="0" />
					
					    <c:forEach var="order" items="${orderList}">
					        <c:if test="${not empty order.orderNumber}">
					            <tr>
					                <!-- 체크박스 -->
					                <td>
					                    <input type="checkbox" name="selectedOrder" value="${order.ibwaitIdx}" />
					                </td>
					
					                <!-- 발주번호 (링크) -->
					                <td>
					                    <c:url var="detailUrl" value="/inbound/inboundDetail">
					                        <c:param name="orderNumber" value="${order.orderNumber}" />
					                        <c:param name="ibwaitIdx" value="${order.ibwaitIdx}" />
					                    </c:url>
					                    <a href="${detailUrl}" class="link-order-number">
					                        <c:out value="${order.orderNumber}" default="-" />
					                    </a>
					                </td>
					
					                <!-- 입고번호 -->
					                <td><c:out value="${order.ibwaitNumber}" /></td>
					
					                <!-- 입고일자 -->
					                <td><c:out value="${order.arrivalDateStr}" default="-" /></td>
					
					                <!-- 공급업체 -->
					                <td><c:out value="${order.supplierName}" /></td>
					                
					                <!-- 상태 -->
					                <td><c:out value="${order.inboundStatus}" /></td>
					
					                <!-- 품목수 -->
					                <td><c:out value="${order.numberOfItems}" /></td>
					
					                <!-- 입고예정수량 -->
					                <td><c:out value="${order.quantity}" /></td>
					
					                <!-- 담당자 -->
					                <td><c:out value="${order.manager}" /></td>
					
					                <!-- 비고 -->
					                <td><c:out value="${order.note}" /></td>
					            </tr>
					
					            <!-- 출력 카운트 증가 -->
					            <c:set var="displayCount" value="${displayCount + 1}" />
					        </c:if>
					    </c:forEach>
					
					    <!-- 출력된 행이 하나도 없을 경우 안내문 -->
					    <c:if test="${displayCount == 0}">
					        <tr>
					            <td colspan="11" class="text-center">입고 데이터가 존재하지 않습니다.</td>
					        </tr>
					    </c:if>
					</tbody>
	<!-- ==============================================================================================================리스트 존========= -->				
				</table>
			</div>
	
			<div class="d-flex justify-content-between align-items-center p-3">
				<div class="text-muted">페이지 1 / 13</div>
				<div class="d-flex gap-2">
					<a href="#" class="btn btn-secondary btn-sm">« 처음</a>
					<a href="#" class="btn btn-secondary btn-sm">‹ 이전</a>
					<a href="#" class="btn btn-primary btn-sm">1</a>
					<a href="#" class="btn btn-secondary btn-sm">2</a>
					<a href="#" class="btn btn-secondary btn-sm">3</a>
					<a href="#" class="btn btn-secondary btn-sm">다음 ›</a>
					<a href="#" class="btn btn-secondary btn-sm">끝 »</a>
				</div>
			</div>
		</div>

		<!-- 공통 설정 모달 -->
		<div id="settings-modal" class="settings-modal" aria-hidden="true">
			<div class="settings-content">
				<div class="settings-header">
					<div class="card-title">페이지 설정</div>
					<button id="settings-close" class="settings-close" aria-label="닫기">&times;</button>
				</div>
				<div class="mb-3">
					<label class="form-label">기본 정렬</label>
					<select class="form-control">
						<option>입고일자 최신순</option>
						<option>입고번호 오름차순</option>
						<option>상태순</option>
					</select>
				</div>
				<div class="d-flex justify-content-between">
					<button id="settings-cancel" class="btn btn-secondary">취소</button>
					<button class="btn btn-primary">저장</button>
				</div>
			</div>
		</div>

	</section>

	<script>
		$("#adminPage").click(function(){
			location.href="/admin/main";
		});

		/* 검색 기준 토글 */
		document.addEventListener('change', function(e) {
			if (e.target && e.target.id === 'dateBasis') {
				const basis = e.target.value;
				document.querySelectorAll('.date-field').forEach(el => el.style.display = 'none');
				if (basis === 'start') {
					document.querySelectorAll('.date-start').forEach(el => el.style.display = '');
				} else if (basis === 'end') {
					document.querySelectorAll('.date-end').forEach(el => el.style.display = '');
				} else if (basis === 'range') {
					document.querySelectorAll('.date-range').forEach(el => el.style.display = '');
				}
			}
		});
		window.addEventListener('DOMContentLoaded', function() {
			const sel = document.getElementById('dateBasis');
			if (sel) sel.dispatchEvent(new Event('change'));
		});
		
		document.getElementById('toggleDetailSearchBtn').addEventListener('click', function() {
		    const detailCard = document.getElementById('detailSearchCard');
		    if (detailCard.style.display === 'none') {
		        detailCard.style.display = '';
		        this.textContent = '상세검색 닫기';
		    } else {
		        detailCard.style.display = 'none';
		        this.textContent = '상세검색';
		    }
		});

		// 간단 검색 버튼 클릭 이벤트
		document.getElementById('simpleSearchBtn').addEventListener('click', function() {
		    const keyword = document.getElementById('simpleItemKeyword').value.trim();
		    if (keyword) {
		        console.log("간단검색 품목 키워드:", keyword);
		        // TODO: 여기에 AJAX 검색 로직 추가
		    } else {
		        alert("품목 코드/명을 입력하세요.");
		    }
		});
	</script>
	<script>
		(function(){
			var cntEl = document.getElementById('resultCount');
			if(cntEl){
				cntEl.textContent = '${displayCount}';
			}
		})();
	</script>
</body>
</html>
