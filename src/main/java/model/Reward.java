package model;

import jakarta.persistence.*;

@Entity
@Table(name = "Rewards")
public class Reward {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RewardID")
    private int rewardID;

    @Column(name = "RewardType", nullable = false, length = 30)
    private String rewardType;

    @Column(name = "Content", nullable = false, length = 1000)
    private String content;

    @Column(name = "BonusCoins")
    private int bonusCoins;

    @Column(name = "Rarity", length = 20)
    private String rarity;

    @Column(name = "IsActive")
    private boolean isActive;

    public Reward() {
        this.bonusCoins = 0;
        this.rarity = "common";
        this.isActive = true;
    }

    // Getters and Setters
    public int getRewardID() {
        return rewardID;
    }

    public void setRewardID(int rewardID) {
        this.rewardID = rewardID;
    }

    public String getRewardType() {
        return rewardType;
    }

    public void setRewardType(String rewardType) {
        this.rewardType = rewardType;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getBonusCoins() {
        return bonusCoins;
    }

    public void setBonusCoins(int bonusCoins) {
        this.bonusCoins = bonusCoins;
    }

    public String getRarity() {
        return rarity;
    }

    public void setRarity(String rarity) {
        this.rarity = rarity;
    }

    public boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
}
