package adminModel;

import java.util.*;

public class Service {
	private int serviceId;
    private String serviceName;
    private String serviceDescription;
    private String serviceCategory;
    private String serviceImgName;
    private double basePrice;
    private double baseDuration;
    private double addOnRate;
    private String includedServiceItems; 
	public Service(int serviceId, String serviceName, String serviceDescription, String serviceCategory,
			String serviceImgName, double basePrice, double baseDuration, double addOnRate,
			String includedServiceItems) {
		super();
		this.serviceId = serviceId;
		this.serviceName = serviceName;
		this.serviceDescription = serviceDescription;
		this.serviceCategory = serviceCategory;
		this.serviceImgName = serviceImgName;
		this.basePrice = basePrice;
		this.baseDuration = baseDuration;
		this.addOnRate = addOnRate;
		this.includedServiceItems = includedServiceItems;
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
	public String getServiceDescription() {
		return serviceDescription;
	}
	public void setServiceDescription(String serviceDescription) {
		this.serviceDescription = serviceDescription;
	}
	public String getServiceCategory() {
		return serviceCategory;
	}
	public void setServiceCategory(String serviceCategory) {
		this.serviceCategory = serviceCategory;
	}
	public String getServiceImgName() {
		return serviceImgName;
	}
	public void setServiceImgName(String serviceImgName) {
		this.serviceImgName = serviceImgName;
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
	public String getIncludedServiceItems() {
		return includedServiceItems;
	}
	public void setIncludedServiceItems(String includedServiceItems) {
		this.includedServiceItems = includedServiceItems;
	}

}
