package MembersAndServices;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.sql.*;

/**
 * Servlet implementation class memberInfo
 */
@WebServlet("/GetMemberInfo")
public class GetMemberInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public GetMemberInfo() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();
		session.setMaxInactiveInterval(60 * 60);
		try {
			Class.forName("org.postgresql.Driver");

			String connURL = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin?user=neondb_owner&password=omcrC2xOqNn6&sslmode=require";

			Connection conn = DriverManager.getConnection(connURL);
			int userId = (int) session.getAttribute("memId");
			if (session.getAttribute("memId") == null) {
				response.sendRedirect("loginPage.jsp");
			}

			String sqlStr = "SELECT * FROM customers WHERE customer_id = ?";
			PreparedStatement pstmt = conn.prepareStatement(sqlStr);
			pstmt.setInt(1, userId);
			ResultSet user = pstmt.executeQuery();
			if (user.next()) {
				int id = user.getInt("customer_id");
				String name = user.getString("first_name") + " " + user.getString("last_name");
				String email = user.getString("email");
				String password = user.getString("password");
				String phNo = user.getString("ph_number");
				String gender = user.getString("gender");
				Timestamp dob = user.getTimestamp("dob");
				Member memberUser = new Member(id, name, email, password, phNo, gender, dob);
				session.setAttribute("user", memberUser);
			} else {
				response.sendRedirect("home.jsp");
			}
			sqlStr = "SELECT b.booking_id, s.service_name, bd.services_id, bd.booking_time FROM bookings AS b INNER JOIN booking_details AS bd ON b.booking_id = bd.booking_id INNER JOIN services AS s ON bd.services_id = s.service_id WHERE b.customer_id = ? ORDER BY bd.booking_time DESC";
			PreparedStatement pstmt2 = conn.prepareStatement(sqlStr);
			pstmt2.setInt(1, userId);
			ArrayList<Booking> bookingHistory = new ArrayList<Booking>();
			ResultSet bookings = pstmt2.executeQuery();
			if (bookings != null) {
				while (bookings.next()) {
					Booking bookingDetails = new Booking(bookings.getInt("booking_id"), bookings.getInt("services_id"),
							bookings.getString("service_name"), bookings.getTimestamp("booking_time"));
					bookingHistory.add(bookingDetails);
				}
			}
			session.setAttribute("bookingHistory", bookingHistory);

			response.sendRedirect("memberPage.jsp");
		} catch (Exception e) {
			out.print(e); // Print the error for debugging
		}
	}
}