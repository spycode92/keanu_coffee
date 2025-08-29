package com.itwillbs.keanu_coffee.inventory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
@NoArgsConstructor
public class CreateWarehouseDTO {
    private char rack;
    private int bay;
    private String levelPostion;
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
