package com.itwillbs.keanu_coffee.common.service;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.mapper.InboundMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ExcelExportService {

	private final InboundMapper inboundMapper;

	public Workbook createInboundManagementExcel(Map<String, Object> searchParams) {

		// 데이터 조회
		List<InboundManagementDTO> list = inboundMapper.selectInboundListForExcel(searchParams);

		// Workbook & Sheet 생성
		Workbook workbook = new XSSFWorkbook();
		Sheet sheet = workbook.createSheet("입고관리");

		// --- 헤더 스타일 ---
		CellStyle headerStyle = workbook.createCellStyle();
		Font headerFont = workbook.createFont();
		headerFont.setBold(true);
		headerFont.setFontHeightInPoints((short) 12);   // 글자 크기
		headerFont.setColor(IndexedColors.WHITE.getIndex());
		headerStyle.setFont(headerFont);
		headerStyle.setAlignment(HorizontalAlignment.CENTER);
		headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
		headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		headerStyle.setBorderTop(BorderStyle.THIN);
		headerStyle.setBorderBottom(BorderStyle.THIN);
		headerStyle.setBorderLeft(BorderStyle.THIN);
		headerStyle.setBorderRight(BorderStyle.THIN);

		// --- 데이터 스타일 ---
		CellStyle dataStyle = workbook.createCellStyle();
		Font dataFont = workbook.createFont();
		dataFont.setFontHeightInPoints((short) 11);   // 글자 크기
		dataStyle.setFont(dataFont);
		dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		dataStyle.setBorderTop(BorderStyle.THIN);
		dataStyle.setBorderBottom(BorderStyle.THIN);
		dataStyle.setBorderLeft(BorderStyle.THIN);
		dataStyle.setBorderRight(BorderStyle.THIN);

		// --- 헤더 작성 ---
		int rowNo = 0;
		Row header = sheet.createRow(rowNo++);
		String[] headers = {"발주번호", "입고번호", "입고일자", "공급업체", "상태", "품목수", "입고예정수량", "담당자", "비고"};

		for (int i = 0; i < headers.length; i++) {
		    Cell cell = header.createCell(i);
		    cell.setCellValue(headers[i]);
		    cell.setCellStyle(headerStyle);
		}

		// --- 데이터 작성 ---
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		for (InboundManagementDTO dto : list) {
			Row row = sheet.createRow(rowNo++);
		    int col = 0;

		    Cell c0 = row.createCell(col++);
		    c0.setCellValue(dto.getOrderNumber());
		    c0.setCellStyle(dataStyle);

		    Cell c1 = row.createCell(col++);
		    c1.setCellValue(dto.getIbwaitNumber());
		    c1.setCellStyle(dataStyle);

		    Cell c2 = row.createCell(col++);
		    c2.setCellValue(dto.getArrivalDate() != null ? dto.getArrivalDate().format(dtf) : "");
		    c2.setCellStyle(dataStyle);

		    Cell c3 = row.createCell(col++);
		    c3.setCellValue(dto.getSupplierName());
		    c3.setCellStyle(dataStyle);

		    Cell c4 = row.createCell(col++);
		    c4.setCellValue(dto.getInboundStatus());
		    c4.setCellStyle(dataStyle);

		    Cell c5 = row.createCell(col++);
		    c5.setCellValue(dto.getNumberOfItems());
		    c5.setCellStyle(dataStyle);

		    Cell c6 = row.createCell(col++);
		    c6.setCellValue(dto.getQuantity());
		    c6.setCellStyle(dataStyle);

		    Cell c7 = row.createCell(col++);
		    c7.setCellValue(dto.getManager() != null ? dto.getManager() : "");
		    c7.setCellStyle(dataStyle);

		    Cell c8 = row.createCell(col++);
		    c8.setCellValue(dto.getNote() != null ? dto.getNote() : "");
		    c8.setCellStyle(dataStyle);
		}


		// --- 컬럼 폭 자동조정 + 여백 ---
		for (int i = 0; i < headers.length; i++) {
		    sheet.autoSizeColumn(i);
		    sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 2048); // 여백
		}

		// --- 줄 높이 기본값 ---
		sheet.setDefaultRowHeightInPoints(18);

		// --- 필터 추가 ---
		sheet.setAutoFilter(new CellRangeAddress(0, 0, 0, headers.length - 1));

		// --- 헤더 고정 (스크롤 내려도 헤더 고정됨) ---
		sheet.createFreezePane(0, 1);

		return workbook;
	}
}
