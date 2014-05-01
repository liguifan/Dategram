package gaussian;

import java.awt.image.BufferedImage;
import java.awt.image.Kernel;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import javax.imageio.ImageIO;

import org.apache.commons.io.IOUtils;

import com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
public class GaussianFilter extends ConvolveFilter {

	static final long serialVersionUID = 5377089073023183684L;

	protected float radius;
	protected Kernel kernel;

	/**
	 * Construct a Gaussian filter
	 */
	public GaussianFilter() {
		this(2);
	}

	/**
	 * Construct a Gaussian filter
	 * @param radius blur radius in pixels
	 */
	public GaussianFilter(float radius) {
		setRadius(radius);
	}

	/**
	 * Set the radius of the kernel, and hence the amount of blur. The bigger the radius, the longer this filter will take.
	 * @param radius the radius of the blur in pixels.
	 */
	public void setRadius(float radius) {
		this.radius = radius;
		kernel = makeKernel(radius);
	}

	/**
	 * Get the radius of the kernel.
	 * @return the radius
	 */
	public float getRadius() {
		return radius;
	}

	public BufferedImage filter( BufferedImage src, BufferedImage dst ) {
		int width = src.getWidth();
		int height = src.getHeight();

		if ( dst == null )
			dst = createCompatibleDestImage( src, null );

		int[] inPixels = new int[width*height];
		int[] outPixels = new int[width*height];
		src.getRGB( 0, 0, width, height, inPixels, 0, width );

		convolveAndTranspose(kernel, inPixels, outPixels, width, height, alpha, CLAMP_EDGES);
		convolveAndTranspose(kernel, outPixels, inPixels, height, width, alpha, CLAMP_EDGES);

		dst.setRGB( 0, 0, width, height, inPixels, 0, width );
		return dst;
	}

	public static void convolveAndTranspose(Kernel kernel, int[] inPixels, int[] outPixels, int width, int height, boolean alpha, int edgeAction) {
		float[] matrix = kernel.getKernelData( null );
		int cols = kernel.getWidth();
		int cols2 = cols/2;

		for (int y = 0; y < height; y++) {
			int index = y;
			int ioffset = y*width;
			for (int x = 0; x < width; x++) {
				float r = 0, g = 0, b = 0, a = 0;
				int moffset = cols2;
				for (int col = -cols2; col <= cols2; col++) {
					float f = matrix[moffset+col];

					if (f != 0) {
						int ix = x+col;
						if ( ix < 0 ) {
							if ( edgeAction == CLAMP_EDGES )
								ix = 0;
							else if ( edgeAction == WRAP_EDGES )
								ix = (x+width) % width;
						} else if ( ix >= width) {
							if ( edgeAction == CLAMP_EDGES )
								ix = width-1;
							else if ( edgeAction == WRAP_EDGES )
								ix = (x+width) % width;
						}
						int rgb = inPixels[ioffset+ix];
						a += f * ((rgb >> 24) & 0xff);
						r += f * ((rgb >> 16) & 0xff);
						g += f * ((rgb >> 8) & 0xff);
						b += f * (rgb & 0xff);
					}
				}
				int ia = alpha ? PixelUtils.clamp((int)(a+0.5)) : 0xff;
				int ir = PixelUtils.clamp((int)(r+0.5));
				int ig = PixelUtils.clamp((int)(g+0.5));
				int ib = PixelUtils.clamp((int)(b+0.5));
				outPixels[index] = (ia << 24) | (ir << 16) | (ig << 8) | ib;
				index += height;
			}
		}
	}


	public static Kernel makeKernel(float radius) {
		int r = (int)Math.ceil(radius);
		int rows = r*2+1;
		float[] matrix = new float[rows];
		float sigma = radius/3;
		float sigma22 = 2*sigma*sigma;
		float sigmaPi2 = 2*ImageMath.PI*sigma;
		float sqrtSigmaPi2 = (float)Math.sqrt(sigmaPi2);
		float radius2 = radius*radius;
		float total = 0;
		int index = 0;
		for (int row = -r; row <= r; row++) {
			float distance = row*row;
			if (distance > radius2)
				matrix[index] = 0;
			else
				matrix[index] = (float)Math.exp(-(distance)/sigma22) / sqrtSigmaPi2;
			total += matrix[index];
			index++;
		}
		for (int i = 0; i < rows; i++)
			matrix[i] /= total;

		return new Kernel(rows, 1, matrix);
	}

	public String toString() {
		return "Blur/Gaussian Blur...";
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



	public static void main(String args[]) throws IOException{
		String imageUrl="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-frc3/t1.0-1/s200x200/1506815_1414118422170091_486868967_n.jpg";
		String path="/Users/liguifan/Desktop/Cloud_pic/jj.jpg";
		//		InputStream is1=new FileInputStream(imageUrl);


		URL url = new URL(imageUrl);
		InputStream is = url.openStream();
		BufferedImage image=getImgURL(is); 


		
		for(int i=0;i<6;i++){
			GaussianFilter BB=new GaussianFilter((int)Math.sqrt(5*i+1));  // the radius of the blur
			BufferedImage imageA=BB.filter(image,null);
			File file = new File ("/Users/liguifan/Desktop/Cloud_pic/sss"+i+".jpg");
			String format = "JPEG";
			ImageIO.write(imageA, format , file);
			try {
				//			ImageIO.write(imageA,format,file);
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


			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}







	}




}