package com.itwillbs.keanu_coffee.common.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class CommonCodeDTO {
	private Integer commonCodeIdx;
	private String gorupCode;
	private String commonCode;
	private String commonCodeName;
	private String description;
}
