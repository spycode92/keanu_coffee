<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>조직 관리</title>
	<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="/resources/css/common/common.css" rel="stylesheet" />
    <script src="/resources/js/common/common.js"></script>
    <script src="/resources/js/admin/system_preferences/dept_team_role.js"></script>
    <sec:csrfMetaTags />
    <style>
        .grid-4 { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; }
        .list-group { list-style: none; margin: 0; padding: 0; }
        .list-group-item { padding: .75rem 1rem; border-bottom: 1px solid #e0e0e0; display: flex; justify-content: space-between; align-items: center; }
        .list-group-item:last-child { border-bottom: none; }
        /* 반응형 디자인 - 화면이 작을 때 */
		@media (max-width: 1200px) {
		    .grid-4 {
		        grid-template-columns: repeat(2, 1fr); /* 2개씩 배치 */
		    }
		}
		
		@media (max-width: 768px) {
		    .grid-4 {
		        grid-template-columns: 1fr; /* 모바일에서는 세로로 배치 */
		    }
		}
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp" />
    <section class="content">
        <div class="container">
            <h3 class="mt-4 mb-0">조직 관리</h3>
            <div class="grid-4">
                <!-- 부서 리스트 -->
                <div class="card h-100">
                    <div class="card-header">
                        <span>부서 리스트</span>
                        <sec:authorize access="hasAnyAuthority('ADMIN_SYSTEM')">
                        	<button type="button" id="btnAddDepartment" class="btn btn-sm btn-primary">+</button>
                        </sec:authorize>
                    </div>
                    <ul id="departmentList" class="list-group">
                        <c:forEach items="${departmentList}" var="department">
                            <li class="list-group-item department-item"
                                data-departmentidx="${department.departmentIdx}">
                                <span class="department-name">${department.departmentName}</span>
                                <sec:authorize access="hasAnyAuthority('ADMIN_SYSTEM')">
	                                <div>
	                                    <button type="button" class="btn btn-sm btn-secondary btn-edit-department">
                                        	<i class="fa-solid fa-pen"></i>
                                        </button>
	                                    <button type="button" class="btn btn-sm btn-destructive btn-delete-department">
	                                        <i class="fa-solid fa-trash"></i>
	                                    </button>
	                                </div>
	                            </sec:authorize>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
                <!-- 팀 리스트 -->
                <div class="card h-100">
                    <div class="card-header">
                        <span>팀 리스트</span>
                        <button type="button" id="btnAddTeam" class="btn btn-sm btn-primary" disabled>+</button>
                    </div>
                    <ul id="teamList" class="list-group">
                        <!-- 선택된 부서의 팀 목록 -->
                    </ul>
                </div>
                <!-- 직책 리스트 -->
                <div class="card h-100">
                    <div class="card-header">
                        <span>직책 리스트</span>
                        <button type="button" id="btnAddRole" class="btn btn-sm btn-primary" disabled>+</button>
                    </div>
                    <ul id="roleList" class="list-group">
                        <!-- 선택된 팀의 직책 목록 -->
                    </ul>
                </div>
                <!-- 권한 리스트 -->
                <div class="card h-100">
                    <div class="card-header">
                        <span>권한 리스트</span>
                        <sec:authorize access="hasAnyAuthority('ADMIN_SYSTEM')">
                        	<button type="button" id="btnAddAutho" class="btn btn-sm btn-primary" >+</button>
                        </sec:authorize>
                        <button type="button" id="btnSaveAutho" class="btn btn-sm btn-primary" disabled >저장</button>
                    </div>
                    <ul id="authoList" class="list-group">
                        <!-- 선택된 직책의 권한 목록 -->
                        <c:forEach var="autho" items="${authorityList }">
	                        <li class="list-group-item d-flex justify-content-between align-items-center autho-item" data-authoidx="${autho.commonCodeIdx}">
	                        	<input type="checkbox" value="${autho.commonCodeIdx }" name="commonCodeName">
   	                            <span >${autho.commonCodeName}</span>
   	                            
								<div>
									<button type="button"  class="btn btn-sm btn-secondary btn-edit-autho"
										data-authoidx="${autho.commonCodeIdx}" data-authoname="${autho.commonCodeName }">
											<i class="fa-solid fa-pen"></i>
									</button> 
	                            	<button type="button"  class="btn btn-sm btn-danger btn-delete-autho" 
	                            		data-authoidx="${autho.commonCodeIdx}" data-authoname="${autho.commonCodeName }">
	                            		<i class="fa-solid fa-trash"></i>	
                            		</button>
								</div>
	                        </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </section>
</body>
</html>