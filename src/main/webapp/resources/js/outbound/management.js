(function($, w, d){
	'use strict';

	/* ========== 알림 ========== */
	function notify(type, msg){
		if(w.Swal && typeof w.Swal.fire === 'function'){
			var title = (type === 'success') ? '완료' : (type === 'warning' ? '경고' : '오류');
			w.Swal.fire({ icon: type, title: title, text: msg, confirmButtonText: '확인' });
		}else{
			w.alert(msg);
		}
	}
	var showSuccess = (m)=>notify('success', m);
	var showWarning = (m)=>notify('warning', m);
	var showError   = (m)=>notify('error',   m);

	/* ========== CSRF: meta만 사용 ========== */
	function getCsrfHeadersFromMeta(){
		var token  = $('meta[name="_csrf"]').attr('content');
		var header = $('meta[name="_csrf_header"]').attr('content');
		var h = {};
		if(token && header){ h[header] = token; }
		return h;
	}

	/* ========== AJAX 기본 헤더 ========== */
	$.ajaxSetup({
		headers: Object.assign({
			'Accept': 'application/json',
			'X-Requested-With': 'XMLHttpRequest'
		}, getCsrfHeadersFromMeta())
	});

	/* ========== HTML 오류 응답 방어 ========== */
	function isHtmlResponse(xhr){
		try{
			var ct = (xhr.getResponseHeader && xhr.getResponseHeader('Content-Type')) || '';
			if(ct && ct.toLowerCase().indexOf('text/html') >= 0) return true;
		}catch(e){}
		var body = (xhr && xhr.responseText) ? xhr.responseText : '';
		return /^\s*<!doctype html/i.test(body) || /<html[\s>]/i.test(body);
	}

	function handleAjaxFail(xhr){
		if(!xhr || typeof xhr.status === 'undefined' || xhr.status === 0){
			showError('네트워크 오류가 발생했습니다.');
			return;
		}
		if(isHtmlResponse(xhr)){
			var body = xhr.responseText || '';
			if(body.indexOf('해당 기능에 접근할 권한이 없습니다') >= 0 || xhr.status === 403){
				showError('권한이 없습니다. 관리자에게 권한을 요청하세요.');
			}else{
				showError('인증이 필요하거나 세션이 만료되었습니다. 다시 로그인해 주세요.');
			}
			return;
		}
		if(xhr.status === 401)      showError('로그인이 필요합니다.');
		else if(xhr.status === 403) showError('권한이 없습니다. 관리자에게 권한을 요청하세요.');
		else                        showError('서버 오류: ' + xhr.status);
	}

	/* ========== JSON 전송 헬퍼 ========== */
	function postJson(url, payload){
		return $.ajax({
			url: url,
			method: 'POST',
			data: JSON.stringify(payload),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json'
		});
	}

	/* ========== 선택된 출고건 수집 ========== */
	function getSelectedOrderIdxList(){
		return $("input[name='selectedOrder']:checked")
			.map(function(){ return Number($(this).val()); })
			.get();
	}

	/* ========== 출고준비 처리 ========== */
	$(document).on('click', '#btnReadyOutbound', function(e){
		e.preventDefault();
	
		const $btn = $(this);
		const selected = $("input[name='selectedOrder']:checked")
			.map(function(){ return $(this).val(); })
			.get();
	
		if(selected.length === 0){
			Swal.fire({
				icon: "warning",
				title: "선택 필요",
				text: "출고준비 처리할 출고건을 선택하세요."
			});
			return;
		}
	
		console.debug("[management.js] 출고준비 처리 요청:", selected);
	
		$btn.prop('disabled', true).attr('aria-busy', 'true');
	
		$.ajax({
			url: contextPath + "/outbound/updateStatusReady",
			method: "POST",
			data: JSON.stringify({ orderIdxList: selected }),
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			headers: getCsrfHeadersFromMeta()
		})
		.done(function(res){
			console.debug("[management.js] 출고준비 응답:", res);
			if (res && res.ok) {
				Swal.fire({
					icon: 'success',
					title: '완료',
					text: '선택된 출고건이 출고준비 상태로 변경되었습니다.',
					confirmButtonText: '확인'
				}).then(() => window.location.reload());
			} else {
				const msg = (res && (res.message || res.error)) || '알 수 없는 오류';
				Swal.fire({ icon: "error", title: "실패", text: msg });
			}
		})
		.fail(function(xhr){
			console.error("[management.js] 출고준비 요청 실패:", xhr);
			if(xhr.status === 403){
				Swal.fire("권한이 없습니다", "로그인 세션을 확인하세요.", "error");
			}else{
				Swal.fire("서버 오류", "상태코드: " + xhr.status, "error");
			}
		})
		.always(function(){
			$btn.prop('disabled', false).removeAttr('aria-busy');
		});
	});

	/* ========== 리스트 행 클릭 시 상세 페이지 이동 ========== */
	$(d).on('click', 'table tbody tr', function(e){
		if ($(e.target).closest('input[type=checkbox], button, a').length) return;
		var href = $(this).data('href');
		if (!href) return;

		Swal.fire({
			title: '출고 상세로 이동',
			text: '선택한 출고건 상세 페이지로 이동하시겠습니까?',
			icon: 'question',
			showCancelButton: true,
			confirmButtonText: '이동',
			cancelButtonText: '취소'
		}).then((result) => {
			if (result.isConfirmed) {
				w.location.href = href;
			}
		});
	});

	/* ========== 커서 포인터 적용 ========== */
	$(d).on('mouseenter', 'table tbody tr', function(){
		if ($(this).data('href')) {
			$(this).css('cursor', 'pointer');
		}
	});

	/* ========== 모달: 담당자 지정 열기/닫기 ========== */
	$(d).on('click', '[data-action="assign-manager"]', function(e){
		e.preventDefault();

		const obwaitIdx = $(this).data('obwait-idx');
		const $hidden = $("#formAssignManager input[name='obwaitIdx']");
		if($hidden.length && obwaitIdx){
			$hidden.val(obwaitIdx);
		}

		console.debug('[management.js] opening modal-assign-manager with obwaitIdx=', obwaitIdx);
		ModalManager.openModalById("modal-assign-manager");
	});

	$(d).on('click', '#modal-assign-manager [data-close], #modal-assign-manager .modal-close-btn', function(){
		ModalManager.closeModalById("modal-assign-manager");
	});

})(jQuery, window, document);

