// /resources/js/inbound/changeLocationIdx.js
(function() {
    "use strict";

    function byId(id) { return document.getElementById(id); }

    const btnAssignLocation = byId("btnAssignLocation");
    const modal = byId("modal-assign-location");

    if (!btnAssignLocation || !modal) {
        console.warn("[changeLocationIdx] 버튼 또는 모달을 찾을 수 없음");
        return;
    }

    // 모달 열기
    btnAssignLocation.addEventListener("click", function() {
        ModalManager.openModalById("modal-assign-location");
    });

    // 취소 버튼 클릭 → 모달 닫기
    const btnCancel = modal.querySelector("[data-close]");
    if (btnCancel) {
        btnCancel.addEventListener("click", function() {
            ModalManager.closeModalById("modal-assign-location");
        });
    }

    // 저장 버튼(form submit) → AJAX 호출
    const form = byId("formAssignLocation");
    if (form) {
        form.addEventListener("submit", function(e) {
            e.preventDefault();

            const ibwaitIdx = form.querySelector("input[name=ibwaitIdx]").value;
            const selectEl = form.querySelector("#inboundLocationSelect"); // ✅ 수정된 ID
            const locationIdx = selectEl.value; // 9999 / 9998 / 9997
            const locationName = selectEl.options[selectEl.selectedIndex].text.trim(); // Location_F / G / H

            const { token, header } = getCsrf();

            $.ajax({
                url: "/inbound/updateLocation",
                type: "POST",
                data: JSON.stringify({
                    ibwaitIdx: ibwaitIdx,
                    inboundLocation: locationIdx   // 서버에는 idx만 전송
                }),
                contentType: "application/json",
                beforeSend: function(xhr) {
                    if (header && token) xhr.setRequestHeader(header, token);
                },
                success: function(res) {
                    if (res.ok) {
                        Swal.fire("성공", "입고위치가 변경되었습니다 ✅", "success");

                        // 화면 갱신
                        const field = byId("fieldInboundLocation");
                        if (field) {
                            field.textContent = locationName;   // 사용자에게 보여줄 이름
                            field.dataset.idx = locationIdx;   // payload용 숫자 코드
                        }

                        ModalManager.closeModalById("modal-assign-location");
                    } else {
                        Swal.fire("실패", "입고위치 변경 실패 ❌", "error");
                    }
                },
                error: function(xhr) {
                    Swal.fire("에러", "서버 오류 발생: " + xhr.status, "error");
                }
            });
        });
    }
})();
