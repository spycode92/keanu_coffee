package com.itwillbs.keanu_coffee.common.utils;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.NotFoundException;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

public class makeQRCode {
	public static void createQR(
			String data, String path,
	            String charset, Map hashMap,
	            int height, int width
	            )
	throws WriterException, IOException
	{
		Path filePath = Paths.get(path);
	
	BitMatrix matrix = new MultiFormatWriter().encode(
	new String(data.getBytes(charset), charset),
	BarcodeFormat.QR_CODE, width, height);
	
	MatrixToImageWriter.writeToPath(
	matrix,
	path.substring(path.lastIndexOf('.') + 1),
	filePath);
	}
	
	// Driver code
	public static void main(String[] args)
	throws WriterException, IOException,
	NotFoundException
	{
	
	// The data that the QR code will contain
	String data = "Isak is so cool";
	
	// The path where the image will get saved
	String path = "C:\\Users\\isaks\\Downloads\\qrCode.jpg";	
	// Encoding charset
	String charset = "UTF-8";
	
	Map<EncodeHintType, ErrorCorrectionLevel> hashMap
	= new HashMap<EncodeHintType,
	      ErrorCorrectionLevel>();
	
	hashMap.put(EncodeHintType.ERROR_CORRECTION,
	ErrorCorrectionLevel.L);
	
	// Create the QR code and save
	// in the specified folder
	// as a jpg file
	createQR(data, path, charset, hashMap, 200, 200);
//	System.out.println("QR Code Generated!!! ");
	}
}
