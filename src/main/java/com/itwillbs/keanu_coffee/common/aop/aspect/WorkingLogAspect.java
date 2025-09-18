package com.itwillbs.keanu_coffee.common.aop.aspect;


import java.time.LocalDate;
import java.util.Map;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.admin.mapper.OrganizationMapper;
import com.itwillbs.keanu_coffee.admin.mapper.SupplyContractMapper;
import com.itwillbs.keanu_coffee.common.aop.annotation.WorkingLog;
import com.itwillbs.keanu_coffee.common.aop.targetEnum.WorkingLogTarget;
import com.itwillbs.keanu_coffee.common.dto.DisposalDTO;
import com.itwillbs.keanu_coffee.common.dto.SystemLogDTO;
import com.itwillbs.keanu_coffee.common.mapper.LogMapper;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.common.utils.TimeUtils;
import com.itwillbs.keanu_coffee.inbound.dto.ReceiptProductDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.InventoryMoveMapper;
import com.itwillbs.keanu_coffee.transport.dto.DeliveryConfirmationDTO;
import com.itwillbs.keanu_coffee.transport.dto.DeliveryConfirmationItemDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegisterRequestDTO;
import com.itwillbs.keanu_coffee.transport.mapper.DispatchMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Aspect
@Component
@Log4j2
@RequiredArgsConstructor
public class WorkingLogAspect {
	private final DispatchMapper dispatchMapper;
	private final LogMapper logmapper;
	private final InventoryMoveMapper inventoryMoveMapper;
	
//	@Around("@annotation(com.itwillbs.keanu_coffee.common.aop.annotation.Insert)")
//	@Around("execution(* com.itwillbs.keanu_coffee.admin.service.*.insertEmployeeInfo(..))")
	
	//직원관리 - 직원추가 로그기록
	@Around("@annotation(workingLog)")
	public Object insertEmployeeLog(ProceedingJoinPoint pjp, WorkingLog workingLog ) throws Throwable {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		SystemLogDTO slog = new SystemLogDTO();
		//시작시간
		long startTime = System.currentTimeMillis();

		//타겟테이블정보
		WorkingLogTarget target = workingLog.target();
		slog.setTarget(target.name());

		//작업자
		String empNo = authentication.getName();
		EmployeeDetail empDetail = (EmployeeDetail)authentication.getPrincipal();
		Integer empIdx = empDetail.getEmpIdx();
		String empName = empDetail.getEmpName();
		
		slog.setEmpNo(empNo);
		
		//작업로그지정
		slog.setSection("작업로그");
		
		Object result = null;
		String errorMessage = null;
		try {
		        result = pjp.proceed(); // 정상 실행
		} catch (Throwable ex) {
			errorMessage = ex.getMessage(); // 에러 메시지 저장
			// 필요하면 stack trace 등도 저장 가능
			throw ex; // 예외 다시 던져서 흐름 유지
		} finally {
			long endTime = System.currentTimeMillis();
	        long elapsedTime = endTime - startTime;
	        slog.setEmpNo(empNo);
	        slog.setStartTime(TimeUtils.formatMillisToLocalDateTime(startTime));
	        slog.setEndTime(TimeUtils.formatMillisToLocalDateTime(endTime));
	        slog.setElapsedTime(elapsedTime);

	        Object[] args = pjp.getArgs();
	        
	        for(int i = 0; i< args.length; i++) {
	        	System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ ");
	        	System.out.println("인덱스["+ i + "] :" + args[i]);
	        	System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ ");
	        }

	        String methodName = pjp.getSignature().getName();
	        //운송시작
	        if (methodName.equals("updateDispatchStatusStart")) {
	        	DispatchRegisterRequestDTO dispatchRegisterRequest = (DispatchRegisterRequestDTO) args[0];
	            slog.setSubSection("출고완료/운송시작");
	            
	            Integer dispatchIdx = dispatchRegisterRequest.getDispatchIdx();
	            dispatchRegisterRequest = dispatchMapper.selectDispatchDetailByDispatchIdx(dispatchIdx, empIdx);
	            
	            slog.setTargetIdx(dispatchIdx);
	            if (errorMessage == null) {
	                slog.setLogMessage(
                		slog.getSection() + ">" + slog.getSubSection() + " : "  + 
                				empName + "(" + empNo + ") "  + " 운전기사가 " + dispatchRegisterRequest.getOrderIds()
                				+ "번 주문의 운송을 시작합니다."
	                );
	            } else {
	                slog.setLogMessage(
	                		slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	                				empName + "(" + empNo + ") "  + " 운전기사가 운송 시작 중 에러 발생"
	                );
	            }
	        }
	        //운송완료
	        if (methodName.equals("updateDeliveryCompleted")) {
	        	DeliveryConfirmationDTO deliveryConfirmation = (DeliveryConfirmationDTO) args[0];
	        	slog.setSubSection("운송완료");
	        	
	        	Integer deliveryConfirmationIdx = deliveryConfirmation.getDeliveryConfirmationIdx();
	        	deliveryConfirmation = dispatchMapper.selectDeliveryConfirmationByDeliveryConfirmationIdx(deliveryConfirmationIdx);
	        	
	        	slog.setTargetIdx(deliveryConfirmation.getDeliveryConfirmationIdx());
	        	if (errorMessage == null) {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        						empName + "(" + empNo + ") "  + " 운전기사가 " + deliveryConfirmation.getOutboundOrderIdx()
	        						+ "번 주문의 운송을 완료하였습니다."
	        				);
	        	} else {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        						empName + "(" + empNo + ") "  + " 운전기사가 운송 완료중 에러 발생"
	        				);
	        	}
	        }
	        
