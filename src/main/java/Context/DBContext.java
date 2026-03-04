package Context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            // Edit URL, username, password to authenticate with your MS SQL Server
            String url = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=IVAN;"
                    + "encrypt=true;"
                    + "trustServerCertificate=true;"
                    + "integratedSecurity=true;";

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url);
        } catch (ClassNotFoundException | SQLException ex) {
            // Logging the exception detail for debugging
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Failed to connect to database.", ex);
        }
    }

    /**
     * Main method to test the database connection.
     * If you are running this in an IDE, ensure you have the SQL Server JDBC driver
     * added to your project's libraries.
     */
    public static void main(String[] args) {
        // Create an instance of DBContext to attempt the connection
        DBContext db = new DBContext();

        System.out.println("--- BẮT ĐẦU KIỂM TRA KẾT NỐI DATABASE ---");

        if (db.connection != null) {
            System.out.println("✅ Kết nối cơ sở dữ liệu 'IVAN' thành công!");

            // Close the connection
            try {
                db.connection.close();
                System.out.println("Đã đóng kết nối.");
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng kết nối: " + e.getMessage());
            }
        } else {
            System.out.println("❌ Kết nối cơ sở dữ liệu thất bại.");
            System.out.println("Kiểm tra lại các yếu tố sau:");
            System.out.println("1. **Driver SQL Server (JDBC)** đã được thêm vào dự án.");
            System.out.println("2. **databaseName** (IVAN) chính xác và đã bật chế độ Windows Authentication.");
            System.out.println("3. **SQL Server** có đang chạy và cho phép kết nối từ xa trên cổng 1433.");
            System.out.println(
                    "4. Gói thư viện **mssql-jdbc_auth.dll** cần đúng phiên bản và nằm trong đường dẫn hệ thống/của dự án.");
        }
    }
}