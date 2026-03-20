package adminController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import adminModel.*;

/**
 * Servlet implementation class UpdateFAQServlet
 */
@WebServlet("/UpdateFAQServlet")
public class UpdateFAQServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UpdateFAQServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			// Retrieve form parameters
			int faqId = Integer.parseInt(request.getParameter("id"));
			String question = request.getParameter("question");
			String answer = request.getParameter("answer");

			// Update FAQs in database
			FAQsDAO.updateFAQ(faqId, question, answer);

			response.sendRedirect("GetAdminFaqManagementServlet");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
