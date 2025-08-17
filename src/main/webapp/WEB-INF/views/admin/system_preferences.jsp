<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자페이지 - 조직 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="/resources/css/common/common.css" rel="stylesheet" />
    <script src="/resources/js/common/common.js"></script>
    <script src="/resources/js/admin/system_preferences/dept_team_role.js"></script>
    <script src="/resources/js/admin/system_preferences/supplier_manage.js"></script>
    <style>
        .department-item.active,
        .team-item.active,
        .position-item.active {
            background-color: var(--primary);
            color: var(--primary-foreground);
            font-weight: var(--font-weight-medium);
        }
        #departmentList,
		#teamList,
		#positionList {
		    max-height: 150px; /* 대략 3개 항목 높이 */
		    overflow-y: auto;
		    overflow-x: hidden; /* 가로 스크롤 방지 */
		}
		
		#supplierModal .modal-content,
		#contractDetailModal .modal-content {
		    background-color: #f5f1e9 !important; /* 부드러운 베이지색 */
		    color: #000 !important; /* 글자색 검정 */
		}
		
		#supplierModal label,
		#contractDetailModal label,
		#supplierModal input.form-control,
		#contractDetailModal input.form-control,
		#supplierModal textarea.form-control,
		#contractDetailModal textarea.form-control,
		#supplierModal select.form-select,
		#contractDetailModal select.form-select {
		    color: #000 !important;
		}
		
		#supplierModal .btn,
		#contractDetailModal .btn {
		    color: #000 !important;
		}
		
		#supplierModal .modal-title,
		#contractDetailModal .modal-title {
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
	
		
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
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
            
            <!-- ---------------------------------------------------------------------------------------------- -->
            <!-- 거래처관리 -->
            <div class="container mt-4">
	            <h4 class="mt-4 mb-3"><i class="fas fa-users"></i>공급계약 관리</h4>
			    <div class="row">
			        <!-- 공급업체 리스트 -->
			        <div class="col-md-4">
			            <div class="card h-100">
			                <div class="card-header d-flex justify-content-between align-items-center">
			                    <span>공급업체</span>
			                    <button type="button" id="btnAddSupplier" class="btn btn-sm btn-primary">추가</button>
			                </div>
			                <ul id="supplierList" class="list-group list-group-flush" style="overflow-y: auto; max-height: 500px;">
			                    <!-- 공급업체 리스트 동적 생성 -->
			                </ul>
			            </div>
			        </div>
			        <!-- 공급계약 리스트 -->
			        <div class="col-md-4">
			            <div class="card h-100">
			                <div class="card-header d-flex justify-content-between align-items-center">
			                    <span>공급계약 리스트</span>
			                    <button type="button" id="btnAddContract" class="btn btn-sm btn-primary" disabled>추가</button>
			                </div>
			                <ul id="contractList" class="list-group list-group-flush" style="overflow-y: auto; max-height: 500px;">
			                    <!-- 계약 리스트 동적 생성 -->
			                </ul>
			            </div>
			        </div>
			        <!-- 계약 상세보기 모달은 별도 위치에 존재하며, 모달로 화면과 겹치므로 따로 칸에 포함하지 않습니다 -->
			    </div>
			    
			    <!-- 공급업체 추가/수정용 모달 -->
				<div class="modal fade" id="supplierModal" tabindex="-1" aria-labelledby="supplierModalLabel" aria-hidden="true">
				    <div class="modal-dialog">
				        <form id="supplierForm">
				            <div class="modal-content">
				                <div class="modal-header">
				                    <h5 class="modal-title" id="supplierModalLabel">공급업체 등록</h5>
				                    <button type="button" class="btn-close" data-dismiss="modal" aria-label="닫기"></button>
				                </div>
				                <div class="modal-body">
				                    <div class="mb-3">
				                        <label for="companyName" class="form-label">업체명</label>
				                        <input type="text" class="form-control" id="companyName" name="companyName" required />
				                    </div>
				                    <div class="mb-3">
				                        <label for="contactPerson" class="form-label">담당자명</label>
				                        <input type="text" class="form-control" id="contactPerson" name="contactPerson" />
				                    </div>
				                    <div class="mb-3">
				                        <label for="phoneNumber" class="form-label">연락처</label>
				                        <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" />
				                    </div>
				                    <div class="mb-3">
				                        <label for="address" class="form-label">주소</label>
				                        <input type="text" class="form-control" id="address" name="address" />
				                    </div>
				                    <div class="mb-3">
				                        <label for="note" class="form-label">비고</label>
				                        <textarea class="form-control" id="note" name="note" rows="3"></textarea>
				                    </div>
				                </div>
				                <div class="modal-footer">
				                    <button type="button" class="btn btn-secondary btn-custom-cancel"  data-dismiss="modal" >취소</button>
				                    <button type="submit" class="btn btn-primary">저장</button>
				                </div>
				            </div>
				        </form>
				    </div>
				</div>
			    
			
			    <!-- 계약 상세보기 모달 -->
			    <div class="modal fade" id="contractDetailModal" tabindex="-1" aria-labelledby="contractDetailModalLabel" aria-hidden="true">
			        <div class="modal-dialog">
			            <form id="contractDetailForm">
			                <div class="modal-content">
			                    <div class="modal-header">
			                        <h5 class="modal-title" id="contractDetailModalLabel">계약 상세정보</h5>
			                        <button type="button" class="btn-close" data-dismiss="modal" aria-label="닫기"></button>
			                    </div>
			                    <div class="modal-body">
			                        <input type="hidden" id="modalContractIdx" name="contractIdx" />
			                        <input type="hidden" id="modalSupplierIdx" name="supplierIdx" />
			                        <div class="mb-3">
			                            <label for="modalProductName" class="form-label">상품명</label>
			                            <input type="text" class="form-control" id="modalProductName" name="productName" readonly />
			                        </div>
			                        <div class="mb-3">
			                            <label for="modalContractPrice" class="form-label">계약 단가</label>
			                            <input type="number" class="form-control" id="modalContractPrice" name="contractPrice" required />
			                        </div>
			                        <div class="mb-3">
			                            <label for="modalContractStart" class="form-label">계약 시작일</label>
			                            <input type="date" class="form-control" id="modalContractStart" name="contractStart" required />
			                        </div>
			                        <div class="mb-3">
			                            <label for="modalContractEnd" class="form-label">계약 종료일</label>
			                            <input type="date" class="form-control" id="modalContractEnd" name="contractEnd" required />
			                        </div>
			                        <div class="mb-3">
			                            <label for="modalMinOrderQuantity" class="form-label">최소 발주 수량</label>
			                            <input type="number" class="form-control" id="modalMinOrderQuantity" name="minOrderQuantity" min="0" />
			                        </div>
			                        <div class="mb-3">
			                            <label for="modalMaxOrderQuantity" class="form-label">최대 발주 수량</label>
			                            <input type="number" class="form-control" id="modalMaxOrderQuantity" name="maxOrderQuantity" min="0" />
			                        </div>
			                        <div class="mb-3">
			                            <label for="modalStatusSelect" class="form-label">계약 상태</label>
			                            <select class="form-select" id="modalStatusSelect" name="status" required>
			                                <option value="활성">활성</option>
			                                <option value="비활성">비활성</option>
			                                <option value="대기">대기</option>
			                            </select>
			                        </div>
			                        <div class="mb-3">
			                            <label for="modalNotes" class="form-label">비고</label>
			                            <textarea class="form-control" id="modalNotes" name="notes" rows="3"></textarea>
			                        </div>
			                    </div>
			                    <div class="modal-footer">
			                        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
			                        <button type="submit" class="btn btn-primary">저장</button>
			                    </div>
			                </div>
			            </form>
			        </div>
			    </div>
			</div>
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        </div>
    </section>
    
</body>
</html>