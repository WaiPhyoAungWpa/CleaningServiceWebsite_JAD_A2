package adminController;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.*;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import adminModel.*;

@WebServlet("/CreateServiceServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
		maxFileSize = 1024 * 1024 * 10, // 10MB
		maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class CreateServiceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String UPLOAD_DIR = "service_images";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			// Retrieve form parameters
			String serviceName = request.getParameter("serviceName");
			String serviceDescription = request.getParameter("serviceDescription");
			// String serviceImgName = request.getParameter("serviceImg");
			String serviceCategory = request.getParameter("serviceCategory");
			double basePrice = Double.parseDouble(request.getParameter("basePrice"));
			double baseDuration = Double.parseDouble(request.getParameter("baseDuration"));
			double addOnRate = Double.parseDouble(request.getParameter("addOnRate"));
			String[] includedServices = request.getParameterValues("includedServices");

			// Handle Image Upload
			Part filePart = request.getPart("serviceImg");
			String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

			// Extract file extension
			String fileExtension = "";
			int lastDot = fileName.lastIndexOf(".");
			if (lastDot != -1) {
				fileExtension = fileName.substring(lastDot).toLowerCase();
			}

			// Validate extension (allow jpg, jpeg, png, gif, webp)
			List<String> allowedExtensions = Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp");
			if (!allowedExtensions.contains(fileExtension)) {
				response.getWriter().write("Invalid file type! Only JPG, JPEG, PNG, GIF, and WebP are allowed.");
				return;
			}

			// Save file with validated extension
			String newFileName = serviceName.replaceAll("\\s+", "_") + fileExtension;

			// Define upload path inside webapp/service_images
			String uploadPath = "C:/Users/Lenovo/eclipse-workspace/A2/src/main/webapp/service_images";

			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs(); // Create folder if not exists
			}

			// Save the file to service_images folder
			File file = new File(uploadPath + File.separator + newFileName);
			try (InputStream fileContent = filePart.getInputStream()) {
				Files.copy(fileContent, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
				System.out.println("File uploaded successfully: " + file.getAbsolutePath());
			} catch (IOException e) {
				System.out.println("File upload failed: " + e.getMessage());
			}

			// Insert image name into database
			ServiceDAO.insertServiceImage(newFileName);

			// Create service in database
			ServiceDAO.createService(serviceName, serviceDescription, serviceCategory, newFileName, basePrice,
					baseDuration, addOnRate, Arrays.asList(includedServices));

			response.sendRedirect("GetAdminServiceManagementServlet");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
