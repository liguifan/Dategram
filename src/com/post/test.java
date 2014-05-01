package com.post;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.text.ParseException;
import java.util.Iterator;

import com.amazonaws.util.json.JSONException;
import com.amazonaws.util.json.JSONObject;
import com.amazonaws.util.json.JSONTokener;







public class test {
	
	
//	int	Requestlength=json.getJSONObject("test").getJSONArray("Tweets").length();
//	JSONObject obj = new JSONObject();
//	JSONArray array = new JSONArray();
//	for (int i = 0; i<Requestlength; i++){
//		array.put(json.getJSONObject("TwitterData").getJSONArray("Tweets").getJSONObject(i).getString("text"));
//		 Iterator<String> yourKeys = json.getJSONObject("TwitterData").getJSONArray("Tweets").getJSONObject(i).keys();
//		 while( yourKeys.hasNext() ){
//			 String temp = yourKeys.next();
//			 
//			 if(temp.equals("retweeted")){
//				 array.put(json.getJSONObject("TwitterData").getJSONArray("Tweets").getJSONObject(i).getString(temp));
//			 }
//		 }
//
//	}
//	
//	 JSONObject obj = new JSONObject();
//	 json.has("made");
//	 String ID = json.getJSONObject("test").getString("ID");
//	 Iterator<String> yourKeys = json.getJSONObject("test").getJSONObject("request").keys();
//	 while( yourKeys.hasNext() ){
//		 String temp = yourKeys.next();
//		 String text = json.getJSONObject("test").getJSONObject("request").getString(temp);
//    obj.put(temp, text);
//	 }
//	JSONObject respon = new JSONObject();
//	respon.put("HelloJSON", obj);
//	return respon;
// }
	
	
	public static void JSONparse(String path) throws FileNotFoundException, JSONException{
	 JSONObject jsonObject = new JSONObject();
	 StringBuffer jsonbuffer = new StringBuffer();
	 File f=new File(path);
	 JSONObject obj = new JSONObject(new JSONTokener(new FileReader(f)));  

	 int length=obj.getJSONObject("TwitterData").getJSONArray("Tweets").length();
	 for (int i=0; i<length; i++){
			String temp_text=obj.getJSONObject("TwitterData").getJSONArray("Tweets").getJSONObject(i).getString("text");
			System.out.println(temp_text);
	 }

}
public static void main(String[] args) throws Exception{  

String path= "/Users/bread/Downloads/tweets1.json";
	JSONparse(path);

} 
}

