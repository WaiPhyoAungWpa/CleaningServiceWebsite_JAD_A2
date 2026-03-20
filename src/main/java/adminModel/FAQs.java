package adminModel;

import java.sql.Timestamp;

public class FAQs {
	private int id;
    private String question;
    private String answer;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
	public FAQs(int id, String question, String answer, Timestamp createdAt, Timestamp updatedAt) {
		super();
		this.id = id;
		this.question = question;
		this.answer = answer;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public Timestamp getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}
	
    
}