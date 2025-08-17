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
    <script src="/resources/js/admin/system_preferences/dept_team_role.js"></script>
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
		
		.list-group-item {
			padding-right: 0;
		}
		
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/admin/preference_modal/add_supplier.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/admin/preference_modal/detail_supplier.jsp"></jsp:include>
    <section class="content">
        <div class="container">
            <h4 class="mt-4 mb-3"><i class="fas fa-users"></i> 조직 관리</h4>
            <div class="row">
                <!-- 부서 리스트 -->
                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <span>부서 리스트</span>
                            <button type="button" id="btnAddDepartment" class="btn btn-sm btn-primary">+</button>
                        </div>
                        <ul id="departmentList" class="list-group list-group-flush" style="background-color: #5f7179;">
                            <c:forEach items="${departmentList}" var="department">
                                <li class="list-group-item d-flex justify-content-between align-items-center department-item" style="color: black;" data-departmentidx="${department.idx}">
                                    <span class="department-name" >${department.departmentName}</span>
                                    <div>
	                                    <button type="button" class="btn btn-sm btn-secondary btn-edit-department">✎</button> 
	                                    <button type="button" class="btn btn-sm btn-danger btn-delete-department">−</button>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
                <!-- 팀 리스트 -->
                <div class="col-md-4">
                	<div class="card h-100">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <span>팀 리스트</span>
                            <button type="button" id="btnAddTeam" class="btn btn-sm btn-primary" disabled>+</button>
                        </div>
                        <ul id="teamList" class="list-group list-group-flush">
                            <!-- 선택된 부서의 팀 목록이 로드됨 -->
                        </ul>
                    </div>
                </div>
                <!-- 직책 리스트 -->
                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <span>직책 리스트</span>
                            <button type="button" id="btnAddRole" class="btn btn-sm btn-primary" disabled>+</button>
                        </div>
                        <ul id="roleList" class="list-group list-group-flush">
                            <!-- 선택된 팀의 직책 목록이 로드됨 -->
                        </ul>
                    </div>
                </div>
            </div>
            <!-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ -->
			<div class="container mt-4">
			    <!-- 제목 -->
			    <h4 class="mb-4">공급계약 관리</h4>
			
			    <div class="row">
			        <!-- 좌측: 공급업체, 상품 관리 (조직관리 좌측 두 칸 크기 동일) -->
			        <div class="col-md-4">
			            <!-- 공급업체 카드 -->
			            <div class="card mb-4">
			                <div class="card-header d-flex justify-content-between align-items-center">
			                    <span>공급업체</span>
			                    <button type="button" id="btnAddSupplier" class="btn btn-sm btn-primary">+</button>
			                </div>
			                <div class="mb-2">
							    <label class="mr-2"><input type="radio" name="supplierStatus" value="ALL" checked>전체</label>
							    <label class="mr-2"><input type="radio" name="supplierStatus" value="HAS_CONTRACT">계약중</label>
							    <label class="mr-2"><input type="radio" name="supplierStatus" value="NO_CONTRACT">미계약</label>
							</div>
			                <ul id="supplierList" class="list-group list-group-flush" style="max-height: 150px; overflow-y: auto;">
								<!-- 공급업체리스트표시 -->
			                </ul>
			            </div>
			
			            <!-- 상품 카드 -->
			            <div class="card">
			                <div class="card-header d-flex justify-content-between align-items-center">
			                    <span>상품</span>
			                    <button type="button" id="btnAddProduct" class="btn btn-sm btn-primary">+</button>
			                </div>
			                <ul id="productList" class="list-group list-group-flush" style="max-height: 150px; overflow-y: auto;">
   			                    <c:forEach var="product" items="${productList }">
			                    	<li>${product.productName }</li>
			                    </c:forEach>
			                </ul>
			            </div>
			        </div>
			
			        <!-- 우측: 계약 리스트 (조직관리 우측 한 칸 크기 동일) -->
			        <div class="col-md-8">
			            <div class="card h-100">
			                <div class="card-header d-flex justify-content-between align-items-center">
			                    <span>공급계약</span>
			                    <button type="button" id="btnAddContract" class="btn btn-sm btn-primary">+</button>
			                </div>
			                <div class="table-responsive mt-3" style="max-height: 300px; overflow-y: auto;">
			                    <table class="table" id="contractTable">
			                        <thead>
			                            <tr>
			                                <th>공급업체</th>
			                                <th>상품명</th>
			                                <th>계약단가</th>
			                                <th>계약기간</th>
			                                <th>상태</th>
			                            </tr>
			                        </thead>
			                        <tbody>
			                            <c:forEach var="contract" items="${supplyContractList}">
			                            
			            	            	<tr>
												<td>${contract.supplierName }</td>
												<td>${contract.productName }</td>
												<td>${contract.contractPrice }</td>
												<td>${contract.contractStart } ~ ${contract.contractEnd }</td>
												<td>${contract.status }</td>
											</tr>		                            	
			                            </c:forEach>
			                        </tbody>
			                    </table>
			                </div>
			            </div>
			        </div>
			    </div>
			</div>
			
			<!-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ -->
            
                 
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        </div>
    </section>
    
</body>
</html>