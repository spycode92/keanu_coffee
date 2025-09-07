package com.itwillbs.keanu_coffee.transport.dto;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

import lombok.Data;

@Data
public class DispatchDetailDTO {
    private Integer dispatchIdx;      
    private Timestamp dispatchDate;   
    private String startSlot;         
    private String status;            
    private char urgent;              
    private Integer vehicleIdx;       
    private String vehicleNumber;     
    private Integer capacity;         
    private String driverName;        
    private String orderIds;          
    private BigDecimal totalVolume;   
    private Integer totalQty;

    // 여러 지점 정보
    private List<DispatchFranchiseDTO> franchises;
}
