package com.itwillbs.keanu_coffee.inventory.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
//@NoArgsConstructor
@AllArgsConstructor
public class CreateWarehouseDTO {
	private String locationName;
    private char rack;
    private int bay;
    private String levelPosition;
    private int width;
    private int depth;
    private int height;
    
//    @Builder
//	public CreateWarehouseDTO(char rack, int bay, String levelPostion, int width, int depth, int height) {
//		super();
//		this.rack = rack;
//		this.bay = bay;
//		this.levelPostion = levelPostion;
//		this.width = width;
//		this.depth = depth;
//		this.height = height;
//	}

    

}
