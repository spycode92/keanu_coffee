// /resources/js/inbound/modal/modify.js
// 위치/담당자 모달 공용: 열기/닫기 + 후보목록 로드 + AJAX 저장 + 포커스/접근성
(function(w, d){
	"use strict";

	function byId(id){ return d.getElementById(id); }
	function qsa(sel){ return d.querySelectorAll(sel); }
	function ctx(){ return d.body.getAttribute("data-context") || ""; }

	const lastOpener = Object.create(null);

	function appRoot(){
		return d.querySelector('[data-app-root], .content.inbound-detail') || d.querySelector('.content') || d.body;
	}
	function setBackgroundInert(on){
		const root = appRoot();
		if(!root) return;
		if(on){ try{ root.setAttribute('inert', ''); }catch(_){} }
		else { try{ root.removeAttribute('inert'); }catch(_){} }
	}
	function focusFirstIn(modal){
		const sel = [
			'[autofocus]',
			'select:not([disabled])',
			'input:not([disabled]):not([type="hidden"])',
			'textarea:not([disabled])',
			'button:not([disabled])',
			'[tabindex]:not([tabindex="-1"])'
		].join(',');
		const first = modal.querySelector(sel);
		if(first){ first.focus(); return; }
		const card = modal.querySelector('.modal-card');
		if(card){ card.setAttribute('tabindex','-1'); card.focus(); }
	}

	function openModal(id, openerEl){
		const modal = byId(id);
		if(!modal){ console.warn("[modify.js] modal not found:", id); return; }
		lastOpener[id] = openerEl instanceof HTMLElement ? openerEl : (d.activeElement || null);
		setBackgroundInert(true);
		if(w.ModalManager?.openModalById){ w.ModalManager.openModalById(id); }
		else { modal.style.display = "block"; modal.removeAttribute("aria-hidden"); }
		focusFirstIn(modal);
	}
	function closeModal(id){
		const modal = byId(id);
		if(!modal) return;
		const opener = lastOpener[id];
		if(opener?.focus) opener.focus(); else (d.body || d.documentElement).focus();
		if(w.ModalManager?.closeModalById){ w.ModalManager.closeModalById(id); }
		else { modal.setAttribute("aria-hidden","true"); modal.style.display = "none"; }
		setBackgroundInert(false);
	}

	// CSRF
	function readCsrfFromForm(form){
		const header = form.querySelector('input[name="_csrf_header"]')?.value;
		const token  = form.querySelector('input[name="_csrf"]')?.value;
		return (header && token) ? { header, token } : null;
	}
	function readCookie(name){
		return d.cookie.split("; ").find(v => v.startsWith(name + "="))?.split("=")[1];
	}
	function resolveCsrf(form){
		const f = readCsrfFromForm(form);
		if(f) return f;
		const cookie = readCookie("XSRF-TOKEN");
		if(cookie) return { header: "X-XSRF-TOKEN", token: decodeURIComponent(cookie) };
		return null;
	}
	async function postJson(url, payload, form){
		const headers = { "Content-Type": "application/json" };
		const csrf = resolveCsrf(form);
		if(csrf){ headers[csrf.header] = csrf.token; }
		const res = await fetch(url, { method: "POST", headers, body: JSON.stringify(payload) });
		if(!res.ok){
			const txt = await res.text().catch(()=> "");
			throw new Error("HTTP " + res.status + " " + txt);
		}
		return res.json().catch(()=> ({}));
	}



	/* ===================== 담당자 ===================== */
	async function fetchManagerCandidates(){
		const url = `${ctx()}/inbound/managerCandidates?departmentIdx=2&roleIdx=2`;
		const res = await fetch(url, { method: "GET", headers: { "Accept": "application/json" } });
		if(!res.ok){
			const txt = await res.text().catch(()=> "");
			throw new Error("HTTP " + res.status + " " + txt);
		}
		return res.json();
	}
	function populateManagerSelect(selectEl, list){
		selectEl.querySelectorAll('option:not([disabled])').forEach(o => o.remove());
		list.forEach(function(emp){
			const opt = d.createElement("option");
			opt.value = String(emp.empIdx ?? emp.id ?? "");
			opt.textContent = String(emp.empName ?? emp.name ?? "");
			selectEl.appendChild(opt);
		});
	}

	function bindManager(){
		const btn = byId("btnAssignManager");
		const modalId = "modal-assign-manager";
		if(btn){
			btn.addEventListener("click", async function(e){
				e.preventDefault();
				
				const currentUser = window.currentUserName || "";
				if(currentUser !== "김입고"){
					Swal.fire({
						icon: 'error',
						title: '접근 불가',
						text: '담당자 지정은 관리자만 접근 가능합니다 ❌',
						confirmButtonText: '확인'
					});
					return;
				}
				
				updateSelectedCount();
				try{
					const selectEl = byId("managerSelect");
					if(selectEl){
						const list = await fetchManagerCandidates();
						populateManagerSelect(selectEl, list);
					}
				}catch(err){
					console.error(err);
					Swal.fire({
						icon: 'error',
						title: '실패',
						text: '담당자 목록을 불러오지 못했습니다: ' + err.message,
						confirmButtonText: '확인'
					});
				}
				openModal(modalId, btn);
			});
		}
		qsa('#' + modalId + ' [data-close], #' + modalId + ' .modal-close-btn').forEach(function(el){
			el.addEventListener("click", function(){ closeModal(modalId); });
		});

		const form = byId("formAssignManager");
		if(form){
			form.addEventListener("submit", async function(e){
				e.preventDefault();

				const checked = Array.from(document.querySelectorAll('input[name="selectedOrder"]:checked'))
					.map(cb => cb.value);

				if (checked.length === 0) {
					Swal.fire({
						icon: 'warning',
						title: '선택 필요',
						text: '담당자를 지정할 항목을 선택하세요.',
						confirmButtonText: '확인'
					});
				    return;
				}

				const selectEl = byId("managerSelect");
				const managerIdx = selectEl?.value || "";
				const managerName = selectEl?.selectedOptions?.[0]?.textContent?.trim() || "";

				if(!managerIdx){
					Swal.fire({
						icon: 'warning',
						title: '선택 필요',
						text: '담당자를 선택해주세요.',
						confirmButtonText: '확인'
					});
					selectEl?.focus();
					return;
				}

				try{
					await postJson(ctx() + "/inbound/updateManagers", {
						ibwaitIdxList: checked,
						managerIdx,
						managerName
					}, form);

					// ✅ 테이블 즉시 반영
					checked.forEach(id => {
						const row = document.querySelector(`input[name="selectedOrder"][value="${id}"]`)?.closest("tr");
						if(row){
							const cell = row.querySelector("td:nth-child(9)"); // 9번째 컬럼: 담당자
							if(cell) cell.textContent = managerName;
						}
					});

					closeModal(modalId);
					Swal.fire({
						icon: 'success',
						title: '성공',
						text: '담당자를 일괄 지정했어요.',
						confirmButtonText: 'OK'
					});
				}catch(err){
					console.error(err);
					Swal.fire({
						icon: 'error',
						title: '실패',
						text: '담당자 저장 실패: ' + err.message,
						confirmButtonText: '확인'
					});
				}
			});
		}
	}

	function bind(){
		bindManager();
		if(!w.ModalManager){
			d.addEventListener("keydown", function(ev){
				if(ev.key === "Escape"){
					closeModal("modal-assign-location");
					closeModal("modal-assign-manager");
				}
			});
		}
	}

	if(d.readyState === "loading") d.addEventListener("DOMContentLoaded", bind);
	else bind();

})(window, document);

function updateSelectedCount() {
	const count = document.querySelectorAll('input[name="selectedOrder"]:checked').length;
	const el = document.getElementById("selectedCount");
	if (el) el.textContent = count;
}
