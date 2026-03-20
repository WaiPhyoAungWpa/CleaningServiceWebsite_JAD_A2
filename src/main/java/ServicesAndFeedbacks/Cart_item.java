package ServicesAndFeedbacks;
import com.google.gson.Gson;

public class Cart_item {
	private int CustomerID;
	private String BookingTime;
	private int ServiceID;
	private String ServiceName;
	private String ServiceImgName;
	private String CategoryName;
	private double BasePrice;
	private double BaseDuration;
	private double AddOnRate;
	
	public Cart_item(int customerID, String bookingTime, int serviceID, String serviceName, String serviceImgName,
			String categoryName, double basePrice, double baseDuration, double addOnRate) {
		super();
		CustomerID = customerID;
		BookingTime = bookingTime;
		ServiceID = serviceID;
		ServiceName = serviceName;
		ServiceImgName = serviceImgName;
		CategoryName = categoryName;
		BasePrice = basePrice;
		BaseDuration = baseDuration;
		AddOnRate = addOnRate;
	}

	public int getCustomerID() {
		return CustomerID;
	}

	public void setCustomerID(int customerID) {
		CustomerID = customerID;
	}

	public String getBookingTime() {
		return BookingTime;
	}

	public void setBookingTime(String bookingTime) {
		BookingTime = bookingTime;
	}

	public int getServiceID() {
		return ServiceID;
	}

	public void setServiceID(int serviceID) {
		ServiceID = serviceID;
	}

	public String getServiceName() {
		return ServiceName;
	}

	public void setServiceName(String serviceName) {
		ServiceName = serviceName;
	}

	public String getServiceImgName() {
		return ServiceImgName;
	}

	public void setServiceImgName(String serviceImgName) {
		ServiceImgName = serviceImgName;
	}

	public String getCategoryName() {
		return CategoryName;
	}

	public void setCategoryName(String categoryName) {
		CategoryName = categoryName;
	}

	public double getBasePrice() {
		return BasePrice;
	}

	public void setBasePrice(double basePrice) {
		BasePrice = basePrice;
	}

	public double getBaseDuration() {
		return BaseDuration;
	}

	public void setBaseDuration(double baseDuration) {
		BaseDuration = baseDuration;
	}

	public double getAddOnRate() {
		return AddOnRate;
	}

	public void setAddOnRate(double addOnRate) {
		AddOnRate = addOnRate;
	}
	
    // Method to return JSON representation of this object
    public String toJson() {
        Gson gson = new Gson();
        return gson.toJson(this);
    }
}
