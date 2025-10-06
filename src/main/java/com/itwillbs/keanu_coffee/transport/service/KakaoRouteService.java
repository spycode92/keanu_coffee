package com.itwillbs.keanu_coffee.transport.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.itwillbs.keanu_coffee.transport.dto.CoordinateDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class KakaoRouteService {
	
	@Value("${kakao.api_key}")
	private String kakaoApiKey;
	
	// 카카오 다중 경유지 호출 api
	private static final String KAKAO_WAYPOINT_URL = "https://apis-navi.kakaomobility.com/v1/waypoints/directions";

	public Map<String, Object> getMultiRoute(List<CoordinateDTO> coords) {
		// 요청 바디 생성
		Map<String, Object> body = new HashMap<String, Object>();
		// 출발지(본사)
		body.put("origin", Map.of("x", coords.get(0).getX(), "y", coords.get(0).getY()));
		// 도착지(마지막 지점)
		body.put("destination", Map.of("x", coords.get(coords.size()-1).getX(), "y", coords.get(coords.size()-1).getY()));
		
		// 경유지(중간 좌표가 2개 이상일 경우에만 추가)
		if (coords.size() > 2) {
			List<Map<String, Double>> waypoints = coords.subList(1, coords.size()-1)
					.stream()
					.map(c -> Map.of("x", c.getX(), "y", c.getY()))
					.collect(Collectors.toList());
			body.put("waypoints", waypoints);
		}
		
		// 요청 헤더 설정(공식 문서 참조)
		HttpHeaders headers = new HttpHeaders();
		// KakaoAK + 공백 필수
		headers.set("Authorization", "KakaoAK " + kakaoApiKey);
		// JSON 형식 명시
		headers.setContentType(MediaType.APPLICATION_JSON);
		
		HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
        RestTemplate restTemplate = new RestTemplate();
        
        // POST 요청 전송 및 응답 수신
        ResponseEntity<Map> response =
                restTemplate.postForEntity(KAKAO_WAYPOINT_URL, entity, Map.class);
        
		return response.getBody();
	}
}
