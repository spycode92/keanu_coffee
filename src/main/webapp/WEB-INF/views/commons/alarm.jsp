<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림</title>
<sec:csrfMetaTags/>
<style type="text/css">
	.read-status {
	    font-size: 12px;
	    color: #888;
	    margin-left: 10px;
	}
	.no-notification {
	    text-align: center;
	    color: #999;
	    padding: 10px;
	}
	.noti-messages {
	  flex: 1;
	  white-space: nowrap;
	  overflow: hidden;
	  text-overflow: ellipsis;
	  color: var(--foreground);
	}
	/* 페이징(.pager: 앞서 만든 공용 클래스가 있다면 그대로 사용) */
	.pager{
	  	display:flex;
	  	align-items:center;
	  	justify-content:center;
	  	margin-top:24px; /* 기존 30px에서 약간 컴팩트 */
	}
	.pager > div{
	  	display:flex;
	  	align-items:center;
	  	flex-wrap:wrap;
	  	gap:8px;
	}
	.pager > div a,
	.pager > div input[type="button"],
	.pager > div strong{
		display:inline-flex;
	  	align-items:center;
	  	justify-content:center;
	  	min-width:36px;
	  	height:36px;
	  	padding:0 12px;
	  	border:1px solid #cbd5e1;
	  	border-radius:8px;
	  	background:#fff;
	  	color:#0f172a;
	  	text-decoration:none;
	  	font-size:.95rem;
	  	line-height:1;
	  	transition:background .12s ease, border-color .12s ease, color .12s ease, box-shadow .12s ease;
	}
	.pager > div a:hover,
	.pager > div input[type="button"]:not([disabled]):hover{ background:#f8fafc; border-color:#94a3b8; }
	.pager > div input[disabled]{ opacity:.45; pointer-events:none; cursor:not-allowed; }
	.pager > div strong{
	  background:#2563eb; border-color:#2563eb; color:#fff; cursor:default;
	}
</style>
<!-- 기본 양식 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/common/common.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/common/common.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>
<body>
<!-- 기본양식 -->
<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 

<section class="content">
	<div class="card">
	    <div class="card-header d-flex justify-content-between align-items-center">
		    <h3 class="card-title mb-0">알림 목록</h3>
		    <button class="btn btn-primary btn-sm" onclick="markAllAsRead()">
		        전체읽음
		    </button>
		</div>
	    <div class="card-body p-0">
	        <div class="overflow-auto">
	            <table class="table">
	                <thead>
	                    <tr>
	                        <th style="width:15%;">시간</th>
	                        <th>알림 메세지</th>
	                        <th style="width:15%;">상태</th>
	                        <th style="width:10%;">이동</th>
	                    </tr>
	                </thead>
	                <tbody>
	                    <c:forEach var="alarm" items="${alarmList}">
	                        <tr class="alarm-row" data-idx="${alarm.alarmIdx}" style="cursor: pointer;">
	                            <td class="text-muted">
	                            	<input type="hidden" >
								    <fmt:formatDate value="${alarm.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
								</td>
	                            <td>
	                                <span class="noti-messages">${alarm.empAlarmMessage}</span>
	                            </td>
	                            <td>
	                                <c:if test="${alarm.empAlarmReadStatus == 1}">
	                                    <span class="badge badge-urgent">안읽음</span>
	                                </c:if>
	                                <c:if test="${alarm.empAlarmReadStatus == 0}">
	                                    <span class="badge badge-confirmed">읽음</span>
	                                </c:if>
	                            </td>
	                            <td>
	                                <button class="link-btn btn btn-sm ${empty alarm.empAlarmLink ? 'btn-secondary' : 'btn-primary'}"
	                                        onclick="link(this)" data-url="${alarm.empAlarmLink }" data-idx="${alarm.alarmIdx }"
	                                        ${empty alarm.empAlarmLink ? 'disabled' : ''}>
	                                    이동
	                                </button>
	                            </td>
	                        </tr>
	                    </c:forEach>
	                </tbody>
	            </table>
	        </div>
	    </div>
	</div>
	<jsp:include page="/WEB-INF/views/inc/pagination.jsp">
		<jsp:param value="/alarm" name="pageUrl"/>
	</jsp:include>
</section>
<script type="text/javascript">
	//전체 읽음
	function markAllAsRead(){
		ajaxPost("/alarm/readAll").then((result)=>{
			swal.fire(result.message,result.title,result.icon).then(()=>{
				window.location.reload();
			})
		});
	}
	
	function link(button){
		const alarmIdx = button.getAttribute('data-idx');
		const url = button.getAttribute('data-url');
		ajaxPost("/alarm/status/" + alarmIdx + "/read").then(()=>{
			if (url && url.trim() !== '') {
		        window.location.href = url;
		    }
		})
	}
	
	// 화면에서 알림 상태 업데이트
	function updateAlarmStatus(alarmIdx) {
	    const row = document.querySelector('tr[data-idx="' + alarmIdx + '"]');
	    if (row) {
	        const statusCell = row.querySelector('td:nth-child(3)');
	        const badge = statusCell.querySelector('.badge');
	        if (badge && badge.classList.contains('badge-urgent')) {
	            badge.classList.remove('badge-urgent');
	            badge.classList.add('badge-confirmed');
	            badge.textContent = '읽음';
	        }
	    }
	}
	
	
	// 페이지 로드 후 이벤트 리스너 등록
	document.addEventListener('DOMContentLoaded', function() {
	    // 모든 알림 행에 클릭 이벤트 추가
	    const alarmRows = document.querySelectorAll('.alarm-row');
	    alarmRows.forEach(row => {
	        row.addEventListener('click', function(event) {
	            // 버튼 클릭 시에는 행 클릭 이벤트가 실행되지 않도록 방지
	            if (event.target.closest('button')) {
	                return;
	            }
	            
	            const alarmIdx = this.getAttribute('data-idx');
	            ajaxPost("/alarm/status/" + alarmIdx + "/read").then(()=>{
	            	updateAlarmStatus(alarmIdx);
	            })
	        });
	    });
	});
</script>

</div>
</body>
</html>