package com.itwillbs.keanu_coffee.inbound.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.inbound.dto.CommitInventoryDTO.InventoryItemDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundProductDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundStatusHistoryDTO;
import com.itwillbs.keanu_coffee.inbound.dto.ReceiptProductDTO;

@Mapper
public interface InboundMapper {
	
	// management 리스트 조회 (페이징)
	List<InboundManagementDTO> selectInboundList(Map<String, Object> searchParams);
	// management 리스트 조회 (엑셀)
	List<InboundManagementDTO> selectInboundListForExcel(Map<String, Object> searchParams);
	
	// management 총 개수
	int selectInboundCount(Map<String, Object> searchParams);
	
	
	// detail 기본 정보 조회
	InboundDetailDTO selectInboundDetailData(int ibwaitIdx);
	
	// detail 상품 정보 조회 
	List<InboundProductDetailDTO> selectInboundProductDetail(String orderNumber);
	
	// detail 로케이션 수정
	void updateLocation(@Param("ibwaitIdx") Long ibwaitIdx,
	                    @Param("inboundLocationNum") int inboundLocationNum);

	// 매니저 조회/수정
	List<EmployeeInfoDTO> selectEmployeeList();
	void updateManagers(@Param("ibwaitIdxList") List<Integer> ibwaitIdxList,
			            @Param("managerIdx") Long managerIdx,
			            @Param("managerName") String managerName);
	
	// 검수 데이터 여부 확인
	int selectDataExists(@Param("ibwaitIdx") Integer ibwaitIdx,
	                     @Param("productIdx") Integer productIdx,
	                     @Param("lotNumber") String lotNumber);
	
	// 검수완료 데이터 저장/수정
	void updateReceiptProduct(ReceiptProductDTO dto);
	void insertReceiptProduct(ReceiptProductDTO dto);
	void updatePurchaseOrderItemAfterInspection(ReceiptProductDTO dto);
	
	// 검수버튼시 '검수중'상태변경
	void updateInboundStatus(@Param("ibwaitIdx") Integer ibwaitIdx, @Param("status") String status);
	
	// 인벤토리 insert
	void insertInventory(InventoryItemDTO item);
	
	// detail.로그조회
	List<InboundStatusHistoryDTO> selectInboundStatusHistory(@Param("ibwaitIdx") Integer ibwaitIdx);
	Integer selectReceiptProductIdx(@Param("ibwaitIdx") Integer ibwaitIdx,
						            @Param("productIdx") Integer productIdx,
						            @Param("lotNumber") String lotNumber);
	
	List<InboundManagementDTO> selectInboundListFilter(Map<String,Object> searchParams);
    int selectInboundCountFilter(Map<String,Object> searchParams);
	
}
