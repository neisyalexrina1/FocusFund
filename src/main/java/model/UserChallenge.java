package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "UserChallenges")
public class UserChallenge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "UserChallengeID")
    private int userChallengeID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "ChallengeID", nullable = false)
    private int challengeID;

    @Column(name = "StartDate", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date startDate;

    @Column(name = "EndDate", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date endDate;

    @Column(name = "DaysCompleted")
    private int daysCompleted;

    @Column(name = "Status", length = 20)
    private String status;

    @Column(name = "CompletedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date completedDate;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ChallengeID", insertable = false, updatable = false)
    private Challenge challenge;

    public UserChallenge() {
        this.daysCompleted = 0;
        this.status = "active";
    }

    // Getters and Setters
    public int getUserChallengeID() {
        return userChallengeID;
    }

    public void setUserChallengeID(int userChallengeID) {
        this.userChallengeID = userChallengeID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getChallengeID() {
        return challengeID;
    }

    public void setChallengeID(int challengeID) {
        this.challengeID = challengeID;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public int getDaysCompleted() {
        return daysCompleted;
    }

    public void setDaysCompleted(int daysCompleted) {
        this.daysCompleted = daysCompleted;
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

    public Challenge getChallenge() {
        return challenge;
    }

    public void setChallenge(Challenge challenge) {
        this.challenge = challenge;
    }
}
