<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
  rel="stylesheet">
</head>
<body>
  <%
  String phNo = request.getParameter("phone");
  String gender = request.getParameter("gender");
  String dob = request.getParameter("dob");
  int userId = (int) session.getAttribute("memId");

  Class.forName("org.postgresql.Driver");
  String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";

  try (Connection conn = DriverManager.getConnection(connURL);
  		PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM customers WHERE customer_id = ?")) {

  	pstmt.setInt(1, userId);
  	try (ResultSet user = pstmt.executeQuery()) {
  		if (user.next()) {
  	String userPassword = user.getString("password");
  	PreparedStatement pstmt2 = conn.prepareStatement("UPDATE customers SET ph_number = ?, gender = ?, dob = ? WHERE customer_id = ?");
  	pstmt2.setString(1, phNo);
  	pstmt2.setString(2, gender);
  	if (dob == null || dob.trim().isEmpty()) {
  		// Set dob as NULL if the input is empty
  		pstmt2.setNull(3, java.sql.Types.TIMESTAMP);
  	} else {
  		// Parse the input to a java.sql.Timestamp if a date is provided
  		java.sql.Timestamp DOB = java.sql.Timestamp.valueOf(dob + " 00:00:00");
  		pstmt2.setTimestamp(3, DOB);
  	}
  	pstmt2.setInt(4, userId);
  	int rowsUpdated = pstmt2.executeUpdate();
  	if (rowsUpdated > 0) {
  		response.sendRedirect("GetMemberInfoServlet");
  	} else {
  		response.sendRedirect("memberPage.jsp?errCode=serverError");
  	}

  		} else {
  	response.sendRedirect("memberPage.jsp?errCode=userNotFound");
  		}
  	}
  } catch (SQLException e) {
  	e.printStackTrace(); // Log error for debugging
  	response.sendRedirect("memberPage.jsp?errCode=serverError");
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