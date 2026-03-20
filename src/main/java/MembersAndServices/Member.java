package MembersAndServices;

import java.sql.*;

public class Member {
	private int Id;
	private String Name;
	private String Email;
	private String Password;
	private String PhNo;
	private String Gender;
	private Timestamp DOB;

	public Member(int id, String name, String email, String password, String phNo, String gender, Timestamp dOB) {
		super();
		Id = id;
		Name = name;
		Email = email;
		Password = password;
		PhNo = phNo;
		Gender = gender;
		DOB = dOB;
	}

	public Member(Member other) {
		this.Id = other.Id;
		this.Name = other.Name;
		this.Email = other.Email;
		this.Password = other.Password;
		this.PhNo = other.PhNo;
		this.Gender = other.Gender;
		this.DOB = other.DOB;
	}

	public int getId() {
		return Id;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public String getEmail() {
		return Email;
	}

	public void setEmail(String email) {
		Email = email;
	}

	public String getPassword() {
		return Password;
	}

	public void setPassword(String password) {
		Password = password;
	}

	public String getPhNo() {
		return PhNo;
	}

	public void setPhNo(String phNo) {
		PhNo = phNo;
	}

	public String getGender() {
		return Gender;
	}

	public void setGender(String gender) {
		Gender = gender;
	}

	public Timestamp getDOB() {
		return DOB;
	}

	public void setDOB(Timestamp dOB) {
		DOB = dOB;
	}
}