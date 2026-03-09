package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "UserDailyQuests", uniqueConstraints = @UniqueConstraint(columnNames = { "UserID", "TemplateID",
        "QuestDate" }))
public class UserDailyQuest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "UserQuestID")
    private int userQuestID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "TemplateID", nullable = false)
    private int templateID;

    @Column(name = "QuestDate", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date questDate;

    @Column(name = "CurrentProgress")
    private int currentProgress;

    @Column(name = "TargetValue")
    private int targetValue;

    @Column(name = "Status", length = 20)
    private String status;

    @Column(name = "CompletedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date completedDate;

    @Column(name = "CoinReward")
    private int coinReward;

    @Column(name = "ExpReward")
    private int expReward;

    // Transient fields for frontend display
    @Transient
    private String questName;
    @Transient
    private String questIcon;
    @Transient
    private String description;
    @Transient
    private String questType;

    public UserDailyQuest() {
        this.currentProgress = 0;
        this.status = "active";
    }

    // Getters and Setters
    public int getUserQuestID() {
        return userQuestID;
    }

    public void setUserQuestID(int userQuestID) {
        this.userQuestID = userQuestID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getTemplateID() {
        return templateID;
    }

    public void setTemplateID(int templateID) {
        this.templateID = templateID;
    }

    public Date getQuestDate() {
        return questDate;
    }

    public void setQuestDate(Date questDate) {
        this.questDate = questDate;
    }

    public int getCurrentProgress() {
        return currentProgress;
    }

    public void setCurrentProgress(int currentProgress) {
        this.currentProgress = currentProgress;
    }

    public int getTargetValue() {
        return targetValue;
    }

    public void setTargetValue(int targetValue) {
        this.targetValue = targetValue;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCompletedDate() {
        return completedDate;
    }

    public void setCompletedDate(Date completedDate) {
        this.completedDate = completedDate;
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

    public String getQuestName() {
        return questName;
    }

    public void setQuestName(String questName) {
        this.questName = questName;
    }

    public String getQuestIcon() {
        return questIcon;
    }

    public void setQuestIcon(String questIcon) {
        this.questIcon = questIcon;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getQuestType() {
        return questType;
    }

    public void setQuestType(String questType) {
        this.questType = questType;
    }
}
