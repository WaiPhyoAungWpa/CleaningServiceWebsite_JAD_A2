package memberModel;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class MemberDAO {
	public static Member getMemberDetails(int userId) {
		Member member = null;
		String sqlStr = "SELECT * FROM customers WHERE customer_id = ?";
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sqlStr);
			pstmt.setInt(1, userId);
			ResultSet user = pstmt.executeQuery();
			if (user.next()) {
//				member = new Member();
//				member.setId(user.getInt("customer_id"));
//        member.setName(user.getString("first_name") + " " + user.getString("last_name"));
//        member.setEmail(user.getString("email"));
//        member.setPassword(user.getString("password"));
//        member.setPhNo(user.getString("ph_number"));
//        member.setGender(user.getString("gender"));
//        member.setDOB(user.getTimestamp("dob"));
				
				 int id = user.getInt("customer_id");
         String name = user.getString("first_name") + " " + user.getString("last_name");
         String email = user.getString("email");
         String password = user.getString("password");
         String phNo = user.getString("ph_number");
         String gender = user.getString("gender");
         Timestamp dob = user.getTimestamp("dob");

         member = new Member(id, name, email, password, phNo, gender, dob);
			}
		} catch (Exception e) {
			System.out.print("Error getting Member Details:" + e);
		}
		return member;
	}
}
