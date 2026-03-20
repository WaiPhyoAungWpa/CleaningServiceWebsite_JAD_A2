<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import="java.sql.*"%> 
<%@ page import="java.util.ArrayList" %>
<%@ page import="ServicesAndFeedbacks.Service" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Card Deck Example</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
	<%
	request.setAttribute("page", "service");
	%>
<%@ include file="header.jsp"%>
<div>
<h2 class="mt-4" align="center">Our Services</h2> 

    <!-- Filter Buttons -->
    <div class="text-right mb-4 pr-5">
        <button class="btn btn1" onclick="filterCards('residential')">Residential</button>
        <button class="btn btn2" onclick="filterCards('commercial')">Commercial</button>
        <button class="btn btn3" onclick="filterCards('others')">Others</button>
    </div>
	<%
	try {
		// Step1: Load JDBC Driver
		Class.forName("org.postgresql.Driver");

		// Step 2: Define Connection URL
		String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";

		// Step 3: Establish connection to URL
		Connection conn = DriverManager.getConnection(connURL);

		// Retrieve service images based on service categories
		String sql1 = "select * from get_service_image_and_category()";
		PreparedStatement pstmt1 = conn.prepareStatement(sql1);

		// Step 5 : Execute the query
		ResultSet rs1 = pstmt1.executeQuery();
		
		ArrayList<Service> serviceList = new ArrayList<Service>();
		
		while (rs1.next()) {
			String sID = rs1.getString("service_id");
		    int ServiceID = Integer.parseInt(sID);
		    String ServiceName = rs1.getString("service_name");
		    String ServiceDescription = rs1.getString("service_description");
		    String ServiceImgName = rs1.getString("service_img_name");
		    String scID = rs1.getString("service_category_id");
		    int ServiceCategoryID = Integer.parseInt(scID);
		    String CategoryName = rs1.getString("category_name");

		Service s = new Service(ServiceID, ServiceName, ServiceDescription, ServiceImgName, ServiceCategoryID, CategoryName);
		serviceList.add(s);
		}

		conn.close();

	    %><div class="container mt-5">
        	<div class="card-deck"> <%
		 for (Service service : serviceList) {
		        %>
		            <div class="col-md-4 card-wrapper <%= service.getCategoryName().toLowerCase() %>" data-category="<%= service.getCategoryName().toLowerCase() %>">
		                <div class="card mb-4">
		                    <img class="card-img-top img-fluid" src="service_images/<%= service.getServiceImgName()%>" alt="Card image cap">
		                    <div class="card-body">
		                        <h5 class="card-title mb-5"><%= service.getServiceName() %></h5>
		                            <div class="icon-and-read-more d-flex justify-content-between align-items-center">
							        <img class="category-icon img-fluid" src="category_icons/<%= service.getCategoryName().toLowerCase()%>.png" alt="Category Icon">
							        <% String toPass = "servicePage.jsp?serviceId="+ service.getServiceID(); %>
							        <button type="button" class="btn btn-primary" onclick="window.location.href='<%= toPass %>'">Read More</button>
							    </div>
		                    </div>
		                    <svg class="svg-wave" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill-opacity="1" d="M0,160L34.3,149.3C68.6,139,137,117,206,96C274.3,75,343,53,411,74.7C480,96,549,160,617,170.7C685.7,181,754,139,823,138.7C891.4,139,960,181,1029,197.3C1097.1,213,1166,203,1234,170.7C1302.9,139,1371,85,1406,58.7L1440,32L1440,320L1405.7,320C1371.4,320,1303,320,1234,320C1165.7,320,1097,320,1029,320C960,320,891,320,823,320C754.3,320,686,320,617,320C548.6,320,480,320,411,320C342.9,320,274,320,206,320C137.1,320,69,320,34,320L0,320Z"></path></svg>
		                </div>
		            </div>
		        <% } 
	      %></div>
	     </div> <%

	} catch (Exception e) {
		out.println("Exception occurred");
		System.out.print(e);
	}
	%>
	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script>
	    let activeFilter = null; // Variable to track the active filter
	
	    function filterCards(category) {
	        const cards = document.querySelectorAll('.card-wrapper');
	
	        // If the clicked category is already active, reset the filter
	        if (activeFilter === category) {
	            activeFilter = null; // Clear the active filter
	            cards.forEach(card => card.style.display = 'block'); // Show all cards
	        } else {
	            // Apply the new filter
	            activeFilter = category;
	            cards.forEach(card => {
	                if (card.getAttribute('data-category') === category) {
	                    card.style.display = 'block'; // Show matching cards
	                } else {
	                    card.style.display = 'none'; // Hide non-matching cards
	                }
	            });
	        }
	    }
	</script>
</div>
<%@ include file="footer.html"%>
</body>
</html>
