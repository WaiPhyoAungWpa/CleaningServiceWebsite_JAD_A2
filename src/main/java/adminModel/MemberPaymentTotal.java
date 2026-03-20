package adminModel;

public class MemberPaymentTotal {
	private int customerId;
	   private String firstName;
	   private String lastName;
	   private double totalAmount;

	   public MemberPaymentTotal(int customerId, String firstName, String lastName, double totalAmount) {
	       this.customerId = customerId;
	       this.firstName = firstName;
	       this.lastName = lastName;
	       this.totalAmount = totalAmount;
	   }

	   // Getters and Setters
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

	   public double getTotalAmount() {
	       return totalAmount;
	   }

	   public void setTotalAmount(double totalAmount) {
	       this.totalAmount = totalAmount;
	   }
}
