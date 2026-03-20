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
 * Servlet implementation class UpdateBookingTimeServlet
 */
@WebServlet("/UpdateBookingTimeServlet")
public class UpdateBookingTimeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateBookingTimeServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			int bookingId = Integer.parseInt(request.getParameter("bookingTimeId"));
			Timestamp bookingTime = null;
			System.out.println("get here");
			String newBookingTime = request.getParameter("newBookingTime");
			if (newBookingTime != null && !newBookingTime.isEmpty()) {
			    // Ensure seconds and fractional seconds are present
			    newBookingTime = newBookingTime.replace("T", " ") + ":00"; // Append seconds
			    bookingTime = Timestamp.valueOf(newBookingTime);
			    // Use bookingTime in your logic
			} else {
			    // Handle invalid input
			    throw new IllegalArgumentException("Invalid or missing booking time.");
			}
			BookingDAO.updateBookingTime(bookingId, bookingTime);
			
			response.sendRedirect("GetAdminMemberManagementServlet");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

}
