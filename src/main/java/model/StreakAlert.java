package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "StreakAlerts")
public class StreakAlert {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "AlertID")
    private int alertID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "AlertType", nullable = false, length = 30)
    private String alertType;

    @Column(name = "Message", length = 500)
    private String message;

    @Column(name = "IsRead")
    private boolean isRead;

    @Column(name = "CreatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    public StreakAlert() {
        this.isRead = false;
        this.createdDate = new Date();
    }

    // Getters and Setters
    public int getAlertID() {
        return alertID;
    }

    public void setAlertID(int alertID) {
        this.alertID = alertID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getAlertType() {
        return alertType;
    }

    public void setAlertType(String alertType) {
        this.alertType = alertType;
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
}
