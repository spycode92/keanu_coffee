package com.itwillbs.keanu_coffee.transport.dto;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.utils.FileUtils.FileUploadHelpper;

import lombok.Data;

@Data
public class DeliveryConfirmationDTO implements FileUploadHelpper {
	   private Integer deliveryConfirmationIdx;  // 고유번호
	   private Integer dispatchAssignmentIdx;    // 배차 배정 고유번호
	   private Integer dispatchStopIdx;          // 경유지 고유번호
	   private Integer outboundOrderIdx;         // 출고주문 고유번호
	   private Timestamp confirmationTime;       // 수주확인 시간
	   private String receiverName;              // 수령자
	   private String note;                      // 비고
	   private char requiresAdditional;
	   private Timestamp updatedAt;
	   
	   private List<DeliveryConfirmationItemDTO> items;
	   
		// 파일업로드
		private MultipartFile[] files;
		private List<FileDTO> fileList;
	    
	    @Override
		public MultipartFile[] getFiles(){
			return files;
		}
	    @Override
		public String getTargetTable(){
			return "DELIVERY_CONFIRMATION";
		}
		@Override
		public Integer getTargetTableIdx() {
			return deliveryConfirmationIdx;
		}
}
