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
@WebServlet("/GetAdminServiceManagementServlet")
public class GetAdminServiceManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public GetAdminServiceManagementServlet() {
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
		List<String> serviceItems = null;
		List<String> serviceImages = null;
		List<ServiceReport> serviceReports = null;

		try {
			// Fetch services from DAO
			services = ServiceDAO.getServices();
			serviceItems = ServiceDAO.getServiceItems();
			serviceImages = ServiceDAO.getServiceImages();
			serviceReports = ServiceDAO.getServiceReports();

			// Set attributes for the request
			request.setAttribute("services", services);
			request.setAttribute("serviceItems", serviceItems);
			request.setAttribute("serviceImages", serviceImages);
			request.setAttribute("serviceReports", serviceReports);

			// Forward to JSP page
			RequestDispatcher dispatcher = request.getRequestDispatcher("adminServiceManagement.jsp");
			dispatcher.forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			out.print("Error fetching services: " + e.getMessage());
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving service data.");
		}
	}
}
