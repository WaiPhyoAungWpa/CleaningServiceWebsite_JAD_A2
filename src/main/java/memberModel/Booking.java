package memberModel;

import java.sql.Timestamp;

public class Booking {
	private int BookingId;
	private int ServiceId;
	private String ServiceName;
	private Timestamp BookingTime;
	private String BookingStatus;
	private double Cost;
	private String PaymentStatus;
	
	public Booking() {
		super();
	}
	
	public Booking(int bookingId, int serviceId, String serviceName, Timestamp bookingTime, String bookingStatus,
			double cost, String paymentStatus) {
		super();
		BookingId = bookingId;
		ServiceId = serviceId;
		ServiceName = serviceName;
		BookingTime = bookingTime;
		BookingStatus = bookingStatus;
		Cost = cost;
		PaymentStatus = paymentStatus;
	}
	public int getBookingId() {
		return BookingId;
	}
	public void setBookingId(int bookingId) {
		BookingId = bookingId;
	}
	public int getServiceId() {
		return ServiceId;
	}
	public void setServiceId(int serviceId) {
		ServiceId = serviceId;
	}
	public String getServiceName() {
		return ServiceName;
	}
	public void setServiceName(String serviceName) {
		ServiceName = serviceName;
	}
	public Timestamp getBookingTime() {
		return BookingTime;
	}
	public void setBookingTime(Timestamp bookingTime) {
		BookingTime = bookingTime;
	}
	public String getBookingStatus() {
		return BookingStatus;
	}
	public void setBookingStatus(String bookingStatus) {
		BookingStatus = bookingStatus;
	}
	public double getCost() {
		return Cost;
	}
	public void setCost(double cost) {
		Cost = cost;
	}
	public String getPaymentStatus() {
		return PaymentStatus;
	}
	public void setPaymentStatus(String paymentStatus) {
		PaymentStatus = paymentStatus;
	}
	
}
