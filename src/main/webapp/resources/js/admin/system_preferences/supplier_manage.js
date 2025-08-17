$(function() {
	
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
	$('#btnSearchAddress').click(function() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            // 우편번호
	            $('#supplierZipcode').val(data.zonecode);  // 우편번호 정보 zonecode 필드 사용
	
	            // 주소 (도로명 주소 우선)
	            var addr = data.roadAddress ? data.roadAddress : data.jibunAddress;
	            $('#supplierAddress1').val(addr);
	
	            // 상세주소 입력란 포커스 이동
	            $('#supplierAddress2').focus();
	        }
	    }).open();
	});


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
	        url: '/admin/systemPreference/addSupplier', 
	        type: 'POST',
	        contentType: 'application/json',
	        data: JSON.stringify(supplierData),
			dataType: 'json',
	        success: function(newSupplier) {
	            $('#supplierModal').modal('hide');
	            // 리스트에 새로 추가·갱신(필요시 전체리로드)
	            $('input[name="supplierStatus"][value="ACTIVE"]').prop('checked', true);
	            // 거래중 상태 공급업체 리스트 새로 로드
	            loadSupplierList('ACTIVE');
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
	        url: '/admin/systemPreference/suppliers',
	        type: 'GET',
	        data: { status: 'ALL' }, // 항상 전체 조회
	        success: function(list) {
	            $('#supplierList').empty();
	            if (list.length === 0) {
	                $('#supplierList').append('<li class="list-group-item text-muted">업체가 없습니다.</li>');
	                return;
	            }
	            // 상태별로 필터링
	            let filteredList = list;
	            if (status === 'HAS_CONTRACT') {
	                filteredList = list.filter(function(supplier) { return supplier.hasContract; });
	            } else if (status === 'NO_CONTRACT') {
	                filteredList = list.filter(function(supplier) { return !supplier.hasContract; });
	            }
	            // 나머지 렌더링 로직 동일
	            filteredList.forEach(function(supplier) {
	                var contractBadge = supplier.hasContract
	                    ? '<span class="badge badge-success ml-2">계약중</span>'
	                    : '<span class="badge badge-secondary ml-2">미계약</span>';
	                $('#supplierList').append(
	                    `<li class="list-group-item d-flex justify-content-between align-items-center" data-id="${supplier.idx}" style="color: black;">
	                        <div class="d-flex align-items-center supplier-name-area">
					            <span class="supplier-name-text">${supplier.supplierName}</span>
					            ${contractBadge}
					        </div>
					        <div>
					            <button type="button" class="btn btn-sm btn-info btn-detail" data-id="${supplier.idx}">상세보기</button>
					            <button type="button" class="btn btn-sm btn-danger btn-delete" data-id="${supplier.idx}">삭제</button>
					        </div>
	                    </li>`
	                );
	            });
	        }
	    });
	}
	
	// 라디오버튼 클릭 이벤트
	$('input[name="supplierStatus"]').on('change', function() {
	    loadSupplierList($(this).val());
	});
	
		
	//공급업체삭제
	$('#supplierList').on('click', '.btn-delete', function() {
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
	                url: '/admin/systemPreference/removeSupplier', // 아래 컨트롤러 URL에 맞게!
	                type: 'DELETE',
	                contentType: 'application/json',
	                data: JSON.stringify({ idx: supplierIdx }),
	                success: function() {
	                    // 리스트에서 삭제
	                    $(`li[data-id="${supplierIdx}"]`).remove();
	                    Swal.fire('삭제되었습니다.', '', 'success');
	                },
	                error: function() {
	                    Swal.fire('삭제에 실패했습니다.', '', 'error');
	                }
	            });
	        }
	    });
	});

	// 페이지 로딩 시 기본 "전체" 업체 조회
	loadSupplierList('ALL');

	
});//끝






















