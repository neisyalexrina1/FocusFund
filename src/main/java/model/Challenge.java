package model;

import jakarta.persistence.*;

@Entity
@Table(name = "Challenges")
public class Challenge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ChallengeID")
    private int challengeID;

    @Column(name = "ChallengeName", nullable = false, length = 100)
    private String challengeName;

    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "ChallengeType", length = 20)
    private String challengeType;

    @Column(name = "DurationDays", nullable = false)
    private int durationDays;

    @Column(name = "TargetMinutesPerDay")
    private int targetMinutesPerDay;

    @Column(name = "CoinReward")
    private int coinReward;

    @Column(name = "ExpReward")
    private int expReward;

    @Column(name = "BadgeRewardID")
    private Integer badgeRewardID;

    @Column(name = "IsActive")
    private boolean isActive;

    public Challenge() {
        this.targetMinutesPerDay = 25;
        this.coinReward = 20;
        this.expReward = 50;
        this.isActive = true;
    }

    // Getters and Setters
    public int getChallengeID() {
        return challengeID;
    }

    public void setChallengeID(int challengeID) {
        this.challengeID = challengeID;
    }

    public String getChallengeName() {
        return challengeName;
    }

    public void setChallengeName(String challengeName) {
        this.challengeName = challengeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getChallengeType() {
        return challengeType;
    }

    public void setChallengeType(String challengeType) {
        this.challengeType = challengeType;
    }

    public int getDurationDays() {
        return durationDays;
    }

    public void setDurationDays(int durationDays) {
        this.durationDays = durationDays;
    }

    public int getTargetMinutesPerDay() {
        return targetMinutesPerDay;
    }

    public void setTargetMinutesPerDay(int targetMinutesPerDay) {
        this.targetMinutesPerDay = targetMinutesPerDay;
    }

    public int getCoinReward() {
        return coinReward;
    }

    public void setCoinReward(int coinReward) {
        this.coinReward = coinReward;
    }

    public int getExpReward() {
        return expReward;
    }

    public void setExpReward(int expReward) {
        this.expReward = expReward;
    }

    public Integer getBadgeRewardID() {
        return badgeRewardID;
    }

    public void setBadgeRewardID(Integer badgeRewardID) {
        this.badgeRewardID = badgeRewardID;
    }

    public boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
}
