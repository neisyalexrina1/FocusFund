package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "DailyStreaks")
public class DailyStreak {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "StreakID")
    private int streakID;

    @Column(name = "UserID", unique = true, nullable = false)
    private int userID;

    @Column(name = "CurrentStreak")
    private int currentStreak;

    @Column(name = "LongestStreak")
    private int longestStreak;

    @Column(name = "LastStudyDate")
    @Temporal(TemporalType.DATE)
    private Date lastStudyDate;

    @Column(name = "StreakStartDate")
    @Temporal(TemporalType.DATE)
    private Date streakStartDate;

    public DailyStreak() {
        this.currentStreak = 0;
        this.longestStreak = 0;
    }

    // Getters and Setters
    public int getStreakID() {
        return streakID;
    }

    public void setStreakID(int streakID) {
        this.streakID = streakID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getCurrentStreak() {
        return currentStreak;
    }

    public void setCurrentStreak(int currentStreak) {
        this.currentStreak = currentStreak;
    }

    public int getLongestStreak() {
        return longestStreak;
    }

    public void setLongestStreak(int longestStreak) {
        this.longestStreak = longestStreak;
    }

    public Date getLastStudyDate() {
        return lastStudyDate;
    }

    public void setLastStudyDate(Date lastStudyDate) {
        this.lastStudyDate = lastStudyDate;
    }

    public Date getStreakStartDate() {
        return streakStartDate;
    }

    public void setStreakStartDate(Date streakStartDate) {
        this.streakStartDate = streakStartDate;
    }
}
