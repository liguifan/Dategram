package com.post;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amazonaws.util.json.JSONArray;
import com.amazonaws.util.json.JSONException;
import com.amazonaws.util.json.JSONObject;
import com.amazonaws.util.json.JSONTokener;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array;
//Network interface: The word in the () is the key or key:value.
//
//1. register: (ID, name, gender, photourl, age, movies[], favorites[]) ——> respond:(OK);
//
//2. update:(ID, pushrecv[]: pushID) ——>respond:(OK, missedmatch[]: (ID, name, gender,  age, blurphoto, common, rate,piechart[] ) ); Send after the first heartbeat when come back and get pushID
//
//3. friendlist:(ID) ——> respond:userself, friendlist[](ID, name gender, photourl, age, movies[], favorites[], rate, piechart[])  first one is for the user himself; Send when game finished.
//
//4. heartbeat:(ID, status{ online, offline, playing, pushrecv: pushID}) Send every 4s in normal mode——>respond:(OK, matchrequest(optional): (ID, name, gender,  age, blurphoto, common, rate,piechart[] ) );
//
//5. match:(ID, answer:ID, fliter); ——> respond:(ID, blurphoto, commoninterest, rate,piechart[] ); if it is responing to a match, then Answer is not "", for server, if an request expired, then send a respond with empty ID back to the user.
//
//6. gamemode:(ID, command, detail) Commandlist: {submit:answer, start:ID(mate’s), quit, nothing}  Send every second——> respond:(status, ID, blurphoto, gamepic, stage) status:{ continue, success, fail, quit})
//Upon success, the document of the new connection’s info is append in the respond

