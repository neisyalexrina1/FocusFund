package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "EmailNotifications")
public class EmailNotification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "NotificationID")
    private int notificationID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "Type", nullable = false, length = 50)
    private String type;

    @Column(name = "Subject", length = 255)
    private String subject;

    @Column(name = "SentDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date sentDate;

    @Column(name = "Status", length = 20)
    private String status;

    public EmailNotification() {
        this.sentDate = new Date();
        this.status = "sent";
    }

    // Getters and Setters
    public int getNotificationID() {
        return notificationID;
    }

    public void setNotificationID(int notificationID) {
        this.notificationID = notificationID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public Date getSentDate() {
        return sentDate;
    }

    public void setSentDate(Date sentDate) {
        this.sentDate = sentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
