//전역변수선언
let allCategories = [];
$(function () {
	
    // 상품 추가 모달 열기
    $('#btnAddProduct').click(function () {
		loadUpperCategoryList(); // 상위 카테고리만 셀렉트박스 갱신
        $('#productAddForm')[0].reset();
        $('#productImagePreview').hide().attr('src', '#');
        $('#productAddModal').modal('show');
    });
	
	 // 상위 카테고리 리스트 불러오기 및 셀렉트박스 렌더링
    function loadUpperCategoryList() {
        $.ajax({
            url: '/admin/systemPreference/categories',
            method: 'GET',
            dataType: 'json',
            success: function(categoryList) {
				allCategories = categoryList;
                const $upper = $('#upperCategorySelect');
                $upper.empty();
                $upper.append('<option value="">상위 카테고리 선택</option>');
	            categoryList.forEach(function(cat) {
	
                    if (cat.parentCategoryIdx === null || cat.parentCategoryIdx === undefined || cat.parentCategoryIdx === "") {
                        $upper.append(`<option value="${cat.idx}">${cat.categoryName}</option>`);
                    }
                });
				// 하위카테고리도 초기화
	            $('#lowerCategorySelect').empty().append('<option value="">상위 카테고리를 먼저 선택하세요</option>');
            },
            error: function() {
                Swal.fire('상위 카테고리 목록 불러오기 실패', '', 'error');
            }
        });
    }
	
	//상위카테고리선택시 실행
	$('#upperCategorySelect').on('change', function() {
	    const val = $(this).val();
	    const $lower = $('#lowerCategorySelect');
	    $lower.empty();
	
	    if (!val) {
	        $lower.append('<option value="">상위 카테고리를 먼저 선택하세요</option>');
	        return;
	    }
	
	    const selectedUpperIdx = Number(val);
	
	    const childCategories = allCategories.filter(cat =>
	        Number(cat.parentCategoryIdx) === selectedUpperIdx
	    );
	
	    if (childCategories.length === 0) {
	        $lower.append('<option value="">하위 카테고리가 없습니다</option>');
	    } else {
	        $lower.append('<option value="">하위 카테고리 선택</option>');
	        childCategories.forEach(function(cat) {
	            $lower.append(`<option value="${cat.idx}">${cat.categoryName}</option>`);
	        });
	    }
	});
	
	// 새 카테고리 추가 모달 열기 (reset 메서드 올바르게)
    $('#btnAddCategory').click(function () {
        $('#addCategoryForm')[0].reset();
		renderParentCategoryOptions();
        $('#addCategoryModal').modal('show');
    });
	
	// 기존 전체 카테고리 리스트 활용
	function renderParentCategoryOptions() {
	    const $parent = $('#parentCategorySelect');
	    $parent.empty();
	    $parent.append('<option value="">없음 (최상위 카테고리)</option>');
	    allCategories.forEach(function(cat) {
	        if (
	            cat.parentCategoryIdx === null ||
	            cat.parentCategoryIdx === undefined ||
	            cat.parentCategoryIdx === 0 ||
	            cat.parentCategoryIdx === ""
	        ) {
	            $parent.append(`<option value="${cat.idx}">${cat.categoryName}</option>`);
	        }
	    });
	}
	
	//카테고리추가버튼기능
	$('#addCategoryForm').on('submit', function (e) {
	    e.preventDefault();
	
	    const newCategory = {
	        categoryName: $('#newCategoryName').val().trim(),
	        parentCategoryIdx: $('#parentCategorySelect').val() === "" ? null : Number($('#parentCategorySelect').val())
	    };
	
	    if (!newCategory.categoryName) {
	        Swal.fire('카테고리명을 입력해주세요.', '', 'warning');
	        return;
	    }
	
	    $.ajax({
	        url: '/admin/systemPreference/addCategory', // 실제 매핑된 서버 주소로 맞추세요!
	        method: 'POST',
	        contentType: 'application/json',
	        data: JSON.stringify(newCategory),
	        success: function (res) {
	            $('#addCategoryModal').modal('hide');
	            Swal.fire('카테고리가 추가되었습니다.', '', 'success');
	            // 성공 후 전체 카테고리 목록을 다시 불러와서 화면 동기화
	            loadUpperCategoryList(); // 함수는 전체 JS 구조에 맞게 수정
	        },
	        error: function () {
	            Swal.fire('카테고리 추가 실패', '서버 오류가 발생했습니다.', 'error');
	        }
	    });
	});
	
	//카테고리관리 모달열기
	$('#btnCategoryManage').click(function () {
	    $('#categoryManageModal').modal('show');
	    renderCategoryListInModal();
	});
	
	//카테고리수정
	$('#categoryListInModal').off('click', '.editBtn').on('click', '.editBtn', function () {
	    const $li = $(this).closest('li');
	    const categoryIdx = $(this).data('idx');
	    const originalName = $li.contents().filter(function() {
	        return this.nodeType === 3;
	    }).text().trim();
	
	    // 편집 중이면 중복 변환 방지
	    if ($li.find('input[type="text"]').length) return;
	
	    // 기존 내용 저장
	    $li.data('originalHtml', $li.html());
	
	    // 인라인 폼으로 변경
	    $li.html(`
	        <input type="text" class="form-control d-inline w-auto" value="${originalName}" style="width:120px; display:inline-block;" />
	        <button class="btn btn-sm btn-primary ml-1 saveEditBtn">저장</button>
	        <button class="btn btn-sm btn-secondary ml-1 cancelEditBtn">취소</button>
	    `);
	
	    // 저장
	    $li.off('click', '.saveEditBtn').on('click', '.saveEditBtn', function () {
	        const newName = $li.find('input[type="text"]').val().trim();
	        if (!newName) {
	            Swal.fire('카테고리명을 입력해주세요.', '', 'warning');
	            return;
	        }
	        $.ajax({
	            url: '/admin/systemPreference/modifyCategory',
	            method: 'PUT',
	            contentType: 'application/json',
	            data: JSON.stringify({ idx: categoryIdx, categoryName: newName }),
	            success: function () {
	                Swal.fire('성공', '카테고리명이 수정되었습니다.', 'success');
	                renderCategoryListInModal();
	            },
	            error: function () {
	                Swal.fire('실패', '수정 중 오류가 발생했습니다.', 'error');
	                renderCategoryListInModal();
	            }
	        });
	    });
	
	    // 취소
	    $li.off('click', '.cancelEditBtn').on('click', '.cancelEditBtn', function () {
	        $li.html($li.data('originalHtml'));
	    });
	});
	
	// 삭제 버튼 클릭 이벤트
	$('#categoryListInModal').off('click', '.deleteBtn').on('click', '.deleteBtn', function () {
	    const categoryIdx = $(this).data('idx');
	
	    Swal.fire({
	        title: '정말 삭제하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonText: '삭제',
	        cancelButtonText: '취소'
	    }).then((result) => {
	        if (result.isConfirmed) {
	            $.ajax({
	                url: `/admin/systemPreference/removeCategory`,
	                method: 'DELETE',
					contentType: 'application/json',
					data: JSON.stringify({ idx: categoryIdx }),
	                success: function (event) {
						console.log(event.responseText);
	                    Swal.fire(event.responseText, '카테고리가 삭제되었습니다.', 'success');
	                    renderCategoryListInModal(); // 삭제 후 리스트 다시 로드
	                },
	                error: function (xhr) {
	                    if (xhr.status === 409) {
				            Swal.fire('삭제 실패', xhr.responseText, 'warning');
				        } else {
				            Swal.fire('삭제 실패', '서버 오류가 발생했습니다.', 'error');
				        }
					}
	            });
	        }
	    });
	});
	
	
	
	//카테고리수정삭제모달불러오기
	function renderCategoryListInModal() {
	    $.ajax({
	        url: '/admin/systemPreference/categories',
	        type: 'GET',
	        success: function (list) {
	            const $list = $('#categoryListInModal');
	            $list.empty();
	
	            function getChildren(parentIdx) {
	                return list.filter(cat => cat.parentCategoryIdx === parentIdx);
	            }
	
	            function renderNode(cat, $container, level) {
	                const indent = '&nbsp;'.repeat(level * 4);
	                // 부모는 굵은 글씨와 회색 배경, 자식은 일반 글씨와 흰 배경
	                const fontWeight = level === 0 ? 'font-weight-bold' : 'font-weight-normal';
	                const bgClass = level === 0 ? 'parent-category-bg' : 'child-category-bg';
	                const paddingLeft = 0 * level; // px 단위 들여쓰기
	
	                const $li = $(`
	                    <li class="${bgClass} ${fontWeight}" style="padding-left: ${paddingLeft}px; border-bottom: 1px solid #eee; margin-bottom: 4px; list-style: none;">
	                        ${indent}${cat.categoryName}
	                        <button class="btn btn-sm btn-outline-primary editBtn ml-2" data-idx="${cat.idx}">수정</button>
	                        <button class="btn btn-sm btn-outline-danger deleteBtn ml-1" data-idx="${cat.idx}">삭제</button>
	                    </li>
	                `);
	                $container.append($li);
	
	                const children = getChildren(cat.idx);
	                if (children.length > 0) {
	                    const $subUl = $('<ul style="padding-left: 0;" ></ul>');
	                    $li.append($subUl);
	                    children.forEach(child => renderNode(child, $subUl, level + 1));
	                }
	            }
	
	            const parents = list.filter(cat =>
	                cat.parentCategoryIdx === null ||
	                cat.parentCategoryIdx === undefined ||
	                cat.parentCategoryIdx === 0 ||
	                cat.parentCategoryIdx === ''
	            );
	
	            parents.forEach(parent => {
	                renderNode(parent, $list, 0);
	            });
	
	            // 이벤트 위임(생략 가능)
	        }
	    });
	}
	
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
	
	//부피자동계산
	function updateVolume() {
	    const width = parseFloat($('#productWidth').val());
	    const length = parseFloat($('#productLength').val());
	    const height = parseFloat($('#productHeight').val());
	    if (!isNaN(width) && !isNaN(length) && !isNaN(height)) {
	        const volume = width * length * height;
	        $('#productVolume').val(volume.toFixed(2));
	    } else {
	        $('#productVolume').val('');
	    }
	}

	
	// 가로, 세로, 높이 입력값 소수점 둘째 자리까지 올림하여 표시 (blur 이벤트)
	// 올림 기능 추가
	function roundUpTo2(num) {
	    return (Math.ceil(num * 100) / 100);
	}
	
	$('#productWidth, #productLength, #productHeight, #productWeight').off('blur').on('blur', function () {
	    const val = parseFloat($(this).val());
	    if (!isNaN(val)) {
	        $(this).val(roundUpTo2(val).toFixed(2));
	    } else {
	        $(this).val('');
	    }
	});
	
	// 부피 계산 (소수점 셋째 자리에서 올림 → 소수점 둘째 자리로 표기)
	function ceilTo2(num) {
	    return (Math.ceil(num * 100) / 100).toFixed(2);
	}
	// 부피 자동 계산 (input 이벤트)
	function updateVolume() {
	    const width = parseFloat($('#productWidth').val());
	    const length = parseFloat($('#productLength').val());
	    const height = parseFloat($('#productHeight').val());
	    if (!isNaN(width) && !isNaN(length) && !isNaN(height)) {
	        const volumeRaw = width * length * height;
	        const volume = ceilTo2(volumeRaw);
	        $('#productVolume').val(volume);
	    } else {
	        $('#productVolume').val('');
	    }
	}
	
	// 값들어갈때마다실행
	$('#productWidth, #productLength, #productHeight').off('input').on('input', updateVolume);	
	
	
	
	
	//상품추가
	$('#productAddForm').off('submit').on('submit', function (e) {
	    e.preventDefault();
	
	    // FormData 객체 생성 (this는 form)
	    const formData = new FormData(this);
	
	    // (필수 검증 추가 가능)
	    if (!$('#productName').val().trim()) {
	        Swal.fire('상품명을 입력하세요.', '', 'warning');
	        return;
	    }
	    if (!$('#upperCategorySelect').val() || !$('#lowerCategorySelect').val()) {
	        Swal.fire('카테고리를 선택하세요.', '', 'warning');
	        return;
	    }
	
	    $.ajax({
	        url: '/admin/systemPreference/addProduct',
	        method: 'POST',
	        data: formData,
	        processData: false,            // 반드시 false (formData 전송 시)
	        contentType: false,            // 반드시 false (formData 전송 시)
	        success: function (res) {
	            Swal.fire('등록 완료', res, 'success');
	            $('#productAddModal').modal('hide');
	            loadProductList(); // 상품 목록 새로고침
	        },
	        error: function (res) {
	            Swal.fire('등록 실패', res, 'error');
	        }
	    });
	});
	
	// 상품 목록 불러오기 함수 (필터 조건 optional)
	function loadProductList(parentCategoryIdx = '', childCategoryIdx = '') {
	    $.ajax({
	        url: '/admin/systemPreference/getProductList',
	        type: 'GET',
	        dataType: 'json',
	        data: {
	            parentCategoryIdx: parentCategoryIdx,
	            categoryIdx: childCategoryIdx
	        },
	        success: function(productList) {
	            let html = '';
	            productList.forEach(function(product) {
	                html += `
	                <li class="list-group-item d-flex justify-content-between align-items-center" data-productidx="${product.idx}" style="color: black;">
	                    <span>${product.productName}</span>
	                    <button type="button" class="btn btn-sm btn-info btn-detail-product">상세보기</button>
	                </li>`;
	            });
	            $('#productList').html(html);
	        },
	        error: function() {
	            Swal.fire('오류', '상품 목록을 불러오는 데 실패했습니다.', 'error');
	        }
	    });
	}
	
	// 대분류 카테고리 리스트 불러오기 (상품카드 영역)
	function loadUpperCategoryListCard() {
	    $.ajax({
	        url: '/admin/systemPreference/categories',
	        method: 'GET',
	        dataType: 'json',
	        success: function(categoryList) {
	            allCategories = categoryList;
	            const $upper = $('#upperCategorySelect_');
	            $upper.empty();
	
	            if (categoryList.length === 0) {
	                $upper.append('<option value="">카테고리를 생성하세요</option>');
	                $('#lowerCategorySelect_').empty()
	                    .append('<option value="">대분류가 없으므로 선택 불가</option>')
	                    .prop('disabled', true);
	                loadProductList();
	                return;
	            }
	
	            $upper.append('<option value="">전체</option>');
	            categoryList.forEach(function(cat) {
	                if (
	                    cat.parentCategoryIdx === null ||
	                    cat.parentCategoryIdx === undefined ||
	                    cat.parentCategoryIdx === 0 ||
	                    cat.parentCategoryIdx === "" ||
	                    cat.parentCategoryIdx === "0"
	                ) {
	                    $upper.append(`<option value="${cat.idx}">${cat.categoryName}</option>`);
	                }
	            });
	
	            const $lower = $('#lowerCategorySelect_');
	            $lower.empty().append('<option value="all">전체</option>');
	            $lower.prop('disabled', true);
	        },
	        error: function() {
	            Swal.fire('상위 카테고리 목록 불러오기 실패', '', 'error');
	        }
	    });
	}
	
	// 대분류 선택 시 소분류 옵션 세팅 및 상품 필터링 유도
	$('#upperCategorySelect_').on('change', function () {
	    const selectedParent = $(this).val();
	    const $lower = $('#lowerCategorySelect_');
	    $lower.empty();
	
	    if (!selectedParent) {
	        $lower.append('<option value="">전체</option>');
	        $lower.prop('disabled', true);
	        loadProductList();
	        return;
	    }
	
	    const childCategories = allCategories.filter(
	        cat => String(cat.parentCategoryIdx) === String(selectedParent)
	    );
	
	    if (childCategories.length === 0) {
	        $lower.append('<option value="">소분류가 없습니다</option>');
	        $lower.prop('disabled', true);

	        $('#productList').html('<li class="list-group-item" style="color: black;">하위 카테고리없음</li>');

        	return;
	    } else {
	        $lower.append('<option value="all">전체</option>');
	        childCategories.forEach(function(cat) {
	            $lower.append(`<option value="${cat.idx}">${cat.categoryName}</option>`);
	        });
	        $lower.prop('disabled', false);
	
	        $lower.val('all');
	        $lower.trigger('change');
	    }
	});
	
	// 소분류 change 시 상품 필터링 로직
	$('#lowerCategorySelect_').on('change', function() {
	    const selectedVal = $(this).val();
	    const parentVal = $('#upperCategorySelect_').val();
	
	    if (selectedVal === "all") {
	        const childCategories = allCategories.filter(
	            cat => String(cat.parentCategoryIdx) === String(parentVal)
	        );
	        const childCatIds = childCategories.map(cat => cat.idx);
	
	        loadProductListByCategoryIds(childCatIds);
	    } else if (selectedVal) {
	        loadProductList('', selectedVal);
	    } else {
	        loadProductList();
	    }
	});
	
	// 복수 카테고리 아이디로 상품목록 필터링 함수
	function loadProductListByCategoryIds(categoryIdxArray) {
	    $.ajax({
	        url: '/admin/systemPreference/getProductList',
	        type: 'GET',
	        dataType: 'json',
	        traditional: true,
	        data: { categoryIdxList: categoryIdxArray },
	        success: function(productList) {
	            let html = '';
	            productList.forEach(function(product) {
	                html += `
	                <li class="list-group-item d-flex justify-content-between align-items-center" data-productidx="${product.idx}" style="color: black;">
	                    <span>${product.productName}</span>
	                    <button type="button" class="btn btn-sm btn-info btn-detail-product">상세보기</button>
	                </li>`;
	            });
	            $('#productList').html(html);
	        },
	        error: function() {
	            Swal.fire('오류', '상품 목록을 불러오는 데 실패했습니다.', 'error');
	        }
	    });
	}
	
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
	$(document).on('click', '.btn-detail-product', function() {
		//상품Idx 저장
		const productIdx = $(this).closest('li').data('productidx');
	    //없으면에러
		if (!productIdx) {
	        Swal.fire('오류', '상품 정보를 불러올 수 없습니다.', 'error');
	        return;
	    }
		// 모달열기
	    $('#productDetailModal').modal('show');

		initProductDetailModal(productIdx);
	});
	
	//상위카테고리불러오기함수
	function loadAndRenderCategories(selectedParentIdx, selectedChildIdx) {
	    $.ajax({
	        url: '/admin/systemPreference/categories',
	        type: 'GET',
	        dataType: 'json',
	        success: function(categories) {
	            // 1. 대분류 옵션 생성 및 선택
	            const $upper = $('#detailUpperCategorySelect');
	            $upper.empty().append('<option value="">카테고리없음</option>');
	            categories.filter(cat => !cat.parentCategoryIdx).forEach(cat => {
	                $upper.append(`<option value="${cat.idx}">${cat.categoryName}</option>`);
	            });
	            $upper.val(selectedParentIdx);
	
	            // 2. 소분류 옵션 생성 및 선택
	            renderLowerCategoryOptions(categories, selectedParentIdx, selectedChildIdx);
	
	            // 3. 대분류 변경시 소분류 동적 갱신
	            $upper.off('change').on('change', function() {
	                const newParentIdx = $(this).val();
	                renderLowerCategoryOptions(categories, newParentIdx, null);
	            });
	        }
	    });
	}
	//하위카테고리불러오기함수
	function renderLowerCategoryOptions(categories, parentIdx, selectedIdx) {
	    const $lower = $('#detailLowerCategorySelect');
	    $lower.empty();
	    const children = categories.filter(cat => String(cat.parentCategoryIdx) === String(parentIdx));
	    if (children.length) {
	        children.forEach(cat => {
	            $lower.append(`<option value="${cat.idx}">${cat.categoryName}</option>`);
	        });
	        $lower.prop('disabled', false);
	        if (selectedIdx) {
				$lower.val(selectedIdx);
				$lower.prop('disabled', true);
			}
		
	    } else {
	        $lower.append('<option value="">소분류 없음</option>');
	        $lower.prop('disabled', true);
	    }
	}
	
		
	//상품상세보기모달창정보불러오기
	function loadProductDetail(productIdx) {
	    $.ajax({
	        url: '/admin/systemPreference/getProductDetail',
	        type: 'GET',
	        dataType: 'json',
	        data: { productIdx },
	        success: function(product) {
	            // 값 채우기 (카테고리 select 박스 등은 option 생성 후 값을 val()로 맞춤)
	            $('#productDetailForm [name=productIdx]').val(product.productIdx);
	            $('#detailProductName').val(product.productName);
	            $('#detailProductWeight').val(product.productWeight);
	            $('#detailProductWidth').val(product.productWidth);
	            $('#detailProductLength').val(product.productLength);
	            $('#detailProductHeight').val(product.productHeight);
	            $('#detailProductVolume').val(product.productVolume);
	            $('#detailProductFrom').val(product.productFrom);
	            $('#detailNote').val(product.note);
	
	            // 이미지(썸네일/다운로드)
	            if (product.fileIdx) {
	                $('#detailProductImagePreview')
	                    .attr('src', '/file/thumbnail/' + product.fileIdx)
	                    .show();
	                $('#detailProductImageDownload')
	                    .attr('href', '/file/' + product.fileIdx)
	                    .show();
	            } else {
	                $('#detailProductImagePreview').hide();
	                $('#detailProductImageDownload').hide();
	            }
				
				loadAndRenderCategories(product.parentCategoryIdx, product.categoryIdx);
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
	    const formData = new FormData($('#productDetailForm')[0]);
	
	    $.ajax({
	        url: '/admin/systemPreference/modifyProduct',  // 수정 API 경로에 맞게 변경
	        type: 'POST',
	        data: formData,
	        processData: false,
	        contentType: false,
	        success: function(res) {
	            Swal.fire('성공', '상품이 정상적으로 저장되었습니다.', 'success');
			    const productIdx = $('#productDetailForm [name=productIdx]').val();
			    if (productIdx) {
			        // 모달 닫기
			        $('#productDetailModal').modal('hide');
			        // 약간의 delay 후 다시 열고 최신 상세정보 요청
			        setTimeout(function() {
			            $('#productDetailModal').modal('show');
			            initProductDetailModal(productIdx); // 상세 초기화 + 최신 데이터 불러오기
			        }, 500); // 0.5초 (필요에 따라 조절)
			    }
	        },
	        error: function() {
	            Swal.fire('실패', '저장 중 오류가 발생했습니다.', 'error');
	        }
	    });
	});
	
	// 올림 함수 (소수점 둘째자리에서 반올림 아니라 '올림')
	function roundUpTo2(num) {
	    return (Math.ceil(num * 100) / 100);
	}
	
	// 입력 후 올림 및 부피 자동 계산
	$('#detailProductWidth, #detailProductLength, #detailProductHeight, #detailProductWeight').off('blur').on('blur', function () {
	    const val = parseFloat($(this).val());
	    if (!isNaN(val)) {
	        $(this).val(roundUpTo2(val).toFixed(2));
	    } else {
	        $(this).val('');
	    }
	    updateDetailVolume(); // 입력값 바뀔 때마다 부피 계산
	});
	
	// 부피 계산 함수
	function updateDetailVolume() {
	    const width = parseFloat($('#detailProductWidth').val());
	    const length = parseFloat($('#detailProductLength').val());
	    const height = parseFloat($('#detailProductHeight').val());
	    if (!isNaN(width) && !isNaN(length) && !isNaN(height)) {
	        const volume = roundUpTo2(width * length * height);
	        $('#detailProductVolume').val(volume.toFixed(2));
	    } else {
	        $('#detailProductVolume').val('');
	    }
	}
	
	// input 이벤트에도 실시간으로 부피 갱신
	$('#detailProductWidth, #detailProductLength, #detailProductHeight').off('input').on('input', updateDetailVolume);
	
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
	
	//삭제버튼 
	$(document).on('click', '#btnDeleteProduct', function() {
	    const productIdx = $('#productDetailForm [name=productIdx]').val();
	    if (!productIdx) {
	        Swal.fire('오류', '상품 정보가 올바르지 않습니다.', 'error');
	        return;
	    }
	    Swal.fire({
	        title: '정말 삭제하시겠습니까?',
	        text: '삭제 후 복구할 수 없습니다.',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonText: '삭제',
	        cancelButtonText: '취소'
	    }).then((result) => {
	        if (result.isConfirmed) {
	            $.ajax({
	                url: '/admin/systemPreference/removeProduct',
	                type: 'DELETE',
	                contentType: 'application/json',
	                data: JSON.stringify({ productIdx: productIdx }),
	                success: function(res) {
	                    Swal.fire('삭제 완료', '상품이 정상적으로 삭제되었습니다.', 'success');
	                    $('#productDetailModal').modal('hide');
	                    loadProductList(); // 상품 목록 새로고침
	                },
	                error: function(xhr) {
	                    let msg = '삭제 중 오류가 발생했습니다.';
	                    if (xhr && xhr.responseText) {
	                        msg = xhr.responseText;
	                    }
	                    Swal.fire('실패', msg, 'error');
	                }
	            });
	        }
	    });
	});
	
	
	
	
	
	
	
	
	
	
	//페이지로딩시 불러오기
	loadUpperCategoryListCard();
	loadUpperCategoryList();
	loadProductList();
    
});