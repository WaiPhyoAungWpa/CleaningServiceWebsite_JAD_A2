<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
	<%@ include file="header.jsp"%>
	<div class="py-5 content" style="background-color: #b3d7f1">
<!-- bookingId = integer -->
<%
String stringBookingId = request.getParameter("bookingId");
String rating = request.getParameter("rating");
String reviewText = request.getParameter("reviewText");

int booking_id = 0;
String service_img_name = "";
String service_name = "";
double base_duration = 0.0;
String service_description = "";
String booking_time = "";

String booked_date = "";
String startTimeString = "";
String endTimeString = "";

int customerId = 1; // need to connect with memId from header

if (stringBookingId != null){
	int bookingId = Integer.parseInt(stringBookingId);
	
	try {// Step1: Load JDBC Driver
		Class.forName("org.postgresql.Driver");

		// Step 2: Define Connection URL
		String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";

		// Step 3: Establish connection to URL
		Connection conn = DriverManager.getConnection(connURL);
		
		String sql1 = "SELECT b.booking_id, s.service_img_name, s.service_name, "
	            + "s.base_duration, s.service_description, b.booking_time "
	            + "FROM booking_details b "
	            + "JOIN get_service_details() AS s "
	            + "ON b.services_id = s.service_id "
	            + "WHERE b.booking_id = ?;";
		
		PreparedStatement pstmt1 = conn.prepareStatement(sql1);
		
		pstmt1.setInt(1, bookingId);
		
		ResultSet rs1 = pstmt1.executeQuery();
		// Check if the result set is empty
		if (!rs1.next()) {
		    // Redirect to login.jsp if no rows are returned
		    response.sendRedirect("home.jsp");
		} else {
		    // Process the result set if there are rows
		    do {
		        booking_id = rs1.getInt("booking_id");
		        service_img_name = rs1.getString("service_img_name");
		        service_name = rs1.getString("service_name");
		        base_duration = rs1.getDouble("base_duration");
		        service_description = rs1.getString("service_description");
		        booking_time = rs1.getString("booking_time");
		        
		        //preparing for date and hour
	        	String booked_time = booking_time;
	        	String[] parts = booked_time.split(" ");
	        	booked_date = parts[0]; 
	            String booked_hour = parts[1].substring(0, 2);
	            int startTime = Integer.parseInt(booked_hour);
	            int endTime = startTime + (int)base_duration;
			   	  
			   	if (startTime > 12) startTimeString = startTime - 12 + "pm";
			    else startTimeString = startTime + "am";
			   	  
			    if (endTime > 12) endTimeString = endTime - 12 + "pm";
			    else endTimeString = endTime + "am";
		    } while (rs1.next());
		}

		// Close the connection
		conn.close();
		
	} catch (SQLException e) {
        out.println("SQLException occurred: " + e.getMessage());
        e.printStackTrace(); // Print the full stack trace for more debugging info
    } catch (ClassNotFoundException e) {
        out.println("JDBC Driver not found: " + e.getMessage());
        e.printStackTrace();
    } catch (Exception e) {
        out.println("An unexpected error occurred: " + e.getMessage());
        e.printStackTrace();
    }
	
} else {
	response.sendRedirect("home.jsp");
}

// to post
if (rating != null && reviewText != null) {
    boolean success = false; // Flag to track success
    try {
        // Step 1: Load JDBC Driver
        Class.forName("org.postgresql.Driver");

        // Step 2: Define Connection URL
        String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";

        // Step 3: Establish connection to URL
        Connection conn = DriverManager.getConnection(connURL);

        String sql1 = "INSERT INTO feedbacks (booking_id, rating, feedback, created_at, updated_at) VALUES (?, ?, ?, NOW(), NOW());";
        PreparedStatement pstmt1 = conn.prepareStatement(sql1);
        pstmt1.setInt(1, Integer.parseInt(stringBookingId));
        pstmt1.setInt(2, Integer.parseInt(rating));
        pstmt1.setString(3, reviewText);

        // Step 5: Execute the query
        pstmt1.executeUpdate();
        success = true; // Mark as successful
        conn.close();
    } catch (SQLException e) {
        out.println("<script>alert('SQLException occurred: " + e.getMessage() + "');</script>");
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        out.println("<script>alert('JDBC Driver not found: " + e.getMessage() + "');</script>");
        e.printStackTrace();
    } catch (Exception e) {
        out.println("<script>alert('An unexpected error occurred: " + e.getMessage() + "');</script>");
        e.printStackTrace();
    }

    // Redirect or show alert based on success
    if (success) {
    	response.sendRedirect("question_afterFeedback.jsp");
    }
}

