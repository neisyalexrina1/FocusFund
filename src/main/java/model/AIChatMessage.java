package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "AIChatMessages")
public class AIChatMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MessageID")
    private int messageID;

    @Column(name = "SessionID", nullable = false)
    private int sessionID;

    @Column(name = "Role", nullable = false, length = 20)
    private String role; // "user" or "assistant"

    @Column(name = "Content", columnDefinition = "NVARCHAR(MAX)")
    private String content;

    @Column(name = "Mode", length = 30)
    private String mode; // "normal", "thinking", "research", "image"

    @Column(name = "CreatedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    public AIChatMessage() {
        this.createdAt = new Date();
        this.mode = "normal";
    }

    // Getters and Setters
    public int getMessageID() {
        return messageID;
    }

    public void setMessageID(int messageID) {
        this.messageID = messageID;
    }

    public int getSessionID() {
        return sessionID;
    }

    public void setSessionID(int sessionID) {
        this.sessionID = sessionID;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
