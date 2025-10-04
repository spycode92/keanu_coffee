package com.itwillbs.keanu_coffee.inventory.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class WarehouseInfoDTO {	
    private int rackCount;
    private int bayCount;
    private int levelCount;
    private int positionCount;
	
}
