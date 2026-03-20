<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
    try {
        // Step 1: Load JDBC Driver
        Class.forName("org.postgresql.Driver");

        // Step 2: Define Connection URL
        String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";

        // Step 3: Establish connection to URL
        Connection conn = DriverManager.getConnection(connURL);

        // Step 4: Call the PostgreSQL function
        String sql = "SELECT * FROM get_customer_feedback_with_service()";
        PreparedStatement pstmt = conn.prepareStatement(sql);

        // Step 5: Execute the query
        ResultSet rs = pstmt.executeQuery();

        // Step 6: Process the result set and display the data
        out.println("<table border='1'>");
        out.println("<tr><th>Customer Name</th><th>Rating</th><th>Feedback Message</th><th>Service Name</th><th>Service ID</th></tr>");
        while (rs.next()) {
            out.println("<tr>");

            out.println("<td>");
            out.println(rs.getString("customer_name")); // Customer name
            out.println("</td>");

            out.println("<td>");
            out.println(rs.getInt("rating")); // Rating
            out.println("</td>");

            out.println("<td>");
            out.println(rs.getString("feedback_message")); // Feedback message
            out.println("</td>");

            out.println("<td>");
            out.println(rs.getString("service_name")); // Service name
            out.println("</td>");

            out.println("<td>");
            out.println(rs.getInt("service_id")); // Service ID
            out.println("</td>");

            out.println("</tr>");
        }
        out.println("</table>");

        // Step 7: Close the connection
        conn.close();

    } catch (Exception e) {
        out.println("Exception occurred");
        System.out.print(e);
    }
%>


</body>
</html>