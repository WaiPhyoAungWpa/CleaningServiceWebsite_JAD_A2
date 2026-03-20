package adminController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;

import adminModel.*;

@WebServlet("/UpdateServiceServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
		maxFileSize = 1024 * 1024 * 10, // 10MB
		maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class UpdateServiceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String UPLOAD_DIR = "service_images";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			// Retrieve form parameters
			int serviceId = Integer.parseInt(request.getParameter("serviceId"));
			String serviceName = request.getParameter("serviceName");
			String editServiceImgName = request.getParameter("editImageName"); // Passed original image name
			String serviceDescription = request.getParameter("serviceDescription");
			String serviceCategory = request.getParameter("serviceCategory");
			double basePrice = Double.parseDouble(request.getParameter("basePrice"));
			double baseDuration = Double.parseDouble(request.getParameter("baseDuration"));
			double addOnRate = Double.parseDouble(request.getParameter("addOnRate"));
			String[] includedServices = request.getParameterValues("includedServices");

			// Define upload path inside webapp/service_images
			String uploadPath = "C:/Users/Lenovo/eclipse-workspace/A2/src/main/webapp/service_images";
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs(); // Create folder if not exists
			}

			String newFileName = editServiceImgName; // Default to original image name

			// Handle Image Upload
			Part filePart = request.getPart("serviceImgUpload");
			if (filePart != null && filePart.getSize() > 0) {
				// New image is uploaded
				String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
				String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();

				// Validate extension (allow jpg, jpeg, png, gif, webp)
				List<String> allowedExtensions = Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp");
				if (!allowedExtensions.contains(fileExtension)) {
					response.getWriter().write("Invalid file type! Only JPG, JPEG, PNG, GIF, and WebP are allowed.");
					return;
				}

				// Generate a new file name based on the service name
				newFileName = serviceName.replaceAll("\\s+", "_") + fileExtension;

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
			} else {
				// No new image uploaded, rename the existing file if the service name changed
				if (editServiceImgName != null && !editServiceImgName.isEmpty()) {
					String currentFileExtension = editServiceImgName.substring(editServiceImgName.lastIndexOf("."));
					newFileName = serviceName.replaceAll("\\s+", "_") + currentFileExtension;

					File oldFile = new File(uploadPath + File.separator + editServiceImgName);
					File newFile = new File(uploadPath + File.separator + newFileName);

					if (oldFile.exists() && !editServiceImgName.equals(newFileName)) {
						boolean renamed = oldFile.renameTo(newFile);
						if (renamed) {
							boolean dbUpdate = ServiceDAO.updateServiceImage(newFileName, editServiceImgName);
							if (dbUpdate) {
								System.out.println("File renamed & database updated successfully: " + oldFile.getName()
										+ " -> " + newFile.getName());
							} else {
								System.out.println("File renamed, but failed to update database.");
							}
						} else {
							System.out.println("File rename failed!");
						}
					}

				}
			}

			// Update service in the database with new image name
			ServiceDAO.updateService(serviceId, serviceName, serviceDescription, serviceCategory, newFileName,
					basePrice, baseDuration, addOnRate, Arrays.asList(includedServices));

			response.sendRedirect("GetAdminServiceManagementServlet");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
