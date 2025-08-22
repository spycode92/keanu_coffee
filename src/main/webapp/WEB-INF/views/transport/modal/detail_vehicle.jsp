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
					<!-- 고정기사/상태만 수정 -->
					<div class="row">
						<div class="field">
							<label>고정기사명</label> 
							<input id="driverName" readonly />
							<input type="hidden" id="driverIdx" name="driverIdx" />
							<button type="button" id="btnAssignDriver">기사배정</button>
						</div>
						<div class="field">
							<label>상태</label> <select id="status">
								<option value="미배정">미배정</option>
								<option value="대기">대기</option>
								<option value="운행중">운행중</option>
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
					<div class="help">운행중인 차량은 고정기사 수정 불가</div>
				</form>
			</div>
			<div class="modal-foot">
				<button class="btn secondary" id="cancelEdit">취소</button>
				<button class="btn" id="saveEdit">저장</button>
			</div>
		</div>
	</div>
	
	<!-- 기사 배정 모달 -->
	<div class="modal" id="assignDriverModal" aria-hidden="true">
		<div class="modal-card" role="dialog" aria-modal="true"
			aria-labelledby="assignDriverTitle">
			<div class="modal-head">
				<strong id="assignDriverTitle">기사 배정</strong>
			</div>
			<div class="modal-body">	
				<table class="table" id="driverTable">
					<thead>
						<tr>
							<th></th>
							<th>이름</th>
							<th>사번</th>
							<th>연락처</th>
						</tr>
					</thead>
					<tbody id="driverTableBody">
						<!-- Ajax로 렌더링 -->
					</tbody>
				</table>
			</div>
			<div class="modal-foot">
				<button class="btn secondary" id="cancelAssignDriver">취소</button>
				<button class="btn" id="confirmAssignDriver">배정</button>
			</div>
		</div>
	</div>