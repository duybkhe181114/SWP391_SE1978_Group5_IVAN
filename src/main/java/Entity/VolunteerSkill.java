package Entity;

public class VolunteerSkill {

    private Integer volunteerId;
    private Integer skillId;

    public VolunteerSkill(Integer volunteerId, Integer skillId) {
        this.volunteerId = volunteerId;
        this.skillId = skillId;
    }

    public VolunteerSkill() {
    }

    public Integer getVolunteerId() {
        return volunteerId;
    }
    public void setVolunteerId(Integer volunteerId) {
        this.volunteerId = volunteerId;
    }

    public Integer getSkillId() {
        return skillId;
    }
    public void setSkillId(Integer skillId) {
        this.skillId = skillId;
    }
}
