package com.itwillbs.keanu_coffee.inventory.service;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.Property;
import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.inventory.dto.GeneratePurchaseOrderDTO;
import com.itextpdf.layout.element.Cell;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Service;
@Service
public class PurchaseOrderGenerator {

    public void generatePurchaseOrder(String filePath, String supplier, GeneratePurchaseOrderDTO generatePurchaseOrderDTO) throws IOException {
        File file = new File(filePath);
        file.getParentFile().mkdirs();

        PdfWriter writer = new PdfWriter(filePath);
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf);

        // Title
        Paragraph title = new Paragraph("Purchase Order");
        		title.setProperty(Property.FONT_WEIGHT, "700");
                title.setFontSize(18);
                title.setMarginBottom(20);
        document.add(title);

        // Basic Info
//        document.add(new Paragraph("PO Number: " + generatePurchaseOrderDTO.getOrderNumber()));
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedTimestamp = now.format(formatter);

        document.add(new Paragraph("Date: " + formattedTimestamp));
        document.add(new Paragraph("Supplier: " + supplier));
        document.add(new Paragraph("Buyer: Keanu Coffee"));
        document.add(new Paragraph("\n"));

        // Table of Items
        float[] columnWidths = {200F, 100F, 100F, 100F};
        Table table = new Table(columnWidths);
        table.addHeaderCell(new Cell().add(new Paragraph("Item")));
        table.addHeaderCell(new Cell().add(new Paragraph("Quantity")));
        table.addHeaderCell(new Cell().add(new Paragraph("Unit Price")));
        table.addHeaderCell(new Cell().add(new Paragraph("Total")));

      
//        table.addCell(GeneratePurchaseOrderDTO.getProductName());
//        int productQuantity = GeneratePurchaseOrderDTO.getProductQuantity();
//        table.addCell(productQuantity);
//        int unitPrice = GeneratePurchaseOrderDTO.getUnitPrice();
//        table.addCell("$" + unitPrice);   
//        table.addCell("$" + productQuantity * unitPrice);

        
//        table.addCell("A4 Paper (500 sheets)");
//        table.addCell("5");
//        table.addCell("$8");
//        table.addCell("$40");

        document.add(table);

        // Footer
//        Paragraph footer = new Paragraph("\nTotal Amount: $" + productQuantity * unitPrice);
//        footer.setProperty(Property.FONT_WEIGHT, "700");
//        document.add(footer);
        document.add(new Paragraph("Thank you for your business!"));

        document.close();
    }
}
