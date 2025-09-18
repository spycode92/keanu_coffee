<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="modal" id="modifyLotNumber">
    <div class="modal-card modal-form md">
        <div class="modal-head">
            <h3>QR 코드 스캔</h3>
            <button class="modal-close-btn" onclick="ModalManager.closeModalById('modifyLotNumber')">✕</button>
        </div>
        <div class="modal-body">
            <!-- 카메라 스캔 영역 -->
            <video id="qrVideo" style="width:100%; height:300px; background:#000;"></video>
            <div id="qrResultText" class="mt-2 text-muted">카메라 준비중...</div>

            <!-- 전환 버튼 -->
            <div class="mt-3 text-right">
                <button id="btnManualInput" class="btn btn-secondary btn-sm">
                    수동 입력
                </button>
            </div>

            <!-- 수동 입력칸 -->
            <div id="manualInputArea" style="display:none;" class="mt-2">
                <input type="text" id="manualLotNumber" class="form-control" placeholder="LOT 번호 입력" />
                <button id="btnApplyManual" class="btn btn-primary btn-sm mt-2">적용</button>
            </div>
        </div>
    </div>
</div>
