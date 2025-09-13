<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
	<!-- 상세 모달(배차 클릭 시) -->
    <div class="modal" id="detailModal" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="detailTitle">
            <div class="modal-head">
                <strong id="detailTitle">배차 상세</strong>
                <button class="modal-close-btn" >✕</button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <label>담당 기사 정보</label>
                    <input id="detailDriver" disabled />
                </div>

                <div class="card" style="margin-top:10px" id="summary">
                    <div class="card-header">주문서(품목)</div>
                    <table class="table" id="summaryInfo">
                        <thead>
                            <tr>
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
                <div class="card" style="margin-top:10px" id="detail">
                    <table class="table" id="detailItems">
                        <thead>
                            <tr>
                                <th>지점</th>
                                <th>품목</th>
                                <th>반품수량/출고수량</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody><!-- JS 렌더링 --></tbody>
                    </table>
                </div>
                <h3 style="margin:12px 0 6px">배송 현황</h3>
            	<div class="timeline" id="timeline"><!-- 단계 표시 --></div>
            </div>
            <div class="modal-foot">
            <button type="button"
                    class="btn btn-confirm"
                    onclick="ModalManager.closeModal(document.getElementById('detailModal'))">
                확인
            </button>
            </div>
        </div>
    </div>