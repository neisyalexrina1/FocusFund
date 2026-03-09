package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "FocusFundContracts")
public class FocusFundContract {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ContractID")
    private int contractID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "StakeAmount", nullable = false)
    private double stakeAmount;

    @Column(name = "PenaltyPercent")
    private int penaltyPercent;

    @Column(name = "GoalType", length = 20)
    private String goalType;

    @Column(name = "GoalValue")
    private int goalValue;

    @Column(name = "DurationDays")
    private int durationDays;

    @Column(name = "StartDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date startDate;

    @Column(name = "EndDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date endDate;

    @Column(name = "DaysCompleted")
    private int daysCompleted;

    @Column(name = "Status", length = 20)
    private String status;

    @Column(name = "CompletedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date completedDate;

    @Column(name = "BonusEarned")
    private double bonusEarned;

    public FocusFundContract() {
        this.penaltyPercent = 10;
        this.goalType = "session";
        this.goalValue = 25;
        this.durationDays = 1;
        this.daysCompleted = 0;
        this.status = "active";
        this.startDate = new Date();
        this.bonusEarned = 0;
    }

    // Getters and Setters
    public int getContractID() {
        return contractID;
    }

    public void setContractID(int contractID) {
        this.contractID = contractID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public double getStakeAmount() {
        return stakeAmount;
    }

    public void setStakeAmount(double stakeAmount) {
        this.stakeAmount = stakeAmount;
    }

    public int getPenaltyPercent() {
        return penaltyPercent;
    }

    public void setPenaltyPercent(int penaltyPercent) {
        this.penaltyPercent = penaltyPercent;
    }

    public String getGoalType() {
        return goalType;
    }

    public void setGoalType(String goalType) {
        this.goalType = goalType;
    }

    public int getGoalValue() {
        return goalValue;
    }

    public void setGoalValue(int goalValue) {
        this.goalValue = goalValue;
    }

    public int getDurationDays() {
        return durationDays;
    }

    public void setDurationDays(int durationDays) {
        this.durationDays = durationDays;
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

    public double getBonusEarned() {
        return bonusEarned;
    }

    public void setBonusEarned(double bonusEarned) {
        this.bonusEarned = bonusEarned;
    }
}
