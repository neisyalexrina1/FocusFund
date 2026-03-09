package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "StudyRooms")
public class StudyRoom {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RoomID")
    private int roomID;

    @Column(name = "RoomName", nullable = false, length = 100)
    private String roomName;

    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "RoomType", length = 20)
    private String roomType;

    @Column(name = "PomodoroSetting", length = 10)
    private String pomodoroSetting;

    @Column(name = "MaxParticipants")
    private int maxParticipants;

    @Column(name = "CurrentParticipants")
    private int currentParticipants;

    @Column(name = "CreatedBy")
    private Integer createdBy;

    @Column(name = "CreatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    @Column(name = "Status", length = 10)
    private String status = "OPEN";

    // Transient field for host display name
    @Transient
    private String hostName;

    public StudyRoom() {
    }

    // Getters and Setters
    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public String getPomodoroSetting() {
        return pomodoroSetting;
    }

    public void setPomodoroSetting(String pomodoroSetting) {
        this.pomodoroSetting = pomodoroSetting;
    }

    public int getMaxParticipants() {
        return maxParticipants;
    }

    public void setMaxParticipants(int maxParticipants) {
        this.maxParticipants = maxParticipants;
    }

    public int getCurrentParticipants() {
        return currentParticipants;
    }

    public void setCurrentParticipants(int currentParticipants) {
        this.currentParticipants = currentParticipants;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    // Helper method for display
    public String getPomodoroLabel() {
        if (pomodoroSetting == null)
            return "";
        switch (pomodoroSetting) {
            case "25-5":
                return "25/5 Pomodoro";
            case "50-10":
                return "50/10 Pomodoro";
            case "90-20":
                return "90/20 Deep Work";
            default:
                return pomodoroSetting;
        }
    }

    public String getRoomTypeBadge() {
        if (roomType == null)
            return "";
        switch (roomType) {
            case "private":
                return "🔒 Private";
            case "silent":
                return "🤫 Silent";
            case "public":
                return "👥 Public";
            default:
                return roomType;
        }
    }

    public String getStatusBadge() {
        if (status == null)
            return "";
        switch (status) {
            case "OPEN":
                return "🟢 Open";
            case "FULL":
                return "🟡 Full";
            case "CLOSED":
                return "🔴 Closed";
            default:
                return status;
        }
    }

    public boolean isOpen() {
        return "OPEN".equals(status);
    }

    public boolean isFull() {
        return "FULL".equals(status);
    }

    public boolean isClosed() {
        return "CLOSED".equals(status);
    }
}
