<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Logging In...</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
	crossorigin="anonymous">
</head>
<body>
	<%
	String email = request.getParameter("email");
	String password = request.getParameter("password");

	if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
		session.setAttribute("emailInput", email);
		response.sendRedirect("loginPage.jsp?errCode=invalidLogin");
		return;
	}

	Class.forName("org.postgresql.Driver");
	String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";

	try (Connection conn = DriverManager.getConnection(connURL)) {
		// Check in admin table first
		try (PreparedStatement pstmtAdmin = conn.prepareStatement("SELECT * FROM admin WHERE email = ? AND password = ?")) {
			pstmtAdmin.setString(1, email);
			pstmtAdmin.setString(2, password);

			try (ResultSet admin = pstmtAdmin.executeQuery()) {
		if (admin.next()) {
			int adminId = admin.getInt("admin_id");
			String adminName = admin.getString("name");
			session.setAttribute("adminId", adminId);
			session.setAttribute("adminName", adminName);
			response.sendRedirect("admin.jsp"); // Redirect to admin dashboard
			return;
		}
			}
		}

		// Check in customers table next
		try (PreparedStatement pstmtCustomer = conn
		.prepareStatement("SELECT * FROM customers WHERE email = ? AND password = ?")) {
			pstmtCustomer.setString(1, email);
			pstmtCustomer.setString(2, password);

			try (ResultSet customer = pstmtCustomer.executeQuery()) {
		if (customer.next()) {
			int customerId = customer.getInt("customer_id");
			String firstName = customer.getString("first_name");
			String lastName = customer.getString("last_name");
			session.setAttribute("memId", customerId);
			session.setAttribute("firstName", firstName);
			session.setAttribute("lastName", lastName);
			response.sendRedirect("home.jsp"); // Redirect to customer home
			return;
		}
			}
		}

		// If no match is found in both tables
		session.setAttribute("emailInput", email);
		response.sendRedirect("loginPage.jsp?errCode=userNotFound");
	} catch (SQLException e) {
		e.printStackTrace(); // Log error for debugging
		session.setAttribute("emailInput", email);
		response.sendRedirect("loginPage.jsp?errCode=invalidLogin");
	}
	%>
	<div class="d-flex justify-content-center align-items-center"
		style="height: 100vh;">
		<div class="spinner-border text-primary"
			style="width: 5rem; height: 5rem;" role="status">
			<span class="visually-hidden">Loading...</span>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"></script>
</body>
</html>