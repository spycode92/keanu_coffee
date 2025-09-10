package com.itwillbs.keanu_coffee.common.mapper;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseWithSupplierDTO;
import com.itwillbs.keanu_coffee.inventory.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.inventory.dto.SupplierProductContractDTO;

@Mapper
public interface PurchaseOrderMapper {

	List<PurchaseWithSupplierDTO> orderDetail();

	List<PurchaseWithSupplierDTO> getOrderDetailByOrderIdx(int orderIdx);



	String selectTodaysPurchaseOrderNumbersInOrderToMakeNewPurchaseOrderNumber();

	void insertProductOrder(@Param("orderIdx") int orderIdx, @Param("orderNumber") String orderNumber, @Param("supplierIdx") int supplierIdx, @Param("orderDate") LocalDateTime orderDate, @Param("expectedArrivalDate") LocalDate expectedArrivalDate);

	List<OutboundOrderItemDTO> selectLastMonthsDemand(@Param("month") int month, @Param("year") int year, @Param("daysInLastMonth") int daysInLastMonth);

	List<OutboundOrderItemDTO> seletAvgDemandSameWeekOneYearAgo(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate, @Param("beta") double beta);

	List<OutboundOrderItemDTO> selectLastMonthsDemandItemsEveryDay(@Param("month") int month, @Param("year") int year);

	double selectPercentOfWarehouseUsed();

	List<OutboundOrderItemDTO> selectInventoryQuantity();

	List<OutboundOrderItemDTO> selectInboundWaitingQuantity();

	List<SupplierProductContractDTO> selectContracts();

	List<SupplierProductContractDTO> selectProductAndSuppplier();

	void insertProductOrderItem(@Param("orderIdx") int orderIdx, @Param("productIdx") int productIdx, @Param("quantity") double quantity);

	void insertInboundWaiting(@Param("inboundWaitingNumber") String inboundWaitingNumber, @Param("orderIdx") int orderIdx, @Param("quantity") int quantity, @Param("numberOfItems") int numberOfItems, @Param("expectedArrivalDate") LocalDate expectedArrivalDate);

	

}
