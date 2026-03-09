package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "MicroSessions")
public class MicroSession {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MicroSessionID")
    private int microSessionID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "InitialDuration")
    private int initialDuration;

    @Column(name = "ActualDuration")
    private int actualDuration;

    @Column(name = "Escalations")
    private int escalations;

    @Column(name = "StartTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date startTime;

    @Column(name = "EndTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date endTime;

    @Column(name = "Status", length = 20)
    private String status;

    @Column(name = "ConvertedToPomodoro")
    private boolean convertedToPomodoro;

    public MicroSession() {
        this.initialDuration = 1;
        this.actualDuration = 0;
        this.escalations = 0;
        this.status = "active";
        this.startTime = new Date();
        this.convertedToPomodoro = false;
    }

    // Getters and Setters
    public int getMicroSessionID() {
        return microSessionID;
    }

    public void setMicroSessionID(int id) {
        this.microSessionID = id;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getInitialDuration() {
        return initialDuration;
    }

    public void setInitialDuration(int initialDuration) {
        this.initialDuration = initialDuration;
    }

    public int getActualDuration() {
        return actualDuration;
    }

    public void setActualDuration(int actualDuration) {
        this.actualDuration = actualDuration;
    }

    public int getEscalations() {
        return escalations;
    }

    public void setEscalations(int escalations) {
        this.escalations = escalations;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isConvertedToPomodoro() {
        return convertedToPomodoro;
    }

    public void setConvertedToPomodoro(boolean convertedToPomodoro) {
        this.convertedToPomodoro = convertedToPomodoro;
    }
}
