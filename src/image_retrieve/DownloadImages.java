package image_retrieve;

import java.io.*;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.io.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jsoup.Jsoup;

import org.jsoup.nodes.Attributes;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import java.io.IOException;
import java.net.URL;

public class DownloadImages {

    //The url of the website. This is just an example
    private static final String webSiteURL = "http://b.zol-img.com.cn/desk/bizhi/image/2/1024x768/1366340444986.jpg";

    //The path of the folder that you want to save the images to
    private static final String folderPath = "/Users/liguifan/Desktop/Cloud_pic/web_image";

    public static void main(String[] args) {

        try {

            //Connect to the website and get the html
            Document doc = Jsoup.connect(webSiteURL).get();

            //Get all elements with img tag ,
            Elements img = doc.getElementsByTag("img");

            for (Element el : img) {

                //for each element get the srs url
                String src = el.absUrl("src");

                System.out.println("Image Found!");
                System.out.println("src attribute is : "+src);
                if(src.length()>1){
                	getImages(src);
                }
            }

        } catch (IOException ex) {
            System.err.println("There was an error");
            Logger.getLogger(DownloadImages.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private static void getImages(String src) throws IOException {

        String folder = null;

        //Exctract the name of the image from the src attribute
        int indexname = src.lastIndexOf("/");

        if (indexname == src.length()) {
            src = src.substring(1, indexname);
        }

        indexname = src.lastIndexOf("/");
        System.out.println("length is : "+src.length());
        String name = src.substring(indexname, src.length());

        System.out.println(name);

        //Open a URL Stream
        URL url = new URL(src);
        InputStream in = url.openStream();

        OutputStream out = new BufferedOutputStream(new FileOutputStream( folderPath+ name));

        for (int b; (b = in.read()) != -1;) {
            out.write(b);
        }
        out.close();
        in.close();

    }
}
