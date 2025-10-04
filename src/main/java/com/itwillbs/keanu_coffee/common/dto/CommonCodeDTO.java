package com.itwillbs.keanu_coffee.common.dto;

import java.io.Serializable;

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
public class CommonCodeDTO implements Serializable {

	private static final long serialVersionUID = 1L;
	private Integer commonCodeIdx;
	private String groupCode;
	private String commonCode;
	private String commonCodeName;
	private String description;
}
