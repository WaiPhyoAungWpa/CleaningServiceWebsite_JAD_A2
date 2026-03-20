package memberModel;

import java.sql.*;

public class DBConnection {
	public static Connection getConnection() {
		String dbUrl = "jdbc:postgresql://ep-jolly-cherry-a19x4h8o.ap-southeast-1.aws.neon.tech/ShinShin";
		String dbUser = "neondb_owner";
		String dbPassword = "omcrC2xOqNn6";
		String dbClass = "org.postgresql.Driver";
		
		Connection connection = null;
		try {
      Class.forName(dbClass);
      connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
  } catch (ClassNotFoundException e) {
      System.err.println("Driver not found: " + e.getMessage());
  } catch (SQLException e) {
      System.err.println("Connection failed: " + e.getMessage());
  }
		return connection;
	}
}
