document.addEventListener("DOMContentLoaded", function() {
	document.getElementById("btnBack")?.addEventListener("click", function(e) {
		e.preventDefault();
		history.back();
	});
});

(function($, w, d){
	'use strict';

	/* ===== 알림 ===== */
	function notify(type, msg){
		if (w.Swal && typeof w.Swal.fire === 'function') {
			const title = (type === 'success') ? '완료' : (type === 'warning' ? '확인' : '오류');
			Swal.fire({ icon: type, title, text: msg, confirmButtonText: '확인' });
		} else { w.alert(msg); }
	}
	const showSuccess = (m)=>notify('success', m);
	const showWarning = (m)=>notify('warning', m);
	const showError   = (m)=>notify('error',   m);

	/* ===== CSRF (meta 우선, cookie 폴백) ===== */
	function csrfHeaders(){
		const $metaToken  = $('meta[name="_csrf"]');
		const $metaHeader = $('meta[name="_csrf_header"]');
		if ($metaToken.length && $metaHeader.length) {
			return { [$metaHeader.attr('content')]: $metaToken.attr('content') };
		}
		const m = (d.cookie || '').match(/(?:^|;\s*)XSRF-TOKEN=([^;]+)/);
		if (m) return { 'X-XSRF-TOKEN': decodeURIComponent(m[1]) };
		return {};
	}

	/* ===== AJAX 기본설정: 매 요청마다 CSRF/헤더 주입 ===== */
	$.ajaxSetup({
		beforeSend: function(xhr){
			const h = csrfHeaders();
			Object.keys(h).forEach(k => xhr.setRequestHeader(k, h[k]));
			xhr.setRequestHeader('Accept', 'application/json');
			xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
		}
	});

	/* ===== 유틸 ===== */
	const ctx = d.body.getAttribute('data-context') || ''; // ex) "" or "/keanu_coffee"

	function isHtmlResponse(xhr){
		try {
			const ct = (xhr.getResponseHeader && xhr.getResponseHeader('Content-Type')) || '';
			if (ct && ct.toLowerCase().indexOf('text/html') >= 0) return true;
		} catch(e){}
		const body = (xhr && xhr.responseText) ? xhr.responseText : '';
		return /^\s*<!doctype html/i.test(body) || /<html[\s>]/i.test(body);
	}

	function redirectToLogin(xhr){
		let loginUrl = `${ctx}/login`;
		try {
			const respUrl = xhr && xhr.responseURL ? xhr.responseURL : '';
			if (respUrl && /\/login/i.test(respUrl)) loginUrl = respUrl;
		} catch(e){}
		if (w.Swal && typeof w.Swal.fire === 'function') {
			Swal.fire({
				icon: 'warning',
				title: '세션 만료',
				text: '세션이 만료되었습니다. 다시 로그인해 주세요.',
				confirmButtonText: '로그인',
				allowOutsideClick: false,
				allowEscapeKey: false
			}).then(() => { w.location.href = loginUrl; });
		} else {
			alert('세션이 만료되었습니다. 다시 로그인해 주세요.');
			w.location.href = loginUrl;
		}
	}

	function handleAjaxFail(xhr){
		// 네트워크/중단
		if (!xhr || typeof xhr.status === 'undefined' || xhr.status === 0) {
			showError('네트워크 오류가 발생했습니다.');
			return;
		}
		// HTML(로그인/권한 에러 페이지) 응답 처리
		if (isHtmlResponse(xhr)) {
			const body = xhr.responseText || '';
			const respUrl = xhr.responseURL || '';
			// 로그인 페이지로 리다이렉트된 경우
			if ((respUrl && /\/login/i.test(respUrl)) || /name=["']username["']/.test(body)) {
				redirectToLogin(xhr);
				return;
			}
			// 권한 없음 페이지
			if (xhr.status === 403 || body.indexOf('해당 기능에 접근할 권한이 없습니다') >= 0) {
				showError('권한이 없습니다. 관리자에게 권한을 요청하세요.');
				return;
			}
			// 그 외 HTML → 세션 만료/인증 필요로 안내
			showError('인증이 필요하거나 세션이 만료되었습니다. 다시 로그인해 주세요.');
			return;
		}
		// 표준 JSON 에러
		if (xhr.status === 401) { redirectToLogin(xhr); return; }
		if (xhr.status === 403) { showError('권한이 없습니다. 관리자에게 권한을 요청하세요.'); return; }

		const msg = (xhr.responseJSON && (xhr.responseJSON.message || xhr.responseJSON.error))
			|| ('서버 오류: ' + xhr.status);
		showError(msg);
	}

	function postJson(url, payload){
		return $.ajax({
			url: url,
			method: 'POST',
			data: JSON.stringify(payload),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json'
		});
	}

	// URL의 ?obwaitNumber=..&outboundOrderIdx=.. 읽기
	function getQueryParams(){
		const sp = new URLSearchParams(w.location.search);
		const obwaitNumber = sp.get('obwaitNumber');
		const outboundOrderIdx = sp.get('outboundOrderIdx') ? Number(sp.get('outboundOrderIdx')) : null;
		return { obwaitNumber, outboundOrderIdx };
	}

	// 상태 뱃지 텍스트(친절 확인용)
	function getCurrentStatusText(){
		const $badge = $('.card-header .badge').first();
		return ($badge.text() || '').trim();
	}

	/* ===== 액션: 출고확정(출고준비 → 배차대기) ===== */
	$(d).on('click', '#btnOutboundComplete', function(e){
		e.preventDefault();

		const { obwaitNumber, outboundOrderIdx } = getQueryParams();
		if (!obwaitNumber || !outboundOrderIdx) {
			showError('필수 파라미터가 없습니다. (obwaitNumber, outboundOrderIdx)');
			return;
		}

		const curStatus = getCurrentStatusText(); // 예: '출고준비'
		const proceed = () => {
			const $btn = $('#btnOutboundComplete').prop('disabled', true).attr('aria-busy','true');
			postJson(`${ctx}/outbound/updateStatusDispatchWait`, { obwaitNumber, outboundOrderIdx })
				.done(function(res){
					if (res && res.ok) {
						if (w.Swal && typeof w.Swal.fire === 'function') {
							Swal.fire({
								icon: 'success',
								title: '완료',
								text: '상태가 "배차대기"로 변경되었습니다.',
								confirmButtonText: '확인',
								allowOutsideClick: false,
								allowEscapeKey: false
							}).then(() => w.location.reload());
						} else {
							alert('상태가 "배차대기"로 변경되었습니다.');
							w.location.reload();
						}
					} else {
						const msg = res && (res.message || res.error) || '알 수 없는 오류';
						showError('처리 실패: ' + msg);
					}
				})
				.fail(handleAjaxFail)
				.always(() => $btn.prop('disabled', false).removeAttr('aria-busy'));
		};

		// 상태가 '출고준비'가 아니어도 진행할지 확인(서버 검증은 별도로)
		if (curStatus && curStatus !== '출고준비') {
			if (w.Swal && typeof w.Swal.fire === 'function') {
				Swal.fire({
					icon: 'warning',
					title: '상태 확인',
					text: `현재 상태는 '${curStatus}' 입니다. '배차대기'로 변경하시겠습니까?`,
					showCancelButton: true, confirmButtonText: '변경', cancelButtonText: '취소'
				}).then(r => { if (r.isConfirmed) proceed(); });
			} else {
				if (confirm(`현재 상태는 '${curStatus}' 입니다. '배차대기'로 변경하시겠습니까?`)) proceed();
			}
		} else {
			proceed();
		}
	});

})(jQuery, window, document);
