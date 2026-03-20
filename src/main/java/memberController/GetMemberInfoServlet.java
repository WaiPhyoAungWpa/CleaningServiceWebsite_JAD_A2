package memberController;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

import com.google.gson.Gson;

import memberModel.*;

/**
 * Servlet implementation class GetBookingHistoryServlet
 */
@WebServlet("/GetMemberInfoServlet")
public class GetMemberInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public GetMemberInfoServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		response.getWriter().append("Served at: ").append(request.getContextPath());
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();
		session.setMaxInactiveInterval(60 * 60);

		int userId = (int) session.getAttribute("memId");
		System.out.println(userId);
		if (session.getAttribute("memId") == null) {
			response.sendRedirect("loginPage.jsp");
			return;
		}
		
		Member member = null;
		List<Booking> bookingHistory = null;

		try {
			member = MemberDAO.getMemberDetails(userId);
			System.out.println(member.getId());
			bookingHistory = BookingDAO.getBookingDetails(userId);

			request.setAttribute("user", member);
			request.setAttribute("bookingHistory", bookingHistory);

			// Forward to JSP page
			RequestDispatcher dispatcher = request.getRequestDispatcher("memberPage.jsp");
			dispatcher.forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving service data.");
		}

	}
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	

}

