package MembersAndServices;

public class CustomerReview {
	private String name;
	private int rating;
	private String feedback;

	public CustomerReview(String name, int rating, String feedback) {
		super();
		this.name = name;
		this.rating = rating;
		this.feedback = feedback;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public String getFeedback() {
		return feedback;
	}

	public void setFeedback(String feedback) {
		this.feedback = feedback;
	}
}
