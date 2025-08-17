const DUPLICATE_CHECK_URL = "/transport/vehicle/dupCheck";

const Toast = Swal.mixin({
    toast: true,
    position: 'top-end',
    showConfirmButton: false,
    timer: 3000,
    timerProgressBar: true,
    didOpen: (toast) => {
	    toast.onmouseenter = Swal.stopTimer;
	    toast.onmouseleave = Swal.resumeTimer;
    }
});

// 모달 열기
function openCreateModal() {
	$("#createForm")[0].reset();
	$("#createModal").attr("aria-hidden", "false").addClass("open");
}

// 모달 닫기
function closeCreateModal() {
	 $("#createModal").attr("aria-hidden", "true").removeClass("open");
}

// esc로 모달 닫기
$(document).on("keydown", function(e) {
	if (e.key === "Escape" && $("#createModal").hasClass("open")) closeCreateModal();
});

// 번호판 패턴: (선택)지역2~3자 + 숫자2~3 + 한글1 + 숫자4
const PLATE_PATTERN = /^(?:[가-힣]{2,3})?(\d{2,3})([가-힣])(\d{4})$/;

function normalizePlate(plateText) {
	// 공백/하이픈 제거
	const compactPlate = plateText.replace(/[\s-]/g, '');
	const match = compactPlate.match(PLATE_PATTERN);
	
	if (!match) {
		return null;
	}
	
	// match 결과를 구조 분해로 변수에 담기
	const [, leadingDigits, middleKoreanChar, trailingDigits] = match;
	return `${leadingDigits}${middleKoreanChar}${trailingDigits}`;
}

//차량번호 유효성 검사
function isValidPlate(plateText) {
	return normalizePlate(plateText) !== null;
}

// 차량번호 중복 검사 요청
function checkDuplicatePlate(normalizedPlate) {
	return $.getJSON(DUPLICATE_CHECK_URL, {vehicleNumber : normalizedPlate});
}

// 차량 등록 폼
function submitCreateForm(e) {
	e.preventDefault();
	
	const vehicleNumber = $("#c_no").val().trim();
	const vehicleType = $("#c_type").val().trim();
	const vehicleCapacity = $('input[name="capacity"]:checked').val();
	const vehicleYear = $("#c_year").val().trim();
	
	const today = new Date();
	const year = today.getFullYear();
	
	if (!vehicleNumber || !vehicleType || !vehicleCapacity) {
		Swal.fire({
			icon: "error",
			text: "차량번호/차종유형/적재량은 필수 입력입니다."
		});
		return;
	}
	
	if (!isValidPlate(vehicleNumber)) {
		Swal.fire({
			icon: "error",
			title: "차량번호 형식을 확인하세요.",
			text: "예) 123가4567 / 12가3456 / 서울 123가 4567"
		});
		$("#c_no").focus().select();
		return;
	}
	
	if (vehicleYear > year) {
		Swal.fire({
			icon: "error",
			text: "차량 연식을 올바르게 입력해주세요."
		});
		$("#c_year").focus().select();
		return;
	}
	
	const normalized = normalizePlate(vehicleNumber);
	
	// 차량번호 중복 검사
	checkDuplicatePlate(normalized)
		.done((res) => {
			if (res.duplicate) {
				Swal.fire({
					icon: "error",
					text: "이미 등록된 차량번호입니다."
				});
				return;
			}
			// 서버로 정규화된 값으로 보냄
			$("#c_no").val(normalized);
			
			$("#createForm")[0].submit();
		})
		.fail(() => {
			Swal.fire({
				icon: "error",
				text: "중복 확인에 실패했습니다. 잠시 후 다시 시도해 주세요."
			});
			return;
		})
}

// 이벤트 바인딩
$(document).ready(function () {
    $("#openCreate").on("click", openCreateModal);
    $("#cancelCreate").on("click", closeCreateModal);
    $("#saveCreate").on("click", submitCreateForm);
});


