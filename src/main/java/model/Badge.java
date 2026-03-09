package model;

import jakarta.persistence.*;

@Entity
@Table(name = "Badges")
public class Badge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BadgeID")
    private int badgeID;

    @Column(name = "BadgeName", nullable = false, length = 100)
    private String badgeName;

    @Column(name = "BadgeIcon", length = 10)
    private String badgeIcon;

    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "BadgeType", length = 30)
    private String badgeType;

    @Column(name = "RequirementType", length = 50)
    private String requirementType;

    @Column(name = "RequirementValue")
    private int requirementValue;

    public Badge() {
    }

    // Getters and Setters
    public int getBadgeID() {
        return badgeID;
    }

    public void setBadgeID(int badgeID) {
        this.badgeID = badgeID;
    }

    public String getBadgeName() {
        return badgeName;
    }

    public void setBadgeName(String badgeName) {
        this.badgeName = badgeName;
    }

    public String getBadgeIcon() {
        return badgeIcon;
    }

    public void setBadgeIcon(String badgeIcon) {
        this.badgeIcon = badgeIcon;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getBadgeType() {
        return badgeType;
    }

    public void setBadgeType(String badgeType) {
        this.badgeType = badgeType;
    }

    public String getRequirementType() {
        return requirementType;
    }

    public void setRequirementType(String requirementType) {
        this.requirementType = requirementType;
    }

    public int getRequirementValue() {
        return requirementValue;
    }

    public void setRequirementValue(int requirementValue) {
        this.requirementValue = requirementValue;
    }
}
