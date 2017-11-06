<%@page import="com.google.appengine.api.datastore.Query.SortDirection"%>
<%@page import="com.google.cloud.datastore.StructuredQuery.OrderBy"%>
<%@page import="com.google.cloud.datastore.Datastore"%>
<%@page import="com.google.cloud.datastore.*" %>
<%@page import="com.google.cloud.storage.Storage" %>
<%@page import="com.google.auth.oauth2.ServiceAccountCredentials" %>
<%@page import="java.io.*" %>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="edu.stts.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js" ></script>
</head>
<body>
		Nama : <input type="text" id="nama"/>
		<br/>
		Harga : <input type="text" id="harga"/>
		<br/>
		Qty : <input type="text" id="qty"/>
		<br/>
		<input type="button" name="btnInsert" value="Insert" onclick="insertClick();"/>
	
	<%
	Datastore datastore = DatastoreOptions.newBuilder().setProjectId("shoppingcart-182405").
	setCredentials(ServiceAccountCredentials.fromStream(new FileInputStream("ShoppingCart-70489f4e859c.json"))).build().getService();
	//DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Query<com.google.cloud.datastore.Entity> query = Query.newEntityQueryBuilder().setKind("barang").build();
	QueryResults<com.google.cloud.datastore.Entity> results = datastore.run(query);
	
	

	if(!results.hasNext()){
		out.println("<h1>Tidak ada data Di Database</h1>");
	} else{
		out.println("<table border=1>");
		out.println("<th>Nama</th>");
		out.println("<th>Price</th>");
		out.println("<th>Qty</th>");
		out.println("<th>Subtotal</th>");
		/* out.println("<th>Time</th>"); */
		out.println("<th>Button</th>");
		int total = 0;
		while (results.hasNext()) {
			
	        Entity entity = results.next();
	        long sub = entity.getLong("harga")* entity.getLong("qty");
	        out.println("<tr id='"+entity.getKey().getId()+"'>");
			out.println("<td class='colNama'>"+entity.getString("nama").toString()+"</td>");
			out.println("<td class='colHarga'>"+entity.getLong("harga")+"</td>");
			out.println("<td class='colQty'>"+entity.getLong("qty")+"</td>");
			/* out.println("<td class='colTime'>"+entity.getString("time")+"</td>"); */
			out.println("<td class='colSubtotal'>"+sub+"</td>");
			out.println("<td class='action'><button style ='display:inline-block' class='edit' onclick='editClick(this.parentNode.parentNode.id);'>Edit</button>"
			+ "<button style='display:inline-block' class='delete' onclick='deleteClick(this.parentNode.parentNode.id);'>Delete</button>"
			+ "<button class='yes' style='display:none;' onclick='editSubmit(this.parentNode.parentNode.id);'>Yes</button>"
			+ "<button class='no' style='display:none;' onclick='editCancel(this.parentNode.parentNode.id);'>Cancel</button></td>");
			
		out.println("</tr>");
		total += sub;
	        //out.println(entity.getKey().getId() + " - " + entity.getString("description") + " - " + (entity.getTimestamp("created").toSqlTimestamp().getYear() + 1900) + "<br/>");        
	    }
		out.println("</table>");
		
		out.println("<h2>Total : " + total +"</h2>");
		} 
	%>
	<script type="text/javascript">
		$nama = "";
		$harga = "";
		$qty = "";
		function insertClick(){
			var nama = $("input#nama").val();
			var harga = $("input#harga").val();
			var qty = $("input#qty").val();
			$.ajax({
				url: "/hello",
				method: "post",
				data: {"action":"insert", "nama":nama, "harga": harga, "qty":qty}
			 }).done(function(result){
				 window.location = "";
			 });
		}
		function editClick(id){			
			//Simpan Variabel
			$nama = $("tr#"+id+" td.colNama").text();
			$harga = $("tr#"+id+" td.colHarga").text();
			$qty = $("tr#"+id+" td.colQty").text();
			
			ubahTextBox(id,$nama,$harga,$qty);
			
			//clear
			/* $("tr#"+id+" td.colNama").text("");
			$("tr#"+id+" td.colHarga").text("");
			$("tr#"+id+" td.colQty").text("");
			//Ganti jadi textbox
			ubahTextBox(id);
			$("tr#"+id+" td.colNama").html("<input type='text' id='editNama' value='" + $nama +"' />");
			$("tr#"+id+" td.colHarga").html("<input type='text' id='editHarga' value='" + $harga +"' />");
			$("tr#"+id+" td. colQty").html("<input type='text' id='editQty' value='" + $qty +"' />");*/
			//Ganti jd Yes / No
			ubahButton(id);
		}
		
		function editSubmit(id){
			ubahTextBox(id, "ok");
			ubahButton(id);
		}
		
		function editCancel(id){
			ubahTextBox(id, "no");
			ubahButton(id);
		}
		
		function ubahTextBox(id, status){
			if(($("tr#"+id+" td.colNama").text() == "" || $("tr#"+id+" td.colNama").text() == null)){
				$nama = $("tr#"+id+" td.colNama input").val();
				$harga = $("tr#"+id+" td.colHarga input").val();
				$qty = $("tr#"+id+" td.colQty input").val();
				
				$("tr#"+id+" td.colNama").html("");
				$("tr#"+id+" td.colHarga").html("");
				$("tr#"+id+" td.colQty").html("");
				
				//isi
				$("tr#"+id+" td.colNama").text($nama);
				$("tr#"+id+" td.colHarga").text($harga);
				$("tr#"+id+" td.colQty").text($qty);
				if(status == "ok"){
					$.ajax({
						url: "/hello",
						method: "post",
						data: {"action":"edit", "id":id, "nama":$nama, "harga": $harga, "qty":$qty}
					 }).done(function(result){
						 /* window.location = ""; */
						 $("tr#" + id + " td.colSubtotal").text($harga * $qty);
						 alert("Edited");
					 });
				}
			}else{
				$nama = $("tr#"+id+" td.colNama").text();
				$harga = $("tr#"+id+" td.colHarga").text();
				$qty = $("tr#"+id+" td.colQty").text();
				
				$("tr#"+id+" td.colNama").text("");
				$("tr#"+id+" td.colHarga").text("");
				$("tr#"+id+" td.colQty").text("");
				
				$("tr#"+id+" td.colNama").html("<input type='text' id='editNama' value='" + $nama +"' />");
				$("tr#"+id+" td.colHarga").html("<input type='text' id='editHarga' value='" + $harga +"' />");
				$("tr#"+id+" td.colQty").html("<input type='text' id='editQty' value='" + $qty +"' />");
				
			}
		}
		
		function ubahButton(id){
			if($("tr#" + id + " td.action button.edit").css("display") == "inline-block"){
				$("tr#" + id + " td.action button.edit").css("display","none");
				$("tr#" + id + " td.action button.delete").css("display","none");
				$("tr#" + id + " td.action button.yes").css("display","inline-block");
				$("tr#" + id + " td.action button.no").css("display","inline-block");
			}
			else if($("tr#" + id + " td.action button.edit").css("display") == "none"){
				$("tr#" + id + " td.action button.edit").css("display","inline-block");
				$("tr#" + id + " td.action button.delete").css("display","inline-block");
				$("tr#" + id + " td.action button.yes").css("display","none");
				$("tr#" + id + " td.action button.no").css("display","none");
			}
		}
		
		function deleteClick(id){
			 $.ajax({
				url: "/hello",
				method: "post",
				data: {"action":"delete", "id":id}
			 }).done(function(result){
				 window.location = "";
			 });
			//alert(id);
		}
		
	</script>
</body>
</html>