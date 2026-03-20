package adminModel;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {
	public static List<Member> getMemberDetails() {
		List<Member> members = new ArrayList<>();
		Connection conn = null;

		try {
			conn = AdminDBConnection.getConnection();
			String sql = "SELECT * FROM get_member_details()";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			// Step 5: Populate member objects
			while (rs.next()) {
				// Retrieve JSON for booking details
				String bookingDetails = rs.getString("booking_details");

				// Create and add Member object
				Member member = new Member(rs.getInt("customer_id"), rs.getString("first_name"),
						rs.getString("last_name"), rs.getString("email"), rs.getString("ph_number"),
						rs.getString("gender"), rs.getTimestamp("dob"), bookingDetails // Store the JSON string
				);
				members.add(member);
			}
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return members;
	}

	public static void updateMemberDetails(int memberId, String firstName, String lastName, String email,
			String phNumber, String gender, Timestamp dob) {
		List<Member> members = new ArrayList<>();
		Connection conn = null;

		try {
			conn = AdminDBConnection.getConnection();
			String sql = "UPDATE customers "
					+ "SET first_name = ?, last_name = ?, email = ?, ph_number = ?, gender = ?, dob = ? "
					+ "WHERE customer_id = ?";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, firstName);
			pstmt.setString(2, lastName);
			pstmt.setString(3, email);
			pstmt.setString(4, phNumber);
			pstmt.setString(5, gender);
			pstmt.setTimestamp(6, dob);
			pstmt.setInt(7, memberId);

			int rs = pstmt.executeUpdate();

			if (rs > 0) {
				System.out.println("Customer Details Edited Successfully!");
			}
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Error during customer update: " + e.getMessage());
		}
	}

	public static void deleteMember(int customerId) {
		Connection conn = null;

		try {
			conn = AdminDBConnection.getConnection();
			String sql = "CALL delete_customer_and_bookings(?)";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, customerId);

			int result = pstmt.executeUpdate();

			if (result > 0) {
				System.out.println("Customer with ID " + customerId + " deleted successfully!");
			} else {
				System.out.println("No customer found with ID " + customerId + ".");
			}

			// Close the connection
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Error during customer deletion: " + e.getMessage());
		}
	}

	public static List<MemberPaymentTotal> getTopTenCustomers() {
		Connection conn = null;
		List<MemberPaymentTotal> topTenCustomer = new ArrayList<>();
		try {
			conn = AdminDBConnection.getConnection();
			String sql = "SELECT t.customer_id, c.first_name, c.last_name, SUM(payment_amount) AS total_amount FROM transactions AS t LEFT JOIN customers AS c ON c.customer_id = t.customer_id WHERE t.customer_id IS NOT NULL GROUP BY t.customer_id, c.customer_id ORDER BY total_amount DESC LIMIT 10;";			
			PreparedStatement pstmt = conn.prepareStatement(sql);

			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				MemberPaymentTotal member = new MemberPaymentTotal(rs.getInt("customer_id"), rs.getString("first_name"),
						rs.getString("last_name"), rs.getDouble("total_amount"));
				topTenCustomer.add(member);
			}
			// Close the connection
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Error getting data: " + e.getMessage());
		}
		return topTenCustomer;
	}

	public static List<MemberBookingTotal> getCustomersByService() {
		Connection conn = null;
		List<MemberBookingTotal> topCustomerByService = new ArrayList<>();
		try {
			conn = AdminDBConnection.getConnection();
			String sql = "SELECT bd.services_id, c.customer_id, c.first_name, c.last_name, COUNT(b.customer_id) AS total_bookings FROM booking_details AS bd LEFT JOIN bookings AS b ON b.booking_id = bd.booking_id LEFT JOIN customers AS c ON c.customer_id = b.customer_id GROUP BY bd.services_id, c.customer_id, c.first_name, c.last_name ORDER BY bd.services_id, total_bookings DESC;";
			PreparedStatement pstmt = conn.prepareStatement(sql);

			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				MemberBookingTotal member = new MemberBookingTotal(rs.getInt("services_id"), rs.getInt("customer_id"),
						rs.getString("first_name"), rs.getString("last_name"), rs.getInt("total_bookings"));
				topCustomerByService.add(member);
			}
			// Close the connection
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Error getting data: " + e.getMessage());
		}
		return topCustomerByService;
	}

	public static List<MemberAddress> getCustomersByAddress() {
		Connection conn = null;
		List<MemberAddress> customerByAddress = new ArrayList<>();
		try {
			conn = AdminDBConnection.getConnection();
			String sql = "SELECT a.address_id, a.customer_id, a.address_name, a.address, a.postal_code, CONCAT(c.first_name, ' ', c.last_name) AS customer_name FROM address a JOIN customers c ON a.customer_id = c.customer_id ORDER BY a.address_id ASC;";
			PreparedStatement pstmt = conn.prepareStatement(sql);

			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				MemberAddress member = new MemberAddress(rs.getInt("address_id"), rs.getInt("customer_id"), rs.getString("customer_name"),
						rs.getString("address_name"), rs.getString("address"), rs.getString("postal_code"));
				customerByAddress.add(member);
			}
		// Close the connection
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Error getting data: " + e.getMessage());
		}
		return customerByAddress;
	}
}
