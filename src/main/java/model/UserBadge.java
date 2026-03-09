package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "UserBadges", uniqueConstraints = @UniqueConstraint(columnNames = { "UserID", "BadgeID" }))
public class UserBadge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "UserBadgeID")
    private int userBadgeID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "BadgeID", nullable = false)
    private int badgeID;

    @Column(name = "EarnedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date earnedDate;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "BadgeID", insertable = false, updatable = false)
    private Badge badge;

    public UserBadge() {
        this.earnedDate = new Date();
    }

    // Getters and Setters
    public int getUserBadgeID() {
        return userBadgeID;
    }

    public void setUserBadgeID(int userBadgeID) {
        this.userBadgeID = userBadgeID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getBadgeID() {
        return badgeID;
    }

    public void setBadgeID(int badgeID) {
        this.badgeID = badgeID;
    }

    public Date getEarnedDate() {
        return earnedDate;
    }

    public void setEarnedDate(Date earnedDate) {
        this.earnedDate = earnedDate;
    }

    public Badge getBadge() {
        return badge;
    }

    public void setBadge(Badge badge) {
        this.badge = badge;
    }
}
