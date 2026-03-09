package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "RoomMessages")
public class RoomMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MessageID")
    private int messageID;

    @Column(name = "RoomID", nullable = false)
    private int roomID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "DisplayName", length = 100)
    private String displayName;

    @Column(name = "Content", nullable = false, length = 500)
    private String content;

    @Column(name = "SentAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date sentAt;

    public RoomMessage() {
    }

    public RoomMessage(int roomID, int userID, String displayName, String content) {
        this.roomID = roomID;
        this.userID = userID;
        this.displayName = displayName;
        this.content = content;
        this.sentAt = new Date();
    }

    // Getters and Setters
    public int getMessageID() {
        return messageID;
    }

    public void setMessageID(int messageID) {
        this.messageID = messageID;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getSentAt() {
        return sentAt;
    }

    public void setSentAt(Date sentAt) {
        this.sentAt = sentAt;
    }
}
