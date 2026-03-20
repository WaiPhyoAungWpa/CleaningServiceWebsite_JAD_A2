package adminModel;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FAQsDAO {
	public static List<FAQs> getAllFAQs() {
        List<FAQs> faqs = new ArrayList<>();
        Connection conn = null;

        try {
        	conn = AdminDBConnection.getConnection();
            String sql = "SELECT * FROM faq ORDER BY question_id";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            // Step 5: Populate FAQ objects
            while (rs.next()) {
                FAQs faq = new FAQs(
                        rs.getInt("question_id"),
                        rs.getString("question"),
                        rs.getString("answer"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
                faqs.add(faq);
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return faqs;
    }

    public static void addFAQ(String question, String answer) {
        Connection conn = null;

        try {
        	conn = AdminDBConnection.getConnection();
            String sql = "INSERT INTO faq (question, answer, created_at, updated_at) VALUES (?, ?, NOW(), NOW())";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, question);
            pstmt.setString(2, answer);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                System.out.println("FAQ added successfully!");
            } else {
                System.out.println("Failed to add FAQ.");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error during FAQ insertion: " + e.getMessage());
        }
    }

    public static void updateFAQ(int id, String question, String answer) {
        Connection conn = null;

        try {
        	conn = AdminDBConnection.getConnection();
            String sql = "UPDATE faq SET question = ?, answer = ?, updated_at= NOW() WHERE question_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, question);
            pstmt.setString(2, answer);
            pstmt.setInt(3, id);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                System.out.println("FAQ updated successfully!");
            } else {
                System.out.println("Failed to update FAQ.");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error during FAQ update: " + e.getMessage());
        }
    }

    public static void deleteFAQ(int id) {
        Connection conn = null;

        try {
        	conn = AdminDBConnection.getConnection();
            String sql = "DELETE FROM faq WHERE question_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                System.out.println("FAQ with ID " + id + " deleted successfully!");
            } else {
                System.out.println("No FAQ found with ID " + id + ".");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error during FAQ deletion: " + e.getMessage());
        }
    }
}
