<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>재고 이동 현황</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<link rel="icon" href="${pageContext.request.contextPath}/resources/images/keanu_favicon.ico">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<style>
    .hidden { display: none; }
    .status-normal { color: green; }
    .status-need { color: red; font-weight: bold; }
    
    .tab {
    	display: flex;
    	align-items: center;
    	justify-content: space-between;
    	margin-bottom: 0.3em;
    }
</style>
</head>
<body>

	<!-- 상단/사이드 레이아웃 -->
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	
	<div class="content">
        <h2 class="page-title">재고 이동 현황</h2>

        <!-- 탭 버튼 -->
        <div class="btn-group interval tab">
        	<div>
	            <button type="button" id="btnPallet" class="btn btn-primary">파레트존 이동 대상</button>
	            <button type="button" id="btnPicking" class="btn btn-secondary">피킹존 보충 대상</button>
        	</div>
        	<div>
	            <button type="button" class="btn btn-primary" onclick="location.href='/inventory/moveInventory'">재고이동</button>
        	</div>
        </div>

        <!-- 파레트존 -->
        <div id="palletZone" class="card">
            <div class="card-header">
                <h3 class="card-title">파레트존 이동 목록</h3>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>상품코드</th>
                                <th>LOT번호</th>
                                <th>수량</th>
                            </tr>
                        </thead>
                        <tbody id="palletBody">
                            <!-- AJAX 로드 -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 피킹존 -->
		<div id="pickingZone" class="card hidden">
		    <div class="card-header">
		        <h3 class="card-title">피킹존 보충 필요 목록</h3>
		    </div>
		    <div class="card-body">
		        <div class="table-responsive">
		            <table class="table">
		                <thead>
		                    <tr>
		                        <th>상품코드</th>
		                        <th>적정재고(100%)</th>
		                        <th>현재 재고</th>
		                        <th>부족 수량</th>
		                        <th>상태</th>
		                    </tr>
		                </thead>
		                <tbody id="pickingBody">
		                    <!-- AJAX 로드 -->
		                </tbody>
		            </table>
		        </div>
		    </div>
		</div>
    </div>
    
    <script>
	$(function(){
	    // 기본: 파레트존 활성화
	    $("#palletZone").show();
	    $("#pickingZone").hide();
	    loadPallet();

	    // 버튼 이벤트
	    $("#btnPallet").click(function(){
	        $("#palletZone").show();
	        $("#pickingZone").hide();
	        $(this).addClass("btn-primary").removeClass("btn-secondary");
	        $("#btnPicking").addClass("btn-secondary").removeClass("btn-primary");
	        loadPallet();
	    });
	    $("#btnPicking").click(function(){
	        $("#palletZone").hide();
	        $("#pickingZone").show();
	        $(this).addClass("btn-primary").removeClass("btn-secondary");
	        $("#btnPallet").addClass("btn-secondary").removeClass("btn-primary");
	        loadPicking();
	    });
	});

	// ✅ 파레트존 조회
	function loadPallet(){
	    $.getJSON("${pageContext.request.contextPath}/inventory/transfer/pallet", function(data){
	        let html = "";
	        if(data.length === 0){
	            html = "<tr><td colspan='3'>파레트존 재고가 없습니다.</td></tr>";
	        } else {
	            $.each(data, function(i, item){
	                html += "<tr>"
	                      + "<td>"+item.productIdx+"</td>"
	                      + "<td>"+(item.lotNumber || '-')+"</td>"
	                      + "<td>"+item.quantity+"</td>"
	                      + "</tr>";
	            });
	        }
	        $("#palletBody").html(html);
	    });
	}

	// ✅ 피킹존 조회
	function loadPicking(){
	    $.getJSON("${pageContext.request.contextPath}/inventory/transfer/picking", function(data){
	        let list = data.pickingList || [];
	        let targetMap = data.targetMap || {};
	        let html = "";
	
	        if(list.length === 0){
	            html = "<tr><td colspan='5'>보충할 재고가 없습니다.</td></tr>";
	        } else {
	            $.each(list, function(i, item){
	                let target = targetMap[item.productIdx] || "-";
	                let shortage = (target !== "-" ? Math.max(0, target - item.quantity) : "-");
	                let status = (target !== "-" && item.quantity < target*0.8)
	                           ? "<span class='status-need'>보충 필요</span>"
	                           : "<span class='status-normal'>정상</span>";
	
	                // ⚠️ 보충 필요인 항목만 표시
	                if(status.includes("보충 필요")){
	                    html += "<tr>"
	                          + "<td>"+item.productIdx+"</td>"
	                          + "<td>"+target+"</td>"
	                          + "<td>"+item.quantity+"</td>"
	                          + "<td>"+shortage+"</td>"
	                          + "<td>"+status+"</td>"
	                          + "</tr>";
	                }
	            });
	
	            if(html === ""){
	                html = "<tr><td colspan='5'>보충할 재고가 없습니다.</td></tr>";
	            }
	        }
	        $("#pickingBody").html(html);
	    });
	}
	</script>
</body>
</html>