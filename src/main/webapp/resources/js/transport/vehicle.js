const DUPLICATE_CHECK_URL = "/transport/vehicle/dupCheck";
const MODIFY_VEHICLE_URL = "/transport/vehicle/detail";
const MODIFY_VEHICLE_STATUS_URL = "/transport/vehicle/status";
const ASSIGN_DRIVER_URL = "/transport/assignDriver";

// 모달 열기
function openCreateModal() {
	$("#createForm")[0].reset();
	$("#createModal").attr("aria-hidden", "false").addClass("open");
}

$(document).on('click', 'tr.rowLink', function (e) {
  // 체크박스/버튼/링크 클릭 시 행 오픈 막기 (선택)
  if ($(e.target).closest('input,button,a,label').length) return;

  const id = $(this).data('vehicle-id');
  openEditModal(id); 
});

// 모달 닫기
function closeCreateModal() {
	 $("#createModal").attr("aria-hidden", "true").removeClass("open");
}

function closeEditModal() {
	 $("#editModal").attr("aria-hidden", "true").removeClass("open");
}

// esc로 모달 닫기
$(document).on("keydown", function(e) {
	if (e.key === "Escape" && $("#createModal").hasClass("open")) closeCreateModal();
});

// esc로 모달 닫기
$(document).on("keydown", function(e) {
	if (e.key === "Escape" && $("#editModal").hasClass("open")) closeEditModal();
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

// 차량 상세 모달
function openEditModal(vehicleIdx) {
  $('#editModal').attr('aria-hidden','false').addClass('open');

  // 로딩 표시(선택)
  $('#e_no, #e_driver').val('');
  $('#e_status').val('대기');

  $.getJSON(MODIFY_VEHICLE_URL, { idx: vehicleIdx })
    .done(function(v) {
	  $("#idx").val(v.vehicleIdx);
	  
      // 상세 정보 입력
      $("#vehicleNumber").val(v.vehicleNumber);
      $("#vehicleType").val(v.vehicleType);
	  $("#status").val(v.status);
      $("#capacity").val(String(v.capacity)); 
      $("#driverName").val(v.driverName || '');
      $("#manufacturerModel").val(v.manufacturerModel);
      $("#manufactureYear").val(v.manufactureYear);

	  v.capacity === 1000 ? $('#capacity').val("1.0t") : $('#capacity').val("1.5t");

      const isModify = (v.status === '운행중' || v.status === '대기');	  
	  $('#saveEdit').prop('disabled', isModify);
	  $('#status').prop('disabled', isModify);

		
	 $("#editModal").data('vehicleIdx', v.vehicleIdx);

    })
    .fail(function(status) {
      Swal.fire({icon:'error', text:'차량 정보를 불러오지 못했습니다.'});
	  closeEditModal();
    });
}

// 저장 버튼 클릭
function saveEdit() {
	const modal = $("#editModal");
	const idx = Number(modal.data("vehicleIdx"));
	const status = $("#status");
	const oldStatus = status.data("prev");
	const newStatus = status.val();
	
	console.log(idx);
	
	if (!idx) {
		Swal.fire({icon:'error', text:'잘못된 차량입니다.'}); return; 
	}
	
	// 상태 변경이 없을 경우 모달창 닫기
	if (newStatus === oldStatus) {
		closeEditModal();
    	return;
	}
	
	// 사용불가 확인
	const confirmStatus = (newStatus === "사용불가") 
		? Swal.fire({
			icon:'warning',
        	title:'사용불가 처리',
        	text:'이 차량을 사용불가로 변경하시겠습니까?',
			showCancelButton:true,
	        confirmButtonText:'변경',
	        cancelButtonText:'취소'
		}).then(r => r.isConfirmed)
		: Promise.resolve(true);
		
	$('#saveEdit').prop('disabled', true);
	
	confirmStatus.then(ok => {
		if (!ok) {
			$('#saveEdit').prop('disabled', false); return; 
		}
		
		requestBulkUpdateStatus([idx], newStatus)
			.done(() => {
				closeEditModal();
				Swal.fire({ icon:'success', text:'상태가 변경되었습니다.' });
				reloadVehicleContent();
			})
			.fail(xhr => {
				const msg = (xhr.responseJSON && xhr.responseJSON.message) || '변경에 실패했습니다. 잠시 후 다시 시도해주세요.';
				Swal.fire({
					icon:'error', 
					text: msg
				});
			});
	});
	
}

// 체크박스 전체 선택
$("#checkAll").on("change", function() {
	const checked = this.checked;
	$('#vehicleTable .rowCheck:not(:disabled)').prop('checked', checked);
});

// 체크된 행의 vehicle-id 수집
function collectSelectedVehicleIdx() {
	return $('#vehicleTable tbody input[type="checkbox"]:checked')
    	.map(function () {
      	return $(this).closest('tr').data('vehicle-id'); // <tr data-vehicle-id="...">
    	})
    	.get()
    	.filter(function (id) { return id != null; });
}

// 서버 상태변경 요청
function requestBulkUpdateStatus(idxArray, status) {
	return $.ajax({
     url: MODIFY_VEHICLE_STATUS_URL,
     method: 'POST',
     contentType: 'application/json',
     data: JSON.stringify({
		idx : idxArray,
		status
   	  })
   });	
}

// 목록 다시 가져오기
function reloadVehicleContent() {
	const params = new URLSearchParams(window.location.search);
  	const url = '/transport/vehicle?' + params.toString();
  	$('.content').load(url + ' .content > *');
}

// 클릭 핸들러
function onClickBulkDelete() {
	const idx = collectSelectedVehicleIdx();

  	if (idx.length === 0) {
    	Swal.fire({ icon: 'info', text: '삭제할 차량을 선택하세요.' });
    	return;
  	}

	const rows = $('#vehicleTable tbody input[type="checkbox"]:checked').closest('tr');
	const hasLocked = rows.toArray().some((tr) => {
		const status = $(tr).data("status");
		return status === "대기" || status === "운행중";
	});
	
	if (hasLocked) {
		Swal.fire({ icon:'error', text:'대기 중이거나 운행 중인 차량은 삭제할 수 없습니다.' });
    	return;
	}

  	Swal.fire({
    	icon: 'warning',
    	title: '선택 삭제',
    	text: '선택한 ' + idx.length + '대의 차량을 삭제하시겠습니까?',
    	showCancelButton: true,
    	confirmButtonText: '삭제',
    	cancelButtonText: '취소'
  	}).then(function (result) {
    	if (!result.isConfirmed) return;

    	$('#bulkDelete').prop('disabled', true);

    	requestBulkUpdateStatus(idx, '사용불가')
      	.done(function () {
        	reloadVehicleContent();
        	Swal.fire({ icon: 'success', text: '삭제되었습니다.' });
      	})
      	.fail(function (xhr) {
        	const message = (xhr.responseJSON && xhr.responseJSON.message) || '삭제에 실패했습니다. 잠시 후 다시 시도해주세요.';
        	Swal.fire({ icon: 'error', text: message });
      	})
      	.always(function () {
        	$('#bulkDelete').prop('disabled', false);
      	});
  	});
}


// 이벤트 바인딩
$(document).ready(function () {
	$("#openCreate").on("click", openCreateModal);
    $("#cancelCreate").on("click", closeCreateModal);
    $("#cancelEdit").on("click", closeEditModal);
    $("#saveCreate").on("click", submitCreateForm);
	$('#bulkDelete').on('click', onClickBulkDelete);
	$('#saveEdit').on('click', saveEdit);
});

