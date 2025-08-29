package com.itwillbs.keanu_coffee.inventory.dto;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

//location_idx INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
//location_name VARCHAR(50),
//rack CHAR(2),
//bay INT(11),
//level_position CHAR(2),
//location_type INT(11),
//width int(10),
//depth int(10),
//height int(10),
//volume int(10) GENERATED ALWAYS AS (width * depth * height) STORED,
//created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
//updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

@Getter
@Setter
@ToString
public class WarehouseLocationDTO {
	private int locationIdx;
	private String locationName;
	private String rack;
	private int bay;
	private String levelPosition;
	private int locationType;
	private int width;
	private int depth;
	private int height;
	private int volume;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	
	
	
}
