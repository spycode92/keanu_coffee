
$(function() {
	// 웹소켓 연결 요청
	connectWebSocket();
});



// ===========================
// top.jsp 페이지에서 웹소켓 통신을 위한 STOMP 객체를 전역으로 설정
// => top.jsp 에서 웹소켓 연결을 담당하고 각 페이지에서는 연결된 웹소켓을 활용
// 1) STOMP 클라이언트 객체 저장용 변수(= 웹소켓 통신용)
let stompClient = null;
// 2) 각 채팅방(roomId)별 구독 정보 저장용 변수
let subscriptions = {};
// 3) 웹소켓 연결 여부를 저장할 변수
let isConnected = false;
// 4) 웹소켓 연결 전 요청된 구독 정보들을 임시 저장하는 배열
let pendingSubscriptions = [];
// 5) 웹소켓 연결 전 요청된 메세지를 임시 저장하는 배열
let pendingMessages = [];

// 기존 구독 정보를 저장할 배열
let subscribeRooms = [];
// 연결 끊어졌을 경우 재접속 시간 간격 지정
let reConnectInterval = 1000; // 1000ms = 1초 
// -----------------------------------------------------------
// 웹소켓 서버에 연결을 수행하는 함수
function connectWebSocket() {
	let socket = new SockJS("/ws-noti"); // 서버의 "/ws-chat" 엔드포인트와 연결 요청할 SockJS 객체 생성
	
	// SockJS 에 의해 선택된 웹소켓 관련 프로토콜을 STOMP 프로토콜로 래핑
	stompClient = Stomp.over(socket);
	
	// 기존 구독 정보 복원
	subscribeRooms.forEach(function(sub){
		// 목록에 저장된 roomId값을 활용하여 새로 구독 요청
		// => 방이름과 콜백함수를 모두 전달
		subscribeRoom(sub.roomId, sub.callback);
	});
			
	// STOMP 를 사용하여 서버와 연결 시도
	stompClient.connect({}, function(frame) {
		// 연결 성공 시 콘솔에 연결 정보가 저장된 frame 값 출력
		console.log("Connected : " + frame);
		// 연결 상태 플래그를 true 로 변경
		isConnected = true;
		
		// 연결 전 이미 요청된 대기열의 구독 처리
		// => pendingSubscriptions 배열을 반복하면서 내부 객체의 roomId 와 callback 값을 subscribeRoom() 함수로 전달
		pendingSubscriptions.forEach(function(sub) {
			subscribeRoom(sub.roomId, sub.callback);
		});
		
		// 구독 대기열 처리 후 대기열 초기화
		pendingSubscriptions = [];
		
		// 연결 전 이미 요청된 메세지 전송 처리
		pendingMessages.forEach(function(msg) {
			sendMessage(msg.roomId, msg.messageContent);
		});
		
		// 메세지 대기열 처리 후 대기열 초기화
		pendingMessages = [];
		
		// 알림을 받기 위한 새로운 구독("/topic/noti") 생성 후 subscriptions 객체에 저장
		subscribeRoom("noti");
				
	}, function(error){ // 서버 연결(접속) 실패 
		showSnackbar("서버 연결 실패! 재연결 시도중...");
		console.log("서버 연결 실패! 재연결 시도중...");
		isConnected = false;
	});
	
	//웹소켓 연결 끊어짐 감지
	socket.onclose = function(){
		console.log("서버 연결 끊어짐! 1초 후 재연결 시도");
		isConnected = false;
		
		//setTimeOut() 메서드 활용하여 connect() 함수를 지정된 시간 뒤에 호출
		setTimeout(function(){
			connectWebSocket(); // 재귀 형태로 접속을 수행하는 자신의 메서드 호출	
		}, reConnectInterval);
	};
	
	
} // connectWebSocket() 메서드 끝


// ==============================================
// 특정 채팅방 구독하는 함수
function subscribeRoom(roomId, callback) { // 파라미터로 룸ID 와 콜백함수 전달받음
	// 아직 웹소켓을 통해 서버에 연결되지 않은 경우 구독 요청을 대기열(배열)에 추가
	if(!isConnected) {
		pendingSubscriptions.push({
			roomId: roomId,
			callback: callback
		});
		return;
	}

	// 이미 구독중인 채팅방일 경우 기존 구독 해제
	if(subscriptions[roomId]) {
		// roomId 에 해당하는 Stomp Client 객체의 unsubscribe() 메서드 호출하여 구독 해제
		subscriptions[roomId].unsubscribe();
	}
	
	// 새로운 구독 정보를 설정하여 요청 및 해당 정보를 구독 정보 객체에 저장
	subscriptions[roomId] = stompClient.subscribe("/topic/" + roomId, function(outputMsg) {
		// 서버에서 구독 처리 후 응답하는 메세지가 콜백함수(function(outputMsg)) 파라미터로 전달됨
		// 수신된 메세지를 JSON 형태로 파싱 후 콜백 함수로 전달
		// => 서버측에서 messagingTemplate.convertAndSend("/topic/room." + message.getRoomId(), message); 메서드 호출 시
		//    현재 익명함수가 호출되고 message 에 해당하는 객체를 JSON 으로 파싱한 형태의 메세지가 전달됨
		// => 따라서, main.jsp 페이지에서 구독 시 전달한 콜백함수를 호출하여 JSON 형태의 메세지를 전달 => 채팅창에 메세지 표시됨
		// --------------------------------------------------------------------------------------
		// roomId가 "noti"일 경우 processNotification 함수, 아니면 calllback 함수 호출
		if(roomId == "noti"){
			processNotification(JSON.parse(outputMsg.body));
		} else {
			callback(JSON.parse(outputMsg.body));
		}
	});
	
	// 구독 목록에 현재 구독 채널(룸) 저장(재연결 시 복원을 위해 미리 저장)
	// 리스트(배열)의 some 메서드를 호출하여 요소를 하나씩 꺼내서 조건을 판별하여
	// 하나라도 조건이 만족할 경우 true 값을 리턴
	let exists = subscribeRooms.some(sub => sub.roomId == roomId)
	// => 최종 결과값이 false일 경우 일치하는 방이 없다는 의미
	if(!exists){ // 해당 방이 구독 목록에포함되어 있지 않을 경우
		subscribeRooms.push({
			roomId: roomId,
			callback: callback
		});
	}
		
	
	
} // subscribeRoom() 메서드 끝

