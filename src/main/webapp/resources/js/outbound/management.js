document.addEventListener('DOMContentLoaded', function () {
    // 관리자 페이지 이동
    const adminBtn = document.getElementById('adminPage');
    if (adminBtn) {
        adminBtn.addEventListener('click', function () {
            location.href = "/admin/main";
        });
    }

    // 검색 기준 토글
    const dateBasis = document.getElementById('dateBasis');
    if (dateBasis) {
        dateBasis.addEventListener('change', function () {
            const basis = this.value;
            document.querySelectorAll('.date-field').forEach(el => el.style.display = 'none');
            if (basis === 'start') {
                document.querySelectorAll('.date-start').forEach(el => el.style.display = '');
            } else if (basis === 'end') {
                document.querySelectorAll('.date-end').forEach(el => el.style.display = '');
            } else if (basis === 'range') {
                document.querySelectorAll('.date-range').forEach(el => el.style.display = '');
            }
        });
        // 초기 트리거
        dateBasis.dispatchEvent(new Event('change'));
    }

    // 상세검색 토글
    const toggleBtn = document.getElementById('toggleDetailSearchBtn');
    const detailCard = document.getElementById('detailSearchCard');
    if (toggleBtn && detailCard) {
        toggleBtn.addEventListener('click', function () {
            const isHidden = detailCard.style.display === 'none';
            detailCard.style.display = isHidden ? '' : 'none';
            this.textContent = isHidden ? '상세검색 닫기' : '상세검색';
        });
    }

    // 간단 검색
    const simpleSearchBtn = document.getElementById('simpleSearchBtn');
    const keywordInput = document.getElementById('simpleItemKeyword');
    if (simpleSearchBtn && keywordInput) {
        simpleSearchBtn.addEventListener('click', function () {
            const keyword = keywordInput.value.trim();
            if (keyword) {
                console.log("간단검색 품목 키워드:", keyword);
                // TODO: AJAX 검색 로직
            } else {
                alert("품목 코드/명을 입력하세요.");
            }
        });
    }
});
