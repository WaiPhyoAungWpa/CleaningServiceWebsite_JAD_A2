<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Account Deleted</title>
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
  rel="stylesheet">
</head>
<body>
  <%
  String password = request.getParameter("confirmPasswordDelete");
  int userId = (int) session.getAttribute("memId");
  Class.forName("org.postgresql.Driver");
  String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";

  try (Connection conn = DriverManager.getConnection(connURL);
  		PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM customers WHERE customer_id = ?")) {
  	pstmt.setInt(1, userId);
  	try (ResultSet user = pstmt.executeQuery()) {
  		if (user.next()) {
  	String userPassword = user.getString("password");
  	if (!password.equals(userPassword)) {
  		response.sendRedirect("memberPage.jsp?errCode=invalidPassword");
  	} else {
  		CallableStatement cstmt = conn.prepareCall("CALL delete_customer_and_bookings(?)");
  		cstmt.setInt(1, userId); // Set the input parameter (customerId)
  		boolean hasResults = cstmt.execute();
  		if (!hasResults) {
  			session.invalidate();
  %>
  <div class="container text-center mt-5">
    <div class="alert alert-success" role="alert">
      <h1 class="display-4">Account Deleted Successfully</h1>
      <p class="lead">Your account has been deleted. We're sad to
        see you go!</p>
    </div>
    <a href="home.jsp" class="btn btn-primary mt-3">Return to Home</a>
  </div>
  <%
  } else {
  response.sendRedirect("memberPage.jsp?errCode=userNotFound");
  }

  }
  } else {
  response.sendRedirect("memberPage.jsp?errCode=userNotFound");
  }
  }
  conn.close();
  } catch (Exception e) {
  e.printStackTrace(); // Debugging purposes
      response.sendRedirect("memberPage.jsp?errCode=serverError");
  }
  %>
  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
