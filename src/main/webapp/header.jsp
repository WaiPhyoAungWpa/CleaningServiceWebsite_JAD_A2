<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Header</title>
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>
	<%
	// Set session timeout in 5 minutes 
	session.setMaxInactiveInterval(5 * 60);
	%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand text-primary font-weight-bold" href="home.jsp">
			<img src="./img/shin-shin-star.svg" alt="Shin Shin Logo" width="50"
			height="50">
		</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarNav" aria-controls="navbarNav"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav">
				<%
				// Retrieve the session attribute for admin ID
				Object adminId = session.getAttribute("adminId");

				if (adminId == null) {
					// Session does not have adminId
				%>
				<li
					class="nav-item <%="home".equals(request.getAttribute("page")) ? "active" : ""%>"><a
					class="nav-link" href="home.jsp">Home</a></li>
				<li
					class="nav-item <%="service".equals(request.getAttribute("page")) ? "active" : ""%>"><a
					class="nav-link" href="available_services.jsp">Services</a></li>
				<%
				} else {
				// Session has adminId
				%>
				<li
					class="nav-item <%="admin".equals(request.getAttribute("page")) ? "active" : ""%>">
					<a class="nav-link" href="admin.jsp">Home</a>
				</li>
				<li
					class="nav-item <%="serviceManagement".equals(request.getAttribute("page")) ? "active" : ""%>">
					<a class="nav-link" href="GetAdminServiceManagementServlet">Service
						Management</a>
				</li>
				<li
					class="nav-item <%="memberManagement".equals(request.getAttribute("page")) ? "active" : ""%>">
					<a class="nav-link" href="GetAdminMemberManagementServlet">Member
						Management</a>
				</li>
				<li
					class="nav-item <%="faqManagement".equals(request.getAttribute("page")) ? "active" : ""%>">
					<a class="nav-link" href="GetAdminFaqManagementServlet">FAQs
						Management</a>
				</li>
				<%
				}
				%>
			</ul>
			<ul class="navbar-nav ml-auto">
				<%
				// Retrieve the session attribute for member ID
				Object memId = session.getAttribute("memId");

				if (memId == null && adminId == null) {
					// Session does not have memId and adminId
				%>
				<li class="nav-item"><a class="nav-link" href="loginPage.jsp">Login</a></li>
				<li class="nav-item"><a class="nav-link"
					href="registrationPage.jsp">Sign Up</a></li>
				<%
				} else {
				if (memId == null && adminId != null) {
				%>
				<li class="nav-item"><a class="nav-link" href="logout.jsp">Logout</a></li>
				<%
				} else {
				%>
				<li class="nav-item"><a class="nav-link"
					href="checkout_page.jsp"> <img src="./img/shopping-cart.png"
						alt="Cart" width="30" height="30">
				</a></li>
				<li class="nav-item "><a class="nav-link" href="logout.jsp">Logout</a></li>
				<li
					class="nav-item <%="memberPage".equals(request.getAttribute("page")) ? "active" : ""%>"><a
					class="nav-link" href="GetMemberInfoServlet"> Profile</a></li>
				<%
				}
				}
				%>
			</ul>
		</div>
	</nav>
	<!-- Modal -->
	<div class="modal fade" id="timeoutModal" tabindex="-1" role="dialog"
		aria-labelledby="timeoutModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="timeoutModalLabel">Session Timeout</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">Your session has expired. Please
					reload.</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="redirectToHome">Reload</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Session Timeout Script -->
	<script>
		document.addEventListener("DOMContentLoaded", function () {
			const sessionTimeout = 5 * 60 * 1000; // Session timeout in milliseconds (5 minutes)

			// Automatically show modal after session timeout
			setTimeout(() => {
				$('#timeoutModal').modal('show');
			}, sessionTimeout);

			// Redirect to login page when "Go to Login" button is clicked
			document.getElementById("redirectToHome").addEventListener("click", function () {
				window.location.href = "home.jsp";
			});
		});
	</script>
	<!-- Bootstrap JS, Popper.js, and jQuery -->
	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>