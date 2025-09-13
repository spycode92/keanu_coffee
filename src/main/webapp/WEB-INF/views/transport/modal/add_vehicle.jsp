<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>

		<!-- 등록 모달 -->
		<div class="modal" id="createModal" aria-hidden="true">
			<div class="modal-card modal-form.lg" role="dialog" aria-modal="true"
				aria-labelledby="createTitle">
				<div class="modal-head">
					<strong id="createTitle">신규 차량 등록</strong>
				</div>
				<div class="modal-body">
					<form class="form" id="createForm" action="/transport/addVehicle" method="post">
						<sec:csrfInput/>
						<input type="hidden" name="vehicleIdx" id="vehicleIdx"/>
						<div class="row">
							<div class="field">
								<label>차량번호*</label> 
								<input id="c_no" name="vehicleNumber" type="text" placeholder="123가4567 / 12가3456" required />
							</div>
							<div class="field">
								<label>차종유형*</label> <input id="c_type" name="vehicleType" type="text"
									placeholder="카고/윙바디/냉동탑 등" required />
							</div>
						</div>
						<div class="row">
							<div class="field">
								<label>적재량*</label>
							  	<div class="seg-radio" role="radiogroup" aria-label="적재량" required>
							    	<input id="cap-1"  type="radio" name="capacity" value="1000">
							    	<label for="cap-1">1t</label>
							
							    	<input id="cap-15" type="radio" name="capacity" value="1500">
							    	<label for="cap-15">1.5t</label>
							    </div>
							</div>
							<div class="field">
								<label>연식</label> 
								<input id="c_year" name="manufactureYear" type="number" placeholder="YYYY"/>
							</div>
						</div>
						<div class="row">
							<div class="field">
								<label>제조사/모델명</label> 
								<input id="c_model" name="manufacturerModel" placeholder="현대 포터 등" />
							</div>
							<div class="field">
								<label>고정기사명</label> <input id="c_driver" disabled/>
							</div>
						</div>
						<div class="help">* 차량번호는 중복 등록 불가</div>
					</form>
				</div>
				<div class="modal-foot">
					<button class="btn btn-cancel" id="cancelCreate">취소</button>
					<button class="btn btn-confirm" id="saveCreate">등록</button>
				</div>
			</div>
		</div>