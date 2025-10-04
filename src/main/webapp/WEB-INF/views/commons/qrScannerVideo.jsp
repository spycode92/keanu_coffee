<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="modal" id="qrScannerModal">
	<div class="modal-card modal-form sm">
		<div class="modal-head">
			<h3>QR 코드 스캔</h3>
			<button class="modal-close-btn" onclick="ModalManager.closeModalById('qrScannerModal')">✕</button>
		</div>
		<div class="modal-body" style="width:93%;">
			<video id="qrVideo" autoplay playsinline muted style="border:1px solid #ccc;"></video>
<!-- 			<div id="sourceSelectPanel" style="margin-top:1rem; display:none;"> -->
<!-- 				<label for="sourceSelect">카메라 선택:</label> -->
<!-- 				<select id="sourceSelect"></select> -->
<!-- 			</div> -->
			<div>
				<label>결과:</label>
				<pre><code id="qrResultText"></code></pre>
			</div>
		</div>
		<div class="modal-foot">
			<button class="btn btn-secondary" onclick="ModalManager.closeModalById('qrScannerModal')">닫기</button>
		</div>
	</div>
</div>
