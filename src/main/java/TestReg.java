import DAO.UserDAO;

public class TestReg {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        try {
            int userId = dao.createVolunteer("testv6@vol.com", "Pass123");
            System.out.println("userId = " + userId);
            if (userId > 0) {
                boolean roles = dao.assignRole(userId, "Volunteer");
                System.out.println("roles = " + roles);
                boolean profile = dao.createEmptyProfile(userId, "Test", "Vol");
                System.out.println("profile = " + profile);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
