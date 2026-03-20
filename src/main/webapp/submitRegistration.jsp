<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registering...</title>
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
  rel="stylesheet">

</head>
<body>
  <%
  try {
  	Class.forName("org.postgresql.Driver");
  	String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";
  	Connection conn = DriverManager.getConnection(connURL);

  	String firstName = request.getParameter("firstName");
  	String lastName = request.getParameter("lastName");
  	String gender = request.getParameter("gender");
  	String dob = request.getParameter("dob");
  	String phoneNo = request.getParameter("phone");
  	String email = request.getParameter("email");
  	String password = request.getParameter("password");

  	if (firstName != null && lastName != null && email != null && password != null) {
  		try {
  	//Check user exists in database via email
  	String sqlStr = "SELECT * FROM customers WHERE email = ?";
  	PreparedStatement pstmt1 = conn.prepareStatement(sqlStr);
  	pstmt1.setString(1, email);
  	ResultSet existingUser = pstmt1.executeQuery();
  	if (existingUser.next()) {
      session.setAttribute("existingUser", email);
  		response.sendRedirect("loginPage.jsp?userExists=true");
      return;
  	}

  	//Insert User into Database
  	sqlStr = "INSERT INTO customers (first_name, last_name, email, password,ph_number,gender,dob) VALUES (?,?,?,?,?,?,?)";
  	PreparedStatement pstmt2 = conn.prepareStatement(sqlStr, Statement.RETURN_GENERATED_KEYS);
  	pstmt2.setString(1, firstName);
  	pstmt2.setString(2, lastName);
  	pstmt2.setString(3, email);
  	pstmt2.setString(4, password);
  	pstmt2.setString(5, phoneNo);
  	pstmt2.setString(6, gender);
  	if (dob == null || dob.trim().isEmpty()) {
  		// Set dob as NULL if the input is empty
  		pstmt2.setNull(7, java.sql.Types.TIMESTAMP);
  	} else {
  		// Parse the input to a java.sql.Timestamp if a date is provided
  		java.sql.Timestamp DOB = java.sql.Timestamp.valueOf(dob + " 00:00:00");
  		pstmt2.setTimestamp(7, DOB);
  	}
  	int rowsInserted = pstmt2.executeUpdate();

  	if (rowsInserted > 0) {
  		//get the customer_id after insert
  		ResultSet generatedKeys = pstmt2.getGeneratedKeys();
  		if (generatedKeys.next()) {
  			int customerId = generatedKeys.getInt(1);

  			// Step 7: Store customerId in session
  			session.setAttribute("memId", customerId);
  			session.setAttribute("firstName", firstName);
  			session.setAttribute("lastName", lastName);
  			response.sendRedirect("home.jsp");
  		}
  	} else {
  		response.sendRedirect("registrationPage.jsp?errCode=invalidInput");
  	}

  		} catch (Exception e) {
  	out.print(e);
  		}
  	} else {
  		response.sendRedirect("registrationPage.jsp?errCode=invalidInput");
  	}
  	conn.close();
  } catch (Exception e) {
  	response.sendRedirect("registrationPage.jsp?errCode=invalidInput");
  }
  %>
<div class="d-flex justify-content-center align-items-center" style="height: 100vh;">
  <div class="spinner-border text-primary" style="width: 5rem; height: 5rem;" role="status">
    <span class="visually-hidden">Loading...</span>
  </div>
</div>
  <script
    src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
    integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
    crossorigin="anonymous"></script>
  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"
    integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
    crossorigin="anonymous"></script>
</body>
</html>