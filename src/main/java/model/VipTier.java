package model;

import jakarta.persistence.*;

@Entity
@Table(name = "VipTiers")
public class VipTier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "TierID")
    private int tierID;

    @Column(name = "TierName", nullable = false, length = 50)
    private String tierName;

    @Column(name = "TierIcon", length = 10)
    private String tierIcon;

    @Column(name = "CoinCost", nullable = false)
    private int coinCost;

    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "Features", length = 1000)
    private String features; // JSON string

    @Column(name = "TierOrder")
    private int tierOrder;

    public VipTier() {
    }

    // Getters and Setters
    public int getTierID() {
        return tierID;
    }

    public void setTierID(int tierID) {
        this.tierID = tierID;
    }

    public String getTierName() {
        return tierName;
    }

    public void setTierName(String tierName) {
        this.tierName = tierName;
    }

    public String getTierIcon() {
        return tierIcon;
    }

    public void setTierIcon(String tierIcon) {
        this.tierIcon = tierIcon;
    }

    public int getCoinCost() {
        return coinCost;
    }

    public void setCoinCost(int coinCost) {
        this.coinCost = coinCost;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFeatures() {
        return features;
    }

    public void setFeatures(String features) {
        this.features = features;
    }

    public int getTierOrder() {
        return tierOrder;
    }

    public void setTierOrder(int tierOrder) {
        this.tierOrder = tierOrder;
    }
}
