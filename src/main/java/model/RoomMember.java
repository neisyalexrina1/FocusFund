package model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "RoomMembers")
public class RoomMember {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MemberID")
    private int memberID;

    @Column(name = "RoomID", nullable = false)
    private int roomID;

    @Column(name = "UserID", nullable = false)
    private int userID;

    @Column(name = "Role", length = 10)
    private String role;

    @Column(name = "JoinedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date joinedAt;

    // Transient fields for display (loaded via queries)
    @Transient
    private String username;

    @Transient
    private String fullName;

    public RoomMember() {
    }

    // Getters and Setters
    public int getMemberID() {
        return memberID;
    }

    public void setMemberID(int memberID) {
        this.memberID = memberID;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Date getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(Date joinedAt) {
        this.joinedAt = joinedAt;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    // Helper methods
    public boolean isHost() {
        return "host".equals(role);
    }

    public String getDisplayName() {
        return (fullName != null && !fullName.isEmpty()) ? fullName : username;
    }

    public String getRoleBadge() {
        return isHost() ? "👑 Host" : "👤 Member";
    }
}
