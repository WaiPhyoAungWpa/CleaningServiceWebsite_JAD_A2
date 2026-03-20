package memberModel;

import java.sql.*;
import java.util.*;


public class BookingDAO {
	public static ArrayList<Booking> getBookingDetails(int userId){
		 ArrayList<Booking> bookingHistory = new ArrayList<>();
		 String sql = "SELECT b.booking_id, s.service_name, bd.services_id, bd.booking_time, p.base_price, st1.description AS booking_status, st2.description AS transaction_status FROM bookings AS b INNER JOIN booking_details AS bd ON b.booking_id = bd.booking_id INNER JOIN services AS s ON bd.services_id = s.service_id LEFT JOIN status AS st1 ON st1.status_id = bd.status_id LEFT JOIN service_pricing AS p ON p.pricing_id = bd.pricing_id LEFT JOIN transactions AS t ON t.transaction_id = bd.transaction_id LEFT JOIN status AS st2 ON st2.status_id = t.status_id WHERE b.customer_id = ? ORDER BY bd.booking_time DESC;";
		 try(Connection conn = DBConnection.getConnection();
				 PreparedStatement pstmt = conn.prepareStatement(sql)){
			 pstmt.setInt(1, userId);
			 ResultSet bookings = pstmt.executeQuery();
			 if (bookings != null) {
	        while (bookings.next()) {
	            int bookingId = bookings.getInt("booking_id");
	            int serviceId = bookings.getInt("services_id");
	            String serviceName = bookings.getString("service_name");
	            Timestamp bookingTime = bookings.getTimestamp("booking_time");
	            String bookingStatus = bookings.getString("booking_status");
	            double cost = bookings.getDouble("base_price");
	            String paymentStatus = bookings.getString("transaction_status");

	            // Create Booking object and add to list
	            Booking bookingDetails = new Booking(
	                    bookingId, 
	                    serviceId, 
	                    serviceName, 
	                    bookingTime, 
	                    bookingStatus, 
	                    cost, 
	                    paymentStatus
	            );
	            bookingHistory.add(bookingDetails);
	        }
			 }
			 conn.close();
		 } catch (Exception e) {
			 e.printStackTrace();
		 }
		 return bookingHistory;
		}
		
		public static Booking getBookingDetailsById(int bookingId) {
			Booking booking = new Booking();
			String sql = "SELECT b.booking_id, s.service_name, bd.services_id, bd.booking_time, " +
          "p.base_price, st1.description AS booking_status, st2.description AS transaction_status " +
          "FROM bookings AS b " +
          "INNER JOIN booking_details AS bd ON b.booking_id = bd.booking_id " +
          "INNER JOIN services AS s ON bd.services_id = s.service_id " +
          "LEFT JOIN status AS st1 ON st1.status_id = bd.status_id " +
          "LEFT JOIN service_pricing AS p ON p.pricing_id = bd.pricing_id " +
          "LEFT JOIN transactions AS t ON t.transaction_id = bd.transaction_id " +
          "LEFT JOIN status AS st2 ON st2.status_id = t.status_id " +
          "WHERE b.booking_id = ?";
			try(Connection conn = DBConnection.getConnection();
					 PreparedStatement pstmt = conn.prepareStatement(sql)){
				 pstmt.setInt(1, bookingId);
				 ResultSet bookings = pstmt.executeQuery();
						while (bookings.next()) {
	            int serviceId = bookings.getInt("services_id");
	            String serviceName = bookings.getString("service_name");
	            Timestamp bookingTime = bookings.getTimestamp("booking_time");
	            String bookingStatus = bookings.getString("booking_status");
	            double cost = bookings.getDouble("base_price");
	            String paymentStatus = bookings.getString("transaction_status");
	            
							booking.setBookingId(bookingId);
							booking.setServiceId(serviceId);
							booking.setServiceName(serviceName);
							booking.setBookingTime(bookingTime);
							booking.setBookingStatus(bookingStatus);
							booking.setCost(cost);
							booking.setPaymentStatus(paymentStatus);
							};
				 conn.close();
			 } catch (Exception e) {
				 e.printStackTrace();
			 }
			return booking;
		}
		
}
