package edu.stts;

import java.io.FileInputStream;
import java.io.IOException;

import com.google.auth.oauth2.ServiceAccountCredentials;
import com.google.cloud.datastore.Datastore;
import com.google.cloud.datastore.DatastoreOptions;

public class Connection {
	private static Connection conn;
	private Datastore datastore;
	
	private Connection() {
		try {
			datastore = DatastoreOptions.newBuilder().setProjectId("shoppingcart-182405").
					setCredentials(ServiceAccountCredentials.fromStream(new FileInputStream("ShoppingCart-70489f4e859c.json"))).build().getService();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public Datastore getDatastore() {
		return datastore;
	}
	
	public static Connection getInstance() {
		if(conn == null) {
			conn = new Connection();
		}
		return conn;
	}
}
