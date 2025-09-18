<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- 담당자 지정 모달 -->
<div class="modal" id="modal-assign-manager" aria-hidden="true">
	<div class="modal-card modal-form sm">
		<div class="modal-head">
			<h3>담당자 지정</h3>
			<button type="button" class="modal-close-btn" aria-label="닫기">✕</button>
		</div>

		<div class="modal-body">
			<form id="formAssignManager" class="form">
				<!-- CSRF -->
				<input type="hidden" name="_csrf_header" value="${_csrf.headerName}">
				<input type="hidden" name="_csrf" value="${_csrf.token}">

				<!-- 다중 체크박스로 선택된 입고번호 목록을 담을 hidden input -->
				<input type="hidden" id="managerIbwaitIdxList" name="ibwaitIdxList" value="">

				<div class="field">
					<label>담당자</label>
					<select class="form-control" name="managerIdx" id="managerSelect">
						<option value="" disabled selected>담당자를 선택하세요</option>
					</select>
				</div>
			</form>

			<!-- 선택된 건수를 보여주기 -->
			<div class="field">
				<label>선택된 입고 건수: <span id="selectedCount">0</span> 건</label>
			</div>
		</div>

		<div class="modal-foot">
			<button type="button" class="btn btn-secondary" data-close>취소</button>
			<button type="submit" class="btn btn-primary" form="formAssignManager">저장</button>
		</div>
	</div>
</div>
