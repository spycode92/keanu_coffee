<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>



<div class="modal" id="modal-assign-manager" aria-hidden="true">
	<div class="modal-card modal-form sm">
		<div class="modal-head">
			<h3>담당자 지정</h3>
			<button type="button" class="modal-close-btn" aria-label="닫기">✕</button>
		</div>
		<div class="modal-body">
			<form id="formAssignManager" class="form">
				<input type="hidden" name="_csrf_header" value="${_csrf.headerName}">
				<input type="hidden" name="_csrf" value="${_csrf.token}">
				<input type="hidden" name="ibwaitIdx" value="${inboundDetailData.ibwaitIdx}">

				<div class="field">
					<label>담당자</label>
					<select class="form-control" name="managerIdx" id="managerSelect" data-current-name="${inboundDetailData.managerName}">
						<option value="" disabled selected>담당자를 선택하세요</option>
					</select>
				</div>
			</form>
		</div>
		<div class="modal-foot">
			<button type="button" class="btn btn-secondary" data-close>취소</button>
			<button type="submit" class="btn btn-primary" form="formAssignManager">저장</button>
		</div>
	</div>
</div>


<div class="modal" id="modal-assign-location" aria-hidden="true">
	<div class="modal-card modal-form sm">
		<div class="modal-head">
			<h3>입고위치 지정</h3>
			<button type="button" class="modal-close-btn" aria-label="닫기">✕</button>
		</div>
		<div class="modal-body">
			<form id="formAssignLocation" class="form">
				<input type="hidden" name="_csrf_header" value="${_csrf.headerName}">
				<input type="hidden" name="_csrf" value="${_csrf.token}">
				<input type="hidden" name="ibwaitIdx" value="${inboundDetailData.ibwaitIdx}">

				<div class="field">
					<label>입고위치</label>
					<select class="form-control" name="inboundLocation" id="inboundLocation">
						<option value="Location_A"
							<c:if test="${inboundDetailData.inboundLocation == 'loc_A'}">selected</c:if>>
							Location_F
						</option>
						<option value="Location_B"
							<c:if test="${inboundDetailData.inboundLocation == 'loc_B'}">selected</c:if>>
							Location_G
						</option>
						<option value="Location_C"
							<c:if test="${inboundDetailData.inboundLocation == 'loc_C'}">selected</c:if>>
							Location_H
						</option>
					</select>
				</div>
			</form>
		</div>
		<div class="modal-foot">
			<button type="button" class="btn btn-secondary" data-close>취소</button>
			<button type="submit" class="btn btn-primary" form="formAssignLocation">저장</button>
		</div>
	</div>
</div>
