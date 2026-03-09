package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "PostLikes", uniqueConstraints = @UniqueConstraint(columnNames = { "PostID", "UserID" }))
public class PostLike {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "LikeID")
    private int likeID;

    @Column(name = "PostID", nullable = false)
    private int postID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "CreatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    public PostLike() {
        this.createdDate = new Date();
    }

    // Getters and Setters
    public int getLikeID() {
        return likeID;
    }

    public void setLikeID(int likeID) {
        this.likeID = likeID;
    }

    public int getPostID() {
        return postID;
    }

    public void setPostID(int postID) {
        this.postID = postID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
}
