<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<!-- 상세 모달 -->
	<div class="modal" id="editModal" aria-hidden="true">
		<div class="modal-card" role="dialog" aria-modal="true"
			aria-labelledby="editTitle">
			<div class="modal-head">
				<strong id="editTitle">차량 상세정보</strong>
			</div>
			<div class="modal-body">
				<form class="form" id="editForm" onsubmit="return false;">
					<input type="hidden" id="idx" />
					<div class="row">
						<div class="field">
							<label>고정기사명</label> 
							<input id="driverName" readonly />
						</div>
						<div class="field">
							<label>상태</label> 
							<select id="status">
								<option value="미배정">미배정</option>
								<option value="대기" disabled>대기</option>
								<option value="운행중" disabled>운행중</option>
								<option value="사용불가">사용불가</option>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="field">
							<label>차량번호*</label> <input id="vehicleNumber"
								name="vehicleNumber" type="text" readonly />
						</div>
						<div class="field">
							<label>차종유형*</label> <input id="vehicleType" name="vehicleType"
								type="text" readonly />
						</div>
					</div>
					<div class="modifyRow">
						<div class="field">
							<label>적재량*</label> <input id="capacity" name="capacity" readonly />
						</div>
						<div class="field">
							<label>연식</label> <input id="manufactureYear"
								name="manufactureYear" readonly />
						</div>
						<div class="field">
							<label>제조사/모델명</label> <input id="manufacturerModel"
								name="manufacturerModel" readonly />
						</div>
					</div>
				</form>
			</div>
			<div class="modal-foot">
				<button class="btn secondary" id="cancelEdit">취소</button>
				<button class="btn" id="saveEdit">저장</button>
				<button class="btn" id="editBtn">수정</button>
			</div>
		</div>
	</div>