package com.itwillbs.keanu_coffee.common.controller;

import java.security.Principal;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.itwillbs.keanu_coffee.common.dto.WebSocketDTO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class WebSocketController {
	private final SimpMessagingTemplate messagingTemplate;
	
	@MessageMapping("/chat.sendMessage")
	public void sendMessage(WebSocketDTO message, Principal principal) {
		
		// ChatMessageDTO 객체에 로그인 한 사용자의 아이디를 발신자로 저장
		// => 로그인한 사용자 정보는 Principal 객체를 주입받아 사용
		message.setSender(principal.getName());
		System.out.println("message : " + message);

		// 특정 채팅방 구독자들에게 메세지 전송
		// => SimpMessageTemplate 객체의 convertAndSend() 메서드 호출하여 특정 채팅방구독자들에게 메세지 전송
		// => 파라미터 : 구독중인 방의 roomId, 전송할 메세지
		// => 이 때, 전송할 메세지를 DTO 객체 등으로 지정 시 STOMP + Jackson 라이브러리에 의해 자동으로 변환이 일어남
		messagingTemplate.convertAndSend("/topic/" + message.getRoomId(), message);
		// => /topic 으로 시작되는 요청은 SimpleBroker에 의해 자동으로 처리됨
		//   즉. /room.xxx 형태의 roomId를 구독하는 구독자에게 ChatMessageDTO 객체의 내용을 JSON 형태로 전송
		
		
	}
}
