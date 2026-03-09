package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "StudySessions")
public class StudySession {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SessionID")
    private int sessionID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "RoomID")
    private Integer roomID;

    @Column(name = "StartTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date startTime;

    @Column(name = "EndTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date endTime;

    @Column(name = "FocusMinutes")
    private int focusMinutes;

    @Column(name = "PomodorosCompleted")
    private int pomodorosCompleted;

    @Column(name = "Goal", length = 500)
    private String goal;

    @Column(name = "Status", length = 20)
    private String status;

    public StudySession() {
    }

    // Getters and Setters
    public int getSessionID() {
        return sessionID;
    }

    public void setSessionID(int sessionID) {
        this.sessionID = sessionID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public Integer getRoomID() {
        return roomID;
    }

    public void setRoomID(Integer roomID) {
        this.roomID = roomID;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public int getFocusMinutes() {
        return focusMinutes;
    }

    public void setFocusMinutes(int focusMinutes) {
        this.focusMinutes = focusMinutes;
    }

    public int getPomodorosCompleted() {
        return pomodorosCompleted;
    }

    public void setPomodorosCompleted(int pomodorosCompleted) {
        this.pomodorosCompleted = pomodorosCompleted;
    }

    public String getGoal() {
        return goal;
    }

    public void setGoal(String goal) {
        this.goal = goal;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