/* ========== 간단검색 버튼 동작 ========== */
$(document).on('click', '#simpleSearchBtn', function(){
	const keyword = $('#simpleItemKeyword').val().trim();
	if(!keyword){
		Swal.fire({
			icon: "warning",
			title: "검색어 입력 필요",
			text: "출고번호를 입력하세요."
		});
		return;
	}
	const query = $.param({ simpleKeyword: keyword });
	window.location.href = contextPath + '/outbound/outboundManagement?' + query;
});

/* ========== 상세검색 버튼 동작 ========== */
$(document).on('click', '#detailSearchBtn', function(){
	const params = {
		outboundNumber: $('#itemKeyword').val().trim(),
		franchiseKeyword: $('#franchiseKeyword').val().trim(),
		status: $('#status').val(),
		outRequestDate: $('#outRequestDate').val(),
		outExpectDate: $('#outExpectDate').val(),
		outRangeStart: $('#outRangeStart').val(),
		outRangeEnd: $('#outRangeEnd').val()
	};

	// 유효성 검사
	if(!params.outboundNumber && !params.franchiseKeyword && !params.status 
		&& !params.outRequestDate && !params.outExpectDate && !params.outRangeStart && !params.outRangeEnd){
		Swal.fire({
			icon: "warning",
			title: "검색 조건 필요",
			text: "최소 한 가지 검색 조건을 입력하세요."
		});
		return;
	}

	if(params.outRangeStart && params.outRangeEnd && params.outRangeStart > params.outRangeEnd){
		Swal.fire({
			icon: "warning",
			title: "잘못된 기간",
			text: "기간 시작일이 종료일보다 늦을 수 없습니다."
		});
		return;
	}

	const query = $.param(params);
	window.location.href = contextPath + '/outbound/outboundManagement?' + query;
});

