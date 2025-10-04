package com.itwillbs.keanu_coffee.inventory.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AvailableWarehouseSpaceDTO {
	
	
	public AvailableWarehouseSpaceDTO(int locationIdx, String locationName, int totalVolume, int usedVolume,
			int availableVolume, double availablePercent) {
		this.locationIdx = locationIdx;
		this.locationName = locationName;
		this.totalVolume = totalVolume;
		this.usedVolume = usedVolume;
		this.availableVolume = availableVolume;
		this.availablePercent = availablePercent;
	}
	private int locationIdx;
	private String locationName;
	private char rack;
	private int bay;
	private String levelPosition;
	private int productIdx1;
	private int productIdx2;
	private int productIdx3;
	private int totalVolume;
	private int usedVolume;
	private int availableVolume;
	private double availablePercent;
	
	
}
