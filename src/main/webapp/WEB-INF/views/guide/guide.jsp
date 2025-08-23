<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>공통 CSS/JS 컴포넌트 가이드</title>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style>
body { padding: 2rem; }
h2 { margin-top: 2rem; border-bottom: 2px solid var(--primary); padding-bottom: .3rem; }
section { margin-bottom: 2rem; }
</style>
</head>
<body>
<section class="content">
<h1>📌 공통 CSS/JS 컴포넌트 가이드</h1>
<div>
	darkmode toggle
	<button id="dark-mode-toggle" class="toggle-switch" aria-label="다크모드 토글"></button>
</div>
<h2>1. Card</h2>
<div class="card">
  <div class="card-header">
    <h3 class="card-title">Card Title</h3>
  </div>
  <p>카드 내용 예시입니다.</p>
</div>

<h2>2. Buttons</h2>
<button class="btn btn-primary">Primary</button>
<button class="btn btn-secondary">Secondary</button>
<button class="btn btn-sm btn-primary">Small</button>

<h2>3. Badges</h2>
<span class="badge badge-pending">Pending</span>
<span class="badge badge-confirmed">Confirmed</span>
<span class="badge badge-urgent">Urgent</span>

<h2>4. Form Controls</h2>
<label class="form-label">Input Label</label>
<input class="form-control" placeholder="텍스트 입력">

<h2>5. Toggle Switch</h2>
<button class="toggle-switch"></button>

<h2>6. Table</h2>
<div class="table-responsive">
<table class="table">
<thead><tr><th>Header 1</th><th>Header 2</th></tr></thead>
<tbody>
<tr><td>Cell 1</td><td>Cell 2</td></tr>
<tr><td>Cell 3</td><td>Cell 4</td></tr>
</tbody>
</table>
</div>

<h2>7. KPI Card</h2>
<div class="kpi-card">
  <div class="kpi-value">2,345</div>
  <div class="kpi-change positive">+5%</div>
</div>

<h2>8. Notifications(JS)</h2>
<button class="btn btn-primary" onclick="showSuccess('성공 메시지!')">Success</button>
<button class="btn btn-secondary" onclick="showError('에러 메시지!')">Error</button>
<button class="btn btn-secondary" onclick="showWarning('경고 메시지!')">Warning</button>


<h2>9. 알림 메시지 테스트 (Notification)</h2>
<button class="btn btn-primary" onclick="showSuccess('성공 메시지! 🎉')">성공 알림</button>
<button class="btn btn-secondary" onclick="showError('에러 메시지! ⚠️')">에러 알림</button>
<button class="btn btn-secondary" onclick="showWarning('경고 메시지! ⚠️')">경고 알림</button>
<button class="btn btn-primary" onclick="showNotification('일반 정보 메시지! ℹ️')">정보 알림</button>

<h2>10. Modal 테스트</h2>
<button class="btn btn-primary" onclick="ModalManager.openModalById('formModal')">폼 모달 열기</button>
<button class="btn btn-primary" onclick="ModalManager.openModalById('tableModal')">테이블 모달 열기</button>
<button class="btn btn-primary" onclick="ModalManager.openModalById('listModal')">리스트 모달 열기</button>
<button class="btn btn-primary" onclick="ModalManager.openModalById('nestedModal')">2중 모달 열기</button>

</section>
<!-- Form Modal -->
<div class="modal" id="formModal">
  <div class="modal-card modal-form md">
    <div class="modal-head">
      <h3>폼 모달</h3>
      <button class="modal-close-btn" onclick="ModalManager.closeModal(document.getElementById('formModal'))">✕</button>
    </div>
    <div class="modal-body">
      <form class="form">
        <div class="row">
          <div class="field">
            <label>이름</label>
            <input type="text" class="form-control" placeholder="이름 입력">
          </div>
          <div class="field">
            <label>이메일</label>
            <input type="email" class="form-control" placeholder="이메일 입력">
          </div>
        </div>
      </form>
    </div>
    <div class="modal-foot">
      <button class="btn btn-primary">Primary</button>
      <button class="btn btn-secondary">Secondary</button>
      <button class="btn btn-cancel">Cancel</button>
      <button class="btn btn-confirm">Confirm</button>
      <button class="btn btn-update">Update</button>
      <button class="btn btn-destructive">Destructive</button>
      <button class="btn btn-sm btn-primary">Small Primary</button>
      <button class="btn btn-sm btn-secondary">Small Secondary</button>
      <button class="btn btn-secondary" onclick="ModalManager.openModalById('nestedModal')">세부 모달 열기</button>
    </div>
  </div>
