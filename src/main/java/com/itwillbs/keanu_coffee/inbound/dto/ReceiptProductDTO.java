package com.itwillbs.keanu_coffee.inbound.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class ReceiptProductDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	// FK
	private Long ibwaitIdx;			// 입고대기 PK (RECEIPT_PRODUCT.ibwait_idx)
	private Long productIdx;		// 상품 PK (RECEIPT_PRODUCT.product_idx)

	// 고유 식별 요소
	private String lotNumber;		// LOT 번호

	// 수량/금액
	private Integer quantity;		// 수량
	private BigDecimal unitPrice;	// 단가
	private BigDecimal amount;		// 공급가액 = quantity * unitPrice
	private BigDecimal tax;			// 부가세(10%) = amount * 0.1
	private BigDecimal totalPrice;	// 총액 = amount + tax

	// 검수 담당/일자
	private Integer empIdx;			// 검수 담당자 idx
	private Integer supplierIdx;
	private Date manufactureDate; 

	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private LocalDate expirationDate;	// 유통기한(있으면 사용, 없으면 null)

	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private LocalDateTime inspectedAt;	// 검수완료 시각

	// 감사필드
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private LocalDateTime createdAt;

	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private LocalDateTime updatedAt;
}
