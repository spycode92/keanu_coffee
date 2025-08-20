<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>기사 마이페이지 (모바일)</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        :root{ --bg:#f6f8ff; --fg:#111827; --muted:#6b7280; --card:#fff; --border:#e5e7eb; --primary:#5660fe; }
        *{ box-sizing:border-box }
        body{ margin:0; background:var(--bg); color:var(--fg); font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Arial,sans-serif; }
        .container{ max-width:720px; margin:16px auto 64px; padding:0 12px; }

        h1{ margin:0 0 10px; font-size:1.25rem; }
        h2{ margin:0 0 8px; font-size:1.05rem; }

        .card{ background:var(--card); border:1px solid var(--border); border-radius:12px; padding:12px; }
        .muted{ color:var(--muted) }
        .btn{ display:inline-flex; align-items:center; gap:.5rem; padding:.5rem .9rem; border-radius:10px; border:1px solid var(--border); background:var(--primary); color:#fff; cursor:pointer; }
        .btn.ghost{ background:#fff; color:#111; }
        .btn:disabled{ opacity:.55; cursor:not-allowed; }

        /* 프로필 */
        .kv{ display:grid; grid-template-columns:88px 1fr; gap:8px 10px; font-size:.95rem; }

        /* 목록(모바일 카드형) */
        table{ width:100%; border-collapse:collapse }
        th,td{ padding:10px 12px; border-bottom:1px solid var(--border); text-align:left; font-size:.95rem; }
        thead th{ background:#eef2ff; font-weight:700; }
        @media (max-width: 600px){
            thead{ display:none; }
            tbody tr{
                display:block; background:#fff; border:1px solid var(--border);
                border-radius:12px; margin-bottom:10px; overflow:hidden;
                box-shadow:0 2px 8px rgba(15,23,42,.05);
            }
            td{ display:flex; justify-content:space-between; align-items:center; border:0; border-bottom:1px dashed #eef2ff; }
            td:last-child{ border-bottom:0 }
            td:nth-child(1)::before{ content:"배차일"; font-weight:600; color:#64748b }
            td:nth-child(2)::before{ content:"지점";   font-weight:600; color:#64748b }
            td:nth-child(3)::before{ content:"예상중량"; font-weight:600; color:#64748b }
            td:nth-child(4)::before{ content:"상태";   font-weight:600; color:#64748b }
            td:nth-child(5)::before{ content:"작업";   font-weight:600; color:#64748b }
        }

        /* 상태 칩 (예약/운송중/완료) */
        .chip{ display:inline-block; padding:4px 10px; border-radius:999px; font-size:.82rem; font-weight:700; }
        .chip.book{ background:#e7eaff; color:#3730a3 }
        .chip.run { background:#e6f1ff; color:#1e40af }
        .chip.done{ background:#eafbea; color:#166534 }

        /* 모달 (하단 시트) */
        .modal{ position:fixed; inset:0; display:none; align-items:flex-end; justify-content:center; background:rgba(0,0,0,.45); z-index:1000; }
        .modal.open{ display:flex }
        .modal-card{ width:100%; max-width:720px; max-height:92vh; background:#fff; border:1px solid var(--border); border-radius:12px 12px 0 0; overflow:hidden; }
        .modal-head{ display:flex; align-items:center; justify-content:space-between; padding:12px; border-bottom:1px solid var(--border) }
        .modal-body{ padding:12px; max-height:calc(92vh - 52px - 64px); overflow:auto }
        .modal-foot{ display:flex; gap:8px; padding:12px; border-top:1px solid var(--border); background:#fff; position:sticky; bottom:0 }

        /* 주문서(그룹 테이블) */
        .group{ border:1px solid var(--border); border-radius:10px; margin-bottom:12px; overflow:hidden; }
        .group-head{ background:#f8faff; padding:10px 12px; font-weight:700; }
        .group table{ width:100%; border-collapse:collapse }
        .group th, .group td{ border-bottom:1px solid #eef2ff; padding:10px 12px }
        .group tr:last-child td{ border-bottom:0 }

        /* 선택 요약 바 - 리스트 버전 */
        .picked-bar{ position:sticky; bottom:0; background:#0f172a; color:#fff; padding:10px 12px; gap:12px; }
        .picked-summary{ max-height:120px; overflow:auto; }
        .picked-summary .area{ font-weight:700; margin:0 0 4px; }
        .picked-summary ul{ margin:0 0 8px; padding-left:18px; }
        .picked-summary li{ line-height:1.5; }

        /* 배송 현황 타임라인 */
        .timeline{ display:flex; gap:6px; flex-wrap:wrap; }
        .step{ background:#eef2ff; color:#3949ab; border:1px solid #c7d2fe; padding:6px 10px; border-radius:999px; font-size:.85rem; }
    </style>
</head>
<body>
    <div class="container">
        <h1>기사 마이페이지</h1>

        <!-- 프로필 -->
        <section class="card">
            <h2>프로필</h2>
            <div class="kv">
                <div class="muted">이름</div><div id="pf_name">이정민</div>
                <div class="muted">연락처</div><div id="pf_phone">010-1234-5678</div>
                <div class="muted">차량</div><div id="pf_vehicle">89바 1234 (1.5t)</div>
                <div class="muted">상태</div><div><span id="pf_status" class="chip book">예약</span></div>
            </div>
        </section>

        <!-- 배차 요청 목록 -->
        <section class="card" style="margin-top:12px">
            <h2>배차 요청 목록</h2>
            <table id="assignTable">
                <thead>
                    <tr>
                        <th>배차일</th>
                        <th>지점</th>
                        <th>예상중량</th>
                        <th>상태</th>
                        <th>작업</th>
                    </tr>
                </thead>
                <tbody><!-- JS --></tbody>
            </table>
        </section>
    </div>

    <!-- 예약 상세(주문서/선택) 모달 -->
    <div class="modal" id="orderModal" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="orderTitle">
            <div class="modal-head">
                <strong id="orderTitle">주문서 확인 및 적재</strong>
                <button class="btn ghost" id="closeOrder">닫기</button>
            </div>
            <div class="modal-body">
                <div id="orderMeta" class="muted" style="margin-bottom:8px">배차일 -</div>
                <div id="groupWrap"><!-- 지점 그룹 --></div>
            </div>

            <div class="picked-bar">
                <div id="pickedSummary" class="picked-summary"><span class="area">선택 없음</span></div>
                <div><strong id="pickedTotal">0.0t</strong></div>
            </div>

            <div class="modal-foot">
                <button class="btn ghost" id="btnClearPick">선택 초기화</button>
                <button class="btn" id="btnStartDelivery" disabled>배송 시작</button>
            </div>
        </div>
    </div>

    <!-- 운송중 상세(납품/현황) 모달 -->
    <div class="modal" id="progressModal" aria-hidden="true">
        <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="progTitle">
            <div class="modal-head">
                <strong id="progTitle">배송 상세</strong>
                <button class="btn ghost" id="closeProgress">닫기</button>
            </div>
            <div class="modal-body">
                <div id="progMeta" class="muted" style="margin-bottom:8px">배차일 -</div>
                <div id="deliverWrap"><!-- 지점별 납품 표 + 버튼 --></div>
                <h3 style="margin:12px 0 6px">배송 현황</h3>
                <div class="timeline" id="timeline"><!-- 단계 표시 --></div>
            </div>
            <div class="modal-foot">
                <button class="btn ghost" id="btnBackBase" style="display:none">복귀</button>
            </div>
        </div>
    </div>

    <script>
        /* ====== 모달 유틸 ====== */
        function openModal(el){ el.classList.add('open'); }
        function closeModal(el){ el.classList.remove('open'); }

        /* ====== 데이터 ====== */
        var myProfile = {
            name: '이원민',
            phone: '010-1234-5678',
            vehicleNo: '89바 1234',
            capNum: 1.5,
            capLimit: 1.5 * 0.8,      // 80%
            state: '예약'             // 예약 / 운송중 / 완료
        };

        var assignments = [
            {
                id: 1001,
                date: '2025-08-13',
                status: '예약',      // 예약 / 운송중 / 완료
                timeline: [],       // ★ 타임라인을 객체에 저장하여 유지
                groups: [
                    {
                        area: '지점A',
                        inTransit: false,
                        delivered: false,
                        items: [
                            { id: 1, name: '원두1', qty: 10, wNum: 0.1, w: '0.1t' },
                            { id: 2, name: '필터',  qty: 20, wNum: 0.2, w: '0.2t' },
                            { id: 3, name: '머그컵', qty: 5,  wNum: 0.3, w: '0.3t' }
                        ]
                    },
                    {
                        area: '지점B',
                        inTransit: false,
                        delivered: false,
                        items: [
                            { id: 4, name: '원두2', qty: 12, wNum: 0.2, w: '0.2t' },
                            { id: 5, name: '컵뚜껑', qty: 30, wNum: 0.4, w: '0.4t' }
                        ]
                    }
                ]
            }
        ];

        /* ====== 프로필 바인딩 ====== */
        document.getElementById('pf_name').textContent    = myProfile.name;
        document.getElementById('pf_phone').textContent   = myProfile.phone;
        document.getElementById('pf_vehicle').textContent = myProfile.vehicleNo + ' (' + myProfile.capNum + 't)';
        document.getElementById('pf_status').textContent  = myProfile.state;
        document.getElementById('pf_status').className    = 'chip ' + (myProfile.state === '예약' ? 'book' : (myProfile.state === '운송중' ? 'run' : 'done'));

        /* ====== 목록 렌더 ====== */
        var tbodyAssign = document.querySelector('#assignTable tbody');

        function chip(state) {
            return '<span class="chip ' + (state === '예약' ? 'book' : (state === '운송중' ? 'run' : 'done')) + '">' + state + '</span>';
        }

        function renderAssignments() {
            tbodyAssign.innerHTML = '';
            assignments.forEach(function(a){
                var areas = a.groups.map(function(g){ return g.area; }).join(', ');
                var est = 0;
                a.groups.forEach(function(g){ g.items.forEach(function(it){ est += it.wNum; }); });

                var tr = document.createElement('tr');
                tr.innerHTML =
                    '<td>' + a.date + '</td>' +
                    '<td>' + areas + '</td>' +
                    '<td>' + est.toFixed(1) + 't</td>' +
                    '<td>' + chip(a.status) + '</td>' +
                    '<td><button class="btn ghost detail-btn" data-id="' + a.id + '">상세</button></td>';
                tbodyAssign.appendChild(tr);
            });
        }
        renderAssignments();

        /* 목록 위임 클릭: 상세 열기 */
        tbodyAssign.addEventListener('click', function(e){
            var btn = e.target.closest('.detail-btn');
            if (!btn) return;
            var id = parseInt(btn.getAttribute('data-id'), 10);
            openDetail(id);
        });

        /* 상태별 상세 열기 */
        function openDetail(assignId){
            var a = assignments.find(function(x){ return x.id === assignId; });
            if (!a) return;
            if (a.status === '예약') openOrderModal(a);
            else                    openProgressModal(a);
        }

        /* ====== 예약 상세(지점 그룹 + 체크) ====== */
        var orderModal     = document.getElementById('orderModal');
        var closeOrderBtn  = document.getElementById('closeOrder');
        var orderMeta      = document.getElementById('orderMeta');
        var groupWrap      = document.getElementById('groupWrap');
        var pickedSummary  = document.getElementById('pickedSummary');
        var pickedTotal    = document.getElementById('pickedTotal');
        var btnClearPick   = document.getElementById('btnClearPick');
        var btnStart       = document.getElementById('btnStartDelivery');

        var currentAssign  = null;
        var pickedByArea   = {};    // { area: { weight: number, items:{name:qty} } }

        function openOrderModal(a){
            currentAssign = a;
            pickedByArea = {};
            orderMeta.textContent = '배차일 ' + a.date;
            groupWrap.innerHTML = '';

            a.groups.forEach(function(g){
                var box = document.createElement('div');
                box.className = 'group';

                var head = document.createElement('div');
                head.className = 'group-head';
                head.textContent = g.area;
                box.appendChild(head);

                var table = document.createElement('table');
                var thead = document.createElement('thead');
                thead.innerHTML =
                    '<tr>' +
                        '<th style="width:48px">체크</th>' +
                        '<th>지점명</th>' +
                        '<th>물품</th>' +
                        '<th>갯수</th>' +
                        '<th>적재량</th>' +
                    '</tr>';
                table.appendChild(thead);

                var tbody = document.createElement('tbody');
                g.items.forEach(function(it){
                    var tr = document.createElement('tr');
                    tr.innerHTML =
                        '<td><input type="checkbox" class="pick" data-area="' + g.area + '" data-name="' + it.name + '" data-qty="' + it.qty + '" data-wnum="' + it.wNum + '"></td>' +
                        '<td>' + g.area + '</td>' +
                        '<td>' + it.name + '</td>' +
                        '<td>' + it.qty + '</td>' +
                        '<td>' + it.w + '</td>';
                    tbody.appendChild(tr);
                });
                table.appendChild(tbody);
                box.appendChild(table);
                groupWrap.appendChild(box);
            });

            Array.prototype.forEach.call(groupWrap.querySelectorAll('.pick'), function(cb){
                cb.addEventListener('change', function(e){
                    var area = cb.getAttribute('data-area');
                    var name = cb.getAttribute('data-name');
                    var qty  = parseInt(cb.getAttribute('data-qty'), 10);
                    var wNum = parseFloat(cb.getAttribute('data-wnum'));

                    if (!pickedByArea[area]) pickedByArea[area] = { weight:0, items:{} };

                    if (e.target.checked) {
                        var next = pickedByArea[area].weight + wNum;
                        if (next > myProfile.capLimit) {
                            alert('해당 지점 선택 중량이 차량 적재 한도( ' + myProfile.capLimit.toFixed(1) + 't )를 초과합니다.');
                            e.target.checked = false;
                            return;
                        }
                        pickedByArea[area].weight = next;
                        pickedByArea[area].items[name] = (pickedByArea[area].items[name] || 0) + qty;
                    } else {
                        pickedByArea[area].weight = Math.max(0, pickedByArea[area].weight - wNum);
                        pickedByArea[area].items[name] = Math.max(0, (pickedByArea[area].items[name] || 0) - qty);
                        if (pickedByArea[area].items[name] === 0) delete pickedByArea[area].items[name];
                        if (!Object.keys(pickedByArea[area].items).length) delete pickedByArea[area]; // 비어있으면 제거
                    }
                    renderPickedSummary();
                });
            });

            renderPickedSummary();
            btnStart.disabled = true;
            openModal(orderModal);
        }

        /* ★ 리스트로 합산 요약 표시 */
        function renderPickedSummary(){
            pickedSummary.innerHTML = '';
            var total = 0;
            var hasAny = false;

            Object.keys(pickedByArea).forEach(function(area){
                var block = document.createElement('div');
                var title = document.createElement('div');
                title.className = 'area';
                title.textContent = area;
                block.appendChild(title);

                var ul = document.createElement('ul');
                var items = pickedByArea[area].items;
                var keys = Object.keys(items);
                if (!keys.length) return;

                hasAny = true;
                total += pickedByArea[area].weight;

                keys.forEach(function(name){
                    var li = document.createElement('li');
                    li.textContent = name + ' ' + items[name] + '개';
                    ul.appendChild(li);
                });
                block.appendChild(ul);
                pickedSummary.appendChild(block);
            });

            if (!hasAny) {
                pickedSummary.innerHTML = '<span class="area">선택 없음</span>';
            }
            pickedTotal.textContent = total.toFixed(1) + 't';
            btnStart.disabled = (total === 0);
        }

        document.getElementById('btnClearPick').addEventListener('click', function(){
            Array.prototype.forEach.call(groupWrap.querySelectorAll('.pick'), function(cb){ cb.checked = false; });
            pickedByArea = {};
            renderPickedSummary();
        });
        document.getElementById('closeOrder').addEventListener('click', function(){ closeModal(orderModal); });

        document.getElementById('btnStartDelivery').addEventListener('click', function(){
            if (!currentAssign) return;
            currentAssign.status = '운송중';
            myProfile.state = '운송중';
            document.getElementById('pf_status').textContent = myProfile.state;
            document.getElementById('pf_status').className = 'chip run';
            // 타임라인 시작 기록(1회만)
            if (currentAssign.timeline.length === 0) currentAssign.timeline.push('배송 시작');

            renderAssignments();
            closeModal(orderModal);
            openProgressModal(currentAssign, true);
        });

        /* ====== 운송중 상세(납품/현황) ====== */
        var progressModal  = document.getElementById('progressModal');
        var closeProgress  = document.getElementById('closeProgress');
        var progMeta       = document.getElementById('progMeta');
        var deliverWrap    = document.getElementById('deliverWrap');
        var timelineEl     = document.getElementById('timeline');
        var btnBackBase    = document.getElementById('btnBackBase');

        function openProgressModal(a, fromStart){
            progMeta.textContent = '배차일 ' + a.date;
            deliverWrap.innerHTML = '';
            timelineEl.innerHTML = '';

            // 미납품 지점은 "운송 중" 단계 1회만 추가
            a.groups.forEach(function(g){
                if (!g.delivered && !g.inTransit) {
                    g.inTransit = true;
                    a.timeline.push('[' + g.area + '] 운송 중');
                }
            });

            // 타임라인 렌더(지속 유지)
            a.timeline.forEach(function(step){
                addTimeline(step);
            });

            // 지점별 납품 블록
            a.groups.forEach(function(g){
                var box = document.createElement('div');
                box.className = 'group';

                var head = document.createElement('div');
                head.className = 'group-head';
                head.textContent = g.area;
                box.appendChild(head);

                var table = document.createElement('table');
                var thead = document.createElement('thead');
                thead.innerHTML =
                    '<tr>' +
                        '<th>지점</th>' +
                        '<th>품목</th>' +
                        '<th>갯수</th>' +
                        '<th>적재량</th>' +
                        '<th>상태</th>' +
                    '</tr>';
                table.appendChild(thead);

                var tbody = document.createElement('tbody');
                g.items.forEach(function(it){
                    var tr = document.createElement('tr');
                    tr.innerHTML =
                        '<td>' + g.area + '</td>' +
                        '<td>' + it.name + '</td>' +
                        '<td>' + it.qty + '</td>' +
                        '<td>' + it.w + '</td>' +
                        '<td>' + (g.delivered ? '완료' : '-') + '</td>';
                    tbody.appendChild(tr);
                });
                table.appendChild(tbody);
                box.appendChild(table);

                var btn = document.createElement('button');
                btn.className = 'btn';
                btn.style.margin = '10px';
                btn.textContent = g.delivered ? '납품 완료' : '납품';
                if (g.delivered) btn.disabled = true;

                btn.addEventListener('click', function(){
                    if (g.delivered) return;
                    g.delivered = true;
                    a.timeline.push('[' + g.area + '] 납품 완료');   // ★ 타임라인에 기록
                    openProgressModal(a, false);                      // 화면만 재렌더

                    var allDone = a.groups.every(function(x){ return x.delivered; });
                    if (allDone) {
                        a.status = '완료';
                        myProfile.state = '완료';
                        document.getElementById('pf_status').textContent = myProfile.state;
                        document.getElementById('pf_status').className = 'chip done';
                        renderAssignments();
                        btnBackBase.style.display = 'inline-flex';
                    }
                });

                box.appendChild(btn);
                deliverWrap.appendChild(box);
            });

            openModal(progressModal);
        }

        function addTimeline(text){
            var el = document.createElement('div');
            el.className = 'step';
            el.textContent = text;
            timelineEl.appendChild(el);
        }

        btnBackBase.addEventListener('click', function(){
            var a = assignments[0];
            a.timeline.push('복귀 완료');
            addTimeline('복귀 완료');
            btnBackBase.disabled = true;
        });

        closeProgress.addEventListener('click', function(){ closeModal(progressModal); });
    </script>
</body>
</html>
