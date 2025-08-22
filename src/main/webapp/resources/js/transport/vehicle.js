const DUPLICATE_CHECK_URL = "/transport/vehicle/dupCheck";
const MODIFY_VEHICLE_URL = "/transport/vehicle/detail";
const DELETE_VEHICLE_URL = "/transport/vehicle/delete";
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
      $('#vehicleNumber').val(v.vehicleNumber);
      $('#vehicleType').val(v.vehicleType);
      $('#capacity').val(String(v.capacity)); 
      $('#year').val(v.manufactureYear || '');
      $('#model').val(v.manufacturerModel || '');
      $('#driverName').val(v.driverName || '');
      $('#manufacturerModel').val(v.manufacturerModel);
      $('#manufactureYear').val(v.manufactureYear);

	  v.capacity === 1000 ? $('#capacity').val("1.0t") : $('#capacity').val("1.5t");

	  const status = v.status;
	  $('status').val(status);

	  // 운행중 또는 사용불가인 경우 기사등록 버튼 비활성화
      const isModify = (v.status === '운행중' || v.status === '사용불가');
      $('#btnAssignDriver').prop('disabled', isModify);
	  $('#vehicleType').prop('disabled', isModify);
    })
    .fail(function(status) {
      $modal.removeClass('open').attr('aria-hidden','true');
      Swal.fire({icon:'error', text:'차량 정보를 불러오지 못했습니다.'});
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

// 서버 삭제 요청
function requestBulkDelete(idxArray) {
	return $.ajax({
     url: DELETE_VEHICLE_URL,
     method: 'DELETE',
     contentType: 'application/json',
     data: JSON.stringify(idxArray)
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

    	requestBulkDelete(idx)
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

// 기사 배정 버튼 클릭
function onClickAssignDriver() {
	$('#assignDriverModal').attr('aria-hidden','false').addClass('open');
	
	$.getJSON(ASSIGN_DRIVER_URL)
	    .done(function(drivers) {
		
		renderDriverTable(drivers);

    })
    .fail(function() {
      $modal.removeClass('open').attr('aria-hidden','true');
      Swal.fire({icon:'error', text:'기사 정보를 불러오지 못했습니다.'});
    });
}

function renderDriverTable(drivers) {
	const tbody = $("#driverTableBody");
	
	tbody.empty();
	
	if (!drivers.length) {
	    tbody.append('<tr><td colspan="4" class="text-center text-muted">배정할 기사가 없습니다.</td></tr>');
	    return;
  	}
	
	// 문자열로 렌더링
  	const rowsHtml = drivers.map( function(driver) {
	    return `
	      <tr data-driver-id="${driver.idx}">
	        <td><input type="radio" name="driverId" value="${driver.idx}"></td>
	        <td>${driver.empNo ?? ''}</td>
	        <td>${driver.empName ?? ''}</td>
	        <td>${driver.empPhone ?? ''}</td>
	      </tr>
	    `
  	}).join('');

  	tbody.html(rowsHtml);
}

$('#driverTableBody').on('click', 'tr', function(e) {
  if (!$(e.target).is('input[type="radio"]')) {
    $(this).find('input[type="radio"]').prop('checked', true);
  }
});

// 배정 버튼 클릭
function assignDriver() {
	const checked = $('input[name="driverId"]:checked');
	
	if (checked.length === 0) {
	    Swal.fire({ icon:'info', text:'배정할 기사를 선택하세요.' });
	    return;
  	}

	const selectedId = $('tr').data('driver-id');
	const driverData = selectedId.dataset.test;
	const selectedName = checked.closest('tr').find('td').eq(2).text().trim();
}

// 이벤트 바인딩
$(document).ready(function () {
	$("#openCreate").on("click", openCreateModal);
    $("#cancelCreate").on("click", closeCreateModal);
    $("#cancelEdit").on("click", closeEditModal);
    $("#saveCreate").on("click", submitCreateForm);
	$('#bulkDelete').on('click', onClickBulkDelete);
	$('#btnAssignDriver').on('click', onClickAssignDriver);
});


