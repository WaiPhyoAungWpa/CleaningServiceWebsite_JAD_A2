package adminController;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

import adminModel.*;

/**
 * Servlet implementation class ServiceServlet
 */
@WebServlet("/GetAdminFaqManagementServlet")
public class GetAdminFaqManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public GetAdminFaqManagementServlet() {
		super();
	}

	/**
	 * Handles retrieving service data
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		// Retrieve FAQ data
		List<FAQs> faqs = null;

		try {
			// Fetch FAQs from DAO
			faqs = FAQsDAO.getAllFAQs();

			// Set attributes for the request
			request.setAttribute("faqs", faqs);

			// Forward to JSP page
			RequestDispatcher dispatcher = request.getRequestDispatcher("adminFAQManagement.jsp");
			dispatcher.forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			out.print("Error fetching services: " + e.getMessage());
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving service data.");
		}
	}
}
