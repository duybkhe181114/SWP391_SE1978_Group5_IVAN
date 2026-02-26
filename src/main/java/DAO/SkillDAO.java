package DAO;

import Context.DBContext;
import Entity.Skill;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SkillDAO extends DBContext {

    public List<Skill> getAll() {

        List<Skill> list = new ArrayList<>();

        String sql = """
    SELECT SkillId,
           SkillName
    FROM Skills
    ORDER BY SkillName
""";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Skill skill = new Skill();
                skill.setSkillId(rs.getInt("SkillId"));
                skill.setSkillName(rs.getString("SkillName"));
                list.add(skill);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}