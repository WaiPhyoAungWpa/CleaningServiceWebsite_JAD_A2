package adminModel;

import java.sql.Timestamp;

public class Member {
	private int customerId;
    private String firstName;
    private String lastName;
    private String email;
    private String phNumber;
    private String gender;
    private Timestamp dob;
    private String bookingDetails;
	public Member(int customerId, String firstName, String lastName, String email, String phNumber, String gender,
			Timestamp dob, String bookingDetails) {
		super();
		this.customerId = customerId;
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.phNumber = phNumber;
		this.gender = gender;
		this.dob = dob;
		this.bookingDetails = bookingDetails;
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
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhNumber() {
		return phNumber;
	}
	public void setPhNumber(String phNumber) {
		this.phNumber = phNumber;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public Timestamp getDob() {
		return dob;
	}
	public void setDob(Timestamp dob) {
		this.dob = dob;
	}
	public String getBookingDetails() {
		return bookingDetails;
	}
	public void setBookingDetails(String bookingDetails) {
		this.bookingDetails = bookingDetails;
	}
	public String getDobString() {
	    if (dob != null) {
	        return dob.toString().split(" ")[0]; // Converts the Timestamp to String and extracts the date part
	    }
	    return null; // Return null if dob is null
	}
}
    
