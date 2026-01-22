package Entity;

public class Skill {

    private Integer skillId;
    private String skillName;

    public Integer getSkillId() {
        return skillId;
    }

    public Skill(Integer skillId, String skillName) {
        this.skillId = skillId;
        this.skillName = skillName;
    }

    public Skill() {
    }

    public void setSkillId(Integer skillId) {
        this.skillId = skillId;
    }

    public String getSkillName() {
        return skillName;
    }
    public void setSkillName(String skillName) {
        this.skillName = skillName;
    }
}
