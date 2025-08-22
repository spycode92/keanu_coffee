<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자페이지 - 조직 관리</title>
    <!-- jquery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!--  bootstrap사용 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- sweetAlert -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- 기본포맷css, js -->
    <link href="/resources/css/common/common.css" rel="stylesheet" />
    <script src="/resources/js/common/common.js"></script>
    <!-- 기능별커스텀js -->
    <script src="/resources/js/admin/system_preferences/supply_contract.js"></script>
    <!-- 다음주소찾기api -->
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    
    <style>
        .department-item.active,
        .team-item.active,
        .position-item.active {
            background-color: var(--primary);
            color: var(--primary-foreground);
            font-weight: var(--font-weight-medium);
        }
        .supplier-modal .modal-content {
		    background-color: #f5f1e9 !important; /* 부드러운 베이지색 */
		    color: #000 !important;               /* 글자색 검정 */
		}
		
		.product-modal .modal-content {
		    background-color: #f5f1e9;  /* 부드러운 베이지색 배경 예시 */
		    color: #000;                /* 검정 글자색 */
		}
		
		.supplier-modal label,
		.supplier-modal input.form-control,
		.supplier-modal textarea.form-control,
		.supplier-modal select.form-select {
		    color: #000 !important;
		}
		
		.supplier-modal .btn,
		.supplier-modal .modal-title {
		    color: #000 !important;
		}
		
		.btn-custom-cancel {
		    background-color: rgba(234, 110, 110, 0.52); /* #ea6e6e85 반투명 배경 */
		    color: #fff;
		    border: none;
		    transition: background-color 0.3s ease;
		}
		
		.btn-custom-cancel:hover {
		    background-color: rgba(234, 110, 110, 0.8); /* 더 진한 배경색 */
		    color: #fff;
		}
		
		.dark .table th,
		.dark .table td {
		    color: var(--foreground) !important;  /* 다크모드 전역 글씨색에 맞춤 */
		    background-color: transparent;        /* 필요시 배경도 지정 가능 */
		}
		
		/* 혹은 라이트/다크 모두 대응하려면 일반 스타일 보완 */
		.table th,
		.table td {
		    color: var(--foreground);             /* 바탕색과 동일하게 */
		    background-color: transparent;
		}
		.dark .form-control {
		    background-color: oklch(0.68 0.01 131.24);
		}
		
		.supplier-name-area {
		    display: flex;
		    align-items: center;
		    min-width: 0; /* flex에서 ellipsis 잘 적용됨 */
		}
		.supplier-name-text {
		    max-width: 90px;
		    white-space: nowrap;
		    overflow: hidden;
		    text-overflow: ellipsis;
		    display: inline-block;
		}
		
		#categoryListInModal {
		    list-style: none;  /* 불릿 제거 */
		    padding-left: 0;   /* 기본 들여쓰기 제거 */
		    margin-left: 0;    /* 필요 시 마진도 제거 */
		}
		.list-group-item {
			padding-right: 0;
		}
		.parent-category-bg {
		    background-color: #d5d3b8; 
		}
		
		.child-category-bg {
		    background-color: #b3b5ac;
		}
		#btnCategoryManage {
		    background-color: #e8bfbf;
		    border-color: #e8bfbf;
		    color: #000;
		    transition: background-color 0.3s ease, border-color 0.3s ease;
		}
		
		#btnCategoryManage:hover,
		#btnCategoryManage:focus {
		    background-color: #efa9a9;  /* 호버 시 더 진한 색 */
		    border-color: #d59e9e;
		    color: #000;
		    text-decoration: none;
		}
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/admin/preference_modal/add_contract.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/admin/preference_modal/detail_contract.jsp"></jsp:include>
    <section class="content">
        <div class="container">
            
			
		    <div class="card-header d-flex justify-content-between align-items-center">
		        <span>공급계약</span>
		        <button type="button" id="btnAddContract" class="btn btn-sm btn-primary">+</button>
		    </div>
		    <div class="table-responsive mt-3" style="max-height: 300px; overflow-y: auto;">
				<table class="table table-striped table-bordered" id="contractTable">
		            <thead>
		                <tr>
		                    <th>공급업체</th>
		                    <th>상품명</th>
		                    <th>계약단가</th>
		                    <th>계약기간</th>
		                    <th>상태</th>
		                    <th>상세보기</th>
		                </tr>
		            </thead>
		            <tbody>
		            </tbody>
		        </table>
		    </div>

		</div>
			
    </section>
    
</body>
</html>