<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
		<%-- 기사 상세 + 차량 배정/변경 모달 --%>
        <div class="modal" id="formModal" aria-hidden="true">
            <div class="modal-card modal-form lg">
                <div class="modal-head">
                    <strong id="driverTitle">기사 정보</strong>
                    <button class="modal-close-btn" >✕</button>
                </div>
                <div class="modal-body" id="driverModal">
                    <div>
                    	<input type="hidden" id="empIdx"/>
                        <div class="field">
                            <label>사번</label>
                            <input id="empNo"   disabled />
                        </div>
                        <div class="field">
                            <label>이름</label>
                            <input id="empName" disabled />
                        </div>
                        <div class="field">
                            <label>연락처</label>
                            <input class="empPhone" disabled />
                        </div>
                        <div class="field">
                            <label>상태</label>
                            <input id="empStatus" disabled />
                        </div>
                    </div>
                    <%-- 차량 선택 --%>
                    <div class="section-title">차량</div>
					<div id="vehicleEmpty" class="vehicle-empty" style="display:none;">
						<div class="vehicle-empty-text">배정된 차량이 없습니다.</div>
						<sec:authorize access="isAuthenticated()">
							<sec:authorize access="hasAnyAuthority('TRANSPORT_WRITE')">
							  	<button class="btn" id="vehicleAssignInlineBtn">차량 배정하기</button>
							</sec:authorize>
						</sec:authorize>
					</div>
					<div id="vehicleDiv" class="vehicle-empty">
						<div class="vehicle-empty-text"></div>
						<sec:authorize access="isAuthenticated()">
							<sec:authorize access="hasAnyAuthority('TRANSPORT_WRITE')">
								<button class="btn btn-primary" id="vehicleAssignBtn">배정 해제</button>
							</sec:authorize>
						</sec:authorize>
					</div>
					<%-- 배정됨/목록 영역 (배정 또는 선택 테이블) --%>
					<div id="vehicleTableWrap" style="display:none;">
						<table class="table responsive" aria-label="차량 선택 테이블">
					    <thead>
						      <tr>
						        <th class="col-radio"></th>
						        <th>차량번호</th>
						        <th>차종</th>
						        <th>적재량(kg)</th>
						      </tr>
						    </thead>
						    <tbody id="vehicleRows">
						      <!-- Ajax로 행 렌더링 -->
						    </tbody>
				        </table>

				  <div class="vehicle-actions">
				    <button class="btn outline" id="vehicleChangeBtn" style="display:none">차량 변경</button>
				  </div>
				</div>
                </div>
                <div class="modal-foot">
                	<sec:authorize access="isAuthenticated()">
                		<sec:authorize access="hasAnyAuthority('TRANSPORT_WRITE')">
		                    <button class="btn outline" id="vehicleAssignBtn" style="display:none">차량 배정</button>
		                    <button class="btn" id="vehicleChangeBtn" style="display:none">차량 변경</button>
	                    </sec:authorize>
                   </sec:authorize> 
                </div>
            </div>
        </div>