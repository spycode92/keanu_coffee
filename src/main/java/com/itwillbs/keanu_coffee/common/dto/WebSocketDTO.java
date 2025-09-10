package com.itwillbs.keanu_coffee.common.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class WebSocketDTO {
	private String roomId;
	private String sender;
	private String message;

}
