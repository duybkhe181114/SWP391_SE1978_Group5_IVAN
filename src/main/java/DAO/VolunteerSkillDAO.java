package DAO;

import Context.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VolunteerSkillDAO extends DBContext {

    public List<Integer> getSkillIdsByUser(int userId) {
        List<Integer> list = new ArrayList<>();

        String sql = """
            SELECT SkillId
            FROM VolunteerSkills
            WHERE VolunteerId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("SkillId"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void updateVolunteerSkills(int userId, String[] skillIds) {

        String deleteSql = "DELETE FROM VolunteerSkills WHERE VolunteerId = ?";
        String insertSql = "INSERT INTO VolunteerSkills (VolunteerId, SkillId) VALUES (?, ?)";

        try {
            connection.setAutoCommit(false);

            // Delete old skills
            try (PreparedStatement deletePs = connection.prepareStatement(deleteSql)) {
                deletePs.setInt(1, userId);
                deletePs.executeUpdate();
            }

            // Insert new skills
            if (skillIds != null) {
                try (PreparedStatement insertPs = connection.prepareStatement(insertSql)) {

                    for (String skillId : skillIds) {
                        insertPs.setInt(1, userId);
                        insertPs.setInt(2, Integer.parseInt(skillId));
                        insertPs.addBatch();
                    }

                    insertPs.executeBatch();
                }
            }

            connection.commit();

        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}