// ===============================================
// 메세지를 서버측으로 전송하는 함수
function sendMessage(roomId, messageContent) {
	// 아직 서버에 연결되지 않은 경우 메세지 전송 요청을 대기열에 저장
	if(!isConnected) {
		pendingMessages.push({
			roomId: roomId,
			messageContent: messageContent
		});
		return;
	}
	
	// 서버에 연결된 상태일 경우 & 메세지 내용이 존재할 경우 서버측으로 메세지 전송
	// => isConnected 는 이미 판별했으나 stompClient 객체가 null 이 아님을 판별하여 정확한 연결 확인
	if(stompClient && messageContent) {
		// 전송할 메세지 객체 생성
		let chatMessage = {
			roomId: roomId,
			message: messageContent
		};
		
		// STOMP 를 통해 서버의 메세지 처리 핸들러로 메세지 전송
		// => 전송할 메세지 객체를 JSON 문자열로 변환하여 전송
		stompClient.send("/app/chat.sendMessage", {}, JSON.stringify(chatMessage));
	}
}

function processNotification(msg) {
	$("#alarm-badge").css("display", "block");
	
	// 메세지 타입에 따라 서로 다른 처리
//	if(msg.messageType == "CHAT_IN"){
//		let chatArea = $("#chatArea");
//		if(chatArea.length){
//			$("#chatArea").append("<div class='chat_system_msg'> &gt;&gt;" + msg.message + "&lt;&lt;</div>");
//		}
//	} 
}






















let notiButton = null; 
let isAllRead = true;
function notification() {
//	notiButton.style.display = (notiButton.style.display === 'block') ? 'none' : 'block';
	
	fetch("/alarm/getAlarm")
		.then(res => res.json()).then(data => {
			isAllRead = true;
			notificationList(data);
		})
		.catch(err => console.log("알림 조회 실패"));
}

function changeNotiColor(e) {
	e.currentTarget.style.backgroundColor = "#f0f0f0";
}

function notificationList(data) {
	const ul = document.querySelector("#notification-list");
	ul.innerHTML = "";
	
	if (data.length === 0) {
		ul.innerHTML = "<li class='no-notification'>알림이 없습니다.</li>"
		return
	}
	
	data.forEach((noti) => {
		const li = document.createElement("li");
		const status = getReadStatus(noti.empAlarmReadStatus);
		if(noti.empAlarmReadStatus == 1){
			isAllRead = false;
		}
		
		li.dataset.alarmIdx = noti.alarmIdx;
		li.dataset.link = noti.empAlarmLink;
		
		li.innerHTML = '<span class="noti-message">' + noti.empAlarmMessage + '</span>' + '<span class="read-status">' + status + '</span>';
		li.addEventListener("mouseover", changeNotiColor);
		li.addEventListener("click", () => handleNotiClick(li))
		ul.appendChild(li);
	});
	
	console.log("다시검사해보기");
	if(!isAllRead){
		$("#alarm-badge").css("display", "block");
	} else {
		$("#alarm-badge").css("display", "none");
	}
}

function handleNotiClick(li) {
	const alarmIdx = li.dataset.alarmIdx;
	const link = li.dataset.link || "";
	
	const readSpan = li.querySelector(".read-status");
	
	if (readSpan) {
		readSpan.innerHTML = getReadStatus(0);
	}
//	
	markAsRead(alarmIdx)
		.then(() => {
			if (link && link.trim() !== "" && link !== "null") {
                window.location.href = link;
            }
			notification();
			console.log("이동안함");
		})
		.catch(err => console.log(err));
//	ajaxPost("/alarm/status/" + alarmIdx + "/read")
//		.then((d) => {
//			console.log("여기까지");
//			if (link && link.trim() !== "" && link !== "null") {
//	            window.location.href = link;
//	        }
//			notification();
//			console.log("이동안함");
//		})
//		.catch(err => console.log(err));
}

function markAsRead(alarmIdx) {
	return ajaxPost("/alarm/status/" + alarmIdx + "/read");
}


// 알림 확인
function getReadStatus(status) {
	
	return status === 1 
        ? '<span class="circle unread"></span>'
        : '<span class="circle read"></span>';
}

// 전체 읽음
function readAll() {
	fetch("/user/notification/all-read", {
		method: "PATCH",
		header: {
			"Content-Type": "application/json"
		}
	})
	  .then((res) => res.json())
	  .then((data) => {
		  if (data.result === "모든 알림을 읽음 처리했습니다") {
			  document.querySelectorAll(".read-status").forEach(span => {
		          span.innerHTML = getReadStatus(1);
		      }); 
		  } else {
			  alert("더 이상 읽을 알림이 없습니다.");
		  }
	  })
	    .catch((err) => console.error("전체 읽음 오류:", err));
}






//문서 로딩후 실행
document.addEventListener("DOMContentLoaded", function() {
	notiButton = document.getElementById('notification-box');
	// 알림아이콘 클릭시 알림내용 표시
	notification();
	$("#alarm-image").click(function() {
		notiButton.style.display = (notiButton.style.display === 'block') ? 'none' : 'block';
	});
});

