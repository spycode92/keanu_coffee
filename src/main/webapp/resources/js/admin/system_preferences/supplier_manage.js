$(function() {
    const supplierModalEl = document.getElementById('supplierModal');
    const supplierModal = new bootstrap.Modal(supplierModalEl);

    // 공급업체 추가 버튼 클릭 시 모달 열기 및 폼 초기화
    $('#btnAddSupplier').click(function() {
        $('#supplierForm')[0].reset();
        $('#supplierModalLabel').text('공급업체 등록');
        supplierModal.show();  // jQuery 대신 순수 JS API 사용
    });

    // 공급업체 등록 폼 제출 이벤트 처리
    $('#supplierForm').submit(function(e) {
        e.preventDefault();
        const formData = {
            companyName: $('#companyName').val().trim(),
            contactPerson: $('#contactPerson').val().trim(),
            phoneNumber: $('#phoneNumber').val().trim(),
            address: $('#address').val().trim(),
            note: $('#note').val().trim()
        };
        if (!formData.companyName) {
            alert('업체명은 필수입니다.');
            return;
        }
        $.ajax({
            url: '/admin/supplier/add',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function(newSupplier) {
                supplierModal.hide();  // 모달 닫기 (jQuery 대신 Bootstrap JS API)
                $('#supplierList').append(
                    `<li class="list-group-item" data-supplieridx="${newSupplier.idx}">
                        ${newSupplier.companyName}
                    </li>`
                );
                alert('공급업체가 성공적으로 등록되었습니다.');
            },
            error: function() {
                alert('공급업체 등록에 실패했습니다. 다시 시도해주세요.');
            }
        });
    });
}); // 끝
	
	
	








































































































