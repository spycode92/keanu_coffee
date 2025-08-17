$(function () {
	//전역변수선언
	let allCategories = [];
	
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
				console.log(categoryList);
				categoryList.forEach(function(cat) {
				    console.log(cat); // cat의 모든 key를 하나씩 확인
				});
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
	
	//상품목록불러오기함수
	function loadProductList() {
	    $.ajax({
	        url: '/admin/systemPreference/getProductList',
	        type: 'GET',
 			dataType: 'json',
	        success: function(productList) {
	            let html = '';
	            productList.forEach(function(product) {
	                html += `
	                <li class="list-group-item d-flex justify-content-between align-items-center" data-productidx="${product.idx}" style="color: black;" >
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//페이지로딩시 불러오기
	loadProductList();
    
});