function loadSupplierProductContracts() {
    $.ajax({
        url: '/admin/systemPreference/supplyContract/getContractList', // 실제 매핑된 서버 엔드포인트로 수정하세요.
        type: 'GET',
        dataType: 'json',
        success: function(contractList) {
            renderContractList(contractList);
        },
        error: function() {
            Swal.fire('오류', '공급계약 목록을 불러오는 데 실패했습니다.', 'error');
        }
    });
}

function renderContractList(list) {
    const $tbody = $('#contractTable tbody');
    $tbody.empty();
    if (!list.length) {
        $tbody.append('<tr><td colspan="999">등록된 공급계약이 없습니다.</td></tr>');
        return;
    }
    list.forEach(function(contract) {
        $tbody.append(`
		   <tr data-contract-idx="${contract.contractIdx}">
			  <td>${contract.supplierName}</td>
			  <td>${contract.productName}</td>
			  <td>${contract.contractPrice}</td>
			  <td>${formatDateFromMillis(contract.contractStart)} ~ ${formatDateFromMillis(contract.contractEnd)}</td>
			  <td>${contract.status}</td>
			  <td><button type="button" class="btn btn-sm btn-info btn-detail-contract">상세보기</button></td>
			</tr>
        `);
    });
}
//기간보이기변환
function formatDateFromMillis(millis) {
    if (!millis) return '';
    const date = new Date(Number(millis));
    // yyyy-MM-dd 형태로 출력
    const yyyy = date.getFullYear();
    const mm = String(date.getMonth() + 1).padStart(2, '0');
    const dd = String(date.getDate()).padStart(2, '0');
    return `${yyyy}-${mm}-${dd}`;
}

// 상품 리스트 불러오기 및 옵션 세팅
function loadProductOptions(selectedProductIdx) {
    $.ajax({
        url: '/admin/systemPreference/product/getProductList', // 실제 엔드포인트로 변경 필요
        type: 'GET',
        dataType: 'json',
        success: function(productList) {
            const $select = $('#productSelect');
            $select.empty();
            $select.append('<option value="">선택하세요</option>');
            $.each(productList, function(i, product) {
                $select.append(
                    `<option value="${product.idx}" ${selectedProductIdx == product.idx ? 'selected' : ''}>
                        ${product.productName}
                     </option>`
                );
            });
        },
        error: function() {
            Swal.fire('오류', '상품 목록을 불러오는 데 실패했습니다.', 'error');
        }
    });
}

// 공급업체 리스트 불러오기 및 옵션 세팅
function loadSupplierOptions(selectedSupplierIdx) {
    $.ajax({
        url: '/admin/systemPreference/supplyCompany/suppliers', // 실제 엔드포인트로 변경 필요
        type: 'GET',
        dataType: 'json',
        success: function(supplierList) {
            const $select = $('#supplierSelect');
            $select.empty();
            $select.append('<option value="">선택하세요</option>');
            $.each(supplierList, function(i, supplier) {
                $select.append(
                    `<option value="${supplier.idx}" ${selectedSupplierIdx == supplier.idx ? 'selected' : ''}>
                        ${supplier.supplierName}
                     </option>`
                );
            });
        },
        error: function() {
            Swal.fire('오류', '공급업체 목록을 불러오는 데 실패했습니다.', 'error');
        }
    });
}

//상세보기모달보기
function openContractDetailModal(contractIdx) {
	currentContractIdx = contractIdx;
    // 모달을 먼저 띄움
    $('#contractDetailModal').modal('show');
	// 데이터 초기화
    $('#contractDetailProductImagePreview').attr('src', '');
    $('#detailSupplier').val('');
    $('#detailProduct').val('');
    $('#detailContractPrice').val('');
    $('#detailContractStart').val('');
    $('#detailContractEnd').val('');

	$('#contractDetailForm input, #contractDetailForm textarea').prop('readonly', true);
    $('#btnEditContractDetail, #btnDeleteContractDetail, .btn-secondary[data-dismiss="modal"]').show();
    $('#btnSaveContractDetail, #btnCancelEditDetail').hide();

	// 공통 fetch 함수 사용!
    $('#contractDetailModal').off('shown.bs.modal.myHandler').on('shown.bs.modal.myHandler', function () {
        $.ajax({
            url: '/admin/systemPreference/supplyContract/getContractDetail',
            type: 'GET',
            data: { idx: contractIdx },
            dataType: 'json',
            success: function(data) {
                if (!data) return;
			    $('#detailSupplier').val(data.supplierName);
			    $('#detailProduct').val(data.productName);
			    $('#detailContractPrice').val(data.contractPrice);
			    $('#detailContractStart').val(formatDateFromMillis(data.contractStart));
			    $('#detailContractEnd').val(formatDateFromMillis(data.contractEnd));
			    $('#detailMinOrderQuantity').val(data.minOrderQuantity);
			    $('#detailMaxOrderQuantity').val(data.maxOrderQuantity);
			    $('#detailStatus').val(data.status);
			    $('#contractDetailNote').val(data.note);
			    // 이미지
			    if (data.fileIdx) {
			        $('#contractDetailProductImagePreview').attr('src', '/file/thumbnail/' + data.fileIdx + '?_=' + Date.now());
			    } else if (data.productIdx) {
			        $('#contractDetailProductImagePreview').attr('src', '/images/products/' + data.productIdx + '.jpg');
			    } else {
			        $('#contractDetailProductImagePreview').attr('src', '/images/no-image.png');
			    }
				saveOriginalData(data);
			},
			error: function() {
                Swal.fire('오류', '상세 정보를 불러오는 데 실패했습니다.', 'error');
            }
		});
    });
}