	        // 카트에담기
	        if (methodName.equals("addCart")) {
	        	InventoryDTO inventory = (InventoryDTO) args[0];
	        	slog.setSubSection("재고이동");
	        	
	        	String productName = inventoryMoveMapper.selectProductName(inventory.getLotNumber());
	        	
	        	
	        	slog.setTargetIdx(inventory.getInventoryIdx());
	        	if (errorMessage == null) {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        						empName + "(" + empNo + ") "  + " 사원이 " + inventory.getLocationName() 
	        						+ "의 " + productName + "(" + inventory.getLotNumber() + ")을 " 
	        						+ inventory.getQuantity() +"개 카트에 담았습니다."
	        				);
	        	} else {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        						empName + "(" + empNo + ") "  + " 사원이 로케이션→카트 재고이동중 에러 발생."  
	        				);
	        	}
	        }
	        
	        // 로케이션으로 재고이동
	        if (methodName.equals("moveInventory")) {
	        	InventoryDTO inventory = (InventoryDTO) args[0];
	        	slog.setSubSection("재고이동");
	        	
	        	String productName = inventoryMoveMapper.selectProductName(inventory.getLotNumber());
	        	
	        	slog.setTargetIdx(inventory.getInventoryIdx());
	        	if (errorMessage == null) {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        						empName + "(" + empNo + ") "  + " 사원이 " + productName + 
	        						"(" + inventory.getLotNumber() + ")을 " + inventory.getQuantity() +"개 "
	        						+ inventory.getLocationName() + "에 진열 하였습니다."
	        				);
	        	} else {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        						empName + "(" + empNo + ") "  + " 사원이 카트→로케이션 재고이동중 에러 발생."  
	        				);
	        	}
	        }
	        
	        // 입고완료처리
	        if (methodName.equals("inspectionCompleteUpdate")) {
	        	ReceiptProductDTO receiptProduct = (ReceiptProductDTO) args[0];
	        	slog.setSubSection("입고처리");
	        	
//	        	String productName = inventoryMoveMapper.selectProductName(inventory.getLotNumber());
	        	
//	        	slog.setTargetIdx(inventory.getInventoryIdx());
//	        	if (errorMessage == null) {
//	        		slog.setLogMessage(
//	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
//	        						empName + "(" + empNo + ") "  + " 사원이 " + productName + 
//	        						"(" + inventory.getLotNumber() + ")을 " + inventory.getQuantity() +"개 "
//	        						+ inventory.getLocationName() + "에 진열 하였습니다."
//	        				);
//	        	} else {
//	        		slog.setLogMessage(
//	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
//	        						empName + "(" + empNo + ") "  + " 사원이 카트→로케이션 재고이동중 에러 발생."  
//	        				);
//	        	}
	        }
	        
	        // 출고 상태 변경(대기 -> 출고준비)
	        if (methodName.equals("updateStatusDispatchWait")) {
	        	String obwaitNumber = (String) args[0];
	        	Long outboundOrderIdx = (Long) args[1];
	        	
	        	slog.setSubSection("출고준비완료");
	        	
	        	
	        	
	        	slog.setTargetIdx(outboundOrderIdx.intValue());
	        	if (errorMessage == null) {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        						empName + "(" + empNo + ") "  + " 사원이 " + outboundOrderIdx + 
	        						"(" + obwaitNumber + ")주문을 준비완료 하였습니다."
	        				);
	        	} else {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        						empName + "(" + empNo + ") "  + " 사원이 " + outboundOrderIdx + 
	        						"(" + obwaitNumber + ")주문을 준비중 에러 발생"
	        				);
	        	}
	        }
	        // 발주처리 입고대기목록추가
	        if (methodName.equals("updateStatusDispatchWait")) {
	        	int orderIdx = (int) args[0];
	        	String orderNumber = (String) args[1];
	        	
	        	LocalDate expectedArrivalDate = (LocalDate) args[4];
	        	slog.setSubSection("출고준비완료");
	        	
	        	
	        	
	        	slog.setTargetIdx(orderIdx);
	        	if (errorMessage == null) {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        					orderIdx + "(" + orderNumber + ")" + "번 발주주문 완료."
	        				);
	        	} else {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        						orderIdx + "(" + orderNumber + ")" + "번 발주주문 중 ."
	        				);
	        	}
	        }
	        // 재고폐기처리
	        if (methodName.equals("disposalInventoryQuantity")) {
	        	
	        	DisposalDTO disposal = (DisposalDTO) args[1];
	        	Integer receiptProductIdx = disposal.getReceiptProductIdx();
	        	
	        	String productName = inventoryMoveMapper.selectProductNameWithReceiptProductIdx(receiptProductIdx);
	        	
	        	slog.setSubSection("재고 폐기");
	        	
	        	slog.setTargetIdx(disposal.getDisposalIdx());
	        	if (errorMessage == null) {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        						empName + "(" + empNo + ")이 " + productName + "(" + receiptProductIdx + ")상품 "
	        						+ disposal.getDisposalAmount() + "개를 폐기하였습니다."
	        				);
	        	} else {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + " : "  + 
	        						empName + "(" + empNo + ")이 " + productName + "(" + receiptProductIdx + ")상품 폐기중 에러발생."
	        				);
	        	}
	        }
	        	        
	        logmapper.insertSystemLog(slog);
//	        System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
//	        System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
//	        System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
//	        System.out.println(slog);
//	        System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
//	        System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
//	        System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
	    }
			
		
		return result;
		
        
	}
	
	
	
	
	
	
	






}

