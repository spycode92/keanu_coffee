<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자페이지</title>
<!-- 기본 양식 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<link href="/resources/css/common/common.css" rel="stylesheet">
<script src="/resources/js/common/common.js"></script>
<style type="text/css">
	.list-group-item{
	    position: relative;
	    display: block;
	    padding: .75rem 1.25rem;
	    background-color: #999090;
	    border: 1px solid rgba(0, 0, 0, .125);
	}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
<section class="content">
  <div class="container">

    <!-- 사용자 권한 관리 그룹 -->
    <h4 class="mb-3"><i class="fas fa-user-shield"></i> 사용자 권한 관리</h4>
    <div class="row">
      <div class="col-md-4">
        <div class="card h-100">
          <div class="card-header d-flex justify-content-between align-items-center">
            <span>권한관리</span>
            <div>⊕ ⊖</div>
          </div>
          <div class="card-body">
            <p class="bg-success text-white p-2">운송관리자</p>
            <p>입고관리자</p>
            <p>출고관리자</p>
            <p>재고관리자</p>
          </div>
        </div>
      </div>

      <div class="col-md-8">
        <div class="card h-100">
          <div class="card-header">부여권한</div>
          <div class="card-body">
            <div class="form-group">
              <label>입고관리</label>
              <select class="form-control">
                <option>null</option>
                <option>read only</option>
                <option>write</option>
              </select>
            </div>
            <div class="form-group">
              <label>출고관리</label>
              <select class="form-control">
                <option>null</option>
                <option>read only</option>
                <option>write</option>
              </select>
            </div>
            <div class="form-group">
              <label>재고관리</label>
              <select class="form-control">
                <option>null</option>
                <option>read only</option>
                <option>write</option>
              </select>
            </div>
            <div class="form-group">
              <label>운송관리</label>
              <select class="form-control">
                <option>null</option>
                <option>read only</option>
                <option>write</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 조직 관리 -->
    <h4 class="mt-4 mb-3"><i class="fas fa-users"></i> 조직 / 지점 관리</h4>
    <div class="row">
      <div class="col-md-6">
        <div class="card h-100">
          <div class="card-header d-flex justify-content-between">
            <span>팀관리</span>
            <div>⊕ ⊖</div>
          </div>
          <div class="card-body">
            <p>입고팀</p>
            <p>출고팀</p>
            <p>운송팀</p>
            <p>재고팀</p>
          </div>
        </div>
      </div>
      
      <div class="col-md-6">
        <div class="card h-100">
          <div class="card-header d-flex justify-content-between">
            <span>지점등록</span>
            <div>⊕ ⊖</div>
          </div>
          <div class="card-body">
            <p>부산1지점</p>
            <p>부산2지점</p>
            <p>부산3지점</p>
          </div>
        </div>
      </div>
    </div>

<h4 class="mt-4 mb-3"><i class="fas fa-building"></i> 거래처 관리</h4>
<div class="row">
    <!-- 왼쪽: 거래처 목록 -->
    <div class="col-md-4">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <span><b>거래처 목록</b></span>
            <button id="addClientBtn" class="btn btn-sm btn-primary">+ 추가</button>
        </div>
        <div class="list-group" id="clientList">
            <button class="list-group-item list-group-item-action active" data-client="client1">
                거래처 A <span class="text-danger float-right del-client">✖</span>
            </button>
            <button class="list-group-item list-group-item-action" data-client="client2">
                거래처 B <span class="text-danger float-right del-client">✖</span>
            </button>
            <button class="list-group-item list-group-item-action" data-client="client3">
                거래처 C <span class="text-danger float-right del-client">✖</span>
            </button>
        </div>
    </div>

    <!-- 오른쪽: 선택한 거래처 상세 -->
    <div class="col-md-8">
        <div class="card">
            <div class="card-header" id="clientTitle">거래처 A 정보</div>
            <div class="card-body">
                <form id="clientForm">
                    <div class="form-group">
                        <label>담당자</label>
                        <input type="text" class="form-control" id="managerName">
                    </div>
                    <div class="form-group">
                        <label>주소</label>
                        <input type="text" class="form-control" id="clientAddress">
                    </div>
                    <div class="form-group">
                        <label>전화번호</label>
                        <input type="text" class="form-control" id="clientPhone">
                    </div>
                    <div class="text-right">
                        <button type="button" id="saveClient" class="btn btn-success">저장</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<h4 class="mt-5 mb-3"><i class="fas fa-cog"></i> 배송 경로 설정</h4>
<div class="row">
  <!-- 왼쪽: 구역 목록 -->
  <div class="col-md-4">
    <div class="d-flex justify-content-between align-items-center mb-2">
      <span><b>구역 목록</b></span>
      <button id="addZoneBtn" class="btn btn-sm btn-primary">+ 추가</button>
    </div>
    <div class="list-group" id="zoneList">
      <button class="list-group-item list-group-item-action active" data-zone="zone1">
        1구역 <span class="text-danger float-right del-zone">✖</span>
      </button>
      <button class="list-group-item list-group-item-action" data-zone="zone2">
        2구역 <span class="text-danger float-right del-zone">✖</span>
      </button>
      <button class="list-group-item list-group-item-action" data-zone="zone3">
        3구역 <span class="text-danger float-right del-zone">✖</span>
      </button>
    </div>
  </div>

  <!-- 오른쪽: 선택한 구역 경로 -->
  <div class="col-md-8">
    <div class="card">
      <div class="card-header" id="zoneTitle">1구역 경로</div>
      <div class="card-body">
        <ul id="routeList" class="list-group"></ul>
        <div class="mt-3 text-right">
          <button id="saveRoute" class="btn btn-success btn-sm">순서 저장</button>
        </div>
      </div>
    </div>
    <div class="mt-3 text-right">
      <button id="saveRouteBtn" class="btn btn-success">전체 경로 저장</button>
    </div>
  </div>
