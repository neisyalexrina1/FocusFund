package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "UserCourseProgress", uniqueConstraints = @UniqueConstraint(columnNames = { "UserID", "CourseID" }))
public class UserCourseProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ProgressID")
    private int progressID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "CourseID", nullable = false)
    private int courseID;

    @Column(name = "CompletedLessons")
    private int completedLessons;

    @Column(name = "TotalLessons")
    private int totalLessons;

    @Column(name = "ProgressPercent", insertable = false, updatable = false) // computed column
    private Double progressPercent;

    @Column(name = "Status", length = 20)
    private String status;

    @Column(name = "StartedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date startedDate;

    @Column(name = "CompletedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date completedDate;

    public UserCourseProgress() {
        this.completedLessons = 0;
        this.totalLessons = 1;
        this.status = "in_progress";
        this.startedDate = new Date();
    }

    // Getters and Setters
    public int getProgressID() {
        return progressID;
    }

    public void setProgressID(int progressID) {
        this.progressID = progressID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public int getCompletedLessons() {
        return completedLessons;
    }

    public void setCompletedLessons(int completedLessons) {
        this.completedLessons = completedLessons;
    }

    public int getTotalLessons() {
        return totalLessons;
    }

    public void setTotalLessons(int totalLessons) {
        this.totalLessons = totalLessons;
    }

    public Double getProgressPercent() {
        return progressPercent;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getStartedDate() {
        return startedDate;
    }

    public void setStartedDate(Date startedDate) {
        this.startedDate = startedDate;
    }

    public Date getCompletedDate() {
        return completedDate;
    }

    public void setCompletedDate(Date completedDate) {
        this.completedDate = completedDate;
    }
}
