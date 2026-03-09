package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "UserRewards")
public class UserReward {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "UserRewardID")
    private int userRewardID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "RewardID", nullable = false)
    private int rewardID;

    @Column(name = "SessionID")
    private Integer sessionID;

    @Column(name = "ReceivedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date receivedDate;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "RewardID", insertable = false, updatable = false)
    private Reward reward;

    public UserReward() {
        this.receivedDate = new Date();
    }

    // Getters and Setters
    public int getUserRewardID() {
        return userRewardID;
    }

    public void setUserRewardID(int userRewardID) {
        this.userRewardID = userRewardID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getRewardID() {
        return rewardID;
    }

    public void setRewardID(int rewardID) {
        this.rewardID = rewardID;
    }

    public Integer getSessionID() {
        return sessionID;
    }

    public void setSessionID(Integer sessionID) {
        this.sessionID = sessionID;
    }

    public Date getReceivedDate() {
        return receivedDate;
    }

    public void setReceivedDate(Date receivedDate) {
        this.receivedDate = receivedDate;
    }

    public Reward getReward() {
        return reward;
    }

    public void setReward(Reward reward) {
        this.reward = reward;
    }
}
