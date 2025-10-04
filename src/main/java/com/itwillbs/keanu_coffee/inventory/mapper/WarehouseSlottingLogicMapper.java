package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inventory.dto.AvailableWarehouseSpaceDTO;

//import com.itwillbs.keanu_coffee.inventory.service.ProductOrderDTO;

@Mapper
public interface WarehouseSlottingLogicMapper {

	public List<AvailableWarehouseSpaceDTO> selectOpenLocationFromPickingZone();

	public List<AvailableWarehouseSpaceDTO> selectOpenLocationFromPalletZone();

	public List<InboundDetailDTO> selectInboundProductThatNeedLocation();

//	public List<ProductOrderDTO> selectSalesStats(Date startOfMonth, Date endOfMonth);
}
