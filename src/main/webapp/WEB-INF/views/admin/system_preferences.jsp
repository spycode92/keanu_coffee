<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자페이지 - 조직 관리</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <link href="/resources/css/common/common.css" rel="stylesheet" />
    <script src="/resources/js/common/common.js"></script>
    <script src="/resources/js/admin/system_preferences/DeptTeamRole.js"></script>
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
                                    <button type="button" class="btn btn-sm btn-danger btn-delete-department">−</button>
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
        </div>
    </section>
    
</body>
</html>