package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Mindmaps")
public class Mindmap {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MindmapID")
    private int mindmapID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "Title", nullable = false, length = 200)
    private String title;

    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "CourseID")
    private Integer courseID;

    @Column(name = "IsPublic")
    private boolean isPublic;

    @Column(name = "LikeCount")
    private int likeCount;

    @Column(name = "UseCount")
    private int useCount;

    @Column(name = "CreatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    @Column(name = "UpdatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedDate;

    public Mindmap() {
        this.isPublic = false;
        this.likeCount = 0;
        this.useCount = 0;
        this.createdDate = new Date();
        this.updatedDate = new Date();
    }

    // Getters and Setters
    public int getMindmapID() {
        return mindmapID;
    }

    public void setMindmapID(int mindmapID) {
        this.mindmapID = mindmapID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getCourseID() {
        return courseID;
    }

    public void setCourseID(Integer courseID) {
        this.courseID = courseID;
    }

    public boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(boolean isPublic) {
        this.isPublic = isPublic;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }

    public int getUseCount() {
        return useCount;
    }

    public void setUseCount(int useCount) {
        this.useCount = useCount;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }
}
