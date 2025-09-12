// /resources/js/outbound/management.js (slim)
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

  /* ========== HTML 오류 응답 방어(권장) ========== */
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
      showError('네트워크 오류가 발생했습니다.'); return;
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

  /* ========== JSON 전송 헬퍼(단일) ========== */
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

  /* ========== 출고준비 처리(위임형) ========== */
  $(d).on('click', '#btnReadyOutbound', function(e){
    e.preventDefault();

    var $btn = $(this);
    var selected = getSelectedOrderIdxList();

    if(selected.length === 0){
      showWarning('출고준비 처리할 출고건을 선택하세요.');
      return;
    }

    $btn.prop('disabled', true).attr('aria-busy', 'true');

    postJson('/outbound/updateStatusReady', { orderIdxList: selected })
	  .done(function(res){
	    if (res && res.ok) {
	      if (w.Swal && typeof w.Swal.fire === 'function') {
	        Swal.fire({
	          icon: 'success',
	          title: '완료',
	          text: '선택된 출고건이 출고준비 상태로 변경되었습니다.',
	          confirmButtonText: '확인',
	          allowOutsideClick: false,
	          allowEscapeKey: false
	        }).then(() => w.location.reload());
	      } else {
	        alert('선택된 출고건이 출고준비 상태로 변경되었습니다.');
	        w.location.reload();
	      }
	      return;
	    }
	    var msg = (res && (res.message || res.error)) || '알 수 없는 오류';
	    showError('처리 실패: ' + msg);
	  })
	  .fail(function(xhr){
	    handleAjaxFail(xhr);
	    w.console && console.error('[updateStatusReady] fail', xhr);
	  })
	  .always(function(){
	    $btn.prop('disabled', false).removeAttr('aria-busy');
	  });
  });

  /* ========== 로드 시 디버그 ========== */
  if(!$('#btnReadyOutbound').length){
    console.warn('[management.js] #btnReadyOutbound not found at load time');
  }
})(jQuery, window, document);
