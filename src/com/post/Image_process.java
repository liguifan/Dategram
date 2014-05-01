package com.post;
import gaussian.GaussianFilter;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.ArrayList;

import javax.imageio.ImageIO;

import org.apache.commons.io.IOUtils;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;

public class Image_process {



	public static void main(String[] args) throws Exception {
		String imageUrl = "https://s3.amazonaws.com/elasticbeanstalk-us-east-1-310698506257/10c1040.jpg";
		String destinationFile = "/Users/liguifan/Desktop/mmm.jpg";

		//		RetrieveImage2S3(imageUrl, destinationFile);
	}

	public void RetrieveImage2S3(String imageUrl, String UserID) throws IOException {
		String buckName="liguifan-cloud-image";

		URL url = new URL(imageUrl);
		InputStream is = url.openStream();

		//		OutputStream os = new FileOutputStream(destinationFile);

		byte[] b = new byte[2048];
		int length;

		//		while ((length = is.read(b)) != -1) {
		//			os.write(b, 0, length);
		//		}


		String Phote_image=UserID+"1";
		AmazonS3 s3 = new AmazonS3Client(new ClasspathPropertiesFileCredentialsProvider());

		try {
			b = IOUtils.toByteArray(is);
		} catch (IOException e) {
			System.err.printf("Failed while reading bytes from %s", e.getMessage());
		} 

		Long contentLength = Long.valueOf(b.length);
		InputStream inputStream=url.openStream();
		ObjectMetadata metadata = new ObjectMetadata();
		metadata.setContentLength(contentLength);

		try {
			s3.putObject(new PutObjectRequest(buckName, Phote_image, inputStream, metadata));
		} catch (AmazonServiceException ase) {
			System.out.println("Error Message:    " + ase.getMessage());
			System.out.println("HTTP Status Code: " + ase.getStatusCode());
			System.out.println("AWS Error Code:   " + ase.getErrorCode());
			System.out.println("Error Type:       " + ase.getErrorType());
			System.out.println("Request ID:       " + ase.getRequestId());
		} catch (AmazonClientException ace) {
			System.out.println("Error Message: " + ace.getMessage());
		} finally {
			if (is != null) {
				is.close();
			}
		}

		is.close();
		//		os.close();
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

	public void upload_Gaussian(String imageUrl) throws IOException {
//		imageUrl="https://s3.amazonaws.com/chaoqian123/pic-77-1-1024x768.jpg";
		//		InputStream is1=new FileInputStream(imageUrl);

		try{
			URL url = new URL(imageUrl);
			InputStream is = url.openStream();
			BufferedImage image=getImgURL(is); 

			for(int i=1;i<6;i++){
				GaussianFilter BB=new GaussianFilter(18*i);  // the radius of the blur
				BufferedImage imageA=BB.filter(image,null);
				//This is store the pictures in local
				File file = new File ("/Users/liguifan/Desktop/Cloud_pic/shuguan"+i+".jpg");
				String format = "JPEG";
				ImageIO.write(imageA, format , file);

				//This is to upload in S3
				AmazonS3 s3 = new AmazonS3Client(new ClasspathPropertiesFileCredentialsProvider());
				ByteArrayOutputStream os = new ByteArrayOutputStream();
				ImageIO.write(imageA, format , os);
				InputStream inputS = new ByteArrayInputStream(os.toByteArray());

				String Phote_image="mm"+i;
				String buckName="liguifan-cloud-image";
				byte[] b = IOUtils.toByteArray(inputS);
				System.out.println(b.length);
				Long contentLength = Long.valueOf(b.length);
				ObjectMetadata metadata = new ObjectMetadata();
				metadata.setContentLength(contentLength);
				InputStream inputS1 = new ByteArrayInputStream(os.toByteArray());
				s3.putObject(new PutObjectRequest(buckName, Phote_image, inputS1, metadata));

			}
		}finally{

	}
}

	



}
