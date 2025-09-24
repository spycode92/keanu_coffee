package com.itwillbs.keanu_coffee.outbound.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundInspectionDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundInspectionItemDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundManagementDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundProductDetailDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundWaitingDTO;

@Mapper
public interface OutboundMapper {
	
	// 출고 전체 목록 조회
	List<OutboundManagementDTO> selectOutboundList(Map<String, Object> params);
	
	// 총 리스트조회
	int selectOutboundTotalCount(Map<String, Object> searchParams);
	
	 // 출고 기본정보 상세 조회
    OutboundManagementDTO selectOutboundDetail(@Param("obwaitNumber") String obwaitNumber, @Param("outboundOrderIdx") Long outboundOrderIdx);

    // 출고 품목 리스트 조회
    List<OutboundProductDetailDTO> selectOutboundProductDetail(@Param("outboundOrderIdx") Long outboundOrderIdx);
    
    // 출고 상태변경(대기 -> 출고준비)
    int updateStatusReady(@Param("orderIdxList") List<Long> orderIdxList);

    int updateStatusDispatchWait(@Param("obwaitNumber") String obwaitNumber, @Param("outboundOrderIdx") Long outboundOrderIdx);
    
    // management 매니저 지정
    List<EmployeeInfoDTO> selectEmployeeList();
    void updateManagers(@Param("obwaitIdxList") List<Integer> obwaitIdxList,
    					@Param("managerName") String managerName);
    
    // inspection 기본정보조회
    OutboundInspectionDTO selectOutboundDetailByIdx(@Param("obwaitIdx") Integer obwaitIdx, @Param("orderNumber") String orderNumber);
    
    // inspection 리스트 조회
    List<OutboundInspectionItemDTO> selectOutboundInspectionItems(@Param("outboundOrderIdx") Integer outboundOrderIdx);

    void updateOutboundLocation(@Param("obwaitIdx") Long obwaitIdx, @Param("outboundLocationIdx") Integer outboundLocationIdx);
    
	
}
