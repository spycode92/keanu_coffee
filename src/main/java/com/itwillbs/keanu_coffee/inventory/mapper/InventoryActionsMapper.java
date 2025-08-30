package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.inventory.dto.CreateWarehouseDTO;

@Mapper
public interface InventoryActionsMapper {

	void insertWarehouse(CreateWarehouseDTO createWarehouseDTO);

}