</div>

<!-- Table Modal -->
<div class="modal" id="tableModal">
  <div class="modal-card modal-table lg">
    <div class="modal-head">
      <h3>테이블 모달</h3>
      <button class="modal-close-btn" onclick="ModalManager.closeModal(document.getElementById('tableModal'))">✕</button>
    </div>
    <div class="modal-body">
      <table class="table">
        <thead>
          <tr><th>날짜</th><th>금액</th><th>상태</th></tr>
        </thead>
        <tbody>
          <tr><td>2025-08-01</td><td>10,000원</td><td>완료</td></tr>
          <tr><td>2025-08-10</td><td>5,000원</td><td>대기</td></tr>
        </tbody>
      </table>
    </div>
    <div class="modal-foot">
      <button class="btn btn-primary">Primary</button>
      <button class="btn btn-secondary">Secondary</button>
      <button class="btn btn-cancel">Cancel</button>
      <button class="btn btn-confirm">Confirm</button>
      <button class="btn btn-update">Update</button>
      <button class="btn btn-destructive">Destructive</button>
      <button class="btn btn-sm btn-primary">Small Primary</button>
      <button class="btn btn-sm btn-secondary">Small Secondary</button>
      <button class="btn btn-secondary" onclick="ModalManager.closeModal(document.getElementById('tableModal'))">닫기</button>
    </div>
  </div>
</div>

<!-- List Modal -->
<div class="modal" id="listModal">
  <div class="modal-card modal-list sm">
    <div class="modal-head">
      <h3>리스트 모달</h3>
      <button class="modal-close-btn" onclick="ModalManager.closeModal(document.getElementById('listModal'))">✕</button>
    </div>
    <div class="modal-body">
      <ul>
        <li>옵션 1</li>
        <li>옵션 2</li>
        <li>옵션 3</li>
        <li>옵션 4</li>
      </ul>
    </div>
    <div class="modal-foot">
      <button class="btn btn-primary">Primary</button>
      <button class="btn btn-secondary">Secondary</button>
      <button class="btn btn-cancel">Cancel</button>
      <button class="btn btn-confirm">Confirm</button>
      <button class="btn btn-update">Update</button>
      <button class="btn btn-destructive">Destructive</button>
      <button class="btn btn-sm btn-primary">Small Primary</button>
      <button class="btn btn-sm btn-secondary">Small Secondary</button>
      <button class="btn btn-secondary" onclick="ModalManager.closeModal(document.getElementById('listModal'))">취소</button>
    </div>
  </div>
</div>

<!-- Nested Modal -->
<div class="modal" id="nestedModal">
  <div class="modal-card sm">
    <div class="modal-head">
      <h3>세부 모달</h3>
      <button class="modal-close-btn" onclick="ModalManager.closeModal(document.getElementById('nestedModal'))">✕</button>
    </div>
    <div class="modal-body">
      <p>여기는 2중 모달의 내용입니다.</p>
    </div>
    <div class="modal-foot">
      <button class="btn btn-primary">Primary</button>
      <button class="btn btn-secondary">Secondary</button>
      <button class="btn btn-cancel">Cancel</button>
      <button class="btn btn-confirm">Confirm</button>
      <button class="btn btn-update">Update</button>
      <button class="btn btn-destructive">Destructive</button>
      <button class="btn btn-sm btn-primary">Small Primary</button>
      <button class="btn btn-sm btn-secondary">Small Secondary</button>
      <button class="btn btn-secondary" onclick="ModalManager.closeModal(document.getElementById('nestedModal'))">닫기</button>
    </div>
  </div>
</div>
  
  

</body>
</html>