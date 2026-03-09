package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Courses")
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "CourseID")
    private int courseID;

    @Column(name = "CourseName", nullable = false, length = 100)
    private String courseName;

    @Column(name = "Icon", length = 10)
    private String icon;

    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "DetailDescription", length = 1000)
    private String detailDescription;

    @Column(name = "Duration", length = 50)
    private String duration;

    @Column(name = "TopicCount")
    private int topicCount;

    @Column(name = "LearnerCount")
    private int learnerCount;

    @Column(name = "CreatedBy")
    private Integer createdBy;

    @Column(name = "IsPublic")
    private boolean isPublic;

    @Column(name = "CreatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    public Course() {
        this.isPublic = true;
        this.createdDate = new Date();
    }

    // Getters and Setters
    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDetailDescription() {
        return detailDescription;
    }

    public void setDetailDescription(String detailDescription) {
        this.detailDescription = detailDescription;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public int getTopicCount() {
        return topicCount;
    }

    public void setTopicCount(int topicCount) {
        this.topicCount = topicCount;
    }

    public int getLearnerCount() {
        return learnerCount;
    }

    public void setLearnerCount(int learnerCount) {
        this.learnerCount = learnerCount;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(boolean isPublic) {
        this.isPublic = isPublic;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
}
