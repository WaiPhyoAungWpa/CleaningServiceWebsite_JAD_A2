package adminController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

import adminModel.*;

/**
 * Servlet implementation class CreateMemberServlet
 */
@WebServlet("/CreateMemberServlet")
public class CreateMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public CreateMemberServlet() {
		super();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Retrieve form parameters
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		String pwd = request.getParameter("password");
		String gender = request.getParameter("gender");
		String dobStr = request.getParameter("dob");
		String contact = request.getParameter("contact");

		try {
			// Build REST client
			Client client = ClientBuilder.newClient();
			String restUrl = "https://shinshin-cleaning-service.azurewebsites.net/createMember";
			WebTarget target = client.target(restUrl);
			Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);

			// Construct JSON using a HashMap
			Map<String, Object> newMember = new HashMap<>();
            newMember.put("firstName", firstName);
            newMember.put("lastName", lastName);
            newMember.put("email", email);
            newMember.put("password", pwd);
            newMember.put("phNumber", contact);
            newMember.put("gender", gender);
            newMember.put("dob", dobStr); 
            
            // Convert Map to JSON
            ObjectMapper objectMapper = new ObjectMapper();
            String jsonPayload = objectMapper.writeValueAsString(newMember);
            
			// Send POST request
			Response resp = invocationBuilder.post(Entity.entity(jsonPayload, MediaType.APPLICATION_JSON));

			// Handle response
            if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
                System.out.println("API Call Successful! Redirecting...");
                response.sendRedirect("GetAdminMemberManagementServlet");
            } else {
                System.out.println("API Call Failed! HTTP Status: " + resp.getStatus());
                response.getWriter().write("API Call Failed: HTTP Status " + resp.getStatus());
            }
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
