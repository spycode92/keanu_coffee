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
</section>
  <script>
    // 토글 스위치 클릭 시 active 상태 토글 예시
	document.addEventListener('DOMContentLoaded', function() {
		const toggle = document.getElementById('toggle1');
		if (toggle) {
			toggle.addEventListener('click', function() {
			this.classList.toggle('active');
			});
		}
	});
  </script>

</body>
</html>