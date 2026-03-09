package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "BuddyActivity")
public class BuddyActivity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ActivityID")
    private int activityID;

    @Column(name = "BuddyPairID", nullable = false)
    private int buddyPairID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "ActivityType", nullable = false, length = 30)
    private String activityType;

    @Column(name = "Message", length = 500)
    private String message;

    @Column(name = "IsRead")
    private boolean isRead;

    @Column(name = "CreatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    // Transient for display
    @Transient
    private String actorName;

    public BuddyActivity() {
        this.isRead = false;
        this.createdDate = new Date();
    }

    // Getters and Setters
    public int getActivityID() {
        return activityID;
    }

    public void setActivityID(int activityID) {
        this.activityID = activityID;
    }

    public int getBuddyPairID() {
        return buddyPairID;
    }

    public void setBuddyPairID(int buddyPairID) {
        this.buddyPairID = buddyPairID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public String getActorName() {
        return actorName;
    }

    public void setActorName(String actorName) {
        this.actorName = actorName;
    }
}
