package DAO;

import Context.DBContext;
import Entity.Organization;
import java.sql.PreparedStatement;

public class OrganizationDAO extends DBContext {

    public boolean createOrganization(Organization org, int createdBy) {

        String sql = """
            INSERT INTO Organizations
            (Name, Description, Phone, Email, Address, Website, CreatedBy)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, org.getName());
            ps.setString(2, org.getDescription());
            ps.setString(3, org.getPhone());
            ps.setString(4, org.getEmail());
            ps.setString(5, org.getAddress());
            ps.setString(6, org.getWebsite());
            ps.setInt(7, createdBy);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