// 상세 정보 불러온 후 데이터를 저장
function saveOriginalData(data) {
    originalContractData = {
        contractPrice: data.contractPrice,
        contractStart: data.contractStart,
        contractEnd: data.contractEnd,
        minOrderQuantity: data.minOrderQuantity,
        maxOrderQuantity: data.maxOrderQuantity,
        status: data.status,
        note: data.note
    };
}

function updateAndRestoreDetail(data) {
    // 받은 데이터로 각 필드 값 채움
    $('#detailSupplier').val(data.supplierName);
    $('#detailProduct').val(data.productName);
    $('#detailContractPrice').val(data.contractPrice);
    $('#detailContractStart').val(formatDateFromMillis(data.contractStart));
    $('#detailContractEnd').val(formatDateFromMillis(data.contractEnd));
    $('#detailMinOrderQuantity').val(data.minOrderQuantity);
    $('#detailMaxOrderQuantity').val(data.maxOrderQuantity);
    $('#detailStatus').val(data.status);
    $('#contractDetailNote').val(data.note);
    // 이미지 처리
    if (data.fileIdx) {
        $('#contractDetailProductImagePreview').attr('src', '/file/thumbnail/' + data.fileIdx + '?_=' + Date.now());
    } else if (data.productIdx) {
        $('#contractDetailProductImagePreview').attr('src', '/images/products/' + data.productIdx + '.jpg');
    } else {
        $('#contractDetailProductImagePreview').attr('src', '/images/no-image.png');
    }

    // 모든 입력창/textarea를 다시 읽기전용(수정 불가)으로 설정
    $('#detailContractPrice, #detailContractStart, #detailContractEnd, #detailMinOrderQuantity, #detailMaxOrderQuantity, #contractDetailNote').prop('readonly', true);

    // select 박스 상태도 다시 수정 불가로 (disabled)
    $('#detailStatus').prop('disabled', true);

    // 버튼 상태 복구: 수정/삭제/닫기 보이기, 저장/취소 숨기기
    $('#btnEditContractDetail, #btnDeleteContractDetail, .btn-secondary[data-dismiss="modal"]').removeClass('d-none').show();
    $('#btnSaveContractDetail, #btnCancelEditDetail').addClass('d-none').hide();
}