public class HTTPhandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static boolean run=true;
	public HTTPhandler() {
		super();
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		JSONObject jsonObject = new JSONObject();
		StringBuffer jsonbuffer = new StringBuffer();
		String line = null;

		try {
			BufferedReader reader = request.getReader();
			while ((line = reader.readLine()) != null)
				jsonbuffer.append(line);
		} catch (Exception e) { /* report an error */
		}

		try {
			jsonObject = new JSONObject(new JSONTokener(jsonbuffer.toString()));
			JSONObject JSONrespon = parseRequest(jsonObject);// handle
			// jsonobject
			response.setContentType("application/json");
			PrintWriter out = response.getWriter();
			out.println(JSONrespon);
			out.flush();

		} catch (JSONException e1) {
			// TODO Auto-generated catch block

			PrintWriter out = response.getWriter();
			out.println("Format error");
			out.flush();
			e1.printStackTrace();
		} catch (SQLException e) {
			PrintWriter out = response.getWriter();
			out.println("SQL exception");
			out.println(e);
			out.flush();
			e.printStackTrace();
		}
		response.getWriter().close();
	}

	public static JSONObject register(JSONObject json)throws JSONException, SQLException, IOException {
		JSONObject obj = json.getJSONObject("register");
		String ID = obj.getString("ID");
		String name = obj.getString("name");
		String age = obj.getString("age");
		String photo = obj.getString("photourl");
		String movies = obj.getString("movies");
		JSONObject favorites = obj.getJSONObject("favorites");
		String athlete="";
		String team="";
		String musician="";
		String personality="nice person";
		if(favorites.has("athlete")){
			athlete=favorites.getString("athlete");
		}
		if(favorites.has("team")){
			team=favorites.getString("team");
		}
		if(favorites.has("musician")){
			musician=favorites.getString("musician");
		}

		RDS rds=new RDS();
		Image_process image=new Image_process();
		rds.createConnectionAndStatement();
		String stage="-1";
		String url1="";
		String url2="";
		String url3="";
		String online_status="online";
		String last_online="";
		String last_update="";

		long current_time=System.currentTimeMillis();
		String time=""+current_time;

		URL url = new java.net.URL(photo);
		HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();
		httpURLConnection.setInstanceFollowRedirects( false );
		httpURLConnection.connect();
		String header = httpURLConnection.getHeaderField("Location");


		try{
			if(ID.equals("100007158396565")){
				rds.update_register(ID, name+"liguifan", age+"1", header, movies, athlete, team, musician, personality);
			}
			rds.register_ID(ID, name, age, header, movies, athlete, team, musician, personality);
			rds.update_DynamicStatus(ID,stage,url1,url2,url3,online_status,last_online,time);
			image.RetrieveImage2S3(header, ID);
			image.upload_Gaussian(header);
		}
		catch(NullPointerException e2){
			JSONObject respon = new JSONObject();
			JSONObject temp = new JSONObject();
			temp.put("OK", e2);
			//                     temp.put("OK12", in);
			respon.put("respond", temp);
			return respon;

		}
		JSONObject respon = new JSONObject();
		JSONObject temp = new JSONObject();
		temp.put("OK", "Success");
		respon.put("respond", temp);
		return respon;
	}





	public static JSONObject update(JSONObject json)throws JSONException {
		JSONObject obj = json.getJSONObject("update");
		String ID = obj.getString("ID");
		JSONArray pushrecv = obj.getJSONArray("pushrecv");

		JSONObject respon = new JSONObject();
		JSONObject temp = new JSONObject();
		JSONArray missedmatch =new JSONArray();
		temp.put("OK", pushrecv.length());
		temp.put("missedmatch", missedmatch);
		respon.put("respond", temp);
		return respon;
	}


	public static JSONObject friendlist(JSONObject json)throws JSONException {
		JSONObject obj = json.getJSONObject("friendlist");
		String ID = obj.getString("ID");

		JSONObject respon = new JSONObject();
		JSONObject temp = new JSONObject();
		JSONArray friendlist =new JSONArray();
		JSONObject self = new JSONObject();
		self.put("ID", "123123123");
		temp.put("userself", self);
		temp.put("friendlist", friendlist);
		respon.put("respond", temp);
		return respon;
	}

	public static JSONObject heartbeat(JSONObject json)throws JSONException {
		JSONObject obj = json.getJSONObject("heartbeat");
		String ID = obj.getString("ID");
		String status = obj.getString("status");
		if(status.equals("online")){}
		else if(status.equals("offline")){}
		else if(status.equals("playing")){}
		else {   }// the string is pushID

		JSONObject respon = new JSONObject();
		JSONObject temp = new JSONObject();
		JSONObject self = new JSONObject();
		run=false;

		//
		//                if status==online
		//                {
		//                	change online of ID in DB to online and update timestamp(current tiem)
		//                	//get the info of this ID
		//                	//status is for the database status
		//                	if(status=-1 || status== ready || status==wait){
		//                		nothing
		//                	}
		//                	else if(status = respond){
		//                		read matchID, get info of matchID
		//                		respond to user of ID.
		//                	}
		//                	else if(status= wait) {
		//						
		//					}
		//                	else 
		//                	{
		//                		respond with quit.
		//                	}
		//    }



		self.put("ID", "123123123");
		temp.put("matchrequest", self);
		temp.put("OK", "OK");
		respon.put("respond", temp);
		return respon;
	}

	public static JSONObject match(JSONObject json)throws JSONException {
		JSONObject obj = json.getJSONObject("match");
		String ID = obj.getString("ID");
		String answer = obj.getString("answer");

		JSONObject respon = new JSONObject();
		JSONObject temp = new JSONObject();

		Users user=new Users();
		if(answer.isEmpty()){// user request a new match
			//call ML algorithm

			/*	

                	check ID's status
                	if(-1){
                		  String mate= user.ML_matching(ID);
                		  online update,
                		  last update to current timestamp.
                	}
                	else if(respond){
                		get mate_id and respond to user
                		change status to 'wait';
                	}
                	else if(answer='quit') {
						change ID's status to -1;
						change mate_id ' status to 'quit'
					}
                	else
                	{
                		if(status==quit){
                			respond 'quit'
                		}else if (status= wait) {
							change ID's status to ready
                			enter game!
						}else {

						}
                	}

                    //get the info of mate

                    while(true){
                    		if(run==false){
                    			//send request to B

                    			break;
                    		}
                    }

                run=true;
			 */

			temp.put("ID", "");
		}
		else { // user are responding to a existing match with another user"ID";
			temp.put("ID", "123123");
		}
		respon.put("respond", temp);
		return respon;
	}

	public static JSONObject gamemode(JSONObject json)throws JSONException {
		JSONObject obj = json.getJSONObject("gamemode");
		String ID = obj.getString("ID");
		String command = obj.getString("command");
		String detail = obj.getString("detail");

		JSONObject respon = new JSONObject();
		JSONObject temp = new JSONObject();
		if(command.equals("submit")){  String answer = detail;}
		else if(command.equals("start")){String matchID = detail;}
		else if(command.equals("quit")){ }//quit
		else {   }// nothing
		temp.put("stage", "2");
		temp.put("status", "continue");
		respon.put("respond", temp);
		return respon;
	}

	public static JSONObject parseRequest(JSONObject json) throws JSONException, SQLException, IOException {
		if (json.has("register")) {
			JSONObject respon = register(json);
			return respon;
		}
		else if (json.has("register")) {
			JSONObject respon = register(json);
			return respon;
		}
		else if (json.has("update")) {
			JSONObject respon = update(json);
			return respon;
		}
		else if (json.has("friendlist")) {
			JSONObject respon = friendlist(json);
			return respon;
		}
		else if (json.has("heartbeat")) {
			JSONObject respon = heartbeat(json);
			return respon;
		}
		else if (json.has("match")) {
			JSONObject respon = match(json);
			return respon;
		}
		else if (json.has("gamemode")) {
			JSONObject respon = gamemode(json);
			return respon;
		}
		else{
			JSONObject respon = new JSONObject();
			JSONObject temp = new JSONObject();
			temp.put("OK", "no");
			respon.put("respond", temp);
			return respon;
		}
	}
}