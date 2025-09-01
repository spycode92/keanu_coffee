//전역변수선언
let allCategories = [];
$(function () {
	//dom로드후 loadCategoryList() 실행
	// allCategories 에 카테고리 정보 입력, 검색창의 카테고리항목 채우기
	loadCategoryList().then(()=>{
		// 상위 카테고리에 카테고리 값집어넣기
		$('.categories').html('<option value="">카테고리</option>');
		$(allCategories).each(function(index, category){
			$('.categories').append(`
			<option value="${category.commonCodeIdx}">${category.commonCodeName}</option>`
			);
		})
	});
	
	// 상위 카테고리 리스트 불러오기 및 셀렉트박스 렌더링
    function loadCategoryList() {
        return $.ajax({
            url: '/admin/systemPreference/product/categories',
            method: 'GET',
            dataType: 'json',
            success: function(categoryList) {
				allCategories = categoryList;
            },
            error: function() {
                Swal.fire('상위 카테고리 목록 불러오기 실패', '', 'error');
            }
        });
    }
	
	
    // 상품 추가 모달 열기
    $('#btnAddProduct').click(function () {
        $('#productAddForm')[0].reset();
        $('#productImagePreview').hide().attr('src', '#');
        const addModal = document.getElementById('productAddModal');
        ModalManager.openModal(addModal);
    });
	
	
	// 새 카테고리 추가 모달 열기
    $('#btnAddCategory').click(function () {
        $('#addCategoryForm')[0].reset();
        const addCatModal = document.getElementById('addCategoryModal');
        ModalManager.openModal(addCatModal);
    });
	
	//카테고리추가버튼기능
	$('#addCategoryForm').on('submit', function (e) {
	    e.preventDefault();
	
        categoryName = $('#newCategoryName').val().trim();
	
	    if(!categoryName) {
	        Swal.fire('카테고리명을 입력해주세요.', '', 'warning');
	        return;
	    }
	
	    ajaxPost('/admin/systemPreference/product/addCategory',
			{ commonCodeName: categoryName }
		).then(function (res) {
			let msg = "카테고리 추가 성공";
			let result ="success"
			if(res.responseJSON){
				msg = res.responseJSON.message || msg;
				result = res.responseJSON.result || result;
			}
			loadCategoryList().then(()=>{
				// 상위 카테고리에 카테고리 값집어넣기
				$('.categories').html('<option value="">전체</option>');
				$(allCategories).each(function(index, category){
					$('.categories').append(`
					<option value="${category.commonCodeIdx}">${category.commonCodeName}</option>`
					);
				})
			})
            Swal.fire(msg, '', result);
            const addCatModal = document.getElementById('addCategoryModal');
			ModalManager.closeModal(addCatModal);
            // 성공 후 전체 카테고리 목록을 다시 불러와서 화면 동기화
        }).catch(function (res) {
	            let msg = "알 수 없는 오류가 발생했습니다.";
		        let result = "error";
		        if (res.responseJSON) {
		            msg = res.responseJSON.message || msg;
		            result = res.responseJSON.result || result;
		        }
		        Swal.fire(msg, '', result);
	    });
	});
	
	//카테고리 관리 모달 열기
	$('#btnCategoryManage').click(function () {
	    const manageModal = document.getElementById('categoryManageModal');
        ModalManager.openModal(manageModal);
	    renderCategoryListInModal();
	});
	
	//카테고리수정삭제모달 카테고리정보 주입
	function renderCategoryListInModal() {
		$('#categoryListInModal').empty();
	    $(allCategories).each(function(index, category){
			$('#categoryListInModal').append(`
			<tr data-idx="${category.commonCodeIdx}">
				<td style="width:75%;">${category.commonCodeName}</td>
				<td>
					<button class="btn btn-sm btn-outline-primary editBtn ml-2" data-idx="${category.commonCodeIdx}">수정</button>
				</td>
				<td>
			        <button class="btn btn-sm btn-outline-danger deleteBtn ml-1" data-idx="${category.commonCodeidx}">삭제</button>
				</td>
			</tr>`
			);
		})
	}
	
	//카테고리수정
	$('#categoryListInModal').off('click', '.editBtn').on('click', '.editBtn', function () {
	    const $tr = $(this).closest('tr');
	    const categoryIdx = $(this).data('idx');
	    const originalName = $tr.find('td:first').text().trim();
	
		const newName = prompt("카테고리명을 입력하세요.", originalName);
		
		// 취소하거나 빈값이면 종료
	    if (newName === null) return;
	    if (!newName.trim()) {
	        Swal.fire('카테고리명을 입력해주세요.', '', 'warning');
	        return;
	    }	    
	
        ajaxPost('/admin/systemPreference/product/modifyCategory',
           { commonCodeIdx:categoryIdx, commonCodeName:newName }
		).then(function () {
                Swal.fire('성공', '카테고리명이 수정되었습니다.', 'success');
				loadCategoryList().then(()=>{
	                renderCategoryListInModal();
				});
            }).catch(function () {
                Swal.fire('실패', '수정 중 오류가 발생했습니다.', 'error');
                loadCategoryList().then(()=>{
	                renderCategoryListInModal();
				});
        });

	});
	
	// 삭제 버튼 클릭 이벤트
	$('#categoryListInModal').off('click', '.deleteBtn').on('click', '.deleteBtn', function () {
	    const $tr = $(this).closest('tr');
		const categoryIdx = $tr.data('idx');
		Swal.fire({
	        title: '정말 삭제하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonText: '삭제',
	        cancelButtonText: '취소'
	    }).then((result) => {
	        if (result.isConfirmed) {
				ajaxPost(`/admin/systemPreference/product/removeCategory`,
	                { commonCodeIdx: categoryIdx }
				).then(function (event) {
						console.log(event.responseText);
	                    Swal.fire(event.responseText, '카테고리가 삭제되었습니다.', 'success');
	                    loadCategoryList().then(()=>{
			                renderCategoryListInModal();
						}); // 삭제 후 리스트 다시 로드
	                }).catch(function (xhr) {
	                    if (xhr.status === 409) {
				            Swal.fire('삭제 실패', xhr.responseText, 'warning');
				        } else {
				            Swal.fire('삭제 실패', '서버 오류가 발생했습니다.', 'error');
				        }
	            });
	        }
	    });
	});
	
	//이미지미리보기
	$('#productImage').on('change', function (e) {
	    const file = e.target.files[0];
	    const $preview = $('#productImagePreview');
	    if (file) {
	        // 파일 확장자 및 사이즈 검사 필요시 추가!
	        const reader = new FileReader();
	        reader.onload = function (evt) {
	            $preview.attr('src', evt.target.result);
	            $preview.show();
	        };
	        reader.readAsDataURL(file);
	    } else {
	        $preview.hide().attr('src', '#');
	    }
	});
	
	

	
	
	//상품추가
	$('#productAddForm').off('submit').on('submit', function (e) {
	    e.preventDefault();
	
	    // (필수 검증 추가 가능)
	    if (!$('#productName').val().trim()) {
	        Swal.fire('상품명을 입력하세요.', '', 'warning');
	        return;
	    }
	    if (!$('#addProductCategory').val()) {
	        Swal.fire('카테고리를 선택하세요.', '', 'warning');
	        return;
	    }
	
	   ajaxPostWithFile('/admin/systemPreference/product/addProduct',
	        '#productAddForm'
		).then(function (res) {
            Swal.fire('등록 완료', res, 'success').then(()=>{
	            const addModal = document.getElementById('productAddModal');
            	ModalManager.closeModal(addModal);
				window.location.href = '/admin/systemPreference/product'
			});
        }).catch( function (res) {
            Swal.fire('등록 실패', res, 'error');
	    });
	});
	
	
	// 모달 초기화 및 상세 정보 불러오기
	function initProductDetailModal(productIdx) {
	    // 1. 모달 초기화
	    $('#productDetailForm')[0].reset();
	    
	    // 2. 파일 입력 필드를 초기화 (새로운 요소로 교체)
	    const $fileInput = $('#productDetailForm input[type="file"]');
	    const $newFileInput = $fileInput.clone(true);
	    $fileInput.replaceWith($newFileInput);
	    
	    // 3. 필드 비활성화 및 UI 초기 상태로 복구
	    $('#productDetailForm input, #productDetailForm select, #productDetailForm textarea, #productDetailForm input[type="file"]').prop('disabled', true);
	    
	    $('#detailProductImagePreview').hide();
	    $('#detailProductImageDownload').hide();
	    
	    $('.btn-edit').show();
	    $('#btnDeleteProduct').show();
	    $('.btn-save, .btn-cancel-edit').hide();
	
	    // 4. 상품 상세 정보 다시 불러오기
	    loadProductDetail(productIdx);
	}
	
	//상품상세모달창열기
	$('#productTable').on('click', 'tr', function() {
		console.log(this);
	    const productIdx = $(this).data('productidx');
	    if (!productIdx) {
	        Swal.fire('오류', '상품 정보를 불러올 수 없습니다.', 'error');
	        return;
	    }
		const detailModal = document.getElementById('productDetailModal');
        initProductDetailModal(productIdx);
        ModalManager.openModal(detailModal);
	});
	
			
	//상품상세보기모달창정보불러오기
	function loadProductDetail(productIdx) {
	    $.ajax({
	        url: '/admin/systemPreference/product/getProductDetail',
	        type: 'GET',
	        dataType: 'json',
	        data: { productIdx },
	        success: function(product) {
	            // 값 채우기 (카테고리 select 박스 등은 option 생성 후 값을 val()로 맞춤)
	            $('#productDetailForm [name=productIdx]').val(product.productIdx);
	            $('#detailProductName').val(product.productName);
	            $('#detailProductCategory').val(product.categoryIdx);
	            $('#detailProductWeight').val(product.productWeight);
	            $('#detailProductVolume').val(product.productVolume);
	            $('#detailProductFrom').val(product.productFrom);
	            $('#detailNote').val(product.note);
	            $('#detailProductStatus').val(product.status);
				console.log(product);
	            // 이미지(썸네일/다운로드)
	            if (product.file.fileIdx) {
	                $('#detailProductImagePreview')
	                    .attr('src', '/file/thumbnail/' + product.file.fileIdx)
	                    .show();
	                $('#detailProductImageDownload')
	                    .attr('href', '/file/' + product.file.fileIdx)
	                    .show();
	            } else {
	                $('#detailProductImagePreview').hide();
	                $('#detailProductImageDownload').hide();
	            }
				
	        },
	        error: function() {
	            Swal.fire('오류', '상품 상세 정보를 불러오는 데 실패했습니다.', 'error');
	        }
	    });
	}
	
	//상품상세보기 수정버튼 클릭
	$(document).on('click', '.btn-edit', function() {
	    // 폼 모든 요소 활성화
	    $('#productDetailForm input, #productDetailForm select, #productDetailForm textarea, #productDetailForm input[type="file"]').prop('disabled', false);
	
	    // 수정/저장/취소 버튼 UI 토글
	    $('.btn-edit').hide();
		$('#btnDeleteProduct').hide();
	    $('.btn-save, .btn-cancel-edit').show();
	
	    // (선택) 이미지 미리보기 다운로드 링크는 상황에 맞게 비활성화, 숨김 등 처리 가능
	});
	
	//상품상세보기>수정>취소버튼클릭
	$(document).on('click', '.btn-cancel-edit', function() {
		const productIdx = $('#productDetailForm [name=productIdx]').val();
		if (productIdx) {
			initProductDetailModal(productIdx);
		}
	});
	
	//상품상세보기>수정>저장
	$(document).on('click', '.btn-save', function() {
	
	    ajaxPostWithFile( '/admin/systemPreference/product/modifyProduct',
			'#productDetailForm'
		).then(function(result) {
            Swal.fire('성공', '상품이 정상적으로 저장되었습니다.', 'success').then(()=>{
					window.location.reload();
			});
        }).catch( function() {
            Swal.fire({
				title: '실패',
			  	html: '잠시후 다시시도 하십시오.<br>등록된 계약이 없나 확인하십시오.',
			  	icon: 'error'
			});
	    });
	});
	
	// 상품정보수정 파일 미리보기
	$('#productDetailForm').on('change', 'input[type="file"][name="files"]', function(e) {
	    const file = e.target.files[0];
	    const $preview = $('#detailProductImagePreview');
	    if (file) {
	        // 확장자, 용량 등 추가 검증이 필요하다면 이 구간에서!
	        const reader = new FileReader();
	        reader.onload = function(evt) {
	            $preview.attr('src', evt.target.result);
	            $preview.show();
	        };
	        reader.readAsDataURL(file);
	    } else {
	        // 파일 없으면 기본 이미지나 숨김 처리
	        $preview.hide().attr('src', '#');
	    }
	});
	
	
});