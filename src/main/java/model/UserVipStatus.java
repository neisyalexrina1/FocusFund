package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "UserVipStatus")
public class UserVipStatus {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "UserVipID")
    private int userVipID;

    @Column(name = "UserID", unique = true, nullable = false)
    private int userID;

    @Column(name = "TierID", nullable = false)
    private int tierID;

    @Column(name = "PurchasedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date purchasedDate;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "TierID", insertable = false, updatable = false)
    private VipTier vipTier;

    public UserVipStatus() {
        this.purchasedDate = new Date();
    }

    // Getters and Setters
    public int getUserVipID() {
        return userVipID;
    }

    public void setUserVipID(int userVipID) {
        this.userVipID = userVipID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getTierID() {
        return tierID;
    }

    public void setTierID(int tierID) {
        this.tierID = tierID;
    }

    public Date getPurchasedDate() {
        return purchasedDate;
    }

    public void setPurchasedDate(Date purchasedDate) {
        this.purchasedDate = purchasedDate;
    }

    public VipTier getVipTier() {
        return vipTier;
    }

    public void setVipTier(VipTier vipTier) {
        this.vipTier = vipTier;
    }
}
