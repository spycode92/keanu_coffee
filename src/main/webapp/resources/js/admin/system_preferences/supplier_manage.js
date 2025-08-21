$(function() {
	
	//다음 주소찾기 api 함수
	function setupDaumPostcode(buttonSelector, zipcodeSelector, addr1Selector, addr2Selector) {
	    $(buttonSelector).click(function() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                $(zipcodeSelector).val(data.zonecode);
	                var addr = data.roadAddress ? data.roadAddress : data.jibunAddress;
	                $(addr1Selector).val(addr);
	                $(addr2Selector).focus();
	            }
	        }).open();
	    });
	}
	
	
    // 공급업체 등록 모달 열기
    $('#btnAddSupplier').click(function() {
        $('#supplierForm')[0].reset();
        $('#supplierModal').modal('show');
    });
	
	//핸드폰번호입력
	$('#supplierManagerPhone').on('input', function() {
		let value = $(this).val();
        // 숫자만 남기기
        value = value.replace(/[^0-9]/g, '');
        // 11자리까지만 허용
        if (value.length > 11) {
            value = value.slice(0, 11);
        }
        // 자동 하이픈 삽입
        let formatted = '';
        if (value.length < 4) {
            formatted = value;
        } else if (value.length < 8) {
            formatted = value.slice(0, 3) + '-' + value.slice(3);
        } else {
            formatted = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7);
        }
        $(this).val(formatted);
    });

    // 핸드폰 번호 입력시 최대 입력 길이 제한
    $('#supplierManagerPhone').attr('maxlength', 13); // 010-1234-5678 (13글자)
	
	// 다음주소 api 실행
