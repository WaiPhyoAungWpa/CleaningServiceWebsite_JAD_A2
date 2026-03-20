package adminModel;

import java.sql.Timestamp;

public class Booking {
	private int BookingId;
	private int ServiceId;
	private String ServiceName;
	private Timestamp BookingTime;
	public Booking(int bookingId,int serviceId, String serviceName, Timestamp bookingTime) {
		super();
		BookingId = bookingId;
		ServiceId = serviceId;
		ServiceName = serviceName;
		BookingTime = bookingTime;
	}

	public Booking() {
		super();
	}

	public int getBookingId() {
		return BookingId;
	}
	public int getServiceId() {
		return ServiceId;
	}
	public String getServiceName() {
		return ServiceName;
	}
	public Timestamp getBookingTime() {
		return BookingTime;
	}
}
