<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin page</title>
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
	request.setAttribute("page", "admin");
	%>
	<%@ include file="header.jsp"%>
    <%
	String adminName = (String) session.getAttribute("adminName");
    if(adminId == null){
    	response.sendRedirect("loginPage.jsp");
    }
	%>
	<!--  Introduction Section -->
	<div class="container-fluid py-5" style="background-color: #b3d7f1;">
		<div class="row justify-content-center py-5 px-5 mx-5">
			<div
				class="col-md-6 d-flex flex-column align-items-center bg-white p-4 rounded shadow-sm">
				<h3 class="text-center">Achievements</h3>
				<div class="d-flex justify-content-around w-100 mt-3">
					<!-- Stat: Number of Services -->
					<div class="d-flex flex-column align-items-center">
						<h4 id="numServices" class="text-primary"></h4>
						<p class="text-muted">Services</p>
					</div>
					<!-- Vertical Divider -->
					<div class="border-left" style="height: 50px; width: 1px;"></div>
					<!-- Stat: Number of Members -->
					<div class="d-flex flex-column align-items-center">
						<h4 id="numMembers" class="text-primary"></h4>
						<p class="text-muted">Members</p>
					</div>
					<!-- Vertical Divider -->
					<div class="border-left" style="height: 50px; width: 1px;"></div>
					<!-- Stat: Number of FAQs -->
					<div class="d-flex flex-column align-items-center">
						<h4 id="numFaqs" class="text-primary"></h4>
						<p class="text-muted">FAQs</p>
					</div>
				</div>
			</div>

			<div class="col-md-6 py-3 px-5 text-center">
				<h2 class="font-weight-bold">Shin Shin</h2>
				<p style="font-size: 1.2rem;">Welcome, <%=adminName%>! Here, you can
					manage services, members and frequently asked questions.</p>
				<a href="GetAdminServiceManagementServlet"
					class="btn btn-primary font-weight-bold d-block mx-auto"
					style="width: fit-content;">Management</a>
			</div>
		</div>
	</div>
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
		String sql1 = "SELECT * FROM get_service_image_and_category() ORDER BY service_id DESC LIMIT 3;";
		PreparedStatement pstmt1 = conn.prepareStatement(sql1);
		ResultSet rs1 = pstmt1.executeQuery();

		List<Map<String, String>> recentAddedServices = new ArrayList<>();

		while (rs1.next()) {
			Map<String, String> service = new HashMap<>();
			service.put("img_name", rs1.getString("service_img_name"));
			service.put("service_name", rs1.getString("service_name"));
			service.put("service_category_name", rs1.getString("category_name"));
			service.put("service_id", rs1.getString("service_id"));

			recentAddedServices.add(service);
		}

		rs1.close();
		pstmt1.close();
		// Store the services list in request attributes
		request.setAttribute("recentAddedServices", recentAddedServices);
		// ------------------------------------------------
		// Second Query: Fetch recent joined members
		String sql2 = "SELECT * FROM customers ORDER BY customer_id DESC LIMIT 3;";
		PreparedStatement pstmt2 = conn.prepareStatement(sql2);
		ResultSet rs2 = pstmt2.executeQuery();

		List<Map<String, String>> recentJoinedMembers = new ArrayList<>();

		while (rs2.next()) {
			Map<String, String> member = new HashMap<>();
			member.put("first_name", rs2.getString("first_name"));
			member.put("last_name", rs2.getString("last_name"));

			recentJoinedMembers.add(member);
		}

		rs2.close();
		pstmt2.close();
		// Store the member list in request attributes
		request.setAttribute("recentJoinedMembers", recentJoinedMembers);
		// ------------------------------------------------
		// Third Query: Fetch recent FAQs
		String sql3 = "SELECT * FROM faq ORDER BY question_id DESC LIMIT 3;";
		PreparedStatement pstmt3 = conn.prepareStatement(sql3);
		ResultSet rs3 = pstmt3.executeQuery();

		List<Map<String, String>> recentAddedFAQs = new ArrayList<>();

		while (rs3.next()) {
			Map<String, String> faq = new HashMap<>();
			faq.put("question", rs3.getString("question"));
			faq.put("answer", rs3.getString("answer"));

			recentAddedFAQs.add(faq);
		}

		rs3.close();
		pstmt3.close();
		// Store the member list in request attributes
		request.setAttribute("recentAddedFAQs", recentAddedFAQs);
		// ------------------------------------------------
		// Fourth Query: Fetch Counts
		String sql4 = "SELECT * FROM get_counts_admin()";
		PreparedStatement pstmt4 = conn.prepareStatement(sql4);
		ResultSet rs4 = pstmt4.executeQuery();

		int serviceCount = 0;
		int memberCount = 0;
		int faqCount = 0;

		if (rs4.next()) {
			serviceCount = rs4.getInt("service_count");
			memberCount = rs4.getInt("member_count");
			faqCount = rs4.getInt("faq_count");
		}

		rs4.close();
		pstmt4.close();

		// Store the counts in request attributes
		request.setAttribute("serviceCount", serviceCount);
		request.setAttribute("memberCount", memberCount);
		request.setAttribute("faqCount", faqCount);

	} catch (Exception e) {
		out.println("Exception occurred " + e.getMessage());
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
	<%
	int serviceCount = (int) request.getAttribute("serviceCount");
	int memberCount = (int) request.getAttribute("memberCount");
	int faqCount = (int) request.getAttribute("faqCount");
	%>
	<script>
    document.getElementById('numServices').textContent = "<%=serviceCount%>";
    document.getElementById('numMembers').textContent = "<%=memberCount%>";
    document.getElementById('numFaqs').textContent = "<%=faqCount%>";
	</script>
	<!-- Our Recent Added Services Section -->
	<div class="container text-center my-5">
		<h2 class="font-weight-bold">Services</h2>
		<p class="text-muted">Recent Created Services</p>
		<hr class="mx-auto" style="width: 75%; border-top: 2px solid #000;">
		<div class="row justify-content-center">
			<%
			// Retrieve services list from request attribute
			List<Map<String, String>> services = (List<Map<String, String>>) request.getAttribute("recentAddedServices");

			if (services != null && !services.isEmpty()) {
				for (Map<String, String> service : services) {
					String imgName = service.get("img_name");
					String serviceName = service.get("service_name");
					String categoryName = service.get("service_category_name");
			%>
			<div class="col-md-4">
				<div class="card shadow-sm">
					<img src="service_images/<%=imgName%>" alt="<%=serviceName%>"
						class="card-img-top img-fluid"
						style="height: 200px; object-fit: cover;">
					<div class="card-body">
						<h5 class="card-title"><%=serviceName%></h5>
						<p class="card-text text-muted"><%=categoryName%></p>
					</div>
				</div>
			</div>
			<%
			}
			} else {
			%>
			<p class="text-center">No services available at the moment.</p>
			<%
			}
			%>
		</div>
	</div>
	<!-- Our Recent Joined Members Section -->
	<div class="container-fluid py-5" style="background-color: #b3d7f1;">
		<div class="text-center mb-5">
			<h2 class="font-weight-bold">Members</h2>
			<p class="text-muted">Recent Joined Members</p>
			<hr class="mx-auto" style="width: 50%; border-top: 2px solid black;">
		</div>

		<div class="d-flex flex-column align-items-center">
			<%
			// Retrieve members list from request attribute
			List<Map<String, String>> recentJoinedMembers = (List<Map<String, String>>) request.getAttribute("recentJoinedMembers");

			if (recentJoinedMembers != null && !recentJoinedMembers.isEmpty()) {
				for (Map<String, String> member : recentJoinedMembers) {
					String firstName = member.get("first_name");
					String lastName = member.get("last_name");
			%>
			<div class="w-50 mb-3">
				<div class="p-3 border rounded bg-white text-center shadow-sm">
					<p>
						<strong><%=firstName%></strong> <strong><%=lastName%></strong> has
						joined the membership.
					</p>
				</div>
			</div>
			<%
			}
			} else {
			%>
			<p class="text-center">No new members have joined recently.</p>
			<%
			}
			%>
		</div>
	</div>
	<!-- Our Recent Added FAQs Section -->
	<div class="container-fluid py-5 bg-white">
		<div class="text-center mb-5">
			<h2 class="font-weight-bold">FAQs</h2>
			<p class="text-muted">Recent Added Questions</p>
			<hr class="mx-auto" style="width: 50%; border-top: 2px solid black;">
		</div>

		<div class="d-flex flex-column align-items-center">
			<%
			// Retrieve recent added FAQs list from request attribute
			List<Map<String, String>> recentAddedFAQs = (List<Map<String, String>>) request.getAttribute("recentAddedFAQs");

			if (recentAddedFAQs != null && !recentAddedFAQs.isEmpty()) {
				int index = 1;
				for (Map<String, String> faq : recentAddedFAQs) {
					String question = faq.get("question");
					String answer = faq.get("answer");
			%>
			<div class="col-md-6 col-lg-4 d-flex align-items-stretch py-3">
				<div class="card shadow-sm w-100" style="background-color: #b3d7f1;">
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
			<p class="text-center">No FAQs available at the moment.</p>
			<%
			}
			%>
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

	<%@ include file="adminFooter.html"%>
</body>
</html>