// 계약상세 원본저장
let originalContractData = {};
let currentContractIdx = 0;
//페이지로드후
$(function(){
	//상품추가버튼클릭
	$(document).on('click', '#btnAddContract', function() {
	    loadProductOptions();    //상품목록
    	loadSupplierOptions();	//공급업체목록

	    $('#contractAddModal').modal('show');
	    $('#contractAddForm')[0].reset();
	});
	
	//상품등록모달창 등록버튼클릭	
	$('#btnSaveContract').on('click', function() {
	    const $form = $('#contractAddForm');
	
	    // 간단한 폼 유효성 검사 예시
	    if (!$form[0].checkValidity()) {
	        $form.reportValidity(); // 기본 HTML5 유효성 알림 띄우기
	        return;
	    }
	
	    const formData = $form.serialize();
	
	    $.ajax({
	        url: '/admin/systemPreference/supplyContract/addContract', // 실제 등록 엔드포인트
	        type: 'POST',
	        data: formData,
	        success: function(res) {
	            Swal.fire('등록 완료', '공급계약이 정상 등록되었습니다.', 'success');
	            $('#contractAddModal').modal('hide');
	            loadSupplierProductContracts(); // 목록 갱신
	        },
	        error: function(xhr) {
	            let msg = '등록 중 오류가 발생했습니다.';
	            if (xhr.responseText) {
	                msg = xhr.responseText;
	            }
	            Swal.fire('오류', msg, 'error');
	        }
	    });
	});
	
	//상세보기버튼클릭
	$('#contractTable').on('click', '.btn-detail-contract', function() {
	    const contractIdx = $(this).closest('tr').data('contract-idx');
	    $('#contractDetailForm').data('contractIdx', contractIdx);
	    openContractDetailModal(contractIdx);
	});
	
	//수정버튼클릭
	$('#btnEditContractDetail').on('click', function() {
	    $('#detailContractPrice, #detailContractStart, #detailContractEnd, #detailMinOrderQuantity, #detailMaxOrderQuantity, #contractDetailNote')
		.prop('readonly', false);
	
	    $('#detailSupplier, #detailProduct').prop('readonly', true);
		// select 활성화 (readonly 해제)
		$('#detailStatus').prop('disabled', false);
		
	    $('#btnSaveContractDetail, #btnCancelEditDetail')
	        .removeClass('d-none')
	        .show();
	
	    $('#btnEditContractDetail, #btnDeleteContractDetail').addClass('d-none').hide();
		
		// 숫자만 입력 가능 제한은 기존과 동일
	    $('#detailContractPrice, #detailMinOrderQuantity, #detailMaxOrderQuantity').off('input').on('input', function() {
	        this.value = this.value.replace(/[^0-9]/g, '');
	    });
	});
	
	// 취소 버튼 클릭
	$('#btnCancelEditDetail').on('click', function() {
	    // 원래 값 복원
	    $('#detailContractPrice').val(originalContractData.contractPrice);
	    $('#detailContractStart').val(originalContractData.contractStart);
	    $('#detailContractEnd').val(originalContractData.contractEnd);
	    $('#detailMinOrderQuantity').val(originalContractData.minOrderQuantity);
	    $('#detailMaxOrderQuantity').val(originalContractData.maxOrderQuantity);
	    $('#detailStatus').val(originalContractData.status);
	    $('#contractDetailNote').val(originalContractData.note);
	
	    // 입력 필드를 다시 읽기 전용으로 설정
	    $('#detailContractPrice, #detailContractStart, #detailContractEnd, #detailMinOrderQuantity, #detailMaxOrderQuantity, #contractDetailNote').prop('readonly', true);
	    $('#detailStatus').prop('disabled', true);
	
	    // UI 버튼 상태 복원 (취소 후에는 수정·삭제 버튼 보이고, 저장·취소 버튼 숨기기)
	    $('#btnEditContractDetail, #btnDeleteContractDetail').removeClass('d-none').show();
	    $('#btnSaveContractDetail, #btnCancelEditDetail').addClass('d-none').hide();
	});
	
	//수정 > 저장버튼
	$('#btnSaveContractDetail').on('click', function() {
	    // 입력값 수집
	    const dataToSave = {
	        contractPrice: $('#detailContractPrice').val(),
	        contractStart: $('#detailContractStart').val(),
	        contractEnd: $('#detailContractEnd').val(),
	        minOrderQuantity: $('#detailMinOrderQuantity').val(),
	        maxOrderQuantity: $('#detailMaxOrderQuantity').val(),
	        status: $('#detailStatus').val(),
	        note: $('#contractDetailNote').val(),
	        idx: currentContractIdx // 모달 열 때 저장해둔 계약 인덱스 변수
	    };
	
	    // 간단한 유효성 검사
	    if (!dataToSave.contractPrice || !dataToSave.contractStart || !dataToSave.contractEnd) {
	        Swal.fire('경고', '계약 단가와 계약 시작일, 종료일은 필수 입력입니다.', 'warning');
	        return;
	    }
	
	    // 서버에 저장 요청
	    $.ajax({
	        url: '/admin/systemPreference/supplyContract/updateContractDetail',
	        type: 'POST',
	        contentType: 'application/json',
	        data: JSON.stringify(dataToSave),
	        success: function(response) {
	           Swal.fire('성공', '계약 정보가 저장되었습니다.', 'success');
		            // 서버에서 상세 데이터를 다시 받아 updateAndRestoreDetail()로 화면 갱신
		            $.ajax({
		                url: '/admin/systemPreference/supplyContract/getContractDetail',
		                type: 'GET',
		                data: { idx: currentContractIdx },
		                dataType: 'json',
		                success: function(data) {
		                    updateAndRestoreDetail(data);
		                },
		                error: function() {
		                    Swal.fire('오류', '업데이트 후 상세 정보를 다시 불러오지 못했습니다.', 'error');
		                }
		            });
		        },
	        error: function() {
	            Swal.fire('오류', '계약 정보 저장에 실패했습니다.', 'error');
	        }
	    });
	});
	
	$('#btnDeleteContractDetail').on('click', function() {
	    Swal.fire({
	        title: '정말 삭제하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonText: '삭제',
	        cancelButtonText: '취소'
	    }).then((result) => {
	        if (result.isConfirmed) {
	            const dataToDelete = {
	                idx: currentContractIdx,
	                status: '삭제' // 상태를 삭제로 변경
	            };
	
	            $.ajax({
	                url: '/admin/systemPreference/supplyContract/deleteContractDetail',
	                type: 'POST',
	                contentType: 'application/json',
	                data: JSON.stringify(dataToDelete),
	                success: function() {
	                    Swal.fire('삭제 완료', '계약 정보가 삭제 상태로 변경되었습니다.', 'success').then(() => {
	                        $('#contractDetailModal').modal('hide');
	                        // 필요하면 목록을 다시 로드하거나 화면 갱신 함수 호출
	                        reloadContractList();
	                    });
	                },
	                error: function() {
	                    Swal.fire('오류', '삭제 처리에 실패했습니다.', 'error');
	                }
	            });
	        }
	    });
	});
	
	
	
	
	loadSupplierProductContracts();
});//끝