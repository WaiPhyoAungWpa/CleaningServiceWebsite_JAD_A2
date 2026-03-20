package ServicesAndFeedbacks;

public class Service {
	// Attributes
    private int ServiceID;
    private String ServiceName;
    private String ServiceDescription;
    private String ServiceImgName;
    private int ServiceCategoryID;
    private String CategoryName;
    
	public Service(int serviceID, String serviceName, String serviceDescription, String serviceImgName,
			int serviceCategoryID, String categoryName) {
		super();
		ServiceID = serviceID;
		ServiceName = serviceName;
		ServiceDescription = serviceDescription;
		ServiceImgName = serviceImgName;
		ServiceCategoryID = serviceCategoryID;
		CategoryName = categoryName;
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

	public String getServiceDescription() {
		return ServiceDescription;
	}

	public void setServiceDescription(String serviceDescription) {
		ServiceDescription = serviceDescription;
	}

	public String getServiceImgName() {
		return ServiceImgName;
	}

	public void setServiceImgName(String serviceImgName) {
		ServiceImgName = serviceImgName;
	}

	public int getServiceCategoryID() {
		return ServiceCategoryID;
	}

	public void setServiceCategoryID(int serviceCategoryID) {
		ServiceCategoryID = serviceCategoryID;
	}

	public String getCategoryName() {
		return CategoryName;
	}

	public void setCategoryName(String categoryName) {
		CategoryName = categoryName;
	}

}