/* ========== Enter 키로 검색 실행 ========== */
// 간단검색 input
$('#simpleItemKeyword').on('keypress', function(e){
	if(e.which === 13){
		e.preventDefault();
		$('#simpleSearchBtn').trigger('click');
	}
});

// 상세검색 input
$('#detailSearchCard input, #detailSearchCard select').on('keypress', function(e){
	if(e.which === 13){
		e.preventDefault();
		$('#detailSearchBtn').trigger('click');
	}
});

/* ========== 상세검색 열기/닫기 토글 ========== */
(function($){
	"use strict";

	function openDetail(){
		const $simple = $('.outbound-simple-search');
		const $detail = $('#detailSearchCard');

		$simple.hide();
		$detail.stop(true, true).slideDown(150).attr('aria-expanded', 'true');

		$('#dateBasis').trigger('change');
		setTimeout(()=>$('#franchiseKeyword').trigger('focus'), 0);
	}

	function closeDetail(){
		const $simple = $('.outbound-simple-search');
		const $detail = $('#detailSearchCard');

		$detail.stop(true, true).slideUp(150).attr('aria-expanded', 'false');
		$simple.show();

		$('#simpleItemKeyword').trigger('focus');
	}

	// 상단 "상세검색" 버튼
	$(document).on('click', '#toggleDetailSearchBtn', function(e){
		e.preventDefault();
		if($('#detailSearchCard').is(':visible')) closeDetail();
		else openDetail();
	});

	// 상세검색 카드 내부의 "간단검색" 버튼
	$(document).on('click', '#backToSimpleBtn', function(e){
		e.preventDefault();
		closeDetail();
	});

})(jQuery);

/* ========== 새로고침(F5/버튼) 확인창 ========== */
document.addEventListener("keydown", function (e) {
	if (e.key === "F5" || e.keyCode === 116) {
		e.preventDefault();
		Swal.fire({
			icon: "question",
			title: "페이지를 초기화하시겠습니까?",
			html: "확인 시 현재 입력값 모두 초기화되고<br>목록이 처음부터 표시됩니다.",
			showCancelButton: true,
			confirmButtonText: "예",
			cancelButtonText: "아니오"
		}).then(result => {
			if (result.isConfirmed) {
				window.location.href = "/outbound/outboundManagement";
			}
		});
	}
});

// ✅ 새로고침 버튼도 같은 동작
const btnReload = document.getElementById("btnReload");
if (btnReload) {
	btnReload.addEventListener("click", function () {
		Swal.fire({
			icon: "question",
			title: "페이지를 초기화하시겠습니까?",
			html: "확인 시 현재 입력값 모두 초기화되고<br>목록이 처음부터 표시됩니다.",
			showCancelButton: true,
			confirmButtonText: "예",
			cancelButtonText: "아니오"
		}).then(result => {
			if (result.isConfirmed) {
				window.location.href = "/outbound/outboundManagement";
			}
		});
	});
}

/* ========== 인쇄 버튼 ========== */
$(document).on('click', '#btnPrint', function(e){
	e.preventDefault();
	window.print();
});

/* ========== 전체 선택/해제 체크박스 ========== */
$(document).on('change', '#checkAll', function () {
	const isChecked = $(this).is(':checked');
	$("input[name='selectedOrder']").prop('checked', isChecked);
});

// 하위 체크박스 중 하나라도 해제되면 상단 체크박스도 해제
$(document).on('change', "input[name='selectedOrder']", function () {
	const total = $("input[name='selectedOrder']").length;
	const checked = $("input[name='selectedOrder']:checked").length;
	$("#checkAll").prop('checked', total > 0 && total === checked);
});
