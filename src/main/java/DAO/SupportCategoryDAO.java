package DAO;

import Context.DBContext;
import Entity.SupportCategory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupportCategoryDAO extends DBContext {

    public List<SupportCategory> getAll() {
        List<SupportCategory> list = new ArrayList<>();

        String sql = "SELECT * FROM SupportCategories";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new SupportCategory(
                        rs.getInt("CategoryId"),
                        rs.getString("Name")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}