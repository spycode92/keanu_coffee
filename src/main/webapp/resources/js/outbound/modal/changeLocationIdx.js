// /resources/js/outbound/changeOutboundLocationIdx.js
(function() {
    "use strict";

    function byId(id) { return document.getElementById(id); }

    const btnAssignLocation = byId("btnAssignLocation");
    const modal = byId("modal-assign-outbound-location");

    if (!btnAssignLocation || !modal) {
        console.warn("[changeOutboundLocationIdx] 버튼 또는 모달을 찾을 수 없음");
        return;
    }

    // 모달 열기
    btnAssignLocation.addEventListener("click", function() {
        ModalManager.openModalById("modal-assign-outbound-location");
    });

    // 취소 버튼 클릭 → 모달 닫기
    const btnCancel = modal.querySelector("[data-close]");
    if (btnCancel) {
        btnCancel.addEventListener("click", function() {
            ModalManager.closeModalById("modal-assign-outbound-location");
        });
    }

    // 저장 버튼(form submit) → AJAX 호출
    const form = byId("formAssignOutboundLocation");
    if (form) {
        form.addEventListener("submit", function(e) {
            e.preventDefault();

            const obwaitIdx = form.querySelector("input[name=obwaitIdx]").value;
            const selectEl = form.querySelector("#outboundLocationSelect");
            const locationIdx = selectEl.value; // 9994 / 9995 / 9996
            const locationName = selectEl.options[selectEl.selectedIndex].text.trim(); // Location_A/B/C

            const { token, header } = getCsrf();

            $.ajax({
                url: "/outbound/updateLocation",
                type: "POST",
                data: JSON.stringify({
                    obwaitIdx: obwaitIdx,
                    outboundLocation: locationIdx   // 서버에는 idx만 전송
                }),
                contentType: "application/json",
                beforeSend: function(xhr) {
                    if (header && token) xhr.setRequestHeader(header, token);
                },
                success: function(res) {
                    if (res.ok) {
                        Swal.fire("성공", "출고위치가 변경되었습니다 ✅", "success");

                        // 화면 갱신
                        const field = byId("fieldOutboundLocation");
                        if (field) {
                            field.textContent = locationName;   // 사용자에게 보여줄 이름
                            field.dataset.idx = locationIdx;   // payload용 숫자 코드
                        }

                        ModalManager.closeModalById("modal-assign-outbound-location");
                    } else {
                        Swal.fire("실패", "출고위치 변경 실패 ❌", "error");
                    }
                },
                error: function(xhr) {
                    Swal.fire("에러", "서버 오류 발생: " + xhr.status, "error");
                }
            });
        });
    }
})();
