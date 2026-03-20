<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="ServicesAndFeedbacks.Service_details"%>
<%@ page import="ServicesAndFeedbacks.Cart_item"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
body {
	background-color: #c2def8;
}
</style>
<link rel="stylesheet" href="css/calendar_style.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
<script src="script/calendar_script.js" defer></script>
</head>

<body data-new-gr-c-s-check-loaded="14.1207.0" data-gr-ext-installed=""
	style="background-color: #b3d7f1;">
	<%@ include file="header.jsp"%>
	<div>
		<%
		String stringServiceId = request.getParameter("serviceId");

		if (stringServiceId == null || memId == null) {
			response.sendRedirect("home.jsp");
			return;
		}

		int customerId = (int) memId;
		// test
		Service_details resultService = null;
		int service_id = Integer.parseInt(stringServiceId);
		String ServiceName = "";
		String ServiceImgName = "";
		String CategoryName = "";
		double BasePrice = 0.0;
		double BaseDuration = 0.0;
		double AddOnRate = 0.0;

		try {
			// test - need to delete later

			// Step1: Load JDBC Driver
			Class.forName("org.postgresql.Driver");

			// Step 2: Define Connection URL
			String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";

			// Step 3: Establish connection to URL
			Connection conn = DriverManager.getConnection(connURL);

			// Retrieve service images based on service categories
			String sql1 = "SELECT * from get_service_details() where service_id = ?";
			PreparedStatement pstmt1 = conn.prepareStatement(sql1);
			pstmt1.setInt(1, service_id);

			// Step 5 : Execute the query
			ResultSet rs1 = pstmt1.executeQuery();

			while (rs1.next()) {
				resultService = new Service_details(rs1.getInt("service_id"), rs1.getString("service_name"),
				rs1.getString("service_description"), rs1.getString("service_category"),
				rs1.getString("service_img_name"), rs1.getDouble("base_price"), rs1.getDouble("base_duration"),
				rs1.getDouble("add_on_rate"), rs1.getString("included_service_items"));

				// to create cart item
				ServiceName = rs1.getString("service_name");
				ServiceImgName = rs1.getString("service_img_name");
				CategoryName = rs1.getString("service_category");
				BasePrice = rs1.getDouble("base_price");
				BaseDuration = rs1.getDouble("base_duration");
				AddOnRate = rs1.getDouble("add_on_rate");
			}

			conn.close();

			String selectedDate = request.getParameter("selectedDate");
			String selectedHour = request.getParameter("selectedHour");

			// Check if both parameters are available
			if (selectedDate != null && selectedHour != null) {
				String bookingTime = selectedDate + " " + selectedHour + ":00:00";

				// Add to session cart
				@SuppressWarnings("unchecked")
				ArrayList<Cart_item> Cart = (ArrayList<Cart_item>) session.getAttribute("sessionCart");
				if (Cart == null) {
			Cart = new ArrayList<Cart_item>();
				}

				Cart_item item = new Cart_item(customerId, bookingTime, service_id, ServiceName, ServiceImgName, CategoryName,
				BasePrice, BaseDuration, AddOnRate);
				Cart.add(item);
				session.setAttribute("sessionCart", Cart);

				response.sendRedirect("question_afterBooking.jsp");
			}

		} catch (Exception e) {
			out.println("Exception occurred");
			System.out.print(e);
		}
		%>

		<div class="container py-5">
			<!-- Main Booking Container -->
			<div class="booking-container overflow-hidden">
				<div class="row g-4">
					<!-- Service Details -->
					<div class="col-12 col-sm-6 col-md-4 divider">
						<div class="service-card text-center">
							<img class="card-img-top img-fluid mb-2"
								src="service_images/<%=resultService.getServiceImgName()%>"
								alt="Card image cap " style="height: 200px;">
							<h5 class="fw-bold"><%=resultService.getServiceName()%></h5>
							<div class="my-3">
								<p>
									<strong>Pricing:</strong>
									<%=resultService.getBasePrice()%>$
								</p>
								<p>
									<strong>Service Duration:</strong>
									<%=resultService.getBaseDuration()%>
									hours
								</p>
								<%=resultService.getAddOnRate() != 0.0
		? "<p><strong>Add-on Rate:</strong> " + resultService.getAddOnRate() + "$/hr</p>"
		: ""%>
							</div>
							<div class="bg-light p-3 rounded">
								<p>
									<strong>Description:</strong>
								</p>
								<p><%=resultService.getServiceDescription()%></p>
							</div>
						</div>
					</div>

					<!-- Calendar Placeholder -->
					<div class="col-12 col-sm-6 col-md-4 divider">
						<div class="wrapper">
							<header>
								<p class="current-date"></p>
								<div class="icons">
									<span id="prev" class="material-symbols-rounded">chevron_left</span>
									<span id="next" class="material-symbols-rounded">chevron_right</span>
								</div>
							</header>
							<div class="calendar">
								<ul class="weeks">
									<li>Sun</li>
									<li>Mon</li>
									<li>Tue</li>
									<li>Wed</li>
									<li>Thu</li>
									<li>Fri</li>
									<li>Sat</li>
								</ul>
								<ul class="days"></ul>
							</div>
						</div>
					</div>

					<!-- Time Slots -->
					<div class="col-12 col-sm-6 col-md-4">
						<div class="scrollable-content">
							<h5 class="fw-bold mb-3 text-center display-selected-date"></h5>

							<%
							for (int i = 10; i + resultService.getBaseDuration() < 23; i++) {
								int startTime = i;
								int endTime = i + (int) resultService.getBaseDuration();
								String startTimeString;
								String endTimeString;

								if (startTime > 12)
									startTimeString = startTime - 12 + "pm";
								else
									startTimeString = startTime + "am";

								if (endTime > 12)
									endTimeString = endTime - 12 + "pm";
								else
									endTimeString = endTime + "am";
							%>
							<div class="d-grid gap-3 options">
								<div class="time-slot m-4 options-time"><%=startTimeString%>
									-
									<%=endTimeString%></div>
								<button type="button" onclick="bookService(<%=startTime%>)"
									class="options-button btn-primary">Confirm</button>
							</div>
							<%
							}
							%>

						</div>
					</div>
				</div>
			</div>
		</div>
		<form action="booking_page.jsp" method="POST" id="bookingForm">
			<input type="hidden" id="selectedDate" name="selectedDate" value="">
			<input type="hidden" id="selectedHour" name="selectedHour" value="">
			<input type="hidden" id="serviceId" name="serviceId"
				value=<%=stringServiceId%>>
			<button type="submit" style="display: none"></button>
			<!-- Hidden submit button -->
		</form>

		<script
			src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
		<script
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
		<script>
  function bookService(pickedHour) {
	    const selectedDateElement = document.querySelector('.selected-date');
	    const wrapperElement = document.querySelector('.wrapper');
	    
	    if (selectedDateElement) {
	        // Get the selected date
	        const selectedDate = selectedDateElement.innerText; // This is the text of the selected date
	        
	        // Update the hidden input for selectedHour with the pickedHour value
	        document.getElementById("selectedHour").value = pickedHour;
	        
	        // Now submit the form
	        document.getElementById("bookingForm").submit();
	    } else {
	        alert('No selected date found. Please select a date.');
	        wrapperElement.style.borderColor = '#2289e6';
	        return;
	    }
	}

  </script>
	</div>
	<%@ include file="footer.html"%>
</body>
</html>