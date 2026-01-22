package Entity;
public class VolunteerCoordinator {

    private Integer coordinatorId;
    private Integer volunteerId;

    public VolunteerCoordinator() {
    }

    public VolunteerCoordinator(Integer coordinatorId, Integer volunteerId) {
        this.coordinatorId = coordinatorId;
        this.volunteerId = volunteerId;
    }

    public Integer getCoordinatorId() {
        return coordinatorId;
    }
    public void setCoordinatorId(Integer coordinatorId) {
        this.coordinatorId = coordinatorId;
    }

    public Integer getVolunteerId() {
        return volunteerId;
    }
    public void setVolunteerId(Integer volunteerId) {
        this.volunteerId = volunteerId;
    }
}
