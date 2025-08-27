<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자페이지 - 조직 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="/resources/css/common/common.css" rel="stylesheet" />
    <script src="/resources/js/common/common.js"></script>
    <script src="/resources/js/admin/system_preferences/dept_team_role.js"></script>
    <style>
        .grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; }
        .list-group { list-style: none; margin: 0; padding: 0; }
        .list-group-item { padding: .75rem 1rem; border-bottom: 1px solid #e0e0e0; display: flex; justify-content: space-between; align-items: center; }
        .list-group-item:last-child { border-bottom: none; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/top.jsp" />
    <section class="content">
        <div class="container">
            <h4 class="mt-4 mb-3"><i class="fas fa-users"></i> 조직 관리</h4>
            <div class="grid-3">
                <!-- 부서 리스트 -->
                <div class="card h-100">
                    <div class="card-header">
                        <span>부서 리스트</span>
                        <button type="button" id="btnAddDepartment" class="btn btn-sm btn-primary">+</button>
                    </div>
                    <ul id="departmentList" class="list-group">
                        <c:forEach items="${departmentList}" var="department">
                            <li class="list-group-item department-item"
                                data-departmentidx="${department.departmentIdx}">
                                <span class="department-name">${department.departmentName}</span>
                                <div>
                                    <button type="button"
                                            class="btn btn-sm btn-secondary btn-edit-department">✎</button>
                                    <button type="button"
                                            class="btn btn-sm btn-destructive btn-delete-department">−</button>
                                </div>
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
            </div>
        </div>
    </section>
</body>
</html>