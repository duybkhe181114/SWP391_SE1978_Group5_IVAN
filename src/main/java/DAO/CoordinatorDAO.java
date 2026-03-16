package DAO;

import Context.DBContext;
import DTO.CoordinatorDTO;
import Entity.Coordinator;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CoordinatorDAO extends DBContext {

    public List<CoordinatorDTO> getCoordinators() {

        List<CoordinatorDTO> list = new ArrayList<>();

        String sql = """
            SELECT 
                u.UserId,
                up.FullName,
                u.Email,
                MAX(e.Title) AS CurrentAssignment,
                CASE 
                    WHEN MAX(
                        CASE 
                            WHEN e.Status = 'Approved' 
                                 AND e.EndDate >= GETDATE()
                            THEN 1 ELSE 0
                        END
                    ) = 1 
                    THEN 'BUSY'
                    ELSE 'ACTIVE'
                END AS CurrentStatus
            FROM Users u
            INNER JOIN EventCoordinators ec 
                ON u.UserId = ec.CoordinatorId
            LEFT JOIN Events e 
                ON ec.EventId = e.EventId
            LEFT JOIN UserProfiles up 
                ON u.UserId = up.UserId
            GROUP BY u.UserId, up.FullName, u.Email
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CoordinatorDTO c = new CoordinatorDTO();
                c.setUserId(rs.getInt("UserId"));
                c.setFullName(rs.getString("FullName"));
                c.setEmail(rs.getString("Email"));
                c.setStatus(rs.getString("CurrentStatus"));
                c.setCurrentAssignment(rs.getString("CurrentAssignment"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public List<Coordinator> getAllCoordinators() {

        List<Coordinator> list = new ArrayList<>();

        String sql = """
    SELECT 
        u.UserId,
        up.FullName,
        u.Email,

        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM Tasks t
                WHERE t.CoordinatorId = u.UserId
                  AND t.Status = 'Assigned'
            )
            THEN 'BUSY'
            ELSE 'ACTIVE'
        END AS Status,

        (
            SELECT TOP 1 e.Title
            FROM Tasks t
            JOIN Events e ON t.EventId = e.EventId
            WHERE t.CoordinatorId = u.UserId
              AND t.Status = 'Assigned'
        ) AS CurrentAssignment

    FROM Users u
    JOIN UserRoles ur ON u.UserId = ur.UserId
    JOIN UserProfiles up ON u.UserId = up.UserId
    WHERE ur.Role = 'Coordinator'
""";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Coordinator(
                        rs.getInt("UserId"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("Status") == null ? "ACTIVE" : rs.getString("Status"),
                        rs.getString("EventName") == null ? "No current assignment" : rs.getString("EventName")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}