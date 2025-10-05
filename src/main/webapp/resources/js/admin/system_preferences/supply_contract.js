// supply_contract.js

let originalContractData = {};
let currentContractIdx = 0;
let allSupplierList = [];
let allProductList = [];

$(function(){
	//공급상품 셀렉트박스 목록채우기
	loadProductlist().then(() =>{
		$("")
		$(".productSelectList").html('<option value="">상품</option>');
		$(allProductList).each(function(index, product){
			$('.productSelectList').append(`
			<option value="${product.productIdx}">${product.productName}</option>`
			);
		});
	});
	// 공급업체 셀렉트박스 목록채우기
	loadSupplierlist().then(() =>{
		$("")
		$(".supplierSelectList").html('<option value="">공급업체</option>');
		$(allSupplierList).each(function(index, supplier){
			$('.supplierSelectList').append(`
			<option value="${supplier.supplierIdx}">${supplier.supplierName}</option>`
			);
		});
	});
	
	// 상품검색 모달열기 계약추가모달
	$("#contractAddForm").on('click', '.searchProduct', function(e) {
		e.preventDefault();
		const searchProductModal = document.getElementById('searchProduct');
		$("#productSearch").val('');
		ModalManager.openModal(searchProductModal);
	});
	
	// 상품검색 모달열기 계약상세모달
	$("#contractDetailForm").on('click', '.searchProduct', function(e) {
		e.preventDefault();
		const searchProductModal = document.getElementById('searchProduct');
		$("#productSearch").val('');
		ModalManager.openModal(searchProductModal);
	});
	
	//상품 검색 모달 검색창입력이벤트
	$("#productSearch").on('input', '' , function() {
        var inputVal = $(this).val().trim();
        var filtered = [];

        // 입력값이 없으면 결과 비우기
        if (inputVal === '') {
            $("#searchProductList").empty();
            return;
        }

        // 포함되는 productName 필터링
        filtered = allProductList.filter(function(item) {
            return item.productName.indexOf(inputVal) !== -1;
        });

        // 상품검색결과 표시용 HTML 생성
        var html = '';
        if (filtered.length > 0) {
            filtered.forEach(function(item) {
                html += '<tr data-productidx="' + item.productIdx + '">'
						+ '<td>' + item.productName + '</td>' 
						+ '</tr>';
            });
        } else {
            html = '<div>검색 결과가 없습니다.</div>';
        }

        $("#searchProductList").html(html);
    });

	// 상품 검색해서 나온 목록선택 이벤트 
	$("#searchProductList").on('click', 'tr', function() {
	    // 클릭된 <tr> 요소
	    var productIdx = $(this).data('productidx');  // data-supplieridx 값 가져오기
	    var productName = $(this).find('td').text();  // 해당 행의 공급업체 이름 가져오기

	    $("#addContractProductSelect").val(productIdx);
	    $("#detailContractProductSelect").val(productIdx);
	    
	    // 검색 결과 영역 비우기
	    $("#searchProductList").empty();
		const searchProductModal = document.getElementById('searchProduct');
		ModalManager.closeModal(searchProductModal);
	});
	
	// 공급처검색 모달열기
	$("#contractAddForm").on('click', '.searchSupplier', function(e) {
		e.preventDefault();
		const searchSupplierModal = document.getElementById('searchSupplier');
		$("#supplierSearch").val('');
		ModalManager.openModal(searchSupplierModal);
	});
	
	// 공급처검색 모달열기
	$("#contractDetailForm").on('click', '.searchSupplier', function(e) {
		e.preventDefault();
		const searchSupplierModal = document.getElementById('searchSupplier');
		$("#supplierSearch").val('');
		ModalManager.openModal(searchSupplierModal);
	});
	//공급처 검색 모달 검색창입력이벤트
	$("#supplierSearch").on('input', '' , function() {
        var inputVal = $(this).val().trim();
        var filtered = [];

        // 입력값이 없으면 결과 비우기
        if (inputVal === '') {
            $("#searchSupplierList").empty();
            return;
        }

        // 포함되는 supplierName 필터링 (대소문자 구분 없이 하려면 toLowerCase 사용)
        filtered = allSupplierList.filter(function(item) {
            return item.supplierName.indexOf(inputVal) !== -1;
        });

        // 공급처검색결과 표시용 HTML 생성
        var html = '';
        if (filtered.length > 0) {
            filtered.forEach(function(item) {
                html += '<tr data-supplieridx="' + item.supplierIdx + '">'
						+ '<td>' + item.supplierName + '</td>' 
						+ '</tr>';
            });
        } else {
            html = '<div>검색 결과가 없습니다.</div>';
        }

        $("#searchSupplierList").html(html);
    });

	// 공급처 검색해서 나온 목록선택 이벤트 
	$("#searchSupplierList").on('click', 'tr', function() {
	    // 클릭된 <tr> 요소
	    var supplierIdx = $(this).data('supplieridx');  // data-supplieridx 값 가져오기
	    var supplierName = $(this).find('td').text();  // 해당 행의 공급업체 이름 가져오기
	
	
	    // 원하는 동작 추가 예:
	    // 예를 들면, input 박스에 선택된 공급업체 이름 넣기
	    $("#addContractSupplierSelect").val(supplierIdx);
	    $("#detailContractSupplierSelect").val(supplierIdx);
	    
	    // 검색 결과 영역 비우기 (필요 시)
	    $("#searchSupplierList").empty();

		const searchSupplierModal = document.getElementById('searchSupplier');
		ModalManager.closeModal(searchSupplierModal);
		
	});
	
	// 시작일을 변경하면 종료일의 최소 날짜(min)를 시작일로 설정
	$("#contractStart").on('change', function() {
	    $("#contractEnd").attr('min', this.value);
	});
	
	// 종료일을 변경하면 시작일의 최대 날짜(max)를 종료일로 설정
	$("#contractEnd").on('change', function() {
	    $("#contractStart").attr('max', this.value);
	});
	
	
	//밀리초 날짜변환
    function formatDateFromMillis(millis) {
        if (!millis) return '';
        const date = new Date(Number(millis));
        const yyyy = date.getFullYear();
        const mm = String(date.getMonth() + 1).padStart(2, '0');
        const dd = String(date.getDate()).padStart(2, '0');
        return `${yyyy}-${mm}-${dd}`;
    }

	// 상품목록 불러오기
    function loadProductlist() {
       return $.ajax({
            url: '/admin/systemPreference/product/getProductList',
            type: 'GET',
            dataType: 'json',
            success: function(productList) {
				allProductList = productList;
            },
            error: function() {
                Swal.fire('상품목록 불러오기 실패!', '', 'error');
            }
        });
    }

	//공급업체 목록 불러오기
    function loadSupplierlist() {
        return $.ajax({
            url: '/admin/systemPreference/supplyCompany/suppliers',
            type: 'GET',
            dataType: 'json',
            success: function(supplierList) {
				allSupplierList = supplierList;
            },
            error: function() {
                Swal.fire('공급처목록 불러오기 실패!', '', 'error');
            }
        });
    }

	

	//상세보기모달열기
    function openContractDetailModal(contractIdx) {
        currentContractIdx = contractIdx;
        const detailModal = document.getElementById('contractDetailModal');
        ModalManager.openModal(detailModal);

        $('#contractDetailForm input, #contractDetailForm textarea').prop('readonly', true);
        $('#detailStatus, #detailContractSupplierSelect, #detailContractProductSelect').prop('disabled', true);
        $('#btnEditContractDetail, #btnDeleteContractDetail').show();
        $('#btnSaveContractDetail, #btnCancelEditDetail, #detailContractSupplierSearch, #detailContractProductSearch').hide();

        // 초기 데이터 비우기
        $('#detailSupplier, #detailProduct, #detailContractPrice, #detailContractStart, #detailContractEnd, #detailMinOrderQuantity, #detailMaxOrderQuantity, #contractDetailNote').val('');
        $('#contractDetailProductImagePreview').attr('src', '');

        // 로드 데이터
        $.ajax({
            url: '/admin/systemPreference/supplyContract/getContractDetail',
            type: 'GET',
            data: { supplyContractIdx: contractIdx },
            dataType: 'json',
            success: function(data) {
                if (!data) return;
                $('#detailContractSupplierSelect').val(data.supplier.supplierIdx);
                $('#detailContractProductSelect').val(data.product.productIdx);
                $('#detailContractPrice').val(data.contractPrice);
                $('#detailContractStart').val(formatDateFromMillis(data.contractStart));
                $('#detailContractEnd').val(formatDateFromMillis(data.contractEnd));
                $('#detailMinOrderQuantity').val(data.minOrderQuantity);
                $('#detailMaxOrderQuantity').val(data.maxOrderQuantity);
                $('#detailStatus').val(data.status);
                $('#contractDetailNote').val(data.note);
                let imgSrc = '/images/no-image.png';
                if (data.file) imgSrc = '/file/thumbnail/' + data.file.fileIdx + '?_=' + Date.now();
                else if (data.product.productIdx) imgSrc = '/resources/images/default_product.jpg';
                $('#contractDetailProductImagePreview').attr('src', imgSrc);
                originalContractData = {
                    contractPrice: data.contractPrice,
                    contractStart: formatDateFromMillis(data.contractStart),
                    contractEnd: formatDateFromMillis(data.contractEnd),
                    minOrderQuantity: data.minOrderQuantity,
                    maxOrderQuantity: data.maxOrderQuantity,
                    status: data.status,
                    note: data.note
                };
            },
            error: function() {
                Swal.fire('오류', '상세 정보를 불러오는 데 실패했습니다.', 'error');
            }
        });
    }

    // 이벤트 바인딩

    // 추가 모달 열기
    $(document).on('click', '#btnAddContract', function() {
        $('#contractAddForm')[0].reset();
        const addModal = document.getElementById('contractAddModal');
        ModalManager.openModal(addModal);
    });

    // 추가 저장
    $('#btnSaveContract').on('click', function() {
        const $form = $('#contractAddForm');
        if (!$form[0].checkValidity()) {
            $form.reportValidity();
            return;
        }
        const formData = $form.serialize();
        $.ajax({
            url: '/admin/systemPreference/supplyContract/addContract',
            type: 'POST',
            data: formData,
            success: function() {
                Swal.fire('등록 완료', '공급계약이 정상 등록되었습니다.', 'success').then(()=>{
	                const addModal = document.getElementById('contractAddModal');
	                ModalManager.closeModal(addModal);
	                window.location.reload();
				});
            },
            error: function(xhr) {
                let msg = '등록 중 오류가 발생했습니다.';
                if (xhr.responseText) msg = xhr.responseText;
                Swal.fire('오류', msg, 'error');
            }
        });
    });

    // 상세보기 열기
    $('#contractTable tbody').on('click', 'tr', function() {
        const contractIdx = $(this).closest('tr').data('contract-idx');
        openContractDetailModal(contractIdx);
    });

    // 수정
    $('#btnEditContractDetail').on('click', function() {
        $('#detailContractPrice, #detailContractStart, #detailContractEnd, #detailMinOrderQuantity, #detailMaxOrderQuantity, #contractDetailNote').prop('readonly', false);
        $('#detailContractSupplierSelect, #detailContractProductSelect' ).prop('disabled', false);
		$('#detailStatus').prop('disabled', false);
        $('#btnSaveContractDetail, #btnCancelEditDetail, #detailContractProductSearch, #detailContractSupplierSearch').show();
        $('#btnEditContractDetail, #btnDeleteContractDetail').hide();
        $('#detailContractPrice, #detailMinOrderQuantity, #detailMaxOrderQuantity').off('input').on('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    });

    // 취소
    $('#btnCancelEditDetail').on('click', function() {
        $('#detailContractPrice').val(originalContractData.contractPrice);
        $('#detailContractStart').val(originalContractData.contractStart);
        $('#detailContractEnd').val(originalContractData.contractEnd);
        $('#detailMinOrderQuantity').val(originalContractData.minOrderQuantity);
        $('#detailMaxOrderQuantity').val(originalContractData.maxOrderQuantity);
        $('#detailStatus').val(originalContractData.status);
        $('#contractDetailNote').val(originalContractData.note);
        $('#detailContractPrice, #detailContractStart, #detailContractEnd, #detailMinOrderQuantity, #detailMaxOrderQuantity, #contractDetailNote').prop('readonly', true);
        $('#detailContractSupplierSelect, #detailContractProductSelect' ).prop('disabled', true);
		$('#detailStatus').prop('disabled', true);
        $('#btnSaveContractDetail, #btnCancelEditDetail, #detailContractProductSearch, #detailContractSupplierSearch').hide();
        $('#btnEditContractDetail, #btnDeleteContractDetail').show();
    });

    // 저장
    $('#btnSaveContractDetail').on('click', function() {
        const dataToSave = {
			supplierIdx:$('#detailContractSupplierSelect').val(),
			productIdx:$('#detailContractProductSelect').val(),
            contractPrice: $('#detailContractPrice').val(),
            contractStart: $('#detailContractStart').val(),
            contractEnd: $('#detailContractEnd').val(),
            minOrderQuantity: $('#detailMinOrderQuantity').val(),
            maxOrderQuantity: $('#detailMaxOrderQuantity').val(),
            status: $('#detailStatus').val(),
            note: $('#contractDetailNote').val(),
            supplyContractIdx: currentContractIdx
        };
        if (!dataToSave.contractPrice || !dataToSave.contractStart || !dataToSave.contractEnd) {
            Swal.fire('경고', '필수 입력 항목을 모두 입력하세요.', 'warning');
            return;
        }
        ajaxPost('/admin/systemPreference/supplyContract/updateContractDetail',
			dataToSave
		).then(function() {
            Swal.fire('성공', '계약 정보가 저장되었습니다.', 'success').then(()=>{
                const detailModal = document.getElementById('contractDetailModal');
                ModalManager.closeModal(detailModal);
				window.location.reload();

			});
        }).catch(function() {
            Swal.fire('오류', '저장 중 오류가 발생했습니다.', 'error');
        });
    });

    // 삭제
    $('#btnDeleteContractDetail').on('click', function() {
        Swal.fire({
            title: '정말 삭제하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                const dataToDelete = { supplyContractIdx: currentContractIdx, status: '삭제' };
                ajaxPost('/admin/systemPreference/supplyContract/deleteContractDetail',
                    dataToDelete
				).then(function(response) {
                        Swal.fire(response.title, response.msg, response.result).then(()=>{
	
                        const detailModal = document.getElementById('contractDetailModal');
						window.location.reload();
                        ModalManager.closeModal(detailModal);
						})
                    }).catch(function() {
                        Swal.fire('오류', '삭제 중 오류가 발생했습니다.', 'error');
                });
            }
        });
    });

    // 모달 닫기 (취소 버튼)
    $('.btn-secondary[data-dismiss="modal"]').on('click', function() {
        const modalId = $(this).closest('.modal').attr('id');
        const modal = document.getElementById(modalId);
        ModalManager.closeModal(modal);
    });
	
	
});

//파라미터값받아오기
function getUrlParameter(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

// 정렬버튼 클릭 함수
function allineTable(thElement) {
	// 지금 누른 orderKey 받아오기	
    const key = thElement.getAttribute('data-key');
	
	//현재 orderKey, orderMethod 
	let currentOrderMethod = getUrlParameter('orderMethod') || 'asc';
    let currentOrderKey = getUrlParameter('orderKey');
	// 새 orderMethod
    let newOrderMethod = 'asc';
    // 지금 누른 오더키가 원래의 오더키 일때 
	if (currentOrderKey === key) {
		// 새 오더메서드 방법 변경
        newOrderMethod = (currentOrderMethod === 'asc') ? 'desc' : 'asc';
    }
	//현재 검색 타입, 검색어 존재하면 유지 없으면 널스트링
	const searchType = getUrlParameter('searchType') || '';
    const searchKeyword = getUrlParameter('searchKeyword') || '';
	const filterStatus = getUrlParameter('filterStatus') || '';
	//요청할 url 조합
	let url = `${window.location.pathname}?orderKey=${key}&orderMethod=${newOrderMethod}`;
    	if(searchType) url += `&searchType=${encodeURIComponent(searchType)}`;
    	if(searchKeyword) url += `&searchKeyword=${encodeURIComponent(searchKeyword)}`;
		if(filterStatus) url += `&filterStatus=${encodeURIComponent(filterStatus)}`;
	// 이동요청
	window.location.href = url;
}