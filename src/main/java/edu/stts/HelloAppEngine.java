package edu.stts;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.FilePermission;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.auth.oauth2.ServiceAccountCredentials;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.datastore.*;
import com.google.cloud.storage.Storage;

import java.util.Date;

public class HelloAppEngine extends HttpServlet {

  /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Connection conn = Connection.getInstance();
	private Datastore ds = conn.getDatastore();
	private KeyFactory kf = ds.newKeyFactory().setKind("barang");
	@Override
  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException{
		PrintWriter out = resp.getWriter();
		String action = req.getParameter("action");
		
		if(action.equals("delete")) {
			Long id = Long.parseLong(req.getParameter("id"));
			delete(id);
		}
		
		if(action.equals("insert")) {
			String nama = req.getParameter("nama");
			Long harga = Long.parseLong(req.getParameter("harga"));
			Long qty = Long.parseLong(req.getParameter("qty"));
			insert(nama, harga, qty);
		}
		
		if(action.equals("edit")) {
			Long id = Long.parseLong(req.getParameter("id"));
			String nama = req.getParameter("nama");
			Long harga = Long.parseLong(req.getParameter("harga"));
			Long qty = Long.parseLong(req.getParameter("qty"));
			edit(id, nama, harga, qty);
		}
//		
//		String nama = req.getParameter("nama");
//		System.out.println("Ini Nama = "+nama);
//		String harga = req.getParameter("harga");
//		System.out.println("Ini harga = "+harga);
//		String qty = req.getParameter("qty");
//		System.out.println("Ini qty= "+qty);
//		
//		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
//		Date date = new Date();
//		System.out.println(dateFormat.format(date));
//		String tampDateTime = dateFormat.format(date);
//		Datastore datastore = DatastoreOptions.newBuilder().setProjectId("shoppingcart-182405").
//	    		setCredentials(ServiceAccountCredentials.fromStream(new FileInputStream("ShoppingCart-70489f4e859c.json"))).build().getService();
//		
//		KeyFactory keyFactory = datastore.newKeyFactory().setKind("barang");
//		Key taskKey = datastore.allocateId(keyFactory.newKey());
//		Entity task = Entity.newBuilder(taskKey)
//			    .set("harga", Long.parseLong(harga))
//			    .set("nama", nama)
//			    .set("qty",Long.parseLong(qty))
//			    .set("time", tampDateTime)
//			    .build();
//		
//		datastore.put(task);
//		
//		System.out.println("Sukses");
//
//		resp.sendRedirect("index.jsp");
		resp.sendRedirect("index.jsp");
  }
	
	private void delete(Long id) {
		Key barangKey = kf.newKey(id);
		ds.delete(barangKey);
	}
	
	private void edit(Long id, String nama, long harga, long qty) {
		
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Date date = new Date();
		System.out.println(dateFormat.format(date));
		String tampDateTime = dateFormat.format(date);
		
		
		Key barangKey = kf.newKey(id);
		Entity barang = Entity.newBuilder(barangKey)
				.set("harga", harga)
			    .set("nama", nama)
			    .set("qty",qty)
			    .set("time", tampDateTime)
			    .build();
		ds.put(barang);
	}
	
	private void insert(String nama, long harga, long qty) {
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Date date = new Date();
		System.out.println(dateFormat.format(date));
		String tampDateTime = dateFormat.format(date);
		
		
		Key barangKey = ds.allocateId(kf.newKey());
		Entity barang = Entity.newBuilder(barangKey)
				.set("harga", harga)
			    .set("nama", nama)
			    .set("qty",qty)
			    .set("time", tampDateTime)
			    .build();
		ds.put(barang);
	}
}