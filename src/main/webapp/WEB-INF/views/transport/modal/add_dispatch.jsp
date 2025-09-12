<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
	<!-- 등록(대기/추가 필요만) 모달 -->
    <div class="modal" id="assignModal" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="assignTitle">
            <div class="modal-head">
                <strong id="assignTitle">배차 등록/수정</strong>
                <button class="modal-close-btn" >✕</button>
            </div>
            <div class="modal-body" style="overflow: auto; height: 500px;	">
                <div style="display:grid; grid-template-columns:2fr 1fr; gap:12px;">
                    <!-- 좌: 대기/추가 필요 리스트 -->
                    <div>
                        <table class="table" id="assignList">
                            <thead>
                                <tr>
                                    <th style="width:44px">선택</th>
                                    <th>배차일</th>
                                    <th>배차시간</th>
                                    <th>구역명</th>
                                    <th>총적재량</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody><!-- JS 렌더링 --></tbody>
                        </table>
                    </div>
                    <!-- 우: 선택건 조치 -->
                    <div>
                        <div class="field">
                            <label>선택된 배차</label>
                            <input id="selAssignSummary" disabled />
                        </div>
                        <div class="field">
                            <label>가용 가능한 기사</label>
                            <select id="primaryDriverSelect"></select>
                            <button class="btn btn-primary" id="btnAssignDriver" style="justify-content: center;">기사 배정</button>
                        </div>

                        <div class="field" id="extraDriverBlock" style="display:none">
                           <span>추가 배차가 필요합니다.</span>
                        </div>

                        <div class="field">
                            <label>요청중량 / 배정 확정 한도</label>
                            <input id="capacityInfo" disabled />
                        </div>
                        
                        <div class="field">
							<label>배정된 기사/차량</label>
						  	<div id="assignedDriverList"></div>
						</div>
                    </div>
                </div>
            </div>
            <div class="modal-foot">
           		<button class="btn btn-cancel" id="btnCancelAssign">배차 취소</button>
       			<button class="btn btn-confirm" id="btnSaveAssign">배차등록</button>
            </div>
        </div>
    </div>