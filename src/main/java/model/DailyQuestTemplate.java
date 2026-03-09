package model;

import jakarta.persistence.*;

@Entity
@Table(name = "DailyQuestTemplates")
public class DailyQuestTemplate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "TemplateID")
    private int templateID;

    @Column(name = "QuestName", nullable = false, length = 200)
    private String questName;

    @Column(name = "QuestIcon", length = 10)
    private String questIcon;

    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "QuestType", nullable = false, length = 30)
    private String questType;

    @Column(name = "TargetValue")
    private int targetValue;

    @Column(name = "CoinReward")
    private int coinReward;

    @Column(name = "ExpReward")
    private int expReward;

    @Column(name = "Difficulty", length = 10)
    private String difficulty;

    @Column(name = "IsActive")
    private boolean isActive;

    public DailyQuestTemplate() {
        this.targetValue = 1;
        this.coinReward = 2;
        this.expReward = 10;
        this.difficulty = "easy";
        this.isActive = true;
    }

    // Getters and Setters
    public int getTemplateID() {
        return templateID;
    }

    public void setTemplateID(int templateID) {
        this.templateID = templateID;
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

    public int getTargetValue() {
        return targetValue;
    }

    public void setTargetValue(int targetValue) {
        this.targetValue = targetValue;
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

    public String getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}
