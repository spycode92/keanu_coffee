<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="modal" id="modal-assign-outbound-location" aria-hidden="true">
	<div class="modal-card modal-form sm">
		<!-- 모달 헤더 -->
		<div class="modal-head">
			<h3>출고위치 지정</h3>
			<button type="button" class="modal-close-btn" aria-label="닫기">✕</button>
		</div>

		<!-- 모달 바디 -->
		<div class="modal-body">
			<form id="formAssignOutboundLocation" class="form">
				<input type="hidden" name="_csrf_header" value="${_csrf.headerName}">
				<input type="hidden" name="_csrf" value="${_csrf.token}">
				<input type="hidden" name="obwaitIdx" value="${obDetail.obwaitIdx}">

				<div class="field">
					<label>출고위치</label>
					<select class="form-control" id="outboundLocationSelect">
					    <option value="9994" data-name="Location_A"
					        <c:if test="${obDetail.outboundLocation == 'Location_A'}">selected</c:if>>
					        Location_A
					    </option>
					    <option value="9995" data-name="Location_B"
					        <c:if test="${obDetail.outboundLocation == 'Location_B'}">selected</c:if>>
					        Location_B
					    </option>
					    <option value="9996" data-name="Location_C"
					        <c:if test="${obDetail.outboundLocation == 'Location_C'}">selected</c:if>>
					        Location_C
					    </option>
					</select>
				</div>
			</form>
		</div>

		<!-- 모달 풋터 -->
		<div class="modal-foot">
			<button type="button" class="btn btn-secondary" data-close>취소</button>
			<button type="submit" class="btn btn-primary" form="formAssignOutboundLocation">저장</button>
		</div>
	</div>
</div>
