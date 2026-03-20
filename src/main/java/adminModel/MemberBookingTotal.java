package adminModel;

public class MemberBookingTotal {
	private int serviceId;
	 private int customerId;
  private String firstName;
  private String lastName;
  private int totalBookings;
  
	public MemberBookingTotal(int serviceId, int customerId, String firstName, String lastName, int totalBookings) {
		super();
		this.serviceId = serviceId;
		this.customerId = customerId;
		this.firstName = firstName;
		this.lastName = lastName;
		this.totalBookings = totalBookings;
	}

	public int getServiceId() {
		return serviceId;
	}

	public void setServiceId(int serviceId) {
		this.serviceId = serviceId;
	}

	public int getCustomerId() {
		return customerId;
	}

	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public int getTotalBookings() {
		return totalBookings;
	}

	public void setTotalBookings(int totalBookings) {
		this.totalBookings = totalBookings;
	}
}
