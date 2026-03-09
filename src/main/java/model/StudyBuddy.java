package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "StudyBuddies", uniqueConstraints = @UniqueConstraint(columnNames = { "User1ID", "User2ID" }))
public class StudyBuddy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BuddyPairID")
    private int buddyPairID;

    @Column(name = "User1ID", nullable = false)
    private int user1ID;

    @Column(name = "User2ID", nullable = false)
    private int user2ID;

    @Column(name = "Status", length = 20)
    private String status;

    @Column(name = "CreatedDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    @Column(name = "TotalSessionsTogether")
    private int totalSessionsTogether;

    public StudyBuddy() {
        this.status = "active";
        this.createdDate = new Date();
        this.totalSessionsTogether = 0;
    }

    // Getters and Setters
    public int getBuddyPairID() {
        return buddyPairID;
    }

    public void setBuddyPairID(int buddyPairID) {
        this.buddyPairID = buddyPairID;
    }

    public int getUser1ID() {
        return user1ID;
    }

    public void setUser1ID(int user1ID) {
        this.user1ID = user1ID;
    }

    public int getUser2ID() {
        return user2ID;
    }

    public void setUser2ID(int user2ID) {
        this.user2ID = user2ID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public int getTotalSessionsTogether() {
        return totalSessionsTogether;
    }

    public void setTotalSessionsTogether(int totalSessionsTogether) {
        this.totalSessionsTogether = totalSessionsTogether;
    }
}
