package DAO;

import Context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO extends DBContext {

    // Kiểm tra mật khẩu cũ
    public boolean checkOldPassword(int userId, String oldPass) {
        try {
            String sql = "SELECT PasswordHash FROM Users WHERE UserId = ?";

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String currentPass = rs.getString("PasswordHash");
                return currentPass.equals(oldPass);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Update password mới
    public boolean updatePassword(int userId, String newPass) {
        try {
            String sql = "UPDATE Users SET PasswordHash = ? WHERE UserId = ?";

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newPass);
            ps.setInt(2, userId);

            int row = ps.executeUpdate();

            return row > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
