package com.post;

import java.awt.image.BufferedImage;
import java.io.InputStream;

import javax.imageio.ImageIO;

public class FileOperation {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
	}
	
	
	public static BufferedImage getImgURL(InputStream IS) {
        BufferedImage bi = null;
        try {
            bi = ImageIO.read(IS);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bi;
    }
	
	
	public void file2strem(){
		
		
		
	}
	

}
