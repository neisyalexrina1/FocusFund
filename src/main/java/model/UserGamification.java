package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "UserGamification")
public class UserGamification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "GamificationID")
    private int gamificationID;

    @Column(name = "UserID", unique = true, nullable = false)
    private int userID;

    @Column(name = "FocusCoins")
    private int focusCoins;

    @Column(name = "TotalExp")
    private int totalExp;

    @Column(name = "CurrentRank", length = 20)
    private String currentRank;

    @Column(name = "TotalStudyMinutes")
    private int totalStudyMinutes;

    @Column(name = "LastCoinEarnedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastCoinEarnedDate;

    public UserGamification() {
        this.focusCoins = 0;
        this.totalExp = 0;
        this.currentRank = "Unranked";
        this.totalStudyMinutes = 0;
    }

    // Calculate rank based on total study hours
    public String calculateRank() {
        double hours = totalStudyMinutes / 60.0;
        if (hours >= 500)
            return "Diamond";
        if (hours >= 200)
            return "Platinum";
        if (hours >= 100)
            return "Gold";
        if (hours >= 50)
            return "Silver";
        if (hours >= 10)
            return "Bronze";
        return "Unranked";
    }

    // Getters and Setters
    public int getGamificationID() {
        return gamificationID;
    }

    public void setGamificationID(int gamificationID) {
        this.gamificationID = gamificationID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getFocusCoins() {
        return focusCoins;
    }

    public void setFocusCoins(int focusCoins) {
        this.focusCoins = focusCoins;
    }

    public int getTotalExp() {
        return totalExp;
    }

    public void setTotalExp(int totalExp) {
        this.totalExp = totalExp;
    }

    public String getCurrentRank() {
        return currentRank;
    }

    public void setCurrentRank(String currentRank) {
        this.currentRank = currentRank;
    }

    public int getTotalStudyMinutes() {
        return totalStudyMinutes;
    }

    public void setTotalStudyMinutes(int totalStudyMinutes) {
        this.totalStudyMinutes = totalStudyMinutes;
    }

    public Date getLastCoinEarnedDate() {
        return lastCoinEarnedDate;
    }

    public void setLastCoinEarnedDate(Date lastCoinEarnedDate) {
        this.lastCoinEarnedDate = lastCoinEarnedDate;
    }

    public double getTotalStudyHours() {
        return totalStudyMinutes / 60.0;
    }
}
