package com.itwillbs.keanu_coffee.transport.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.common.dto.DisposalDTO;
import com.itwillbs.keanu_coffee.transport.dto.DeliveryConfirmationDTO;
import com.itwillbs.keanu_coffee.transport.dto.DeliveryConfirmationItemDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchAssignmentDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchDetailDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegisterRequestDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchStopDTO;

public interface DispatchMapper {
	
	// 페이징을 위한 배차 카운트
	int selectDispatchCount(@Param("filter") String filter, @Param("searchKeyword") String searchKeyword);

	// 배차 리스트
	List<DispatchRegionGroupViewDTO> selectAllDispatch(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("filter") String filter,
			@Param("searchKeyword") String searchKeyword);
	
	// 배차 요청 리스트
	List<DispatchRegionGroupViewDTO> selectDispatchList();

	// 배차 테이블 등록
	void insertDispatch(DispatchRegisterRequestDTO request);

	// 배차 배정 테이블 등록
	void insertDispatchAssignment(DispatchAssignmentDTO driver);

	// 배차 매핑 테이블 등록
	void insertDispatchOrderMap(@Param("outboundOrderIdx") Integer outboundOrderIdx,
			@Param("dispatchIdx") Integer dispatchIdx);

	// 출고Idx로 배차idx 조회
	List<Integer> selectByorderIdList(Integer outboundOrderIdx);

	// 배차 상태 취소로 변경
	void updateDispatchStatus(@Param("dispatchIdx") Integer dispatchIdx, @Param("status") String status);

	// 배차 상태 확인
	String selectDispatchStatus(int dispatchIdx);

	// 배차 상세 정보(적재 전)
	DispatchRegionGroupViewDTO selectDispatchSummary(@Param("dispatchIdx") Integer dispatchIdx, @Param("vehicleIdx") Integer vehicleIdx);

	// 배차 상제 정보(적재 완료 후)
	DispatchDetailDTO selectDispatchDetail(@Param("dispatchIdx") Integer dispatchIdx, @Param("vehicleIdx") Integer vehicleIdx);

	// 배차 정보 조회 (차량idx로 조회)
	List<DispatchRegionGroupViewDTO> selectDispatchByVehicleIdx(Integer vehicleIdx);

	// 마이페이지 배차 상세 정보 조회
	DispatchDetailDTO selectMyDispatchInfo(@Param("dispatchIdx") Integer dispatchIdx, @Param("vehicleIdx") Integer vehicleIdx);

	// 배차 배정 테이블 조회
	Integer selectAssigmentIdx(@Param("dispatchIdx") Integer dispatchIdx, @Param("vehicleIdx") Integer vehicleIdx);

	// 경유지 데이터 등록
	void insertDispatchStop(DispatchStopDTO dispatchStop);

	// 수주확인서 데이터 등록
	void insertDeliveryConfirmation(DeliveryConfirmationDTO confirmation);

	// 수주확인서품목 데이터 등록
	void insertDeliveryConfirmationItem(DeliveryConfirmationItemDTO confirmItem);

	// 현재 기사 Assignment 상태를 적재완료로 갱신
	void updateAssigmentStatus(@Param("assigmentIdx") Integer assigmentIdx, @Param("status") String status);
	
	// 같은 배차에 배정된 기사 수 카운트
	int selectCountAssigment(Integer dispatchIdx);
	
	// 상태에 따라 완료한 기사 수 카운트
	int selectCountAssignmentsByStatus(@Param("dispatchIdx") Integer dispatchIdx, @Param("status") String status);

	// 배정된 경유지 중 제일 첫 배송지
	Integer selectFirstStopIdx(@Param("dispatchIdx") Integer dispatchIdx, @Param("vehicleIdx") Integer vehicleIdx);

	// 경유지 테이블 상태 변경
	void updateDispatchStopStatus(@Param("firstStopIdx") Integer firstStopIdx, @Param("status") String status);

	// 경유지 테이블 업데이트(상태 및 시간)
	void updateDispatchStopCompleted(@Param("dispatchStopIdx") Integer dispatchStopIdx, @Param("status") String status);

	// 수주확인서 업데이트
	void updateDeliveryConfirmation(@Param("deliveryConfirmationIdx") Integer deliveryConfirmationIdx, @Param("receiverName") String receiverName);

	// 수주확인서 품목 업데이트
	void updateDeliveryConfirmationItem(DeliveryConfirmationItemDTO item);

	// 배정된 기사의 상태
	String selectDispatchAssignment(@Param("dispatchIdx") Integer dispatchIdx, @Param("vehicleIdx") Integer vehicleIdx);

	// 배차idx로 Assignment 상태 변경
	void updateAssigmentStatusByDispatchIdx(@Param("dispatchIdx") Integer dispatchIdx, @Param("status") String status);

	// 배차 매핑 테이블 삭제
	void deleteMapping(Integer dispatchIdx);
	
	// 배차에 배정된 차량 목록 조회
	List<Integer> selectAllVehicleIdx(Integer dispatchIdx);

	// 출고 idx 조회
	List<Integer> selectOutboundOrderIdx(Integer dispatchIdx);

	// 출고 주문 테이블 상태 변경
	void updateOutboundOrderStatus(@Param("outboundOrderIdx") Integer outboundOrderIdx, @Param("status") String status);
	
	// 출고 대기 시간 변경
	void updateOutboundWaiting(Integer outboundOrderIdx);

	// 적재 상태 확인
	String selectOutboundOrderStatus(Integer outboundOrderIdx);

	// 상품 번호 조회
	Integer selectReceiptProductIdxForDisposal(@Param("deliveryConfirmationIdx") Integer deliveryConfirmationIdx, @Param("confirmationItemIdx") Integer confirmationItemIdx);

	// 반품 폐기 처리
	void insertDeliveryDisposal(DisposalDTO disposal);
}
