package com.itwillbs.keanu_coffee.common.webSocket.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
	// 클라이언트가 연결할 엔트포인트 등록
	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/ws-noti") // "/ws-chat" URL 을 엔트포인트로 등록(클라이언트에서 new SockJS("/ws-chat") 형태로 엔드포인트 주소 지정)
				.setAllowedOriginPatterns("*") // CORS 허용
				.withSockJS(); // SockJS fallback 활성화
	}

	// 메세지 전송을 처리하는 메세지 브로커 설정
	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		registry.enableSimpleBroker("/topic"); // 메세지 브로커가 "/topic/**" 로 발생된 메세지를 구독자에게 전달
		
		registry.setApplicationDestinationPrefixes("/app"); // 클라이언트가 "/app/**" 으로 보낸 메세지를 @MessagingMapping 어노테이션으로 라우팅
	}
}
