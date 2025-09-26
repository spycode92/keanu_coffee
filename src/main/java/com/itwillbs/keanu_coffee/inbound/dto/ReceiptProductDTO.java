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

    // PK
    private Integer receiptProductIdx;

    // FK
    private Integer ibwaitIdx;     // 입고대기 PK
    private Integer productIdx;    // 상품 PK
    private Integer supplierIdx;   // 공급업체 PK

    // 고유 식별 요소
    private String lotNumber;      // LOT 번호

    // 수량/금액
    private Integer quantity;      
    private BigDecimal unitPrice;
    private BigDecimal amount;
    private BigDecimal tax;
    private BigDecimal totalPrice;

    // 검수 담당자
    private Integer empIdx;

    // 제조/유통기한
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate manufactureDate;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate expirationDate;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime inspectedAt;

    // 감사 필드
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime createdAt;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime updatedAt;
}
