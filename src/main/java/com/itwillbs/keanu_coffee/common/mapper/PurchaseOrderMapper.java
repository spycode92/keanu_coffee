package com.itwillbs.keanu_coffee.common.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;

@Mapper
public interface PurchaseOrderMapper {

	List<PurchaseOrderDTO> orderDetail();

	List<PurchaseOrderDTO> getOrderDetailByOrderIdx(int orderIdx);



}
