<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="modal" id="modal-assign-location" aria-hidden="true">
	<div class="modal-card modal-form sm">
		<!-- 모달 헤더 -->
		<div class="modal-head">
			<h3>입고위치 지정</h3>
			<button type="button" class="modal-close-btn" aria-label="닫기">✕</button>
		</div>

		<!-- 모달 바디 -->
		<div class="modal-body">
			<form id="formAssignLocation" class="form">
				<input type="hidden" name="_csrf_header" value="${_csrf.headerName}">
				<input type="hidden" name="_csrf" value="${_csrf.token}">
				<input type="hidden" name="ibwaitIdx" value="${inboundDetailData.ibwaitIdx}">

				<div class="field">
					<label>입고위치</label>
					<select class="form-control" id="inboundLocationSelect">
					    <option value="9999" data-name="Location_F"
					        <c:if test="${inboundDetailData.inboundLocation == 'Location_F'}">selected</c:if>>
					        Location_F
					    </option>
					    <option value="9998" data-name="Location_G"
					        <c:if test="${inboundDetailData.inboundLocation == 'Location_G'}">selected</c:if>>
					        Location_G
					    </option>
					    <option value="9997" data-name="Location_H"
					        <c:if test="${inboundDetailData.inboundLocation == 'Location_H'}">selected</c:if>>
					        Location_H
					    </option>
					</select>
				</div>
			</form>
		</div>

		<!-- 모달 풋터 -->
		<div class="modal-foot">
			<button type="button" class="btn btn-secondary" data-close>취소</button>
			<button type="submit" class="btn btn-primary" form="formAssignLocation">저장</button>
		</div>
	</div>
</div>