%>
<div class="container bg-white p-4 shadow-sm mt-4 selected-booking-container ">
  <div class="row align-items-center py-3">
    <div class="col-2 text-center">
      <img src="service_images/<%= service_img_name %>" alt="Service Image" class="img-fluid rounded service-img">
    </div>
    <div class="col-3">
      <h6 class="mb-0"><%= service_name %></h6>
      <small class="text-muted"><i class="bi bi-clock"></i> Service Duration</small>
      <p class="mb-0"><strong><%= (int) base_duration %> hours</strong></p>
    </div>
    <div class="col-4 text-center">
      <p class="description-container"><%= service_description %></p>
    </div>
    <div class="col-3 text-center">
      <div class="d-flex flex-column">
        <small class="text-muted"><i class="bi bi-calendar3"></i><%= booked_date %></small>
        <button class="btn btn-outline-primary btn-sm mt-1 selected-time"><%= startTimeString %>-<%= endTimeString %></button>
      </div>
    </div>
  </div>
</div>
<h3 class="text-center pt-3">Feedback</h3>
<div class="container bg-light p-4 shadow-sm mt-4 review-container">
  <div class="row align-items-center">
    <div class="col-md-6 text-center">
      <h5 class="fw-bold">We value your opinion.</h5>
      <p>How would you rate your overall experience?</p>
      <div class="stars">
        <span class="star" data-value="1">&#9733;</span>
        <span class="star" data-value="2">&#9733;</span>
        <span class="star" data-value="3">&#9733;</span>
        <span class="star" data-value="4">&#9733;</span>
        <span class="star selected-star" data-value="5">&#9733;</span>
      </div>      
    </div>
    <div class="col-md-6 text-center">
      <textarea
        class="form-control feedback-textarea"
        placeholder="Kindly take a moment to tell us what you think"
      ></textarea>
      <button class="btn btn-success mt-3 w-20" onclick="postReview()">Post</button>
    </div>
  </div>
</div>
	<form action="createFeedback.jsp" method="POST" id="createReviewForm">
    <input type="hidden" id="bookingId" name="bookingId" value="<%= stringBookingId %>">
    <input type="hidden" id="rating" name="rating" value="">
    <input type="hidden" id="reviewText" name="reviewText" value="">
    <button type="submit" style="display:none"></button> <!-- Hidden submit button -->
	</form>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    const stars = document.querySelectorAll('.stars .star');

 // Add event listeners to stars
 stars.forEach((star, index) => {
   star.addEventListener('click', () => {
     
     // Reset all stars to faint
     stars.forEach(s => s.classList.add('faint'));
     stars.forEach(s => s.classList.remove('selected-star'));
     star.classList.add('selected-star');
     // Highlight stars up to the clicked one
     for (let i = 0; i <= index; i++) {
       stars[i].classList.remove('faint');
     }
   });
 });
 
 function postReview() {
	    // Get the selected rating
	    const selectedStar = document.querySelector('.stars .selected-star');
	    const ratingValue = selectedStar ? selectedStar.getAttribute('data-value') : null;

	    // Get the review text
	    const reviewText = document.querySelector('.feedback-textarea').value.trim();

	    // Validate if the rating and review text exist
	    if (!ratingValue || !reviewText) {
	        alert('Please provide both a rating and feedback before submitting.');
	        return;
	    }

	    // Set the extracted values to the hidden inputs
	    document.getElementById("rating").value = ratingValue;
	    document.getElementById("reviewText").value = reviewText;

	    // Submit the form
	    document.getElementById("createReviewForm").submit();
	}

    </script>
    </div>
    	<%@ include file="footer.html"%>
</body>
</html>