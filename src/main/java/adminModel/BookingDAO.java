package adminModel;

import java.sql.*;
import java.util.*;

import adminModel.AdminDBConnection;

public class BookingDAO {
	public ArrayList<Booking> getBookingDetails(int userId){
		 ArrayList<Booking> bookingHistory = new ArrayList<>();
		 String sql = "SELECT b.booking_id, s.service_name, bd.services_id, bd.booking_time FROM bookings AS b INNER JOIN booking_details AS bd ON b.booking_id = bd.booking_id INNER JOIN services AS s ON bd.services_id = s.service_id WHERE b.customer_id = ? ORDER BY bd.booking_time DESC";
		 try(Connection conn = AdminDBConnection.getConnection();
				 PreparedStatement pstmt = conn.prepareStatement(sql)){
			 pstmt.setInt(1, userId);
			 ResultSet bookings = pstmt.executeQuery();
			 if (bookings != null) {
					while (bookings.next()) {
						Booking bookingDetails = new Booking(
								bookings.getInt("booking_id"),
								bookings.getInt("services_id"),
								bookings.getString("service_name"),
								bookings.getTimestamp("booking_time"));
						bookingHistory.add(bookingDetails);
						}
			 }
			 conn.close();
		 } catch (Exception e) {
			 e.printStackTrace();
		 }
		 return bookingHistory;
		}
		
		public Booking getBookingDetailsById(int bookingId) {
			Booking booking = new Booking();
			String sql = "SELECT b.booking_id, s.service_name, bd.services_id, bd.booking_time FROM bookings AS b INNER JOIN booking_details AS bd ON b.booking_id = bd.booking_id INNER JOIN services AS s ON bd.services_id = s.service_id WHERE booking_id = ?";
			try(Connection conn = AdminDBConnection.getConnection();
					 PreparedStatement pstmt = conn.prepareStatement(sql)){
				 pstmt.setInt(1, bookingId);
				 ResultSet bookings = pstmt.executeQuery();
						while (bookings.next()) {
							Booking bookingDetails = new Booking(
									bookings.getInt("booking_id"),
									bookings.getInt("services_id"),
									bookings.getString("service_name"),
									bookings.getTimestamp("booking_time"));
							}
				 conn.close();
			 } catch (Exception e) {
				 e.printStackTrace();
			 }
			return booking;
		}
		
		public static void updateBookingStatus(int bookingId, int statusId) {
			Connection conn = null;
			try {
				conn = AdminDBConnection.getConnection();
				String sql = "UPDATE booking_details SET status_id = ? WHERE booking_id = ?;";
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, statusId);
				pstmt.setInt(2, bookingId);
				
				int rs = pstmt.executeUpdate();
				if (rs > 0) {
					System.out.println("Booking Status Updated Successfully");
				}
				conn.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		public static void updateBookingTime(int bookingId, Timestamp bookingTime) {
			Connection conn = null;
			try {
				conn = AdminDBConnection.getConnection();
				String sql = "UPDATE booking_details SET booking_time = ? WHERE booking_id = ?;";
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.setTimestamp(1, bookingTime);
				pstmt.setInt(2, bookingId);
				
				int rs = pstmt.executeUpdate();
				if (rs > 0) {
					System.out.println("Booking Time Updated Successfully");
				}
				conn.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		public static void cancelBooking(int bookingId) {
			Connection conn = null;
			try {
				conn = AdminDBConnection.getConnection();
				String sql = "UPDATE booking_details SET status_id = 4 WHERE booking_id = ?;";
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, bookingId);
				
				int rs = pstmt.executeUpdate();
				if (rs > 0) {
					System.out.println("Booking Cancelled Successfully");
				}
				conn.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
}
