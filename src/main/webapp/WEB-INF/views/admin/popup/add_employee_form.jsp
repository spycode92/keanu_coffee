<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 추가</title>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" >
<style>
input {
	background-color: gray;
}

form {
    display: flex;
    flex-direction: column;
    gap: 10px;
}
label {
    font-weight: bold;
}
input[type="text"], input[type="email"], input[type="password"] {
    padding: 5px;
    width: 250px;
}
input[type="submit"] {
    padding: 8px;
    background: #486f4a;
    color: white;
    border: none;
    cursor: pointer;
}
input[type="submit"]:hover {
    background: #45a049;
}
</style>
</head>
<body>
<h2>직원 추가</h2>
<form action="addEmployee" method="post">
    <label>이름</label>
    <input type="text" name="empName" required>

    <label>이메일</label>
    <input type="email" name="empEmail" required>

    <label>연락처</label>
    <input type="text" name="empPhone" required>
	
    <label>팀</label>
    <input type="text" name="empTeam">
    
    <label>직책</label>
    <input type="text" name="empPosition">

    <input type="submit" value="등록">
</form>
</body>
</html>