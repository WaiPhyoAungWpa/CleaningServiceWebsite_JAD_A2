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
@WebServlet("/GetAdminMemberManagementServlet")
public class GetAdminMemberManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public GetAdminMemberManagementServlet() {
		super();
	}

	/**
	 * Handles retrieving service data
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		// Retrieve service data
		List<Service> services = null;

		// Retrieve member data
		List<Member> members = null;
		List<MemberPaymentTotal> topcustomers = null;
		List<MemberBookingTotal> customersbyservice = null;
		List<MemberAddress> customersbyaddress = null;

		try {
			// Fetch services from DAO
			services = ServiceDAO.getServices();

			// Fetch members from DAO
			members = MemberDAO.getMemberDetails();
			topcustomers = MemberDAO.getTopTenCustomers();
			customersbyservice = MemberDAO.getCustomersByService();
			customersbyaddress = MemberDAO.getCustomersByAddress();

			// Set attributes for the request
			request.setAttribute("services", services);

			// Set attributes for the request
			request.setAttribute("members", members);
			request.setAttribute("topcustomers", topcustomers);
			request.setAttribute("customersbyservice", customersbyservice);
			request.setAttribute("customersbyaddress", customersbyaddress);

			// Forward to JSP page
			RequestDispatcher dispatcher = request.getRequestDispatcher("adminMemberManagement.jsp");
			dispatcher.forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			out.print("Error fetching services: " + e.getMessage());
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving service data.");
		}
	}
}
