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
    <script src="/resources/js/admin/system_preferences/supplier_manage.js"></script>
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
    <jsp:include page="/WEB-INF/views/admin/preference_modal/add_supplier.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/admin/preference_modal/detail_supplier.jsp"></jsp:include>
    <section class="content">
        <div class="container">
            <div class="container mt-4">
			   <div>
			   		<div style="display: flex; ">
			   		
					    <!-- 추가 버튼 -->
					    <button type="button" id="btnAddSupplier" class="btn btn-primary btn-sm mb-3">+ 공급업체 추가</button>
					
					    <!-- 필터 라디오 버튼 -->
					    <div class="mb-3">
					        <label><input type="radio" name="supplierStatus" value="ALL" checked> 전체</label>
					        <label class="ml-3"><input type="radio" name="supplierStatus" value="HAS_CONTRACT"> 계약중</label>
					        <label class="ml-3"><input type="radio" name="supplierStatus" value="NO_CONTRACT"> 미계약</label>
					    </div>
			   		</div>
				
				    <!-- 공급업체 테이블 -->
				    <table id="supplierTable" class="table table-bordered">
				        <thead>
				            <tr>
				            	<th>업체 번호</th>
				                <th>공급업체명</th>
				                <th>계약 상태</th>
				                <th>상세보기</th>
				                <th>삭제</th>
				            </tr>
				        </thead>
				        <tbody>
				            <!-- JS로 렌더링 -->
				        </tbody>
				    </table>
				</div>
			    
			
			            
			       
			
			        
		
			</div>
			
			<!-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ -->
            
                 
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        </div>
    </section>
    
</body>
</html>