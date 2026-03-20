package adminModel;

public class MemberAddress {
	private int addressId;
	private int customerId;
	private String customerName;
	private String addressName;
	private String address;
	private String postalCode;

	public MemberAddress(int addressId, int customerId, String customerName, String addressName, String address, String postalCode) {
		super();
		this.addressId = addressId;
		this.customerId = customerId;
		this.customerName = customerName;
		this.addressName = addressName;
		this.address = address;
		this.postalCode = postalCode;
	}

	public int getAddressId() {
		return addressId;
	}

	public void setAddressId(int addressId) {
		this.addressId = addressId;
	}

	public int getCustomerId() {
		return customerId;
	}

	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}
	
	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getAddressName() {
		return addressName;
	}

	public void setAddressName(String addressName) {
		this.addressName = addressName;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPostalCode() {
		return postalCode;
	}

	public void setPostalCode(String postalCode) {
		this.postalCode = postalCode;
	}

}
