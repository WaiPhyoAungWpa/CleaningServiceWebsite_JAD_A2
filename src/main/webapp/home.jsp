<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home Page</title>
<!-- Bootstrap CSS -->
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Bootstrap Icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.5/font/bootstrap-icons.min.css">
</head>
<body>
	<%
	request.setAttribute("page", "home");
	%>
	<%@ include file="header.jsp"%>
	<%
	String memberFirstName = (String) session.getAttribute("firstName");
	String memberLastName = (String) session.getAttribute("lastName");
	%>
	<!--  Introduction Section -->
	<div class="container-fluid py-5" style="background-color: #b3d7f1;">
		<div class="row justify-content-center py-5 px-5 mx-5">
			<div
				class="col-md-6 d-flex flex-column align-items-center bg-white p-4 rounded shadow-sm">
				<h3 class="text-center">Our Achievements</h3>
				<div class="d-flex justify-content-around w-100 mt-3">
					<!-- Service Count -->
					<div class="text-center">
						<h4 class="text-success" id="serviceCount"></h4>
						<p class="mb-0">Available Services</p>
					</div>
					<div class="border-left" style="height: 50px; width: 1px;"></div>
					<!-- Average Rating -->
					<div class="text-center">
						<h4 class="text-primary" id="avgRating"></h4>
						<p class="mb-0">Stars</p>
					</div>
					<div class="border-left" style="height: 50px; width: 1px;"></div>
					<!-- Customer Count -->
					<div class="text-center">
						<h4 class="text-info" id="customerCount"></h4>
						<p class="mb-0">Members Joined</p>
					</div>
				</div>
			</div>

			<div class="col-md-6 py-3 px-5 text-center">
				<h2 class="font-weight-bold">Shin Shin</h2>
				<p style="font-size: 1.2rem;">
					<%
					if (memId != null) {
						out.print("Welcome, " + memberFirstName + " " + memberLastName
						+ "! Book reliable cleaning services effortlessly. From home to office cleaning, our platform streamlines appointments and feedback to enhance your experience.");
					} else {
						out.print(
						"Book reliable cleaning services effortlessly! From home to office cleaning, our platform streamlines appointments and feedback to enhance your experience. Enjoy quick, efficient service tailored to your needs.");
					}
					%>
				</p>
				<!-- <a href="bookService.jsp"
					class="btn btn-primary font-weight-bold d-block mx-auto"
					style="width: fit-content;">BOOK A SERVICE</a> -->
				<a class="btn btn-primary font-weight-bold d-block mx-auto"
					style="width: fit-content;"
					href="available_services.jsp">
					   Book Now </a>
			</div>
		</div>
	</div>
	<!-- Our Services Section -->
	<%
	Connection conn = null;
	try {
		// Step1: Load JDBC Driver
		Class.forName("org.postgresql.Driver");

		// Step 2: Define Connection URL
		String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";

		// Step 3: Establish connection to URL
		conn = DriverManager.getConnection(connURL);

		// ------------------------------------------------
		// First Query: Fetch service images and categories
		String sql1 = "select * from get_service_image_and_category()";
		PreparedStatement pstmt1 = conn.prepareStatement(sql1);
		ResultSet rs1 = pstmt1.executeQuery();

		List<Map<String, String>> residential = new ArrayList<>();
		List<Map<String, String>> commercial = new ArrayList<>();
		List<Map<String, String>> others = new ArrayList<>();

		while (rs1.next()) {
			Map<String, String> service = new HashMap<>();
			service.put("img_name", rs1.getString("service_img_name"));
			service.put("service_id", rs1.getString("service_id"));

			int categoryId = rs1.getInt("service_category_id");
			if (categoryId == 1 && residential.size() < 5) {
		residential.add(service);
			} else if (categoryId == 2 && commercial.size() < 5) {
		commercial.add(service);
			} else if (categoryId == 3 && others.size() < 5) {
		others.add(service);
			}
		}

		rs1.close();
		pstmt1.close();

		// Store the data in request attributes for use in the rendering function (renderCategory)
		request.setAttribute("residential", residential);
		request.setAttribute("commercial", commercial);
		request.setAttribute("others", others);
		// ------------------------------------------------
		// Second Query: Fetch client feedback
		String sql2 = "SELECT * FROM get_customer_feedback_with_service()";
		PreparedStatement pstmt2 = conn.prepareStatement(sql2);
		ResultSet rs2 = pstmt2.executeQuery();

		List<Map<String, String>> feedbacks = new ArrayList<>();
		while (rs2.next()) {
			Map<String, String> feedback = new HashMap<>();
			feedback.put("customer_name", rs2.getString("customer_name"));
			feedback.put("rating", rs2.getString("rating"));
			feedback.put("feedback_message", rs2.getString("feedback_message"));
			feedback.put("service_name", rs2.getString("service_name"));
			feedback.put("service_id", rs2.getString("service_id"));
			feedbacks.add(feedback);
		}
		rs2.close();
		pstmt2.close();

		// Store the data in request attributes for use in the rendering function
		request.setAttribute("feedbacks", feedbacks);
		// ------------------------------------------------
		// Third Query: Fetch top 9 FAQs
		String sql3 = "SELECT question, answer FROM faq ORDER BY created_at DESC LIMIT 9";
		PreparedStatement pstmt3 = conn.prepareStatement(sql3);
		ResultSet rs3 = pstmt3.executeQuery();

		// Store FAQs in a List
		List<Map<String, String>> faqs = new ArrayList<>();
		while (rs3.next()) {
			Map<String, String> faq = new HashMap<>();
			faq.put("question", rs3.getString("question"));
			faq.put("answer", rs3.getString("answer"));
			faqs.add(faq);
		}
		rs3.close();
		pstmt3.close();

		// Store FAQs in Request Attributes
		request.setAttribute("faqs", faqs);
		// ------------------------------------------------
		// Fourth Query: Fetch Stats
		String sql4 = "SELECT * FROM get_stats_home()";
		PreparedStatement pstmt4 = conn.prepareStatement(sql4);
		ResultSet rs4 = pstmt4.executeQuery();

		double avgRating = 0.0;
		int serviceCount = 0;
		int customerCount = 0;

		if (rs4.next()) {
			avgRating = rs4.getDouble("avg_rating");
			serviceCount = rs4.getInt("service_count");
			customerCount = rs4.getInt("customer_count");
		}

		request.setAttribute("avgRating", avgRating);
		request.setAttribute("serviceCount", serviceCount);
		request.setAttribute("customerCount", customerCount);

		rs4.close();
		pstmt4.close();

	} catch (Exception e) {
		out.println("Exception occurred");
		System.out.print(e);
	} finally {
		if (conn != null) {
			try {
		conn.close();
			} catch (Exception e) {
		out.println("Exception occurred");
		System.out.print(e);
			}
		}
	}
	%>
	<script>
    document.getElementById('avgRating').textContent = '<%=request.getAttribute("avgRating")%>';
    document.getElementById('serviceCount').textContent = '<%=request.getAttribute("serviceCount")%>';
    document.getElementById('customerCount').textContent = '<%=request.getAttribute("customerCount")%>';
	</script>
	<%!// Helper function to generate HTML
	public void renderCategory(JspWriter out, List<Map<String, String>> categoryData, String categoryName)
			throws IOException {
		out.println("<div class='my-4'>");
		out.println("<h4>" + categoryName + "</h4>");
		out.println("<hr class='mx-auto' style='width: 50%; border-top: 2px solid #000;'>");
		out.println("<div class='row justify-content-center'>");

		for (Map<String, String> service : categoryData) {
			String imgName = service.get("img_name");
			String serviceId = service.get("service_id");

			out.println("<div class='col-md-2'>");
			out.println("<a href='servicePage.jsp?serviceId=" + serviceId + "'>");
			out.println("<img src='service_images/" + imgName
					+ "' alt='Service' class='img-fluid' style='width: 150px; height: 150px; object-fit: cover;'>");
			out.println("</a>");
			out.println("</div>");
		}

		out.println("</div>");
		out.println("</div>");
	}%>
	<div class="container text-center my-5">
		<h2 class="font-weight-bold">Our Services</h2>
		<%
		// Render categories dynamically by retrieving data from request attributes
		renderCategory(out, (List<Map<String, String>>) request.getAttribute("residential"), "Residential");
		renderCategory(out, (List<Map<String, String>>) request.getAttribute("commercial"), "Commercial");
		renderCategory(out, (List<Map<String, String>>) request.getAttribute("others"), "Others");
		%>
	</div>
	<hr class="mx-auto" style="width: 75%; border-top: 2px solid #000;">
	<!-- Our Clients' Feedbacks Section -->
	<%!// Helper function to generate the feedback carousel
	public void renderFeedbackCarousel(JspWriter out, List<Map<String, String>> feedbacks) throws IOException {
		//out.println("<div class='container my-5 pt-3'>");
		//out.println("<h2 class='text-center font-weight-bold'>Our Clients' Feedbacks</h2>");
		//out.println("<div class='position-relative d-flex justify-content-center'>");
		//out.println("<div id='feedbackCarousel' class='carousel slide' data-ride='carousel' style='max-width: 600px; position: relative;'>");
		//out.println("<div class='carousel-inner'>");

		boolean firstItem = true;
		for (Map<String, String> feedback : feedbacks) {
			String customerName = feedback.get("customer_name");
			String rating = feedback.get("rating");
			String feedbackMessage = feedback.get("feedback_message");
			String serviceName = feedback.get("service_name");
			String serviceId = feedback.get("service_id");

			out.println("<div class='carousel-item " + (firstItem ? "active" : "") + "'>");
			out.println("<div class='p-4 rounded' style='background-color: #b3d7f1; color: black;'>");

			// Customer information
			out.println("<div class='d-flex align-items-center mb-3'>");
			out.println("<div class='mr-3'><img src='profile.jpeg' alt='" + customerName
					+ "' class='rounded-circle' width='50' height='50'></div>");
			out.println("<div><h5 class='mb-0'>" + customerName + "</h5>");
			out.println("<p class='text-warning mb-0'>" + "&#9733; ".repeat(Integer.parseInt(rating)) + "</p></div>");
			out.println("</div>");

			// Feedback text
			out.println("<div class='bg-white text-center p-3 rounded mb-3'><p class='mb-0'>\"" + feedbackMessage
					+ "\"</p></div>");

			// Service information
			//out.println("<div class='bg-white text-center p-3 rounded mb-3'>");
			out.println(
					"<div class='bg-white d-flex justify-content-between align-items-center text-center p-2 rounded py-3'>");
			out.println("<p class='mb-0'>Service Used: <strong>" + serviceName + "</strong></p>");
			out.println("<a href='servicePage.jsp?serviceId=" + serviceId + "' class='btn btn-link text-dark px-5'>Go to &gt;&gt;</a>");
			out.println("</div>");

			out.println("</div>");
			out.println("</div>");

			firstItem = false; // Only the first item is "active"
		}

		//out.println("</div>");

		// Carousel controls
		//out.println("<a class='carousel-control-prev' href='#feedbackCarousel' role='button' data-slide='prev'>");
		//out.println("<span class='carousel-control-prev-icon' aria-hidden='true'></span>");
		//out.println("<span class='sr-only'>Previous</span></a>");
		//out.println("<a class='carousel-control-next' href='#feedbackCarousel' role='button' data-slide='next'>");
		//out.println("<span class='carousel-control-next-icon' aria-hidden='true'></span>");
		//out.println("<span class='sr-only'>Next</span></a>");

		//out.println("</div></div></div>");
	}%>
	<div class="container my-5 pt-3">
		<h2 class="text-center font-weight-bold">Our Clients' Feedbacks</h2>

		<div class="position-relative d-flex justify-content-center">
			<!-- Carousel for feedbacks -->
			<div id="feedbackCarousel" class="carousel slide"
				data-ride="carousel" style="max-width: 600px; position: relative;">
				<div class="carousel-inner">
					<%
					// Render the feedback carousel dynamically
					renderFeedbackCarousel(out, (List<Map<String, String>>) request.getAttribute("feedbacks"));
					%>
					<!-- Carousel Controls, positioned with absolute positioning and z-index -->
					<a class="carousel-control-prev" href="#feedbackCarousel"
						role="button" data-slide="prev"
						style="position: absolute; top: 50%; left: 10px; transform: translateY(-50%); z-index: 10;">
						<span class="carousel-control-prev-icon" aria-hidden="true"></span>
						<span class="sr-only">Previous</span>
					</a> <a class="carousel-control-next" href="#feedbackCarousel"
						role="button" data-slide="next"
						style="position: absolute; top: 50%; right: 10px; transform: translateY(-50%); z-index: 10;">
						<span class="carousel-control-next-icon" aria-hidden="true"></span>
						<span class="sr-only">Next</span>
					</a>

				</div>
			</div>
		</div>
	</div>
	<!-- FAQ Section -->
	<div class="container-fluid py-5" style="background-color: #b3d7f1;">
		<div class="row justify-content-center py-5 px-5 mx-5">
			<!-- Header -->
			<div
				class="col-12 d-flex flex-column align-items-center p-4 rounded shadow-sm mb-5">
				<h3 class="text-center">Frequently Asked Questions</h3>
			</div>

			<!-- FAQs -->
			<div class="col-12">
				<div class="row gy-4">
					<%
					// Retrieve FAQs from Request Attribute
					List<Map<String, String>> faqs = (List<Map<String, String>>) request.getAttribute("faqs");

					// Generate FAQs Dynamically
					if (faqs != null && !faqs.isEmpty()) {
						int index = 1; // Counter for FAQ IDs
						for (Map<String, String> faq : faqs) {
							String question = faq.get("question");
							String answer = faq.get("answer");
					%>
					<div class="col-md-6 col-lg-4 d-flex align-items-stretch py-3">
						<div class="card shadow-sm w-100">
							<div class="card-body d-flex flex-column">
								<h5
									class="card-title d-flex justify-content-between align-items-center">
									<span><%=question%></span>
									<button
										class="btn p-0 card-toggler text-decoration-none text-black d-flex align-items-center justify-content-center"
										data-bs-toggle="collapse" data-bs-target="#faq<%=index%>"
										aria-expanded="false" aria-controls="faq<%=index%>"
										id="toggle<%=index%>">
										<i class="bi bi-chevron-double-down arrow-icon"></i>
									</button>
								</h5>
								<div class="collapse card-collapse text-start pt-2"
									id="faq<%=index%>">
									<p><%=answer%></p>
								</div>
							</div>
						</div>
					</div>
					<%
					index++;
					}
					} else {
					%>
					<p class="text-center col-12">No FAQs available at the moment.</p>
					<%
					}
					%>
				</div>
			</div>
		</div>
	</div>

	<!-- Script for Toggle Behavior -->
	<script>
		document.addEventListener('DOMContentLoaded', function() {
			// Attach event listener for each toggler
			document.querySelectorAll('.card-toggler').forEach(
					function(toggler) {
						toggler.addEventListener('click', function() {
							const icon = toggler.querySelector('.arrow-icon'); // Find the icon within the button
							const isExpanded = toggler
									.getAttribute('aria-expanded') === 'true';

							// Change icon based on collapse state
							icon.classList.toggle('bi-chevron-double-down',
									!isExpanded);
							icon.classList.toggle('bi-chevron-double-up',
									isExpanded);
						});
					});
		});
	</script>



	<!-- Bootstrap JS, Popper.js, and jQuery -->
	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
		<%@ include file="footer.html"%>
</body>

</html>