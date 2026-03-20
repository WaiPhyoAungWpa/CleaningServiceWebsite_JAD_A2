package adminModel;

import java.sql.*;
import java.util.*;

public class ServiceDAO {
	public static List<Service> getServices() throws SQLException {
		List<Service> services = new ArrayList<>();
		Connection conn = null;

		try {
			conn = AdminDBConnection.getConnection();
			String sql = "SELECT * FROM get_service_details()";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				int serviceId = rs.getInt("service_id");
				String serviceName = rs.getString("service_name");
				String serviceDescription = rs.getString("service_description");
				String serviceCategory = rs.getString("service_category");
				String serviceImgName = rs.getString("service_img_name");
				double basePrice = rs.getDouble("base_price");
				double baseDuration = rs.getDouble("base_duration");
				double addOnRate = rs.getDouble("add_on_rate");
				String includedServiceItems = rs.getString("included_service_items");

				Service service = new Service(serviceId, serviceName, serviceDescription, serviceCategory,
						serviceImgName, basePrice, baseDuration, addOnRate, includedServiceItems);
				services.add(service);
			}
		} catch (Exception e) {
			System.out.println("Error fetching services: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (conn != null)
				conn.close();
		}

		return services;
	}

	public static List<String> getServiceItems() throws SQLException {
		List<String> serviceItems = new ArrayList<>();
		Connection conn = null;

		try {
			conn = AdminDBConnection.getConnection();
			String sql = "SELECT item_name FROM service_items";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				serviceItems.add(rs.getString("item_name"));
			}
		} catch (Exception e) {
			System.out.println("Error fetching service items: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (conn != null)
				conn.close();
		}
		return serviceItems;
	}

	public static List<String> getServiceImages() throws SQLException {
		List<String> serviceImages = new ArrayList<>();
		Connection conn = null;

		try {
			conn = AdminDBConnection.getConnection();
			String sql = "SELECT * FROM service_images";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				serviceImages.add(rs.getString("service_img_name"));
			}

		} catch (Exception e) {
			System.out.println("Error fetching service images: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (conn != null)
				conn.close();
		}
		return serviceImages;
	}

	public static void insertServiceImage(String imgFileName) throws SQLException {
		Connection conn = null;

		try {
			conn = AdminDBConnection.getConnection();
			String sql = "INSERT INTO service_images (service_img_name) VALUES (?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, imgFileName);
			ps.executeUpdate();
		} catch (SQLException e) {
			System.out.println("SQL Error inserting service image: " + e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			System.out.println("Unexpected error inserting service image: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (conn != null)
				conn.close();
		}
	}

	public static void createService(String serviceName, String serviceDescription, String serviceCategory,
			String serviceImg, double basePrice, double baseDuration, double addOnRate, List<String> includedServices)
			throws SQLException {
		Connection conn = null;

		try {
			conn = AdminDBConnection.getConnection();
			Array serviceItemsArray = conn.createArrayOf("text", includedServices.toArray());
			String sql = "CALL insert_new_service(?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, serviceName);
			ps.setString(2, serviceDescription);
			ps.setString(3, serviceCategory);
			ps.setString(4, serviceImg);
			ps.setDouble(5, basePrice);
			ps.setDouble(6, baseDuration);
			ps.setDouble(7, addOnRate);
			ps.setArray(8, serviceItemsArray);

			// Step 6: Execute procedure
			ps.execute();
			System.out.println("Service created successfully!");
		} catch (SQLException e) {
			System.out.println("SQL Error creating service: " + e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			System.out.println("Unexpected error creating service: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (conn != null)
				conn.close();
		}
	}

	public static boolean updateServiceImage(String newFileName, String oldFileName) throws SQLException {
		Connection conn = null;
		boolean isUpdated = false;

		try {
			conn = AdminDBConnection.getConnection();
			String sql = "UPDATE service_images SET service_img_name = ? WHERE service_img_name = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, newFileName);
			ps.setString(2, oldFileName);

			int rowsUpdated = ps.executeUpdate();
			isUpdated = rowsUpdated > 0; // True if at least one row is updated

		} catch (SQLException e) {
			System.out.println("SQL Error updating service image: " + e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			System.out.println("Unexpected error updating service image: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (conn != null) {
				conn.close();
			}
		}

		return isUpdated;
	}

	public static void updateService(int serviceId, String serviceName, String serviceDescription,
			String serviceCategory, String serviceImg, double basePrice, double baseDuration, double addOnRate,
			List<String> includedServices) throws SQLException {
		Connection conn = null;

		try {
			conn = AdminDBConnection.getConnection();

			// Convert includedServices list to PostgreSQL array
			Array serviceItemsArray = conn.createArrayOf("text", includedServices.toArray());

			// SQL statement to call stored procedure
			String sql = "CALL update_service(?, ?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, serviceName);
			ps.setString(2, serviceDescription);
			ps.setString(3, serviceCategory);
			ps.setString(4, serviceImg);
			ps.setDouble(5, basePrice);
			ps.setDouble(6, baseDuration);
			ps.setDouble(7, addOnRate);
			ps.setArray(8, serviceItemsArray);
			ps.setInt(9, serviceId);

			// Execute procedure and store the result
			ps.execute();

			System.out.println("Service updated successfully!");

		} catch (SQLException e) {
			System.out.println("SQL Error updating service: " + e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			System.out.println("Unexpected error updating service: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (conn != null)
				conn.close();
		}
	}

	public static void deleteService(int serviceId) throws SQLException {
		Connection conn = null;
		int result = 0;

		try {
			conn = AdminDBConnection.getConnection();
			String sql = "CALL delete_service(?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, serviceId);
			ps.execute();
		} catch (Exception e) {
			System.out.println("Error deleting service: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (conn != null)
				conn.close();
		}
	}

	public static List<ServiceReport> getServiceReports() throws SQLException {
		List<ServiceReport> reports = new ArrayList<>();
		Connection conn = null;

		try {
			conn = AdminDBConnection.getConnection();
			String sql = "SELECT * FROM get_service_reports()";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				int serviceId = rs.getInt("service_id");
				String serviceName = rs.getString("service_name");
				String serviceCategory = rs.getString("service_category");
				double basePrice = rs.getDouble("base_price");
				double baseDuration = rs.getDouble("base_duration");
				double addOnRate = rs.getDouble("add_on_rate");
				double calculatedRating = rs.getDouble("calculated_rating");
				int bookingCount = rs.getInt("booking_count");
				String status = rs.getString("status");

				ServiceReport report = new ServiceReport(serviceId, serviceName, serviceCategory, basePrice,
						baseDuration, addOnRate, calculatedRating, bookingCount, status);
				reports.add(report);
			}
		} catch (Exception e) {
			System.out.println("Error fetching services: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (conn != null)
				conn.close();
		}

		return reports;
	}
}
