$(function() {
	
	//다음 주소찾기 api 함수
	function setupDaumPostcode(buttonSelector, zipcodeSelector, addr1Selector, addr2Selector
	, bcodeSelector, sidoSelector, sigunguSelector, dongSelector ) {
	    $(buttonSelector).click(function() {
	        new daum.Postcode({
	            oncomplete: function(data) {
					$(bcodeSelector).val(data.bcode);
					$(sidoSelector).val(data.sido);
					$(sigunguSelector).val(data.sigungu);
					$(dongSelector).val(data.bname);
	                $(zipcodeSelector).val(data.zonecode);
	                var addr = data.roadAddress ? data.roadAddress : data.jibunAddress;
	                $(addr1Selector).val(addr);
	                $(addr2Selector).focus();
	            }
	        }).open();
	    });
	}
	
	
    // 공급업체 등록 모달 열기
    $('#btnAddFranchise').click(function() {
        $('#addFranchiseForm')[0].reset();
		const modal = document.getElementById('addFranchiseModal');
        ModalManager.openModal(modal);
    });
	
	//핸드폰번호입력
	$('#addFranchisePhone').on('input', function() {
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
    $('#addFranchisePhone').attr('maxlength', 13); // 010-1234-5678 (13글자)

	setupDaumPostcode('#btnSearchAddress', '#addFranchiseZipcode', '#addFranchiseAddress1', '#addFranchiseAddress2'
	, '#addFranchiseBcode', '#addFranchiseSido', '#addFranchiseSigungu', '#addFranchiseDong' );
	


    // 공급업체 등록 폼 제출
    $('#addFranchiseForm').on('submit', function(e) {
	    e.preventDefault();
		
		//공백제거
	    const franchiseData = {
	        franchiseName: $('#addFranchiseName').val().trim(),
	        franchiseManagerName: $('#addFranchiseManagerName').val().trim(),
	        franchisePhone: $('#addFranchisePhone').val().trim(),
	        franchiseZipcode: $('#addFranchiseZipcode').val().trim(),
	        franchiseAddress1: $('#addFranchiseAddress1').val().trim(),
	        franchiseAddress2: $('#addFranchiseAddress2').val().trim(),
	        administrativeRegion:{
				bcode: $('#addFranchiseBcode').val().trim(),
		        sido: $('#addFranchiseSido').val().trim(),
		        sigungu: $('#addFranchiseSigungu').val().trim(),
		        dong: $('#addFranchiseDong').val().trim()
			}
	    };
		console.log(franchiseData);
		console.log($('#addFranchiseName').val().trim());
	
	    // 유효성검사 추가
	    if (!franchiseData.franchiseName || !franchiseData.franchiseManagerName || !franchiseData.franchisePhone ||
			!franchiseData.franchiseZipcode || !franchiseData.franchiseAddress1 || !franchiseData.franchiseAddress2) {
	        Swal.fire('필수 정보를 입력해주세요.', '', 'warning');
	        return;
	    }
	
	    $.ajax({
	        url: '/admin/systemPreference/franchise/addFranchise', 
	        type: 'POST',
	        contentType: 'application/json',
	        data: JSON.stringify(franchiseData),
			dataType: 'json',
	        success: function(newfranchise) {
	            const modal = document.getElementById('addFranchiseModal');
				ModalManager.closeModal(modal);

	            Swal.fire('지점이 등록되었습니다.', '', 'success').then(() => {
            		window.location.reload();
				});
	        },
	        error: function() {
	            Swal.fire('등록 실패', '서버 오류이나 중복 등록 등 확인 필요.', 'error');
	        }
	    });
	});
	
	// 공급업체 상세보기 버튼 클릭 이벤트
	let originalFranchiseData = null; //전역변수선언
	$('.franchise-row').each(function() {
		$(this).on('click', function(){
			const franchiseIdx = $(this).data('franchise-idx')
			
			$.ajax({
	    	    url: '/admin/systemPreference/franchise/' + franchiseIdx,
		        type: 'GET',
		        dataType: 'json',
		        success: function(data) {
					console.log(data);
		            originalFranchiseData = data;
		            $('#franchiseDetailForm #franchiseDetailIdx').val(data.franchiseIdx);
		            $('#franchiseDetailForm #detailFranchiseName').val(data.franchiseName);
		            $('#franchiseDetailForm #detailFranchiseManager').val(data.franchiseManagerName);
		            $('#franchiseDetailForm #detailFranchisePhone').val(data.franchisePhone);
		            $('#franchiseDetailForm #detailFranchiseZipcode').val(data.franchiseZipcode);
		            $('#franchiseDetailForm #detailFranchiseAddress1').val(data.franchiseAddress1);
		            $('#franchiseDetailForm #detailFranchiseAddress2').val(data.franchiseAddress2);
		            $('#franchiseDetailForm #detailFranchiseBcode').val(data.administrativeRegion.bcode);
		            $('#franchiseDetailForm #detailFranchiseSido').val(data.administrativeRegion.sido);
		            $('#franchiseDetailForm #detailFranchiseSigungu').val(data.administrativeRegion.sigungu);
		            $('#franchiseDetailForm #detailFranchiseDong').val(data.administrativeRegion.dong);
		            $('#franchiseDetailForm #detailFranchiseStatus').val(data.status);
		
		            const detailModal = document.getElementById('franchiseDetailModal');
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
	setupDaumPostcode('#btnDetailSearchAddress', '#detailFranchiseZipcode', '#detailFranchiseAddress1', '#detailFranchiseAddress2'
		, '#detailFranchiseBcode', '#detailFranchiseSido', '#detailFranchiseSigungu', '#detailFranchiseDong');
	
	// 모달창 수정불가
	function setReadonlyMode() {
	    $('#franchiseDetailForm input').prop('readonly', true);
		$('#btnDetailSearchAddress').prop('disabled', true);
		$('#detailFranchiseStatus').prop('disabled', true);
	    $('.btn-edit').show();
	    $('.btn-save, .btn-cancel-edit').hide();
	}
	
	// 모달창 수정가능
	function setEditMode() {
	    $('#franchiseDetailForm input').prop('readonly', false);
		$('#btnDetailSearchAddress').prop('disabled', false);
		$('#detailFranchiseStatus').prop('disabled', false);
	    $('.btn-edit').hide();
	    $('.btn-save, .btn-cancel-edit').show();
	}
	
	// 상세보기 > 수정모드 전환
	$('#franchiseDetailForm').on('click', '.btn-edit',function() {
	    setEditMode();
	});
	
	// 수정모드 > 취소(상세보기) 모드 전환
	$('.btn-cancel-edit').on('click', function() {
	    if (originalFranchiseData) {
	        $('#franchiseDetailForm #franchiseDetailIdx').val(originalFranchiseData.franchiseIdx);
            $('#franchiseDetailForm #detailFranchiseName').val(originalFranchiseData.franchiseName);
            $('#franchiseDetailForm #detailFranchiseManager').val(originalFranchiseData.franchiseManagerName);
            $('#franchiseDetailForm #detailFranchisePhone').val(originalFranchiseData.franchisePhone);
            $('#franchiseDetailForm #detailFranchiseZipcode').val(originalFranchiseData.franchiseZipcode);
            $('#franchiseDetailForm #detailFranchiseAddress1').val(originalFranchiseData.franchiseAddress1);
            $('#franchiseDetailForm #detailFranchiseAddress2').val(originalFranchiseData.franchiseAddress2);
            $('#franchiseDetailForm #detailFranchiseBcode').val(originalFranchiseData.administrativeRegion.bcode);
            $('#franchiseDetailForm #detailFranchiseSido').val(originalFranchiseData.administrativeRegion.sido);
            $('#franchiseDetailForm #detailFranchiseSigungu').val(originalFranchiseData.administrativeRegion.sigungu);
            $('#franchiseDetailForm #detailFranchiseDong').val(originalFranchiseData.administrativeRegion.dong);
            $('#franchiseDetailForm #detailFranchiseStatus').val(originalFranchiseData.status);
	    }
	    setReadonlyMode();
	});
	
	//수정할때 번호입력
	$('#detailFranchisePhone').on('input', function() {
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
	$('#franchiseDetailForm').on('submit', function(e) {
	    e.preventDefault();
	    // 폼 데이터 직렬화 또는 JSON 객체 생성 공백제거
	    const updateData = {
		    franchiseIdx: $('#franchiseDetailForm #franchiseDetailIdx').val(),
		    franchiseName: $('#franchiseDetailForm #detailFranchiseName').val().trim(),
		    franchiseManagerName: $('#franchiseDetailForm #detailFranchiseManager').val().trim(),
		    franchisePhone: $('#franchiseDetailForm #detailFranchisePhone').val().trim(),
		    franchiseZipcode: $('#franchiseDetailForm #detailFranchiseZipcode').val().trim(),
		    franchiseAddress1: $('#franchiseDetailForm #detailFranchiseAddress1').val().trim(),
		    franchiseAddress2: $('#franchiseDetailForm #detailFranchiseAddress2').val().trim(),
			status: $('#franchiseDetailForm #detailFranchiseStatus').val().trim(),
			administrativeRegion: {
			    bcode: $('#franchiseDetailForm #detailFranchiseBcode').val().trim(),
			    sido: $('#franchiseDetailForm #detailFranchiseSido').val().trim(),
			    sigungu: $('#franchiseDetailForm #detailFranchiseSigungu').val().trim(),
			    dong: $('#franchiseDetailForm #detailFranchiseDong').val().trim()
			}
				
		};
	
	    $.ajax({
	        url: '/admin/systemPreference/franchise/modifyFranchise',
	        type: 'PUT',
	        contentType: 'application/json',
	        data: JSON.stringify(updateData),
	        success: function(reslult) {
				console.log(reslult);
	            Swal.fire('수정 완료', '', 'success').then( () => {
	            setReadonlyMode();
//	            const detailModal = document.getElementById('franchiseDetailModal');
//				ModalManager.closeModal(detailModal);
				location.href = '/admin/systemPreference/franchise'
				});
	        },
	        error: function() {
	            Swal.fire({
					title: '실패',
					html: '잠시후 다시시도 하십시오.',
					icon: 'error'
				});
	        }
	    });
	});


	
});//끝






















