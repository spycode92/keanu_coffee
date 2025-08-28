package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface InventoryActionsMapper {

	String insertWarehouse(List<String> locationList, int width, int depth, int height);

}
