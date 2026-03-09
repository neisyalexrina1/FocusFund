package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Follows", uniqueConstraints = @UniqueConstraint(columnNames = { "FollowerID", "FollowingID" }))
public class Follow {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "FollowID")
    private int followID;

    @Column(name = "FollowerID", nullable = false)
    private int followerID;

    @Column(name = "FollowingID", nullable = false)
    private int followingID;

    @Column(name = "CreatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    public Follow() {
        this.createdDate = new Date();
    }

    // Getters and Setters
    public int getFollowID() {
        return followID;
    }

    public void setFollowID(int followID) {
        this.followID = followID;
    }

    public int getFollowerID() {
        return followerID;
    }

    public void setFollowerID(int followerID) {
        this.followerID = followerID;
    }

    public int getFollowingID() {
        return followingID;
    }

    public void setFollowingID(int followingID) {
        this.followingID = followingID;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
}
