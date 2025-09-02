package com.itwillbs.keanu_coffee.common.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseWithSupplierDTO;

@Mapper
public interface PurchaseOrderMapper {

	List<PurchaseWithSupplierDTO> orderDetail();

	List<PurchaseWithSupplierDTO> getOrderDetailByOrderIdx(int orderIdx);



}
