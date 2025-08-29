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
		const modal = document.getElementById('supplierModal');
        ModalManager.openModal(modal);
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
	            const modal = document.getElementById('supplierModal');
				ModalManager.closeModal(modal);

	            Swal.fire('공급업체가 등록되었습니다.', '', 'success').then(() => {
            	window.location.reload();
				});
	        },
	        error: function() {
	            Swal.fire('등록 실패', '서버 오류이나 중복 등록 등 확인 필요.', 'error');
	        }
	    });
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
	$('.supplier-row').each(function() {
		$(this).on('click', function(){
			const supplierIdx = $(this).data('supplieridx')
			
			$.ajax({
	    	    url: '/admin/systemPreference/supplyCompany/supplier/' + supplierIdx,
		        type: 'GET',
		        dataType: 'json',
		        success: function(data) {
		            originalSupplierData = data;
		            $('#supplierDetailForm #supplierIdx').val(data.supplierIdx);
		            $('#supplierDetailForm #detailSupplierName').val(data.supplierName);
		            $('#supplierDetailForm #detailSupplierManager').val(data.supplierManager);
		            $('#supplierDetailForm #detailSupplierManagerPhone').val(data.supplierManagerPhone);
		            $('#supplierDetailForm #detailSupplierZipcode').val(data.supplierZipcode);
		            $('#supplierDetailForm #detailSupplierAddress1').val(data.supplierAddress1);
		            $('#supplierDetailForm #detailSupplierAddress2').val(data.supplierAddress2);
		            $('#supplierDetailForm #detailSupplierStatus').val(data.status);
		
		            const detailModal = document.getElementById('supplierDetailModal');
					ModalManager.openModal(detailModal);
		            setReadonlyMode();
		        },
		        error: function() {
		            Swal.fire('상세 정보 조회 실패', '', 'error');
		        }
	   		});
		});	
	});
	

	//수정모달 다음주소찾기
	setupDaumPostcode('#btnDetailSearchAddress', '#detailSupplierZipcode', '#detailSupplierAddress1', '#detailSupplierAddress2');
	
	// 모달창 수정불가
	function setReadonlyMode() {
	    $('#supplierDetailForm input').prop('readonly', true);
		$('#btnDetailSearchAddress').prop('disabled', true);
		$('#detailSupplierStatus').prop('disabled', true);
	    $('.btn-edit').show();
	    $('.btn-save, .btn-cancel-edit').hide();
	}
	
	// 모달창 수정가능
	function setEditMode() {
	    $('#supplierDetailForm input').prop('readonly', false);
		$('#btnDetailSearchAddress').prop('disabled', false);
		$('#detailSupplierStatus').prop('disabled', false);
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
	        $('#supplierDetailForm #supplierIdx').val(originalSupplierData.supplierIdx);
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
		    supplierIdx: $('#supplierIdx').val(),
		    supplierName: $('#detailSupplierName').val().trim(),
		    supplierManager: $('#detailSupplierManager').val().trim(),
		    supplierManagerPhone: $('#detailSupplierManagerPhone').val().trim(),
		    supplierZipcode: $('#detailSupplierZipcode').val().trim(),
		    supplierAddress1: $('#detailSupplierAddress1').val().trim(),
		    supplierAddress2: $('#detailSupplierAddress2').val().trim(),
			status: $('#detailSupplierStatus').val().trim()
		};
	
	    $.ajax({
	        url: '/admin/systemPreference/supplyCompany/modifySupplier',
	        type: 'PUT',
	        contentType: 'application/json',
	        data: JSON.stringify(updateData),
	        success: function() {
	            Swal.fire('수정 완료', '', 'success').then( () => {
	            setReadonlyMode();
	            const detailModal = document.getElementById('supplierDetailModal');
				ModalManager.closeModal(detailModal);
				location.href = '/admin/systemPreference/supplyCompany'
				});
	        },
	        error: function() {
	            Swal.fire('수정 실패', '서버 오류가 발생했습니다.', 'error');
	        }
	    });
	});


	
});//끝






