</div>
	
	</div>
<script>
	$(function(){
	    // 위로 이동
	    $(document).on('click', '.up', function(){
	        let li = $(this).closest('li');
	        li.prev().before(li);
	    });
	
	    // 아래로 이동
	    $(document).on('click', '.down', function(){
	        let li = $(this).closest('li');
	        li.next().after(li);
	    });
	
	    // 저장
	    $('#saveRouteBtn').click(function(){
	        let allData = {};
	        $('.route-list').each(function(){
	            let zoneId = $(this).attr('id');   // zone1, zone2 ...
	            let order = [];
	            $(this).find('li').each(function(){
	                order.push($(this).contents().get(0).nodeValue.trim());
	            });
	            allData[zoneId] = order;
	        });
	        console.log('구역별 경로:', allData);
	        alert('구역별 경로가 저장되었습니다.');
	        // Ajax로 allData 서버 전송 가능
	    });
	    
	    // 샘플 데이터
	    let zoneCount = 3;
	    const routeData = {
	        zone1: ["서울", "인천", "수원"],
	        zone2: ["부산", "대구", "울산"],
	        zone3: ["광주", "전주", "목포"]
	    };

	    // 구역 로딩
	    loadZoneRoute("zone1");

	    // 구역 클릭
	    $("#zoneList").on("click", "button", function(e){
	        // 삭제 버튼 클릭 시 이벤트 분리 처리
	        if ($(e.target).hasClass("del-zone")) return;

	        $("#zoneList button").removeClass("active");
	        $(this).addClass("active");
	        loadZoneRoute($(this).data("zone"));
	    });

	    // 경로 목록 로드
	    function loadZoneRoute(zoneId) {
	        $("#zoneTitle").text(zoneId.replace('zone','') + "구역 경로");
	        const list = $("#routeList");
	        list.empty();
	        (routeData[zoneId] || []).forEach(name => {
	            list.append(`
	                <li class="list-group-item d-flex justify-content-between align-items-center">
	                    \${name}
	                    <span>
	                        <button class="btn btn-sm btn-light up">▲</button>
	                        <button class="btn btn-sm btn-light down">▼</button>
	                    </span>
	                </li>
	            `);
	        });
	        list.data("zone", zoneId);
	    }

	    // 순서 변경
	    $("#routeList").on("click", ".up", function(){
	        const li = $(this).closest("li");
	        li.prev().before(li);
	    });
	    $("#routeList").on("click", ".down", function(){
	        const li = $(this).closest("li");
	        li.next().after(li);
	    });

	    // 현재 구역 순서 저장
	    $("#saveRoute").click(function(){
	        const zoneId = $("#routeList").data("zone");
	        const newOrder = [];
	        $("#routeList li").each(function(){
	            newOrder.push($(this).contents().get(0).nodeValue.trim());
	        });
	        routeData[zoneId] = newOrder;
	        alert(zoneId + " 순서 저장 완료");
	    });

	    // 전체 저장
	    $("#saveRouteBtn").click(function(){
	        console.log("전체 경로 데이터", routeData);
	        alert("전체 경로가 저장되었습니다.");
	    });
		
	    //구역추가
	    $("#addZoneBtn").click(function(){
	        let zoneName = prompt("새 구역 이름을 입력하세요:");
	        if(!zoneName) return; // 입력 안 하면 종료

	        // zoneId는 내부 데이터 키, zoneName은 화면 표시용
	        const newZoneId = "zone" + (++zoneCount);
	        routeData[newZoneId] = [];

	        $("#zoneList").append(`
	            <button class="list-group-item list-group-item-action" data-zone="\${newZoneId}">
	                \${zoneName} <span class="text-danger float-right del-zone">✖</span>
	            </button>
	        `);
	    });

	    // 구역 삭제
	    $("#zoneList").on("click", ".del-zone", function(e){
	        e.stopPropagation(); // 클릭 버블 방지
	        const parentBtn = $(this).closest("button");
	        const zoneId = parentBtn.data("zone");

	        if (confirm(zoneId + "를 삭제하시겠습니까?")) {
	            delete routeData[zoneId];
	            parentBtn.remove();

	            // 삭제 후 첫 번째 구역 표시
	            const firstZoneBtn = $("#zoneList button").first();
	            if (firstZoneBtn.length) {
	                firstZoneBtn.addClass("active");
	                loadZoneRoute(firstZoneBtn.data("zone"));
	            } else {
	                $("#routeList").empty();
	                $("#zoneTitle").text("구역 경로");
	            }
	        }
	    });

	    
	});
</script>
</body>
</html>