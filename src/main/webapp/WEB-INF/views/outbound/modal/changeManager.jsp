<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<div id="changeManager" class="modal" aria-hidden="true">
	<div class="modal-card md" role="dialog" aria-modal="true" aria-labelledby="changeManagerTitle">
		<div class="modal-head">
			<h3 id="changeManagerTitle" class="card-title">담당자 변경</h3>
			<button type="button" class="modal-close-btn" aria-label="닫기" onclick="ModalManager.closeModalById('changeManager')">&times;</button>
		</div>
		<div class="modal-body">
			<form id="changeManagerForm" class="form">
				<div class="field">
					<label for="manager" class="form-label">새 담당자</label>
					<input type="text" id="manager" name="manager" class="form-control" />
				</div>
			</form>
		</div>
		<div class="modal-foot">
			<button type="button" class="btn btn-cancel" onclick="ModalManager.closeModalById('changeManager')">취소</button>
			<button type="submit" form="changeManagerForm" class="btn btn-primary">변경</button>
		</div>
	</div>
</div>
