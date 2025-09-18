<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Page Jump Modal -->
<div class="modal" id="pageJumpModal">
	<div class="modal-card modal-form sm">
		<div class="modal-head">
			<h3>페이지 이동</h3>
			<button class="modal-close-btn" onclick="ModalManager.closeModalById('pageJumpModal')">✕</button>
		</div>
		<div class="modal-body">
			<label class="form-label">이동할 페이지 번호</label>
			<input type="number" id="pageInput" class="form-control" placeholder="예: 5" min="1" />
		</div>
		<div class="modal-foot">
			<button class="btn btn-secondary" onclick="ModalManager.closeModalById('pageJumpModal')">취소</button>
			<button class="btn btn-primary" onclick="goToPage(${pageInfo.maxPage})">이동</button>
		</div>
	</div>
</div>
