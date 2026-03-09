package model;

import jakarta.persistence.*;

@Entity
@Table(name = "LeaderboardMonthly", uniqueConstraints = @UniqueConstraint(columnNames = { "UserID", "MonthYear" }))
public class LeaderboardMonthly {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "LeaderboardID")
    private int leaderboardID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "MonthYear", nullable = false, length = 7)
    private String monthYear;

    @Column(name = "TotalCoinsEarned")
    private int totalCoinsEarned;

    @Column(name = "TotalStudyMinutes")
    private int totalStudyMinutes;

    @Column(name = "Ranking")
    private Integer ranking;

    @Column(name = "PrizeAmount")
    private double prizeAmount;

    public LeaderboardMonthly() {
        this.totalCoinsEarned = 0;
        this.totalStudyMinutes = 0;
    }

    // Getters and Setters
    public int getLeaderboardID() {
        return leaderboardID;
    }

    public void setLeaderboardID(int leaderboardID) {
        this.leaderboardID = leaderboardID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getMonthYear() {
        return monthYear;
    }

    public void setMonthYear(String monthYear) {
        this.monthYear = monthYear;
    }

    public int getTotalCoinsEarned() {
        return totalCoinsEarned;
    }

    public void setTotalCoinsEarned(int totalCoinsEarned) {
        this.totalCoinsEarned = totalCoinsEarned;
    }

    public int getTotalStudyMinutes() {
        return totalStudyMinutes;
    }

    public void setTotalStudyMinutes(int totalStudyMinutes) {
        this.totalStudyMinutes = totalStudyMinutes;
    }

    public Integer getRanking() {
        return ranking;
    }

    public void setRanking(Integer ranking) {
        this.ranking = ranking;
    }

    public double getPrizeAmount() {
        return prizeAmount;
    }

    public void setPrizeAmount(double prizeAmount) {
        this.prizeAmount = prizeAmount;
    }
}
