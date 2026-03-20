package adminModel;

public class ServiceReport {
	private int serviceId;
    private String serviceName;
    private String serviceCategory;
    private double basePrice;
    private double baseDuration;
    private double addOnRate;
    private double calculatedRating; 
    private int bookingCount; 
    private String status;
	public ServiceReport(int serviceId, String serviceName, String serviceCategory, double basePrice,
			double baseDuration, double addOnRate, double calculatedRating, int bookingCount, String status) {
		super();
		this.serviceId = serviceId;
		this.serviceName = serviceName;
		this.serviceCategory = serviceCategory;
		this.basePrice = basePrice;
		this.baseDuration = baseDuration;
		this.addOnRate = addOnRate;
		this.calculatedRating = calculatedRating;
		this.bookingCount = bookingCount;
		this.status = status;
	}
	public int getServiceId() {
		return serviceId;
	}
	public void setServiceId(int serviceId) {
		this.serviceId = serviceId;
	}
	public String getServiceName() {
		return serviceName;
	}
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}
	public String getServiceCategory() {
		return serviceCategory;
	}
	public void setServiceCategory(String serviceCategory) {
		this.serviceCategory = serviceCategory;
	}
	public double getBasePrice() {
		return basePrice;
	}
	public void setBasePrice(double basePrice) {
		this.basePrice = basePrice;
	}
	public double getBaseDuration() {
		return baseDuration;
	}
	public void setBaseDuration(double baseDuration) {
		this.baseDuration = baseDuration;
	}
	public double getAddOnRate() {
		return addOnRate;
	}
	public void setAddOnRate(double addOnRate) {
		this.addOnRate = addOnRate;
	}
	public double getCalculatedRating() {
		return calculatedRating;
	}
	public void setCalculatedRating(double calculatedRating) {
		this.calculatedRating = calculatedRating;
	}
	public int getBookingCount() {
		return bookingCount;
	}
	public void setBookingCount(int bookingCount) {
		this.bookingCount = bookingCount;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
    
    
    
}
