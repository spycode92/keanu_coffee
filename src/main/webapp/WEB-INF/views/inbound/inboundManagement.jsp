<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입고 관리</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
</head>
<body>
  <!-- 상단/사이드 레이아웃 -->
  <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>

  <section class="content">
  	<div class="row mb-4">
	  <div class="col-md-3">
	    <div class="kpi-card">
	      <div class="text-muted">총 입고건수(월)</div>
	      <div class="kpi-value">1,240건</div>
	      <div class="kpi-change positive">+120건 (전월 대비)</div>
	    </div>
	  </div>
	  <div class="col-md-3">
	    <div class="kpi-card">
	      <div class="text-muted">총 출고건수(월)</div>
	      <div class="kpi-value">980건</div>
	      <div class="kpi-change negative">-45건 (전월 대비)</div>
	    </div>
	  </div>
	  <div class="col-md-3">
	    <div class="kpi-card">
	      <div class="text-muted">총 재고수량</div>
	      <div class="kpi-value">85,320</div>
	      <div class="text-muted">EA</div>
	    </div>
	  </div>
	  <div class="col-md-3">
	    <div class="kpi-card">
	      <div class="text-muted">지연 처리 건</div>
	      <div class="kpi-value">8건</div>
	      <div class="kpi-change negative">확인 필요</div>
	    </div>
	  </div>
	  <div class="col-md-3">
	    <div class="kpi-card">
	      <div class="text-muted">적재</div>
	      <div class="kpi-value">8건</div>
	      <div class="kpi-change negative">확인 필요</div>
	    </div>
	  </div>
	  <div class="col-md-3">
	    <div class="kpi-card">
	      <div class="text-muted">폐기율</div>
	      <div class="kpi-value">+0.7%</div>
	      <div class="kpi-change positive">+0.1 (전월 대비)</div>
	    </div>
	  </div>
	</div>
    <!-- 헤더 액션 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h1 class="card-title" style="margin:0;">입고관리</h1>
      <div class="d-flex gap-2">
        <a href="#" id="settings-button" class="btn btn-secondary">설정</a>
        <a href="#" class="btn btn-primary">새 입고 등록</a>
      </div>
    </div>

    <!-- 검색/필터 -->
    <div class="card mb-4">
      <div class="card-header">
        <div class="card-title">검색 / 필터</div>
      </div>
      <div class="row">
        <div class="col-md-3">
          <label class="form-label">입고일(시작)</label>
          <input type="date" class="form-control search-input" />
        </div>
        <div class="col-md-3">
          <label class="form-label">입고일(종료)</label>
          <input type="date" class="form-control search-input" />
        </div>
        <div class="col-md-3">
          <label class="form-label">공급업체</label>
          <input type="text" class="form-control search-input" placeholder="업체명/코드 검색" />
        </div>
        <div class="col-md-3">
          <label class="form-label">창고</label>
          <select class="form-control search-select">
            <option value="">전체</option>
            <option>중앙창고</option>
            <option>동부창고</option>
            <option>서부창고</option>
          </select>
        </div>
        <div class="col-md-3">
          <label class="form-label">상태</label>
          <select class="form-control search-select">
            <option value="">전체</option>
            <option value="PENDING">대기</option>
            <option value="CONFIRMED">확정</option>
            <option value="COMPLETED">완료</option>
          </select>
        </div>
        <div class="col-md-3">
          <label class="form-label">품목 코드/명</label>
          <input type="text" class="form-control search-input" placeholder="예) SKU-0001" />
        </div>
        <div class="col-md-6 d-flex align-items-center gap-2 mt-3">
          <button class="btn btn-primary btn-search">검색</button>
          <button class="btn btn-secondary btn-reset">초기화</button>
        </div>
      </div>
    </div>

    <!-- KPI -->
    <div class="row mb-4">
      <div class="col-md-3">
        <div class="kpi-card">
          <div class="text-muted">오늘 입고건</div>
          <div class="kpi-value">12건</div>
          <div class="kpi-change positive">+3건 (어제 대비)</div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="kpi-card">
          <div class="text-muted">미확정</div>
          <div class="kpi-value">5건</div>
          <div class="kpi-change warning">확정 필요</div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="kpi-card">
          <div class="text-muted">총 입고수량(금일)</div>
          <div class="kpi-value">3,240</div>
          <div class="text-muted">EA</div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="kpi-card">
          <div class="text-muted">지연건</div>
          <div class="kpi-value">2건</div>
          <div class="kpi-change negative">처리 필요</div>
        </div>
      </div>
    </div>

    <!-- 액션 바 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
      <div class="text-muted">검색결과: 총 <strong>128</strong>건</div>
      <div class="d-flex gap-2">
        <a href="#" class="btn btn-secondary btn-sm">엑셀 다운로드</a>
        <a href="#" class="btn btn-secondary btn-sm">선택삭제</a>
      </div>
    </div>

    <!-- 목록 -->
    <div class="card">
      <div class="card-header">
        <div class="card-title">입고 목록</div>
      </div>
      <div class="table-responsive">
        <table class="table">
          <thead>
            <tr>
              <th style="width:36px;"><input type="checkbox" class="select-all" /></th>
              <th>입고번호</th>
              <th>입고일자</th>
              <th>공급업체</th>
              <th>창고</th>
              <th>상태</th>
              <th>품목수</th>
              <th>총수량</th>
              <th>담당자</th>
              <th>비고</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><input type="checkbox" /></td>
              <td>IN-20250811-001</td>
              <td>2025-08-11</td>
              <td>에이스상사</td>
              <td>중앙창고</td>
              <td><span class="badge badge-pending">대기</span></td>
              <td>4</td>
              <td>540</td>
              <td>김담당</td>
              <td>-</td>
            </tr>
            <tr>
              <td><input type="checkbox" /></td>
              <td>IN-20250811-002</td>
              <td>2025-08-11</td>
              <td>그린푸드</td>
              <td>동부창고</td>
              <td><span class="badge badge-confirmed">확정</span></td>
              <td>8</td>
              <td>1,220</td>
              <td>이담당</td>
              <td>부분입고</td>
            </tr>
            <tr>
              <td><input type="checkbox" /></td>
              <td>IN-20250810-015</td>
              <td>2025-08-10</td>
              <td>베스트유통</td>
              <td>서부창고</td>
              <td><span class="badge badge-completed">완료</span></td>
              <td>3</td>
              <td>180</td>
              <td>박담당</td>
              <td>-</td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 페이지네이션 -->
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
  </script>
</body>
</html>
