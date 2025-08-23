// supply_contract.js

let originalContractData = {};
let currentContractIdx = 0;

$(function(){
    // 공급계약 목록 로드
    function loadSupplierProductContracts() {
        $.ajax({
            url: '/admin/systemPreference/supplyContract/getContractList',
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

    function formatDateFromMillis(millis) {
        if (!millis) return '';
        const date = new Date(Number(millis));
        const yyyy = date.getFullYear();
        const mm = String(date.getMonth() + 1).padStart(2, '0');
        const dd = String(date.getDate()).padStart(2, '0');
        return `${yyyy}-${mm}-${dd}`;
    }

    function loadProductOptions(selectedProductIdx) {
        $.ajax({
            url: '/admin/systemPreference/product/getProductList',
            type: 'GET',
            dataType: 'json',
            success: function(productList) {
                const $select = $('#productSelect');
                $select.empty().append('<option value="">선택하세요</option>');
                productList.forEach(function(product) {
                    $select.append(
                        `<option value="${product.idx}" ${selectedProductIdx == product.idx ? 'selected' : ''}>${product.productName}</option>`
                    );
                });
            },
            error: function() {
                Swal.fire('오류', '상품 목록을 불러오는 데 실패했습니다.', 'error');
            }
        });
    }

    function loadSupplierOptions(selectedSupplierIdx) {
        $.ajax({
            url: '/admin/systemPreference/supplyCompany/suppliers',
            type: 'GET',
            dataType: 'json',
            success: function(supplierList) {
                const $select = $('#supplierSelect');
                $select.empty().append('<option value="">선택하세요</option>');
                supplierList.forEach(function(supplier) {
                    $select.append(
                        `<option value="${supplier.idx}" ${selectedSupplierIdx == supplier.idx ? 'selected' : ''}>${supplier.supplierName}</option>`
                    );
                });
            },
            error: function() {
                Swal.fire('오류', '공급업체 목록을 불러오는 데 실패했습니다.', 'error');
            }
        });
    }

    function openContractDetailModal(contractIdx) {
        currentContractIdx = contractIdx;
        const detailModal = document.getElementById('contractDetailModal');
        ModalManager.openModal(detailModal);

        $('#contractDetailForm input, #contractDetailForm textarea').prop('readonly', true);
        $('#detailStatus').prop('disabled', true);
        $('#btnEditContractDetail, #btnDeleteContractDetail').show();
        $('#btnSaveContractDetail, #btnCancelEditDetail').hide();

        // 초기 데이터 비우기
        $('#detailSupplier, #detailProduct, #detailContractPrice, #detailContractStart, #detailContractEnd, #detailMinOrderQuantity, #detailMaxOrderQuantity, #contractDetailNote').val('');
        $('#contractDetailProductImagePreview').attr('src', '');

        // 로드 데이터
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
                let imgSrc = '/images/no-image.png';
                if (data.fileIdx) imgSrc = '/file/thumbnail/' + data.fileIdx + '?_=' + Date.now();
                else if (data.productIdx) imgSrc = '/images/products/' + data.productIdx + '.jpg';
                $('#contractDetailProductImagePreview').attr('src', imgSrc);
                originalContractData = {
                    contractPrice: data.contractPrice,
                    contractStart: data.contractStart,
                    contractEnd: data.contractEnd,
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
        loadProductOptions();
        loadSupplierOptions();
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
                Swal.fire('등록 완료', '공급계약이 정상 등록되었습니다.', 'success');
                const addModal = document.getElementById('contractAddModal');
                ModalManager.closeModal(addModal);
                loadSupplierProductContracts();
            },
            error: function(xhr) {
                let msg = '등록 중 오류가 발생했습니다.';
                if (xhr.responseText) msg = xhr.responseText;
                Swal.fire('오류', msg, 'error');
            }
        });
    });

    // 상세보기 열기
    $('#contractTable').on('click', '.btn-detail-contract', function() {
        const idx = $(this).closest('tr').data('contract-idx');
        openContractDetailModal(idx);
    });

    // 수정
    $('#btnEditContractDetail').on('click', function() {
        $('#detailContractPrice, #detailContractStart, #detailContractEnd, #detailMinOrderQuantity, #detailMaxOrderQuantity, #contractDetailNote').prop('readonly', false);
        $('#detailStatus').prop('disabled', false);
        $('#btnSaveContractDetail, #btnCancelEditDetail').show();
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
        $('#detailStatus').prop('disabled', true);
        $('#btnSaveContractDetail, #btnCancelEditDetail').hide();
        $('#btnEditContractDetail, #btnDeleteContractDetail').show();
    });

    // 저장
    $('#btnSaveContractDetail').on('click', function() {
        const dataToSave = {
            contractPrice: $('#detailContractPrice').val(),
            contractStart: $('#detailContractStart').val(),
            contractEnd: $('#detailContractEnd').val(),
            minOrderQuantity: $('#detailMinOrderQuantity').val(),
            maxOrderQuantity: $('#detailMaxOrderQuantity').val(),
            status: $('#detailStatus').val(),
            note: $('#contractDetailNote').val(),
            idx: currentContractIdx
        };
        if (!dataToSave.contractPrice || !dataToSave.contractStart || !dataToSave.contractEnd) {
            Swal.fire('경고', '필수 입력 항목을 모두 입력하세요.', 'warning');
            return;
        }
        $.ajax({
            url: '/admin/systemPreference/supplyContract/updateContractDetail',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(dataToSave),
            success: function() {
                Swal.fire('성공', '계약 정보가 저장되었습니다.', 'success');
                const detailModal = document.getElementById('contractDetailModal');
                ModalManager.closeModal(detailModal);
                setTimeout(function() {
                    openContractDetailModal(currentContractIdx);
                }, 500);
            },
            error: function() {
                Swal.fire('오류', '저장 중 오류가 발생했습니다.', 'error');
            }
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
                const dataToDelete = { idx: currentContractIdx, status: '삭제' };
                $.ajax({
                    url: '/admin/systemPreference/supplyContract/deleteContractDetail',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(dataToDelete),
                    success: function() {
                        Swal.fire('삭제 완료', '계약 정보가 삭제되었습니다.', 'success');
                        const detailModal = document.getElementById('contractDetailModal');
                        ModalManager.closeModal(detailModal);
                        loadSupplierProductContracts();
                    },
                    error: function() {
                        Swal.fire('오류', '삭제 중 오류가 발생했습니다.', 'error');
                    }
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

    loadSupplierProductContracts();
});