//	$('#btnSearchAddress').click(function() {
//	    new daum.Postcode({
//	        oncomplete: function(data) {
//	            // 우편번호
//	            $('#supplierZipcode').val(data.zonecode);  // 우편번호 정보 zonecode 필드 사용
//	
//	            // 주소 (도로명 주소 우선)
//	            var addr = data.roadAddress ? data.roadAddress : data.jibunAddress;
//	            $('#supplierAddress1').val(addr);
//	
//	            // 상세주소 입력란 포커스 이동
//	            $('#supplierAddress2').focus();
//	        }
//	    }).open();
//	});
	setupDaumPostcode('#btnSearchAddress', '#supplierZipcode', '#supplierAddress1', '#supplierAddress2');
	


    // 공급업체 등록 폼 제출
    $('#supplierForm').on('submit', function(e) {
	    e.preventDefault();

		//공백제거
	    const supplierData = {
	        supplierName: $('#supplierName').val().trim(),
	        supplierManager: $('#supplierManager').val().trim(),
	        supplierManagerPhone: $('#supplierManagerPhone').val().trim(),
	        supplierZipcode: $('#supplierZipcode').val().trim(),
	        supplierAddress1: $('#supplierAddress1').val().trim(),
	        supplierAddress2: $('#supplierAddress2').val().trim()
	    };
	
	    // 유효성검사 추가
	    if (!supplierData.supplierName || !supplierData.supplierZipcode || !supplierData.supplierAddress1) {
	        Swal.fire('필수 정보를 입력해주세요.', '', 'warning');
	        return;
	    }
	
	    $.ajax({
	        url: '/admin/systemPreference/supplyCompany/addSupplier', 
	        type: 'POST',
	        contentType: 'application/json',
	        data: JSON.stringify(supplierData),
			dataType: 'json',
	        success: function(newSupplier) {
	            $('#supplierModal').modal('hide');

				// 라디오 버튼 값을 'ALL'로 변경
			    $('input[name="supplierStatus"][value="ALL"]').prop('checked', true);
			
			    // 전체 리스트 다시 로드
			    loadSupplierList('ALL');

	            Swal.fire('공급업체가 등록되었습니다.', '', 'success');
	        },
	        error: function() {
	            Swal.fire('등록 실패', '서버 오류이나 중복 등록 등 확인 필요.', 'error');
	        }
	    });
	});
	
	// 상태별 공급업체 리스트 조회 Ajax 함수
	function loadSupplierList(status) {
	    $.ajax({
	        url: '/admin/systemPreference/supplyCompany/suppliers',
	        type: 'GET',
	        data: { status: status },
	        success: function(response) {
	            const list = response; // 배열 그대로 사용
	            const tbody = $('#supplierTable tbody');
	            tbody.empty();
	
	            if (!list || list.length === 0) {
	                tbody.append('<tr><td colspan="4" class="text-center text-muted">업체가 없습니다.</td></tr>');
	                return;
	            }
	
	            let filteredList = list;
	            if (status === 'HAS_CONTRACT') {
	                filteredList = list.filter(supplier => supplier.hasContract === 1);
	            } else if (status === 'NO_CONTRACT') {
	                filteredList = list.filter(supplier => supplier.hasContract === 0);
	            }
	
	            filteredList.forEach(function(supplier) {
	                const isDeletable = supplier.hasContract === 0;
	                const contractBadge = supplier.hasContract === 1
	                    ? '<span class="badge badge-success">계약중</span>'
	                    : '<span class="badge badge-secondary">미계약</span>';
	
	                const tr = $('<tr></tr>').attr('data-id', supplier.idx);
					tr.append(`<td>${supplier.idx}</td>`);
	                tr.append(`<td>${supplier.supplierName}</td>`);
	                tr.append(`<td>${contractBadge}</td>`);
	                tr.append(`<td><button type="button" class="btn btn-sm btn-info btn-detail" data-id="${supplier.idx}">상세보기</button></td>`);
	                tr.append(`<td><button type="button" class="btn btn-sm btn-danger btn-delete" data-id="${supplier.idx}" ${isDeletable ? '' : 'disabled title="계약이 있어 삭제할 수 없습니다."'}>삭제</button></td>`);
	                tbody.append(tr);
	            });
	        },
	        error: function(xhr, status, error) {
	            console.error('AJAX 오류:', error);
	        }
	    });
	}
	
	// 라디오버튼 클릭 이벤트
	$('input[name="supplierStatus"]').on('change', function() {
	    loadSupplierList($(this).val());
	});
	
		
	//공급업체삭제
	$('#supplierTable').on('click', '.btn-delete', function() {
	    const supplierIdx = $(this).data('id');
	    Swal.fire({
	        title: '정말 삭제하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonText: '삭제',
	        cancelButtonText: '취소'
	    }).then((result) => {
	        if (result.isConfirmed) {
	            $.ajax({
	                url: '/admin/systemPreference/supplyCompany/removeSupplier',
	                type: 'DELETE',
	                contentType: 'application/json',
	                data: JSON.stringify({ idx: supplierIdx }),
	                success: function() {
	                    // 테이블에서 삭제
	                    $(`#supplierTable tr[data-id="${supplierIdx}"]`).remove();
	                    Swal.fire('삭제되었습니다.', '', 'success');
	                },
	                error: function() {
	                    Swal.fire('삭제에 실패했습니다.', '', 'error');
	                }
	            });
	        }
	    });
	});
	
	// 공급업체 상세보기 버튼 클릭 이벤트
	let originalSupplierData = null; //전역변수선언
	$('#supplierTable').on('click', '.btn-detail', function() {
    const supplierIdx = $(this).data('id');
    $.ajax({
        url: '/admin/systemPreference/supplyCompany/supplier/' + supplierIdx,
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            originalSupplierData = data;
            $('#supplierDetailForm #supplierIdx').val(data.idx);
            $('#supplierDetailForm #detailSupplierName').val(data.supplierName);
            $('#supplierDetailForm #detailSupplierManager').val(data.supplierManager);
            $('#supplierDetailForm #detailSupplierManagerPhone').val(data.supplierManagerPhone);
            $('#supplierDetailForm #detailSupplierZipcode').val(data.supplierZipcode);
            $('#supplierDetailForm #detailSupplierAddress1').val(data.supplierAddress1);
            $('#supplierDetailForm #detailSupplierAddress2').val(data.supplierAddress2);

            $('#supplierDetailModal').modal('show');
            setReadonlyMode();
        },
        error: function() {
            Swal.fire('상세 정보 조회 실패', '', 'error');
        }
    });
});

	//수정모달 다음주소찾기
	setupDaumPostcode('#btnDetailSearchAddress', '#detailSupplierZipcode', '#detailSupplierAddress1', '#detailSupplierAddress2');
	
	// 모달창 수정불가
	function setReadonlyMode() {
	    $('#supplierDetailForm input').prop('readonly', true);
		$('#btnDetailSearchAddress').prop('disabled', true);
	    $('.btn-edit').show();
	    $('.btn-save, .btn-cancel-edit').hide();
	}
	
	// 모달창 수정가능
	function setEditMode() {
	    $('#supplierDetailForm input').prop('readonly', false);
		$('#btnDetailSearchAddress').prop('disabled', false);
	    $('.btn-edit').hide();
	    $('.btn-save, .btn-cancel-edit').show();
	}
	
	// 상세보기 > 수정모드 전환
	$('.btn-edit').on('click', function() {
	    setEditMode();
	});
	
	// 수정모드 > 취소(상세보기) 모드 전환
	$('.btn-cancel-edit').on('click', function() {
	    if (originalSupplierData) {
	        $('#supplierDetailForm #supplierIdx').val(originalSupplierData.idx);
	        $('#supplierDetailForm #detailSupplierName').val(originalSupplierData.supplierName);
	        $('#supplierDetailForm #detailSupplierManager').val(originalSupplierData.supplierManager);
	        $('#supplierDetailForm #detailSupplierManagerPhone').val(originalSupplierData.supplierManagerPhone);
	        $('#supplierDetailForm #detailSupplierZipcode').val(originalSupplierData.supplierZipcode);
	        $('#supplierDetailForm #detailSupplierAddress1').val(originalSupplierData.supplierAddress1);
	        $('#supplierDetailForm #detailSupplierAddress2').val(originalSupplierData.supplierAddress2);
	    }
	    setReadonlyMode();
	});
	
	//수정할때 번호입력
	$('#detailSupplierManagerPhone').on('input', function() {
	    let value = $(this).val();
	    // 숫자만 남기기
	    value = value.replace(/[^0-9]/g, '');
	    // 11자리까지만 허용
	    if (value.length > 11) {
	        value = value.slice(0, 11);
	    }
	    // 자동 하이픈 삽입
	    let formatted = '';
	    if (value.length < 4) {
	        formatted = value;
	    } else if (value.length < 8) {
	        formatted = value.slice(0, 3) + '-' + value.slice(3);
	    } else {
	        formatted = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7);
	    }
	    $(this).val(formatted);
	});
	
	
	// 수정완료(저장) 폼 제출 처리
	$('#supplierDetailForm').on('submit', function(e) {
	    e.preventDefault();
	
	    // 폼 데이터 직렬화 또는 JSON 객체 생성 공백제거
	    const updateData = {
		    idx: $('#supplierIdx').val(),
		    supplierName: $('#detailSupplierName').val().trim(),
		    supplierManager: $('#detailSupplierManager').val().trim(),
		    supplierManagerPhone: $('#detailSupplierManagerPhone').val().trim(),
		    supplierZipcode: $('#detailSupplierZipcode').val().trim(),
		    supplierAddress1: $('#detailSupplierAddress1').val().trim(),
		    supplierAddress2: $('#detailSupplierAddress2').val().trim()
		};
	
	    $.ajax({
	        url: '/admin/systemPreference/supplyCompany/modifySupplier',
	        type: 'PUT',
	        contentType: 'application/json',
	        data: JSON.stringify(updateData),
	        success: function() {
	            Swal.fire('수정 완료', '', 'success');
	            setReadonlyMode();
	            $('#supplierDetailModal').modal('hide');
	            // 필요 시 리스트 갱신 호출
	            loadSupplierList();
	        },
	        error: function() {
	            Swal.fire('수정 실패', '서버 오류가 발생했습니다.', 'error');
	        }
	    });
	});






	// 페이지 로딩 시 기본 "전체" 업체 조회
	loadSupplierList('ALL');

	
});//끝






















