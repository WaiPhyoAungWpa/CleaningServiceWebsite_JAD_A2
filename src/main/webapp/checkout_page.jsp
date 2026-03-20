<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList,java.sql.Timestamp" %>
<%@ page import="ServicesAndFeedbacks.Cart_item" %>
<%@ page import="java.sql.*, java.net.*, java.io.*, java.util.Scanner" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="css/style.css">
	<style>
    body {
	    background-color: #c2def8;
	}
    </style>
</head>
<body style="background-color: #b3d7f1;">
	<%@ include file="header.jsp"%>
	<div>
   <h1 class="text-center p-3">Your Cart</h1>
    
    <%
    
	if (memId == null) {
		response.sendRedirect("home.jsp");
		return;
	}

	int customerId = (int) memId;
    // Retrieve the cart from the session
    @SuppressWarnings("unchecked")
    ArrayList<Cart_item> Cart = (ArrayList<Cart_item>) session.getAttribute("sessionCart");

    if (Cart == null || Cart.isEmpty()) {
    %>
        <div class="text-center pt-5">
		    <div class="bg-white p-4 rounded shadow-sm d-inline-block">
		        <h5>Your cart is empty.</h5>
		    </div>
		</div>

    <% 
    } else { 
    	String passedIndex = request.getParameter("passedIndex");
    	String toBook = request.getParameter("toBook");
    	String passedTotalAmount = request.getParameter("passedTotalAmount");
    	if(passedIndex != null){
    		int indexToRemove = Integer.parseInt(passedIndex);
    		Cart.remove(indexToRemove);
    		session.removeAttribute("passedIndex"); //important
    	}
    	
    	if(toBook != null){
    		System.out.println("customerId: "+ customerId); //testing
    		System.out.println("passedTotalAmount: "+ passedTotalAmount); //testing
    		
    		// Remove the dollar sign from the total amount
    		double totalAmount = Double.parseDouble(passedTotalAmount.replace("$", ""));
    		
    		// Call API to create transaction
            URL url = new URL("http://localhost:8082/shinshin/create/transaction");
            HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
            httpConn.setRequestMethod("POST");
            httpConn.setRequestProperty("Content-Type", "application/json");
            httpConn.setDoOutput(true);

            // Create JSON payload
			String jsonString = "{"
			    + "\"customer_id\": " + customerId + ","
			    + "\"payment_amount\": " + totalAmount
			    + "}";

            // Send JSON request
            try (OutputStream os = httpConn.getOutputStream()) {
                byte[] input = jsonString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            // Get the response
            int transactionId = 0;
            if (httpConn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                try (Scanner scanner = new Scanner(httpConn.getInputStream(), "utf-8")) {
                    if (scanner.hasNext()) {
                        transactionId = Integer.parseInt(scanner.nextLine().trim());
                    }
                }
            }
            
            if (transactionId == 0) {
                System.out.println("Error Creating new Transaction");
            } else {
                // Store transaction ID in session
                session.setAttribute("transactionId", transactionId);
                System.out.println("Transaction ID: " + transactionId); // testing

                // Call STRIPE API (GET request)
                try {
                    // Create the URL for the GET request
                    URL StripeUrl = new URL("http://localhost:8082/shinshin/create-checkout-session?transactionId=" + transactionId);
                    
                    // Open connection
                    HttpURLConnection StripeHttpConn = (HttpURLConnection) StripeUrl.openConnection();
                    StripeHttpConn.setRequestMethod("GET");
                    
                    // Set necessary headers (if needed)
                    StripeHttpConn.setRequestProperty("Content-Type", "application/json");

                    // Get the response code
                    int responseCode = StripeHttpConn.getResponseCode();
                    
                    if (responseCode == HttpURLConnection.HTTP_OK) {
                        // Handle success (Read the response, if needed)
                        try (Scanner scanner = new Scanner(StripeHttpConn.getInputStream(), "utf-8")) {
                            while (scanner.hasNext()) {
                                String responseLine = scanner.nextLine();
                            }
                        }
                    } else if (responseCode == HttpURLConnection.HTTP_MOVED_TEMP || responseCode == HttpURLConnection.HTTP_MOVED_PERM) {
                        // Handle redirect (302 or 301)
                        String redirectUrl = StripeHttpConn.getHeaderField("Location");
                        
                        // Redirect the user to Stripe checkout page (This will open in the browser)
                        response.sendRedirect(redirectUrl); // Use response.sendRedirect to redirect the user to Stripe
                    } else {
                        System.out.println("GET request failed, Response Code: " + responseCode);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("Error calling STRIPE API: " + e.getMessage());
                }
            }
    	
    	}
    	
	    int index = 0; //for delete button index
	    double totalPrice = 0.0;
    %>     <!-- Booking Summary -->
    <div class="container bg-white p-4 rounded shadow-sm mt-4 item-container">
      <div id="booking-list">
        <!-- Booking Items (Repeat as needed)  loop the below-->
        <% for (Cart_item item : Cart){
        	
        	String booked_time = item.getBookingTime();
        	String[] parts = booked_time.split(" ");
        	String booked_date = parts[0]; 
            String booked_hour = parts[1].substring(0, 2);
            int startTime = Integer.parseInt(booked_hour);
            int endTime = startTime + (int)item.getBaseDuration();
            
            String startTimeString;
		   	String endTimeString;
		   	  
		   	if (startTime > 12) startTimeString = startTime - 12 + "pm";
		    else startTimeString = startTime + "am";
		   	  
		    if (endTime > 12) endTimeString = endTime - 12 + "pm";
		    else endTimeString = endTime + "am";
        %>
        <div class="row align-items-center border-bottom py-3">
            <div class="col-3 text-center">
              <img src="service_images/<%= item.getServiceImgName() %>" alt="Service Image" class="img-fluid rounded service-img">
            </div>
            <div class="col-3">
              <h6 class="mb-0"><%= item.getServiceName() %></h6>
              <small class="text-muted"><i class="bi bi-clock"></i> Service Duration</small>
              <p class="mb-0"><strong><%= (int) item.getBaseDuration() %> hours</strong></p>
            </div>
            <div class="col-3 text-center">
              <div class="d-flex flex-column">
                <small class="text-muted"><i class="bi bi-calendar3"></i> <%= booked_date %></small>
                <button class="btn btn-outline-primary btn-sm mt-1 selected-time"><%= startTimeString %>-<%= endTimeString %></button>
              </div>
            </div>
            <div class="col-2 text-center">
              <button class="btn btn-danger btn-sm remove-btn" onclick="delete_cartItem(<%= index++ %>)">Remove</button>
            </div>
            <div class="col-1 text-end">
              <p class="mb-0 price">$<%= item.getBasePrice() %></p>
            </div>
          </div>
        <% 
        
        totalPrice = totalPrice + item.getBasePrice();
        } %>
          
        <!-- Add more items as needed -->
      </div>
    </div>
    
    <!-- Footer Section (Separate from items) -->
    <div class="container mt-4">
      <div class="row align-items-center">
        <div class="col text-start pb-5">
          <button class="btn btn-primary fw-bold px-4 py-2" onclick="bookWithArray()">Book Now</button>
        </div>
        <div class="col text-end pb-5" style="padding-right:40px">
          <p class="mb-0"><strong>Total:</strong> <span id="total-price">$<%= totalPrice %></span></p>
        </div>
      </div>
    </div>
    
    <form action="checkout_page.jsp" method="POST" id="deleteForm">
    <input type="hidden" id="passedIndex" name="passedIndex" value="">
    <button type="submit" style="display:none"></button> <!-- Hidden submit button -->
	</form>
	
	<form action="checkout_page.jsp" method="POST" id="bookForm">
    <input type="hidden" id="toBook" name="toBook" value="">
    <input type="hidden" id="passedTotalAmount" name="passedTotalAmount" value="">
    <button type="submit" style="display:none"></button> <!-- Hidden submit button -->
	</form>
    <% } %>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function delete_cartItem(index){
    	document.getElementById("passedIndex").value = index;
    	document.getElementById("deleteForm").submit();
    }
    function bookWithArray(){
    	var totalPrice = document.getElementById("total-price").textContent.replace("$", "");
    	document.getElementById("toBook").value = "true";
    	document.getElementById("passedTotalAmount").value = totalPrice;
    	document.getElementById("bookForm").submit();
    }
    </script>
    </div>
	<%@ include file="footer.html"%>
</body>
</html>
